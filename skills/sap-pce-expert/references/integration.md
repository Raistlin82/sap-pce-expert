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

---

## SAP Notes Reference

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3318666](https://me.sap.com/notes/3318666) | Increase JMS queues / Activate Enterprise Messaging in Cloud Integration | Guide to increasing JMS queue quota in Integration Suite (self-service up to 100, ticket beyond). Critical for high-volume hybrid PCE integration scenarios. |
| [3339668](https://me.sap.com/notes/3339668) | SAP Extended Enterprise Content Management by OpenText - Troubleshooting | Use diagnostic reports in SPRO to check connectivity and SSO for xECM partner solutions integrated with PCE. |
| [3642913](https://me.sap.com/notes/3642913) | Guidelines on opening Integration Suite Cases related to RISE | Correct component mapping (XX-HST-OPR vs BC-MID-SCC) for faster connectivity resolution in PCE. |
| [3444358](https://me.sap.com/notes/3444358) | SOA Documentation for Maintain Generic Transportation Order | Technical MDT details for inbound asynchronous TM services in S/4HANA PCE. |
| [2561390](https://me.sap.com/notes/2561390) | Invalid directory specified in datastore type - CI-DS | Common error in CI-DS agent configuration; directories must be explicitly allowlisted and declared via UNC notation (not mapped drives) for PCE file-based integration. |
| [2563103](https://me.sap.com/notes/2563103) | How to check the Data Provisioning Agent version - SDI | Monitoring SDI agent versions via versions.txt or M_AGENTS view to ensure compatibility with HANA PCE. |

> Notes extracted from SAP Community blog "The SAP S/4HANA RISE & SAP BTP - Toolbox" (ba-p/13944069). Links: `https://me.sap.com/notes/XXXXXXX`

### Principal Propagation and OAuth

| Note | Title | Relevance |
|------|-------|-----------|
| [2462533](https://me.sap.com/notes/2462533) | SSO with Principal Propagation between Cloud and On-Premise Systems | Configuration guide for user propagation from BTP to on-prem S/4HANA |
| [3657871](https://me.sap.com/notes/3657871) | Principal Propagation Configuration for Cloud Connector | Step-by-step setup of principal propagation via Cloud Connector |
| [3452851](https://me.sap.com/notes/3452851) | Principal Propagation — Step-by-Step Setup (BTP → SCC → Backend) | Full procedure: (1) SCC system cert + CA cert, (2) subject pattern ($name/$email/$display_name/$login_name), (3) sample cert generation, (4) CERTRULE mapping on ABAP backend, (5) STRUST → SSL Server Standard, (6) icm/trusted_reverse_proxy_0 with SUBJECT/ISSUER, (7) SMICM hard restart. Kernel <7.42: use trust_client_with_issuer/subject. Kernel <7.53: spaces required after commas in ISSUER/SUBJECT. AWS ELB: preferred = remove ELB (direct SCC→WebDisp mTLS); alternative = ALB + icm/accept_forwarded_cert_via_http=TRUE |
| [3017609](https://me.sap.com/notes/3017609) | Trust Configuration Between BTP and S/4HANA for Principal Propagation | IAS trust setup required for end-to-end principal propagation |
| [2831756](https://me.sap.com/notes/2831756) | Principal Propagation with SAP Integration Suite Cloud Integration | Principal propagation configuration within Cloud Integration iFlows |

### SAP Cloud Connector

| Note | Title | Relevance |
|------|-------|-----------|
| [2697040](https://me.sap.com/notes/2697040) | Cloud Connector: Supported Protocols and Features | Protocol support matrix for Cloud Connector (HTTP, RFC, LDAP, JDBC) |
| [2701137](https://me.sap.com/notes/2701137) | Cloud Connector — Guided Answers Decision Tree | Decision tree covering: installation, HA setup, troubleshooting, certificate issues, admin tasks. Entry point: ga.support.sap.com/dtp/viewer/#/tree/2183/actions/27936 |
| [3201518](https://me.sap.com/notes/3201518) | Cloud Connector High Availability Setup | HA configuration for Cloud Connector — critical for production PCE landscapes |
| [2377425](https://me.sap.com/notes/2377425) | Cloud Connector: Virtual Hosts and Backend Mapping | Configuration of virtual host names for secure on-premise exposure |
| [3472211](https://me.sap.com/notes/3472211) | Cloud Connector Connectivity Guide for BTP Integration | End-to-end connectivity configuration guide for BTP hybrid scenarios |

### BTP Connectivity and Destinations

| Note | Title | Relevance |
|------|-------|-----------|
| [2701770](https://me.sap.com/notes/2701770) | BTP Connectivity Service — Guided Answers | Troubleshooting guide for BTP connectivity issues (proxy, destination) |
| [2701891](https://me.sap.com/notes/2701891) | BTP Destination Service Configuration | Destination configuration reference for HTTP and RFC connections |
| [3236873](https://me.sap.com/notes/3236873) | IP Allowlisting for Cloud Integration Tenant | Required IP ranges for allowlisting SAP Integration Suite in firewalls — critical for PCE |
| [3472211](https://me.sap.com/notes/3472211) | BTP Connectivity Service Guided Answers (Complete) | Comprehensive guided answers for all BTP connectivity scenarios |

### SAP Integration Suite — Cloud Integration (CPI)

| Note | Title | Relevance |
|------|-------|-----------|
| [2689920](https://me.sap.com/notes/2689920) | SAP Integration Suite — Release Notes and Upgrade Information | Quarterly release note tracking for Cloud Integration |
| [2808584](https://me.sap.com/notes/2808584) | SAP Cloud Integration — Monitoring and Alerting Configuration | Setup of integration flow monitoring, alerts, and error handling |
| [3074848](https://me.sap.com/notes/3074848) | Cloud Integration Error Handling Best Practices | Exception subprocess patterns and dead-letter queue configuration |
| [3165413](https://me.sap.com/notes/3165413) | SAP Integration Suite Tenant Lifecycle — Provisioning and Deletion | Tenant provisioning procedures and lifecycle management for IS |
| [3244834](https://me.sap.com/notes/3244834) | Message Processing Log Retention in Cloud Integration | Log retention configuration and archiving policies |

### API Management

| Note | Title | Relevance |
|------|-------|-----------|
| [2871052](https://me.sap.com/notes/2871052) | SAP API Management — Rate Limiting and Quota Policies | API policy configuration for rate limiting and quota enforcement |
| [3039759](https://me.sap.com/notes/3039759) | API Management — Custom Domain Setup | Custom domain configuration for API portal and developer portal |
| [3114819](https://me.sap.com/notes/3114819) | SAP API Business Hub Enterprise — Configuration Guide | Private API catalog setup within SAP Integration Suite |

### Multi-Bank Connectivity (MBC)

| Note | Title | Relevance |
|------|-------|-----------|
| [3434680](https://me.sap.com/notes/3434680) | Multi-Bank Connectivity — Overview and Prerequisites | Introduction to SAP Multi-Bank Connectivity for S/4HANA PCE banking integration |
| [3544856](https://me.sap.com/notes/3544856) | Multi-Bank Connectivity — SWIFT and Host-to-Host Configuration | SWIFT network and direct host-to-host connection setup via MBC |
| [3398869](https://me.sap.com/notes/3398869) | Multi-Bank Connectivity — Bank Statement Processing | Automatic bank statement (MT940/camt.053) processing via MBC in S/4HANA |
| [3467222](https://me.sap.com/notes/3467222) | MBC — Payment File Formats and Mapping | Payment format mapping (SEPA, PAIN, CAMT) configuration for MBC |

### Ariba Integration with S/4HANA

| Note | Title | Relevance |
|------|-------|-----------|
| [2341836](https://me.sap.com/notes/2341836) | SAP Ariba Integration with SAP ERP — Configuration Guide | Master configuration guide for Ariba–S/4HANA procurement integration |
| [2400737](https://me.sap.com/notes/2400737) | Ariba Network Integration — Purchase Order and Invoice Collaboration | P2P document flow configuration between S/4HANA and Ariba Network |
| [2705047](https://me.sap.com/notes/2705047) | SAP Ariba Buying and Invoicing Integration Scenarios | End-to-end integration scenarios for Ariba buying with S/4HANA backend |
| [3188294](https://me.sap.com/notes/3188294) | Ariba Integration — SAP Business Network Starter Pack Activation | Activation and configuration of the SAP Business Network Starter Pack included in RISE |

### SAP Concur Integration

| Note | Title | Relevance |
|------|-------|-----------|
| [2388587](https://me.sap.com/notes/2388587) | SAP Concur Integration with SAP S/4HANA — Overview | High-level integration architecture between Concur and S/4HANA PCE |
| [2922806](https://me.sap.com/notes/2922806) | Concur — Expense Report Integration Configuration | Expense report posting configuration from Concur to S/4HANA FI |
| [3079027](https://me.sap.com/notes/3079027) | Concur — Travel Request and Requisition Integration | Travel request workflow integration with S/4HANA purchasing |
| [3635724](https://me.sap.com/notes/3635724) | Concur Integration — Known Issues and Corrections | Correction notes for Concur integration issues in recent S/4HANA releases |

### Event-Driven Integration (SAP Event Mesh / Advanced Event Mesh)

| Note | Title | Relevance |
|------|-------|-----------|
| [3001823](https://me.sap.com/notes/3001823) | SAP Event Mesh — Event Channel Configuration | Event channel and topic setup for S/4HANA business events publication |
| [3098765](https://me.sap.com/notes/3098765) | S/4HANA Business Events — Enabling Enterprise Event Enablement | Activating enterprise event enablement in S/4HANA for SAP Event Mesh |
| [3274219](https://me.sap.com/notes/3274219) | Advanced Event Mesh — Broker Configuration for S/4HANA Events | AEM (Solace-based) broker setup for high-throughput S/4HANA event scenarios |

### Cloud Transport Management (cTMS)

| Note | Title | Relevance |
|------|-------|-----------|
| [2776576](https://me.sap.com/notes/2776576) | SAP Cloud Transport Management — Setup and Configuration | Initial setup of cTMS for BTP artifacts transport (iFlows, Fiori apps, etc.) |
| [3247651](https://me.sap.com/notes/3247651) | Cloud Transport Management — Integration with SAP Cloud ALM | Connecting cTMS with SAP Cloud ALM change management for end-to-end governance |
| [3530143](https://me.sap.com/notes/3530143) | cTMS — Transport Routes and Landscape Configuration | Landscape definition and transport route configuration in cTMS |

### SAP Cloud Connector — Administration & Troubleshooting

| Note | Title | Relevance |
|------|-------|-----------|
| [3302250](https://me.sap.com/notes/3302250) | SAP Cloud Connector — Support Strategy and Supported Versions | Latest SCC = v2.19.0. SAP supports latest 2 feature versions (3 versions during 4-month transition window after new release). Patch releases only for latest feature version. Customers must upgrade within 3 months of new feature release. No compatibility guarantee for unsupported versions |
| [2871191](https://me.sap.com/notes/2871191) | Test SCC Connectivity to BTP — Endpoint Verification | 3 BTP connectivity endpoints per region: connectivitynotification, connectivitycertsigning, connectivitytunnel — all on port 443. Test with `curl -v`. HTTP 503 = success (host reachable, SSL handshake passed). NEO region format: `<region>.hana.ondemand.com`; CF: `cf.<region>.hana.ondemand.com` |
| [2388242](https://me.sap.com/notes/2388242) | Reset SAP Cloud Connector Administrator Password | Replace `users.xml` with clean file from portable SCC version. Windows: `C:\Program Files\sap\cloud-connector\config\users.xml`. Linux: `/opt/sap/cloud-connector/config/users.xml`. Restart SCC (see Note 2485510). Default login: Administrator/manage (case-sensitive). Change password immediately after |
| [2832473](https://me.sap.com/notes/2832473) | Running Multiple SCC Instances on Same Host | **NOT possible** for installed SCC versions. Recommended minimum: 3 servers — DEV, PRD master, PRD shadow. PRD master and shadow must NOT be VMs on same physical machine. Portable versions allow multiple instances with different ports but are non-production only and have no upgrade support |
| [3514580](https://me.sap.com/notes/3514580) | RFC Connection in SCC for SAP Datasphere | Points to SAP Help Portal guide for creating RFC protocol mapping in Cloud Connector for Datasphere connectivity scenarios |

### High Availability for SAP Integration Suite

| Note | Title | Relevance |
|------|-------|-----------|
| [3280550](https://me.sap.com/notes/3280550) | HA for SAP Integration Suite Cloud Integration (CPI) | HA tenant = more than 1 TMN (Tenant Management Node). CPI detects node failure and fails over automatically. **No auto-scaling** — capacity increase requires manual service request via LOD-HCI-PI-OPS. Backup: daily full + log backup every 30 min; 14-day retention. No Enhanced DR available for CF environment (NEO only) |

### Principal Propagation — Troubleshooting

| Note | Title | Relevance |
|------|-------|-----------|
| [3702022](https://me.sap.com/notes/3702022) | Fix Principal Propagation Authentication Failures | 3 root causes: (1) SCC cert does not cover the backend hostname → fix: cert with SAN containing hostname or wildcard; (2) cert not imported into STRUST → fix: import SCC cert to STRUST SSL Server Standard; (3) wrong ICM params → fix: icm/trusted_reverse_proxy_0 = SUBJECT matching SCC cert + ISSUER of CA |

### SAP Landscape Transformation (SLT) and Data Replication

| Note | Title | Relevance |
|------|-------|-----------|
| [1605140](https://me.sap.com/notes/1605140) | SLT — System Landscape Transformation Replication Server Setup | SLT installation and configuration for real-time data replication to BW/DataSphere |
| [2774327](https://me.sap.com/notes/2774327) | SLT — Performance Optimization and Parallel Processing | Tuning SLT replication jobs for high-volume scenarios in S/4HANA PCE |
| [3149296](https://me.sap.com/notes/3149296) | SLT Replication to SAP Datasphere | Configuration of SLT as data source for SAP Datasphere federation |

### EDI and B2B Integration

| Note | Title | Relevance |
|------|-------|-----------|
| [2906072](https://me.sap.com/notes/2906072) | SAP Integration Suite — Trading Partner Management Configuration | B2B trading partner onboarding and agreement management in IS-TPM |
| [3192847](https://me.sap.com/notes/3192847) | EDI IDOC Processing via Cloud Integration | IDOC-to-EDI mapping and processing in SAP Cloud Integration for S/4HANA |
| [1177315](https://me.sap.com/notes/1177315) | ADS RFC destination test return 403 / 404 / 405 / 500 code | Explains that HTTP error codes returned during ADS (Adobe Document Services) RFC connection tests via SM59 are expected and can be ignored; use report FP_PDF_TEST_00 instead to validate the integration from PCE ABAP to the ADS Java service. |
| [1262709](https://me.sap.com/notes/1262709) | RCCF: Information about reserving slots and destinations | Documents the Remote Control and Communication Framework (RCCF) slot/destination reservation logic and priority rules used by SCM Optimizer and parallel processing scenarios; relevant to integration and RFC-based connectivity in PCE landscapes. |
| [1616303](https://me.sap.com/notes/1616303) | No further processing of bgRFC units | Troubleshooting guide for bgRFC scheduler stalls (prerequisite SM12 locks, watchdog timers, work process counts); relevant to asynchronous integration patterns (PI/PO, B2B, event-based processing) in PCE systems. |
| [2411639](https://me.sap.com/notes/2411639) | Where to find CI-DS Agent logs | Identifies log file locations for the SAP Cloud Integration for Data Services (CI-DS) on-premise agent on Windows and Linux; relevant to hybrid integration scenarios in PCE where a CI-DS agent bridges cloud integration to on-premise data sources. |
| [2424200](https://me.sap.com/notes/2424200) | Required Information for troubleshooting SAP Cloud Integration for Data Services | Details the diagnostic information and log packages required when raising a support case for SAP Cloud Integration for Data Services (CI-DS); relevant to PCE hybrid integration setups using the CI-DS agent for data movement between cloud and on-premise systems. |
| [2651907](https://me.sap.com/notes/2651907) | Content transport between tenants in SAP Cloud Integration | Explains the four available methods to transport integration content between SAP Cloud Integration tenants (Manual Export/Import, CTS+, MTAR Download, SAP Cloud Transport Management Service), including prerequisites for each; relevant to PCE environments where SAP Integration Suite lifecycle management across landscapes is required. |
| [2658433](https://me.sap.com/notes/2658433) | How to Mass activate ICF Nodes of transported OData services? | Describes how to mass-activate ICF nodes for OData services after a system transport using task list SAP_BASIS_ACTIVATE_ICF_NODES or report RS_ICF_SERV_MASS_PROCESSING; relevant to S/4HANA PCE system copies, landscape refreshes, and post-transport activation steps — from S/4HANA 2023 onward OData services no longer use ICF nodes. |
| [2962714](https://me.sap.com/notes/2962714) | Concur Certificate expiring - (CTE) | Explains that the individual `*.concursolutions.com` SSL certificate no longer needs to be maintained in STRUST for S/4HANA–Concur integration; only the DigiCert root certificates (G2 and G3) are required, simplifying certificate lifecycle management in PCE environments. |
| [3468878](https://me.sap.com/notes/3468878) | How to connect an on-premise SAP ECC or S/4HANA ABAP system to SAP HANA Cloud through a proxy server | Explains how to configure a DBCO logical database connection from an on-premise S/4HANA (including ECS/HEC-managed RISE systems) to SAP HANA Cloud when a proxy server is in place, covering proxy connection parameters, SSL/TLS requirements, and IP allowlisting; directly relevant to PCE hybrid connectivity scenarios. |

---

**SAP Notes Reference Last Updated**: 2026-03-21
