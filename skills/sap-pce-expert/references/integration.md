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


### Additional Notes (2026 Enrichment)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1867160](https://me.sap.com/notes/1867160) | Data Services job fails to extract from ECC via Client pointing to a non-modifiable repository - SAP Data Services | Extracting from a non-modifiable S/4 system (as PCE prod always is), the Data Services ABAP 'Generate and Execute' option fails; upload ABAP dataflow programs and set the datastore to 'Execute Preloaded'. |
| [1891274](https://me.sap.com/notes/1891274) | How to set SAP user authorizations for SAP Data Services and SAP Cloud Integration for data services? | Authorization objects (S_RFC, S_TABU_DIS, S_BTCH_JOB, custom S_DSAUTH/S_SDS etc.) required on the SAP side for Data Services / Cloud Integration for data services to extract from a PCE S/4HANA system. |
| [1978857](https://me.sap.com/notes/1978857) | WS/RM Integration Guide for SAP Transportation Management | Point-to-point WS/RM (Web Service Reliable Messaging) integration of S/4HANA TM (as of 1709, incl. embedded TM<=>EWM) with ERP/GTS/EWM without PI mediation; relevant for PCE integration architecture. |
| [2012233](https://me.sap.com/notes/2012233) | How to create external alias in transaction code SICF | Create ICF external aliases in SICF to expose services (e.g. webgui) under clean URLs; used for Fiori/HTTP service exposure and reverse-proxy routing in PCE. |
| [2258549](https://me.sap.com/notes/2258549) | An existing connection was forcibly closed by the remote host - SAP Cloud Connector | Cloud Connector 'connection forcibly closed' (ljs_trace.log) fix: protocol/port mismatch, proxy/firewall, or low ICM timeout on the S/4HANA PCE backend. |
| [2324184](https://me.sap.com/notes/2324184) | SAP Cloud Integration for data services Release Information | Central release/patch tracker for SAP Cloud Integration for data services (CI-DS) Server and Agent versions per data center; used for data loads/integration into S/4HANA PCE. |
| [2392606](https://me.sap.com/notes/2392606) | Initialization of Web Service Configuration | Report SRT_WSP_INITIALIZE_WS_CFG (successor to SRT_ADMIN_SYS_COPY) clears/reinitializes SOAMANAGER web service config (logical ports, endpoints, registries) after a system copy, needed for post-refresh integration cleanup in PCE. |
| [2397165](https://me.sap.com/notes/2397165) | How do I connect the SAP Cloud Connector (SCC) to SAP Analytics Cloud (SAC)? | Configuring the SAP Cloud Connector subaccount (region host, S-/P-user, location ID) to link SAC to S/4HANA on-premise/BW for import and live connections, a standard hybrid integration pattern for PCE. |
| [2457930](https://me.sap.com/notes/2457930) | How to troubleshoot DP Agent Proxy issues - SDI | Troubleshoot HANA Smart Data Integration DP Agent proxy errors (407, dpagentconfig.ini log level, secure_storage) when SDI connects through a proxy to PCE HANA. |

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
| [2445282](https://me.sap.com/notes/2445282) | Is it possible for one DP Agent to connect to several SAP HANA systems? | A HANA Smart Data Integration (SDI) Data Provisioning Agent can register with only one target HANA DB (dpagentconfig.ini) - plan one DP Agent per HANA system (including Datasphere/SAC targets) when sizing SDI-based real-time replication for PCE. |
| [2548152](https://me.sap.com/notes/2548152) | Increase Heap size of SAP Cloud Connector | Tune Cloud Connector Java VM heap/direct-memory when SCC is slow or terminates under many backend connections ('failed to allocate direct memory') — key for PCE hybrid on-premise connectivity. |
| [2571763](https://me.sap.com/notes/2571763) | Authorization problem in SAP Cloud Connector when adding Cloud Foundry subaccount | Resolve SCC '417/401/403' errors when adding a CF subaccount: use subaccount UUID + login e-mail (S-user, not Universal ID), correct AWS region, required role and 2FA passcode — core PCE-to-BTP connectivity setup. |
| [2577197](https://me.sap.com/notes/2577197) | Recommended location for DP Agent Installation - SDI | Install the HANA Smart Data Integration DP Agent on a separate host close to the source (min 4-core/16GB/30GB), never on the HANA system itself — sizing guidance for PCE SDI-based integration. |
| [2608492](https://me.sap.com/notes/2608492) | Additional Information for Cloud Integration Automation Service | Cloud Integration Automation Service (CIAS) provides guided, no-extra-cost workflows to wire up integrations between SAP cloud products from a BTP subaccount; useful for PCE architects setting up S/4HANA-to-cloud integration scenarios (note release status, data-center regions, English-only limits). |
| [2653269](https://me.sap.com/notes/2653269) | Configuring and Accessing SAP Integration Advisor | Provision SAP Integration Advisor from BTP cockpit and assign roles (Guidelines.ReadWrite, TypeSystem.Read) for the icaapp - relevant when building B2B/EDI mapping content on RISE Integration Suite Enterprise edition. |
| [2667924](https://me.sap.com/notes/2667924) | Access denied to resource ... on system ... In case this was a valid request, ensure to expose the resource correctly in your cloud connector. | Cloud Connector "Access denied to resource/system" 403 errors when a BTP/hybrid app calls an S/4HANA PCE backend: fix Cloud-to-On-Premise Access Control resource mapping (case-sensitive paths), use virtual host/port not internal, and ensure unique Location IDs across multiple SCCs on one subaccount. |
| [2712296](https://me.sap.com/notes/2712296) | SAP Analytics Cloud subaccount is not visible in the SAP BTP Cockpit | Why an SAP Analytics Cloud subaccount is hidden in BTP Cockpit (SAP-managed; only the configured Subaccount User sees Cloud Connector info under the EPM Team global account) - context when wiring SAC live connections to S/4HANA PCE via Cloud Connector. |
| [2712590](https://me.sap.com/notes/2712590) | SAP Business Technology Platform and SAP Solution Manager ChaRM scenario | Wire Solution Manager ChaRM to SAP Cloud Transport Management (Cloud TMS) or CTS+ via LMDB external-service systems and OAuth RFC destinations to transport BTP/hybrid extension content alongside PCE. |
| [2714853](https://me.sap.com/notes/2714853) | SICF Fiori services not available, /sap/opu/odata/UI2/ missing | Re-add missing /UI2/ Fiori Launchpad OData services (INTEROP, PAGE_BUILDER_*, etc.) via /IWFND/MAINT_SERVICES and activate ICF nodes when STC01 basic Fiori config fails on the PCE frontend. |
| [2726437](https://me.sap.com/notes/2726437) | How to add additional administrative users to Cloud Connector | Add named admin users to SAP Cloud Connector by switching to an LDAP user store (admin/sccadmin groups) since only one built-in admin exists — governs SCC used for PCE-to-BTP connectivity. |
| [2758852](https://me.sap.com/notes/2758852) | SAP Cloud Platform Transport Management Service availability | BTP Cloud Transport Management (CTMS) availability/commercial model on BTP Cloud Foundry; used in RISE/PCE to transport BTP extension artifacts across dev/test/prod. |
| [2807852](https://me.sap.com/notes/2807852) | How to create DP Agent FullSystemDump - SAP HANA Smart Data Integration | Generate SDI Data Provisioning Agent full system dump via agentcli --createFullSystemDump for support; relevant to troubleshooting HANA SDI real-time replication feeding PCE HANA. |
| [2844772](https://me.sap.com/notes/2844772) | "Communication scenario already in use" when creating/modifying a communication arrangement | Communication Arrangements app / SAP_COM_* scenarios that allow only one instance per client throw 'Communication scenario already in use'; delete duplicate (incl. draft) arrangements when configuring API integrations in PCE. |
| [2871045](https://me.sap.com/notes/2871045) | SAP Cloud Connector dump - OutOfMemoryError: Java heap space | SCC tunnel traffic stops with OutOfMemoryError (ljs_trace.log/scc_core.trc); set initial=max JVM heap per sizing guide, monitor Hardware Metrics, upgrade to >=2.18.0 for leak fixes - critical for RISE hybrid on-prem/BTP connectivity. |
| [2923196](https://me.sap.com/notes/2923196) | FAQ: Financial Posting in the Concur Integration | Concur-S/4HANA native integration FI posting FAQ (credit card handling, posting limitations) - reference for PCE expense-management integration scenarios. |
| [2933925](https://me.sap.com/notes/2933925) | Setup embedded TM- embedded EWM Integration via soamanager (WSRM) | Embedded TM-EWM web-service integration setup/refresh via SOAMANAGER/WSRM (check SRT_MONI, SLD) - transferable to any embedded-component SOAP integration after system copy in PCE. |
| [2948977](https://me.sap.com/notes/2948977) | How to Register OData V4 Service in SAP Gateway System? | Publish/activate OData V4 service groups via tx /IWFND/V4_ADMIN and test (200 status) - foundational Gateway step for Fiori apps and OData APIs in PCE. |
| [2971940](https://me.sap.com/notes/2971940) | How to Find the Endpoint of a HANA Cloud / HANA Service Instance in the SAP BTP Cockpit | Locate HANA Cloud/HANA Service endpoints via BTP Cockpit > Instances and Subscriptions > HANA Cloud Central - needed when wiring PCE side-by-side BTP extensions to HANA Cloud. |
| [3003350](https://me.sap.com/notes/3003350) | OAuth enablement for CMIS repositories | Enables OAuth (CL_CMIS_OUTBOUND_API) for CMIS document repositories; implement companion notes 3008650/3003412 - secures outbound document-management integration from ABAP in PCE. |
| [3011960](https://me.sap.com/notes/3011960) | Connecting External CMIS repository to SAP S/4 Cloud systems | Communication scenario SAP_COM_0597 connects a customer-managed CMIS repository to S/4HANA Cloud for storing new documents (no migration) - external document-storage integration pattern for cloud ERP. |
| [3018349](https://me.sap.com/notes/3018349) | Error "Agent messaging privilege not found for agent XXX" for DP Agent connecting with SAP Datasphere | SDI DP Agent 'messaging privilege not found': ensure agent.name in dpagentconfig.ini and the HANA XS messaging user match the registered instance (System > Configuration > Data Integration) - fixes SDI replication from S/4/HANA to Datasphere/SAC. |
| [3094622](https://me.sap.com/notes/3094622) | Connecting the CMIS repository to your SAP system | OAC0 with Storage Type 'CMIS Content Server' plus a Type G RFC destination (OAuth optional) connects an external CMIS content repository for document storage on S/4HANA (Basis 752+); external content-server integration for PCE. |
| [3106619](https://me.sap.com/notes/3106619) | SAP IBP Real-time integration - Notes for installation | Prerequisite SP levels/notes and business functions SCM_GEN_01/02 to enable SAP IBP Real-Time Integration on S/4HANA, install via SNOTE for the S/4HANA-IBP integration scenario. |
| [3110007](https://me.sap.com/notes/3110007) | IBP Real-time Integration: Information/Restrictions | IBP Real-Time Integration restrictions/prereqs for S/4HANA private cloud: requires SAP Connectivity service + Cloud Connector (not metered), order-based planning area SAP7F, plus documented process/master-data limits. |
| [3115273](https://me.sap.com/notes/3115273) | SAP IBP Real-Time Integration - Roles | Delivers S/4HANA authorization roles SAP_SCM_IBP_RTI_MAIN_1/CONFIG_1 required for IBP Real-Time Integration; upload after prerequisite notes. |
| [3118326](https://me.sap.com/notes/3118326) | Using an SICF external alias for IDoc via SOAP access path | IDoc-via-SOAP (SRTIDOC) ICF path does not support a manually created SICF external alias ("No Web service configuration for this access path"); delete it, relevant for PCE SOAP/IDoc integration. |
| [3129197](https://me.sap.com/notes/3129197) | ArchiveLink Item Creation Issue in CMIS repository | OAC0 ArchiveLink to CMIS repository: program-error fix where CL_ALINK_CONNECTION->CREATE_CMIS_ITEM fails to create the Business Object relation ('sapbo:ArchiveLink' cmis:item) — relevant to PCE external content-server archiving. |
| [3139456](https://me.sap.com/notes/3139456) | How to set up DP Agent services start automatically with the Linux operating system- SAP HANA Smart Data Integration | Configure a systemd unit to auto-start the HANA SDI Data Provisioning Agent (dpagent) on Linux reboot — relevant when SDI real-time data provisioning agents feed a PCE HANA landscape. |
| [3140199](https://me.sap.com/notes/3140199) | IFbA: OAuth 2.0 Client Profile for ADS connection over the logical port | Use delivered OAuth 2.0 client profile ADS_OAUTH2_PROFILE in OA2C_CONFIG to authenticate the ADS logical-port connection to SAP Forms service by Adobe — form-output integration from PCE. |
| [3151782](https://me.sap.com/notes/3151782) | Issue with Archivelink Document creation in CMIS repository | Program-error fix for failure to save ArchiveLink documents into a CMIS content repository via the Content Management Service — PCE external content archiving. |
| [3165420](https://me.sap.com/notes/3165420) | Connection to HTTP content server in OAC0/CSADMIN failed with error 'NIECONN_REFUSED' | Resolve OAC0/CSADMIN HTTP content-server connection failures caused by a global HTTP proxy redirecting the request — check tables THTTP, HTTPURLLOC and SM59 HTTP Proxy Configuration — PCE content-server connectivity. |
| [3196836](https://me.sap.com/notes/3196836) | SAP BTP Cloud Foundry: Trouble Shooting for Client Authentication (mTLS) Problems | mTLS/client-auth troubleshooting for CF-deployed apps and CPI endpoints (HTTP 401, SNI, TLS 1.2/1.3 cipher suites, cert chains, tenant mapping); core to Integration Suite/CPI inbound connectivity in RISE. |
| [3254953](https://me.sap.com/notes/3254953) | SAP Data Intelligence / SAP Datasphere - ABAP Integration - SAP S/4HANA 2023 | Master correction-note list (verify via Note Analyzer 3016862) for SAP Datasphere/Data Intelligence ABAP integration on S/4HANA 2023 (Basis 7.58) — SLT/ODP/CDS replication flows from a PCE S/4HANA source. |
| [3260185](https://me.sap.com/notes/3260185) | ABAP Data Integration - Runtime Parameters (DHBAS_RUNTIME / LTBAS_RUNTIME) | Reference for ABAP Data Integration runtime parameters (MAX_APE_SESSIONS, RMS_MAX_PARTITIONS, ODP package size) set via SM30/DHADM; Cloud Connector whitelist decides DHAPE_* (S/4) vs LTAPE_* (DMIS) — tuning Datasphere replication load on PCE. |
| [3273867](https://me.sap.com/notes/3273867) | How to use SAP Variant Configuration and Pricing data replication when the source system is managed by SAP Enterprise Cloud Services (ECS) | ECS/RISE setup of a HANA SDI DP Agent for Variant Configuration and Pricing (CPS) replication: raise ECS service requests ('Install an agent', 'Assisted Service Request'), create CPS_SDI_REPLICATION HANA user, pass credentials via Customer Remote Logon Depot — ECS operational process. |
| [3274769](https://me.sap.com/notes/3274769) | OAuth 2.0 client Profile ADS_OAUTH2_PROFILE is missing | OA2C_CONFIG dropdown lacks ADS_OAUTH2_PROFILE for connecting S/4HANA to SAP Forms Service by Adobe (Cloud Foundry); requires min SAP_BASIS level (1809 SP8+/1909 SP6+/2020 SP4+/2021+), relevant when wiring PCE Adobe forms to BTP. |
| [3276488](https://me.sap.com/notes/3276488) | HTTPS connection to Backend system is "Not Reachable" from SAP Cloud Connector with error "Peer certificate rejected by ChainVerifier" | Cloud Connector backend unreachable ('Peer certificate rejected by ChainVerifier') when 'Determining Trust Through Allowlist' toggle is on but the backend root cert is missing from the trust store; key for PCE hybrid connectivity setup. |
| [3279287](https://me.sap.com/notes/3279287) | How to find the system alias used for the Taskprocessing service | Find the taskprocessing service system alias via /IWFND/MAINT_SERVICE (and My Inbox > Support Information for version); needed to configure Fiori My Inbox/workflow routing in PCE frontend/backend Gateway setups. |
| [3299657](https://me.sap.com/notes/3299657) | How to copy (export/import) CPI artifacts between tenants | Export/import Cloud Integration (CPI) iFlows/packages between Integration Suite tenants via manual export-import, MTAR, CTS+ or Cloud Transport Management - relevant to RISE hybrid integration content transport across DEV/TEST/PROD tenants. |
| [3313373](https://me.sap.com/notes/3313373) | How to use the Malware Scanner in SAP Cloud Integration | Enable the Cloud Integration malware scanner (Settings > Malware Scanner tab, Cloud Foundry only) to scan design-time artifact uploads; note no automated runtime scanning of inbound files (e.g. SFTP sender) - relevant to RISE Integration Suite security posture. |
| [3331767](https://me.sap.com/notes/3331767) | Issues while Transporting Content using SAP Cloud Transport Management Service (cTMS) | Troubleshoots cTMS 404/failed transports of Build Work Zone content (verify integration/config steps), applicable to cTMS-based content promotion in RISE/BTP landscapes. |
| [3343395](https://me.sap.com/notes/3343395) | FAQ: How to connect Cloud Integration to T-code AL11 | Cloud Integration cannot read AL11 directly; expose the file share via (S)FTP, which in RISE/ECS is provisioned by SAP via the PCO-OPS RISE Fileshare service request (KBA 3726822) with Cloud Connector for on-prem. |
| [3358694](https://me.sap.com/notes/3358694) | Integration between SAP Cloud ALM Deployment and SAP Cloud Transport Management service | Connects SAP Cloud ALM Deployment to a standalone cTMS instance (destination CALM_FTR_CTMS_*) to transport BTP-side artifacts (Integration Suite, BAS, Work Zone) in PCE landscapes. |
| [3358787](https://me.sap.com/notes/3358787) | SAP Cloud Connector - How to Set Up Subject Pattern that Simultaneously Satisfies NEO and CF Principal Propagation | Configure dual Cloud Connector subject patterns (CN=${mail} default plus CN=${email} exists) with two certrule certificates so principal propagation works for both NEO and Cloud Foundry. |
| [3367596](https://me.sap.com/notes/3367596) | FAQ: SAP Multi-Bank Connectivity (MBC) | FAQ for SAP Multi-Bank Connectivity (MBC) cloud service (SWIFT/EBICS) integrated with S/4HANA PCE for bank statement and payment connectivity. |
| [3369433](https://me.sap.com/notes/3369433) | How to troubleshoot Cloud Connector related issues when creating connection in SAP Datasphere | Cloud Connector troubleshooting (virtual host/port mapping, principal propagation, TLS, SICF Basic Auth) for connecting on-prem/PCE S/4HANA and BW ABAP systems to Datasphere via SDA/replication flows. |
| [3389204](https://me.sap.com/notes/3389204) | Support the import of multiple transport requests in the SAP Cloud Transport Management for imports of references of type BTP ABAP - Change Control Management | Cloud TMS now imports all/selected transports per queue for BTP ABAP references via ChaRM/QGM; PCE landscapes wiring cTMS-based deployment must import prior transports of the same Software Component together to avoid errors. |
| [3404816](https://me.sap.com/notes/3404816) | SAC Subaccount and URL Details in SAP Analytics Cloud | To configure Cloud Connector for SAC-to-on-prem S/4HANA (PCE) connectivity, find the SAC BTP subaccount ID under Main Menu > System > Administration > Datasource Configuration > SAP BTP Core Account (not visible in BTP Cockpit). |
| [3433720](https://me.sap.com/notes/3433720) | Cloud Transport Management Setup with Custom IDP in SAP CPI | Transporting CPI/Integration Suite artifacts via CTMS with a custom IDP requires BTP destinations set to OAuth2Password + technical user (origin handling per user type) - relevant to PCE hybrid integration CI/CD. |
| [3436149](https://me.sap.com/notes/3436149) | IBP Real-Time Integration Recommendations for Golive and Cut Over | IBP Real-Time Integration (RTI) golive/cutover: monitor S/4 inbound bgRFC queues in SBGRFCMON (and IBP Monitor bgRFC Queues), never delete queues, use reconciliation job - S/4-side integration ops for PCE. |
| [3447790](https://me.sap.com/notes/3447790) | Calling the endpoint of Odata API Artifact failed with 401 Unauthorized error | Cloud Integration OData API artifact returns 401; create the Process Integration Runtime service instance with plan 'integration-flow' (role ESBMessaging.send), not plan 'api', for inbound sender authentication. |
| [3447819](https://me.sap.com/notes/3447819) | Error "Virtual destination port is not valid" in S/4HANA On-Premise Connection - SAP Datasphere | Datasphere data/replication flow to S/4HANA fails with 'Virtual destination port not valid'; in Cloud Connector system mapping use protocol RFC and gateway port format sapgw<instance-nr> (e.g. sapgw55). |
| [3453814](https://me.sap.com/notes/3453814) | SLD Registration issues in migrated Process Orchestration system | After system copy or migration to RISE/ECS, PI/PO SLD registration, Communication Channels and transports break when SLD_DataSupplier/SLD_Client destinations point to wrong host; fix in NWA and rerun the AEX SLD self-registration wizard. |
| [3453943](https://me.sap.com/notes/3453943) | Error "Name or password is incorrect RFC_LOGON_FAILURE" in S/4HANA On-Premise Connection - SAP Datasphere | Datasphere flow to S/4HANA fails with RFC_LOGON_FAILURE; verify/unlock the remote RFC user via SU01, and for real-time replication pause it before re-entering the password so it propagates to the remote source. |
| [3474088](https://me.sap.com/notes/3474088) | Cloud Foundry Environment details missing in SAP Business Technology Platform cockpit | BTP cockpit troubleshooting when the Cloud Foundry API endpoint/Org details are missing in the subaccount, relevant to enabling CF for RISE-side BTP extensions. |
| [3498203](https://me.sap.com/notes/3498203) | Clarification on JMS queue loads | In Cloud Integration (Integration Suite) the Message Queues detail view may not list all messages by design; expectation-setting when monitoring JMS queues in a RISE integration setup. |
| [3499435](https://me.sap.com/notes/3499435) | Integration of SAP Task Center with SAP Build Work Zone across Different Sub Accounts | Integrate SAP Task Center with Build Work Zone across separate BTP global/subaccounts (remote subaccount config); common in RISE contracts where Work Zone and Task Center sit in different subaccounts. |
| [3519493](https://me.sap.com/notes/3519493) | How to Keep Your ERP up to date for RTI with quarterly IBP releases? | Systematic SAP Note search (components SCM-IBP-INT-RTI, SCM-S4H-INT-IBP, BC-MID-SCC, BC-CP-DEST-CF) to keep S/4HANA code current for SAP IBP Real-Time Integration across quarterly IBP releases. |
| [3543296](https://me.sap.com/notes/3543296) | Cannot access or use the SAP Cloud ALM Cloud Transport Management app when CTMS instance is in another Global account and Subaccount | SAP Cloud ALM built-in CTMS app only reaches legacy CTMS in the ALM subaccount; for RISE/PCE landscapes with CTMS in your own BTP global account, remove the app and use the connected CTMS via the standard setup procedure. |
| [3546211](https://me.sap.com/notes/3546211) | Error registering Service in SRTIDOC | Fix SRTIDOC "SOAP application unknown" by running report SRT_REGISTER_APPLICATION with application urn:sap-com:soap:runtime:application:idoc and class CL_SOAP_APPLICATION_IDOC; needed to enable SOAP-based IDoc web services on S/4HANA PCE. |
| [3548524](https://me.sap.com/notes/3548524) | Connectivity Proxy URL for Use with SAP AI Core | Use Connectivity Proxy URL http://connectivity-proxy.connectivity-proxy.svc.cluster.local:20003 in SAP AI Core to reach on-premise/PCE systems via Cloud Connector for hybrid connectivity. |
| [3557953](https://me.sap.com/notes/3557953) | How to Clone/Migrate API Management entities between tenants | Clone/transport SAP Integration Suite API Management entities (proxies, artifacts) between tenants via Tenant Cloning Tool / Cloud Transport Management; relevant to promoting API Management content across RISE/PCE integration landscapes. |
| [3558655](https://me.sap.com/notes/3558655) | SAP IBP real-time integration Implementation Project Evaluation Questionnaire | SAP IBP real-time integration (RTI) project risk-assessment questionnaire (submit to engage-ibp@sap.com) covering IBP-to-S/4HANA integration in private cloud environments. |
| [3568990](https://me.sap.com/notes/3568990) | Central KBA of SCM IBP Real-Time Integration (RTI) | Central how-to KBA for IBP Real-Time Integration with S/4HANA: connectivity/CIF customizing, RTI integration profiles, queues, reconciliation, performance and BAdIs for S/4HANA-to-IBP integration. |
| [3572234](https://me.sap.com/notes/3572234) | How to Clone/Migrate SAP Integration Suite entities between tenants | Matrix of tenant-to-tenant clone/migration support per Integration Suite capability (Cloud Integration, API Management, etc.) with the relevant procedure notes — reference when moving Integration Suite tenants in RISE landscapes. |
| [3574562](https://me.sap.com/notes/3574562) | Increase processing of JMS Queues | Raise Cloud Integration JMS throughput by increasing the JMS Sender adapter 'Number of concurrent processes' (keep 1-5, Non-Exclusive access) — Integration Suite performance tuning for RISE hybrid scenarios. |
| [3582994](https://me.sap.com/notes/3582994) | IBP: How to get "ABAP Cloud Tenant Host" and "Instance number" of IBP tenant | Cloud Connector service channel for RFC config: set host = Cloud Connector URL and instance number = last two digits of the service channel, core pattern for PCE cloud-to-on-premise RFC connectivity. |
| [3595329](https://me.sap.com/notes/3595329) | CMIS Repository with S/4 systems | Consolidated note for connecting a CMIS content repository to S/4HANA (1809+) for ArchiveLink/DMS document storage with OAuth handling; relevant for PCE external content repository setup. |
| [3607594](https://me.sap.com/notes/3607594) | Activation and Consumption of SAP Data Products for Business Data Cloud - Prerequisites (Collection Note) | Collection note listing per-release PCE backend prerequisites (SAP notes, remote-user role, CDS-view extraction annotations) to activate/consume BDC data products from S/4HANA Cloud Private Edition; use the attached Excel before installing packages in BDC Cockpit. |
| [3634323](https://me.sap.com/notes/3634323) | Error "Please re-enter credentials to establish connectivity for data flows / replication flows" in S/4HANA On-Premise Connection- SAP Datasphere | Datasphere data/replication flow validation against S/4HANA fails when the Cloud Connector Access Control Virtual System ID is malformed; use range 1-65535 without leading zeros for load-balanced RISE-to-Datasphere connectivity. |
| [3640118](https://me.sap.com/notes/3640118) | Error "The port must be a number" when validate S/4HANA On-Premise connection in Datasphere | Datasphere remote-table federation to S/4HANA via ABAP SQL service fails when RFC instead of HTTPS Cloud Connector mapping is used; create two SCC system mappings (RFC for flows, HTTPS for remote tables) and enter the HTTPS virtual host/port explicitly. |
| [3645653](https://me.sap.com/notes/3645653) | SAP S/4HANA 2025: Process Integration with SAP on-premise Solutions | Release-planning note listing SAP on-premise products (TM, EWM, GTS, MDG, CRM, SRM, BW/4HANA, ERP 6.0, etc.) with released process-integration scenarios and PAM links for S/4HANA 2025 / Cloud Private Edition 2025; reference for PCE 2025 sidecar landscape planning. |

---

**SAP Notes Reference Last Updated**: 2026-03-21
