# Integration

> **Ownership**: SAP Integration Suite on BTP (iFlows, Cloud Integration, API Management, Event Mesh, Edge Integration Cell), integration patterns for cloud-to-cloud and hybrid, SAP Business Network connectivity, prebuilt integration content, clean integration principles.
> **See also**: `architecture-and-components.md` (for Integration Suite as a RISE bundle component), `extensibility-and-development.md` (for extension integration patterns), `security-and-compliance.md` (for integration security patterns)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| Future-Proofing Enterprise Agility with SAP Integration Suite and Clean Core | https://community.sap.com/t5/technology-blog-posts-by-sap/future-proofing-enterprise-agility-with-sap-integration-suite-and-clean/ba-p/14272078 | SAP Community Blog |
| Next-gen hybrid integration with SAP Integration Suite & Edge Integration Cell | https://community.sap.com/t5/integration-blog-posts/next-gen-hybrid-integration-with-sap-integration-suite-edge-integration/ba-p/13577780 | SAP Community Blog |
| Secure Data Flow and Connectivity with SAP Cloud Services | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/secure-data-flow-and-connectivity-with-sap-cloud-services/ba-p/13580781 | SAP Community Blog |
| Modernizing RFC/BAPI-based Integrations for a Clean Core | https://community.sap.com/t5/technology-blog-posts-by-sap/modernizing-rfc-bapi-based-integrations-for-a-clean-core-with-sap/ba-p/14240582 | SAP Community Blog |
| SAP Integration Solution Advisory Methodology | https://www.sap.com/services-support/integration-solution-advisory-methodology.html | SAP.com |
| SAP Business Accelerator Hub | https://hub.sap.com/ | SAP Hub |

---

## Clean Integration Principle

In RISE with SAP, the **integration dimension** of Clean Core requires:

- Use of **standard APIs** (OData, REST, SOAP) — no direct RFC/BAPI access to internal SAP objects
- **Event-driven architectures** preferred over point-to-point coupling
- **Centralized monitoring and governance** via SAP Integration Suite
- **Reusable, SAP-delivered content** from SAP Business Accelerator Hub

> "Clean integration is the architectural foundation that supports a clean core. Data mappings and transformations must happen **outside of S/4HANA** — never inside the core."

---

## SAP Integration Suite

SAP Integration Suite is SAP's strategic **Integration Platform as a Service (iPaaS)** — the recommended integration platform for all RISE with SAP scenarios.

### Core Capabilities

| Capability | Description |
|------------|-------------|
| **Cloud Integration (CPI)** | Design, deploy, and operate iFlows connecting SAP and non-SAP systems |
| **API Management** | Publish, govern, and monetize APIs; API portal and developer hub |
| **Event Mesh** | Asynchronous event-based messaging (publish/subscribe) |
| **Integration Advisor** | Machine learning-assisted B2B message mapping |
| **Trading Partner Management** | EDI-based B2B partner management |
| **Edge Integration Cell** | On-premise/hybrid runtime for private cloud or air-gapped scenarios |
| **Open Connectors** | 170+ pre-built third-party connectors |
| **Integration Assessment** | Evaluate existing integration landscape maturity |

### Scale of Prebuilt Content (SAP Business Accelerator Hub)

| Asset Type | Count |
|------------|-------|
| Business accelerators (iFlows) | 7,000+ |
| Published APIs | 4,600+ |
| Business events | 1,400+ |
| Connectors (SAP + third-party) | 250+ |

---

## Edge Integration Cell

The **Edge Integration Cell** is SAP Integration Suite's next-generation hybrid integration runtime:

- Runs as a lightweight container-based runtime **on-premise or in private cloud**
- Allows integration flows to execute locally — data never leaves the customer network
- Designed for: air-gapped environments, regulated industries with data sovereignty requirements, low-latency on-premise scenarios

> **Key differentiator vs classic Cloud Connector**: Edge Integration Cell can run full iFlow logic locally, not just tunnel connectivity.

### When to Use Edge Integration Cell

| Scenario | Recommendation |
|----------|---------------|
| Data must not traverse internet | Edge Integration Cell |
| Regulated industries (GDPR, HIPAA) | Edge Integration Cell |
| Low-latency on-premise integration | Edge Integration Cell |
| Standard cloud-to-cloud integration | SAP Integration Suite (cloud runtime) |
| Legacy SAP PI/PO migration | Evaluate Edge Integration Cell as migration target |

---

## Integration Patterns for RISE with SAP

### PCE ↔ SAP BTP

- **SAP Cloud Connector** (pre-deployed in PCE) provides outbound tunnel to BTP
- mTLS 1.2 between Cloud Connector and BTP Connectivity Service
- API-first via SAP Integration Suite iFlows
- Events via SAP Event Mesh (publish from S/4HANA → consume in BTP extensions)

### PCE ↔ SAP SuccessFactors

| Aspect | Detail |
|--------|--------|
| Protocol | OData API |
| Authentication | mTLS 1.2 |
| Orchestration | BTP Integration Suite |
| Prebuilt content | SAP Business Accelerator Hub: HR integration packages |

### PCE ↔ SAP Ariba

| Aspect | Detail |
|--------|--------|
| Integration layer | SAP Ariba Cloud Integration Gateway (CIG) via BTP Integration Suite |
| Protocols | REST, OData, SOAP, Commerce XML |
| Authentication | TLS 1.2 mutual authentication (Ariba CIG ↔ Cloud Connector in PCE) |

### PCE ↔ SAP Concur

| Aspect | Detail |
|--------|--------|
| Integration layer | BTP Integration Suite |
| Data at rest | PGP encryption before transfer |
| Data in transit | SFTP (encrypted) |

### PCE ↔ Non-SAP Systems (e.g., Salesforce, ServiceNow)

| Aspect | Detail |
|--------|--------|
| Recommended pattern | BTP Integration Suite iFlow as middleware |
| APIs | S/4HANA released OData APIs via SAP Business Accelerator Hub |
| Event-driven | S/4HANA Business Events → SAP Event Mesh → BTP extension or third-party system |

---

## Modernizing Legacy Integrations (RFC/BAPI)

Classic RFC and BAPI-based integrations are **Level C or D** in the clean core extensibility model and must be modernized:

### Replacement Strategy

| Legacy Approach | Clean Core Replacement |
|----------------|----------------------|
| RFC function calls from external systems | OData/REST APIs published via SAP Business Accelerator Hub |
| BAPI calls | Standard APIs documented in SAP Business Accelerator Hub |
| RFC adapter in SAP Integration Suite | Replace with REST/OData adapter + API-based connectivity |
| Direct DB table access from interfaces | SAP released CDS views exposed as OData |

> SAP Integration Suite supports RFC adapter for backward compatibility during migration — but the **target state is always REST/OData**.

---

## SAP Business Network Integration

SAP Business Network (Ariba Network, Logistics Business Network) connects buyers and suppliers:

- **Starter Pack** included in all RISE subscriptions
- Integration via **Ariba Cloud Integration Gateway (CIG)**
- Document types: Purchase Orders, Invoices, Shipping Notifications, Payments
- Supports direct EDI and cXML document exchange

---

## Integration Governance: ISAM

The **Integration Solution Advisory Methodology (ISAM)** is SAP's framework for designing integration architecture:

1. **Define strategy**: Cloud-native, API-first, event-driven architecture target
2. **Design architecture**: Future-state integration blueprint
3. **Establish governance**: Center of Excellence (CoE), standards enforcement
4. **Define transformation roadmap**: Migration from legacy to target architecture
5. **Implement and monitor**: Deploy iFlows, use SAP Cloud ALM Integration & Exception Monitoring

> Establish a Center of Excellence (CoE) for integration governance — same principle as the Solution Standardization Board for extensibility.

---

## PI/PO Migration

SAP PI/PO (Process Integration / Process Orchestration) is a **legacy on-premise integration platform** reaching end-of-mainstream maintenance. Migration to SAP Integration Suite is **mandatory** for RISE customers.

| Migration Path | Tool |
|---------------|------|
| PI/PO iFlows → Integration Suite | Semi-automated migration tooling |
| PI/PO BPM workflows | BTP Build Process Automation |
| EDI/B2B scenarios | SAP Integration Suite Trading Partner Management |

> SAP provides migration assessment tools, semi-automated migration flows, and partner solutions for regression testing.

---

## Key SAP Notes and References

| Resource | Description |
|----------|-------------|
| [SAP Business Accelerator Hub](https://hub.sap.com/) | All published APIs, events, iFlows, and integration packages |
| [SAP Integration Suite Trial](https://account.hanatrial.ondemand.com/) | Free trial for hands-on exploration |
| [Integration Solution Advisory Methodology](https://www.sap.com/services-support/integration-solution-advisory-methodology.html) | ISAM framework for integration strategy |
| SAP Cloud ALM – Integration & Exception Monitoring | Monitor integration health in productive systems |

---

**Last Updated**: 2026-03-10
**Sources verified**: 2026-03-10
