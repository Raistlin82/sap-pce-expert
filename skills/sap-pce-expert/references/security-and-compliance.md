# Security and Compliance

> **Ownership**: Certifications (ISO 27001, SOC 1/2, GDPR, etc.), shared responsibility model, penetration testing policy, vulnerability management, network security controls, data residency, audit logging, encryption, ransomware/malware protection, SOC operations.
> **See also**: `cross-cutting/identity-and-access.md` (for IAM, SAML/OAuth, XSUAA, user provisioning), `infrastructure-and-deployment.md` (for VPC/VNET topology and hyperscaler network architecture), `operations-and-sla.md` (for HA/DR SLAs, patching, backup)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| RISE with SAP PCE Cybersecurity FAQ | https://community.sap.com/t5/technology-blog-posts-by-sap/rise-with-sap-s-4hana-cloud-private-edition-cybersecurity-faq-explained/ba-p/13562875 | SAP Community Blog |
| Secure Data Flow and Connectivity with SAP Cloud Services | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/secure-data-flow-and-connectivity-with-sap-cloud-services/ba-p/13580781 | SAP Community Blog |
| SAP Trust Center – Certifications | https://www.sap.com/sea/about/trust-center/certification-compliance.html | SAP Trust Center |
| RISE Roles and Responsibilities document | https://www.sap.com/sea/about/agreements/policies/hec-services.html | SAP Agreements |

---

## Security Architecture Overview

SAP S/4HANA Cloud, Private Edition (PCE) delivers a **multi-layered defence-in-depth and zero-trust architecture** covering infrastructure and technical managed services.

Key characteristics:
- Each customer gets a **dedicated, single-tenant environment** — separate VPC/VNET per customer
- SAP Enterprise Cloud Services (ECS) manages infrastructure, OS, DB, and application security
- End-to-end SLAs covering the entire stack under SAP operations management
- 24×7 Security Operations Centre (SOC)

---

## Customer Network Segregation

### Per-Customer Isolation

| Hyperscaler | Isolation Unit |
|-------------|---------------|
| AWS | Separate Account per customer |
| Azure | Separate Subscription per customer |
| GCP | Separate Project per customer |

Within each account/subscription/project, SAP creates a **dedicated VPC/VNET** with a private IP address space exclusively for that customer.

### Subnet Architecture

SAP ECS creates multiple subnets within the VPC/VNET:

| Subnet | Purpose |
|--------|---------|
| **Gateway subnet** | Internet Proxy, DNS, NAT, Customer Gateway Server (CGS) |
| **Application Gateway subnet** | WAF + Application Load Balancer for inbound internet traffic |
| **Admin subnet** | Jump hosts, terminal servers, admin plane |
| **Production subnet** | S/4HANA application servers, HANA database |
| **Non-production subnet** | Dev/QA systems (created on request) |

Each subnet is protected by **Security Groups** (AWS), **Network Security Groups** (Azure), or **Firewall rules** (GCP).

**Note**: Dev, QA, and Production systems reside in the same VPC/VNET. Communication between non-production and production is necessary for transport management and client copies.

---

## Secure Connectivity Options

### On-Premises to PCE

| Option | Details |
|--------|---------|
| **Dedicated private connection** | AWS Direct Connect, Azure ExpressRoute, GCP Cloud Interconnect. Recommended for productive workloads — higher quality, greater availability. Multiple bandwidths: 100Mbps to 10Gbps. Azure ExpressRoute supports network-level encryption. |
| **IPSEC VPN (Site-to-Site)** | High Availability configuration supported. Multiple throughput SKUs available. |
| **Internet (TLS 1.2)** | Inbound traffic inspected by WAF (Azure Application Gateway WAF / AWS WAF + ALB / GCP Cloud Armour). |
| **AWS Transit Gateway** | SAP ECS does not configure Transit Gateway within RISE landscape. However, PCE can connect to a customer-owned Transit Gateway in the customer's own AWS account. |
| **VPC/VNET Peering** | Supported between PCE and customer-owned account/subscription. Traffic traverses hyperscaler backbone network. Both Regional and Global Peering supported. |

### PCE to SAP BTP

- SAP **Cloud Connector** is pre-deployed in the PCE landscape
- Mutual TLS 1.2 (mTLS) authentication between Cloud Connector and SAP BTP Connectivity Service
- Outbound traffic via Internet Proxy with explicit allow-list for SAP BTP URLs
- BTP URLs (SAP BTP, SuccessFactors, Ariba, Fieldglass, SAP Support Hub) are pre-configured in the allow-list

### Services in BTP to Customer Hyperscaler

- **SAP Private Link service**: Establishes secure private connection between BTP services and customer-owned hyperscaler services — keeps traffic within hyperscaler network, no public internet.

### SAP BTP to SAP SaaS

- All connections via internet secured by TLS 1.2
- Protocols: OData, SFTP, HTTPS/REST, Cloud Integration Gateway (Ariba), Webhooks

---

## Inbound/Outbound Traffic Flows

### External Inbound Internet Traffic

- Inspected by WAF associated with:
  - **Azure**: Application Gateway WAF (OWASP protection, XSS, SQLi)
  - **AWS**: WAF + Application Load Balancer
  - **GCP**: Cloud Armour
- Only HTTPS (TLS 1.2+) permitted inbound
- **Not enabled by default** — must be requested during onboarding

### Inbound from Dedicated Network / VPN

- Traffic hits Standard Load Balancer (Layer 4, TCP/HTTP/HTTPS)
- SLB → Web Dispatcher → Application Server → HANA
- Non-HTTPS traffic (e.g., SAP GUI TCP) goes directly to application server — does **not** go through NLB
- WEBGUI is **not enabled** for PCE

### Outbound HTTPS to Internet

- Routed through Internet Proxy on Customer Gateway Server
- Only HTTPS protocol supported via proxy
- Allow-list controls which URLs can be accessed
- Pre-configured allow-list includes: SAP BTP, SuccessFactors, Ariba, Fieldglass, SAP Support Hub

### Outbound Non-HTTPS (e.g., SFTP)

- Routed via Azure Standard Load Balancer with SNAT
- Private IP translated to public SLB IP for external systems
- Rules must use IP addresses (not hostnames)
- Separate outbound SLB instance used for DR region

---

## Encryption

### Data in Transit

- **TLS 1.2** enforced end-to-end for all connections
- Mutual TLS 1.2 (mTLS) for Cloud Connector ↔ SAP BTP
- Azure ExpressRoute supports additional network-level encryption

### Data at Rest

- **HANA Volume Encryption** for in-memory database data and log files
- **AES-256** encryption algorithm
- IaaS provider encrypts storage (data files, log files, backups) using Server-Side Encryption (SSE) with server-managed keys

---

## Security Controls

### Access Controls for SAP Cloud Admins

By default, SAP cloud admins **cannot access customer business clients**:
- Admin access limited to Client 000
- Access to Client 000 requires:
  1. Encrypted HTTPS/VPN connections
  2. Strong authentication
  3. Terminal servers
  4. Jump hosts
  5. Session recording
  6. SAP SIEM monitoring all sessions
  7. DLP (Data Loss Prevention)

All administrative ports are blocked between systems by default. New admin sessions can only be initiated from the jump host area (admin plane).

### Threat Protection

| Control | Description |
|---------|-------------|
| **EDR** | Endpoint Detection & Response — detections integrated with SIEM/SOAR |
| **Malware protection** | Endpoint & Server Protection, Secure Booting |
| **Network security** | Dedicated connections, WAF, Security Groups, Load Balancers |
| **Internet Proxy + DNS Security** | Controls outbound access |
| **Threat Intelligence** | Continuous Security Monitoring |
| **Periodic patching** | Infrastructure, applications, and DB |

### Ransomware Mitigation

Three categories of controls:
1. **Preventive**: Network segregation, patch management, endpoint protection
2. **Detective**: SIEM, EDR, threat intelligence
3. **Reactive**: Incident response playbooks, backup/restore

Reference: [SAP Ransomware Whitepaper](https://www.sap.com/documents/2022/07/daf1e680-527e-0010-bca6-c68f7e60039b.html)

---

## Managed Firewall Service (PCE Tailored Option only)

Available on Azure for PCE Tailored Option customers:
- Full SPI-based packet filtering
- Deep Packet Inspection (IPS)
- Known bot activity scanning
- PCI DSS alignment support
- Enhanced traffic flow control

Contact Cloud Architect Advisory (CAA) for details.

---

## Security Certifications

SAP S/4HANA Cloud, Private Edition maintains the following third-party audited certifications:

| Certification | Scope |
|---------------|-------|
| **ISO 27001** | Information Security Management |
| **ISO 27017** | Cloud-specific security controls |
| **ISO 27018** | Protection of personal data in cloud |
| **ISO 9001** | Quality Management Systems |
| **BS 10012** | Personal Information Management |
| **ISO 22301** | Business Continuity Management Systems |
| **SOC 1 Type 2** | Financial reporting controls |
| **SOC 2 Type 2** | Security, Availability, Confidentiality, Privacy |

Download certificates: [SAP Trust Center – Compliance](https://www.sap.com/sea/about/trust-center/certification-compliance.html)
SOC attestation reports available on request via Trust Center (subject to NDA).

---

## Shared Responsibility Model

### SAP (ECS) is responsible for:

- Managing detective, protective, and remediation controls on cloud accounts
- Resilient platform architecture (HA and DR)
- Single-tenanted landscape
- Managed backup and restore
- Secure VMs, OS, networking, HANA database
- HANA DB management
- Technical managed services
- 24×7 Security Operations Centre (SOC)
- Personal data breach notification
- SLA and support services
- Threat management and patch management
- Operational security and incident management

### Customer is responsible for:

- Dedicated private connectivity to hyperscaler
- **Application user identity management**
- **Authentication and authorization for application users**
- **Definition of user roles, groups, and access control**
- Customer data ownership and logical integrity of data
- Compliance with government and industry regulations
- **Application security audit logging**
- Integration and extension support, including custom development
- Configuration of customer business processes
- Application change management

---

## Audit Logging

| Log Type | Managed by | Customer Access |
|----------|-----------|-----------------|
| Application Security Audit Logs | Customer | Full access |
| Infrastructure Logs (Firewalls, LBs, Proxies, DBs) | SAP ECS | SAP manages centrally; event correlation shared |
| OS/DB Logs | SAP ECS | Available near-real-time via "LogServ" additional service (customer SIEM) |

---

## Penetration Testing (VAPT)

- Customers **can** request Vulnerability Assessment and Penetration Testing
- Scope: **application layer only**
- Requires prior approval and authorization by SAP
- Reference: SAP Note 3080379

---

## Security Patch Management

- SAP ECS performs OS/DB security patches **regularly** (frequency per contract)
- SAP creates deployment bundles, tests patches before release
- Customers must:
  1. Submit Service Request for patches via Customer Dashboard
  2. Authorize downtime during Maintenance Period

---

## Security Incident Response

- 24×7 SAP SOC following one global process
- Documented playbooks for common incidents: phishing, malware/virus, privilege escalation, improper usage, unauthorized access, data deletion, data theft
- Incident response process: Detection → Analysis → Containment → Eradication → Recovery → Post-incident analysis

---

## Integration Security Patterns

> For full integration flows, see `integration.md`. Security aspects summarized here.

### PCE ↔ SAP BTP (Cloud Connector)

- Mutual TLS 1.2 between Cloud Connector and BTP Connectivity Service
- SAP Cloud Connector deployed in PCE landscape — outbound tunnel only (no inbound ports)

### PCE ↔ SAP SuccessFactors (via BTP Integration Suite)

- OData API for data operations
- mTLS 1.2 authentication end-to-end
- BTP Integration Suite orchestrates the flow

### PCE ↔ SAP Ariba (via Ariba CIG)

- SAP Ariba Cloud Integration Gateway (CIG) leverages BTP Integration Suite
- Data exchange: REST APIs, OData, SOAP, Commerce XML
- TLS 1.2 mutual authentication between Ariba CIG and Cloud Connector in PCE

### PCE ↔ SAP Concur (via BTP)

- PGP encryption for data at rest before transfer
- SFTP for encrypted transit
- BTP Integration Suite as integration layer

---

## Contractual Security Assurances

| Document | Covers |
|----------|--------|
| **SLA** | System availability, uptime, update windows, credits |
| **Data Processing Agreement (DPA)** | SAP and sub-processor obligations, Technical Organizational Measures (TOMs), description of processing |
| **General Terms and Conditions** | Essential legal terms |
| **Cloud Support Policy** | Scope of support and success offerings |
| **Cloud Service Supplemental Terms** | Service-specific legal terms |

**Data return on contract expiry**: Customers can obtain a system export, native database backup (restorable on own hyperscaler), or export SAP data using SAP tools/partners.

---

## Availability and DR (Security Perspective)

> See `operations-and-sla.md` for full SLA details.

- Standard System Availability SLA: **99.7%**
- **SAP responsibility**: infrastructure, OS, database, application layer availability
- **Customer responsibility**: logical data integrity
- DR is an **optional service** — not included by default
  - Standard DR: RPO = 0 (Short Distance) or 30 min (Long Distance), RTO = 12 hours
  - Enhanced DR: RTO = 4 hours (on request)

---

**Last Updated**: 2026-03-09
**Sources verified**: 2026-03-09

---

## SAP Notes Reference

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2217548](https://me.sap.com/notes/2217548) | FAQ related to GRC Access Control Installation, Upgrade | Reference for GRC component compatibility and installation prerequisites in PCE landscapes. |
| [2542518](https://me.sap.com/notes/2542518) | GRC FAQ | Comprehensive technical troubleshooting guide for GRC implementations in RISE. |
| [2648777](https://me.sap.com/notes/2648777) | FAQ: Access Control 12.0 Upgrade | Critical considerations for transitioning to GRC 12.0 in a private cloud environment. |
| [3470873](https://me.sap.com/notes/3470873) | SAP Access Control 12.0 - Rise/PCE migration queries | Guidance on technical steps for migrating GRC environments to S/4HANA PCE. |

> Key SAP Notes for Security and Compliance. Full master list: see `sap-notes-master-list.md` in workspace root.

### Penetration Testing / VAPT

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3080379](https://me.sap.com/notes/3080379) | Customer Penetration Testing Request Process | 3-phase process: **Request** (SR via SAP for Me → template "Authorization for application testing" or "Authorization for ECS-application testing"; 5-15 business days approval) → **Test** (approved scope only; no DoS/DDoS/DDoS, non-load bearing) → **Validation/Remediation** (send findings to secure@sap.com encrypted with PGP; PSRT responds within 2 weeks for High, 4 weeks for Med/Low). Annual limit. For premium partner RISE/IBP/Concur/Fieldglass: use form at pentest@sap.com. DORA/TLPT engagements handled by central SAP team independently. Test results are confidential — must not be shared without SAP written authorization. |
| [3554013](https://me.sap.com/notes/3554013) | Requests for Infrastructure and Data Security Process Information | How to request infrastructure/data security information from SAP ECS |
| [3497943](https://me.sap.com/notes/3497943) | SAP Cloud ALM Penetration Test information | Penetration test scope and process specific to Cloud ALM |
| [2871898](https://me.sap.com/notes/2871898) | Request for penetration test results | How to request pentest results from SAP |
| [3588916](https://me.sap.com/notes/3588916) | Queries on Reports of Penetration testing | FAQ for pentest report queries |
| [2249479](https://me.sap.com/notes/2249479) | Customer Vulnerability Assessment/Penetration Test request - SAP SuccessFactors | VAPT process for SuccessFactors (reference for cross-system scope) |
| [3554013](https://me.sap.com/notes/3554013) | Requests for Infrastructure and Data Security Process Information | Process for requesting infrastructure security documents (SOC reports, ISO certs) |

### Security Audit Log (SAL)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2676384](https://me.sap.com/notes/2676384) | Best Practice Configuration of Security Audit Log | Use **RSAU_CONFIG** (NW 7.50+). Exclude high-volume events from all-users filter: **AUW, AU5, AUK, CUV, DUI, DUR, EUE**. For SAP* and emergency users + client 066: log **ALL** events. Enable rsau/integrity=1 (see Note 2033317). Apply config via RSAU_TRANSFER upload or RSAU_SET_DFLT with profile 'SAP_SEC Best Practice Pattern (Note 2676384)'. Changes to static profile require system restart. Min 10 selection filters. |
| [2191612](https://me.sap.com/notes/2191612) | FAQ \| Use of Security Audit Log as of SAP NetWeaver 7.50 | Comprehensive FAQ for SAL on NW 7.50+ (PCE and on-premise). Covers: SM19/SM20 vs new transactions RSAU_CONFIG/RSAU_READ_LOG/RSAU_ADMIN (both can coexist), parameterization (rsau/* profile params), dynamic vs static configuration, filter profiles, retention and archiving. For SAP_BASIS < 7.50 SP3: use Note 539404. For public cloud: use Note 2903873. |
| [2033317](https://me.sap.com/notes/2033317) | Integrity protection format for Security Audit Log | SAL integrity protection — file format and cryptographic verification |
| [2883981](https://me.sap.com/notes/2883981) | RSAU_READ* \| anonymized display of Security Audit Log data | Anonymized SAL data display for GDPR compliance |
| [3053445](https://me.sap.com/notes/3053445) | RSAU_ADMIN \| File reorganization with active integrity protection | SAL file reorganization procedures |
| [3090362](https://me.sap.com/notes/3090362) | RSAU_ADMIN \| Integrity protection format - data management | Data management for SAL with integrity protection active |
| [3009171](https://me.sap.com/notes/3009171) | RSAU_ADMIN \| error when checking the integrity protection format | Troubleshooting SAL integrity check errors |
| [3495228](https://me.sap.com/notes/3495228) | RSAU_ADMIN \| Integrity protection check for files without integrity protection format | Handling legacy SAL files without integrity protection |
| [3508896](https://me.sap.com/notes/3508896) | RSAU_ADMIN \| Optimization of integrity protection check | Performance optimization for SAL integrity checks |
| [3445458](https://me.sap.com/notes/3445458) | How to verify changes on the Recording Target (Database, File system) of the Security Audit Log | Verify SAL recording target configuration changes |
| [3137004](https://me.sap.com/notes/3137004) | How to archive and delete audit log from DB | SAL archiving and deletion procedures |
| [3407647](https://me.sap.com/notes/3407647) | RSAU_READ_LOG \| Optimization of reading audit log files | Performance optimization for reading SAL files |
| [3629004](https://me.sap.com/notes/3629004) | How to retrieve audit log table size in SAP HANA database | Check SAL table size in HANA |

### RFC and Gateway Security

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2008727](https://me.sap.com/notes/2008727) | Securing Remote Function Calls (RFC) | Comprehensive RFC security whitepaper (also at support.sap.com/securitywp). Covers: **UCON** (Unified Connectivity — allowlist-based RFC access control), **S_RFC** authorization maintenance, Trusted System Security (Trusted RFC), **SNC** for encrypted RFC, RFC callback allowlists (Note 1686632), **Gateway ACL** (reginfo/secinfo files), blocking RFC proxy requests. Also covers RFC security monitoring. Required reading before any PCE RFC security hardening project. |
| [1480644](https://me.sap.com/notes/1480644) | "gw/acl_mode" and "gw/reg_no_conn_info" | **gw/acl_mode=0** = no restriction on external programs (never use in PRD). **gw/acl_mode=1** = only internal hosts (same system's AS, DB, MS, enqueue) allowed — all others rejected unless in reginfo/secinfo. If gw/reg_info + gw/sec_info files exist, their entries take full precedence over gw/acl_mode. As of kernel 74x: gw/acl_mode is independent from gw/reg_no_conn_info. Use keyword **"internal"** in reginfo/secinfo files for simplified host-group definition (covers all system-internal IPs). |
| [1444282](https://me.sap.com/notes/1444282) | gw/reg_no_conn_info settings | Gateway registration security parameter reference |
| [1408081](https://me.sap.com/notes/1408081) | Basic settings for reg_info and sec_info | Gateway security files (reginfo/secinfo) basic configuration |
| [1686632](https://me.sap.com/notes/1686632) | Positive lists for RFC callback | RFC callback security positive lists |
| [2941068](https://me.sap.com/notes/2941068) | sm59/Callback allowlist input validation missing | SM59 callback allowlist security fix |

### SNC and Network Encryption

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1848999](https://me.sap.com/notes/1848999) | Central Note for CommonCryptoLib 8 (SAPCRYPTOLIB) | **Current version: 8.6.2** (shipped with ABAP kernels from 2026). Key features: Post-Quantum Cryptography (NIST FIPS 203/204), TLS 1.3 with hybrid quantum-safe key exchange (**X25519MLKEM768**), FIPS 140-3 certified crypto kernel (8.6.1). CCL 8.4 and older = NOT supported. No extra license for server-to-server SNC, Kerberos server auth, system-internal security. License for **SAP Secure Login Service** required for user-based SSO (X.509/Kerberos); product EOL 31.12.2027. Distributed via **DW_UTILS*.SAR** package. Verify version: `sapgenpse cryptinfo`. Only latest version receives security patches — no hotfixes for old versions. |
| [1684886](https://me.sap.com/notes/1684886) | License conditions of SNC Client Encryption | SNC client encryption licensing terms |
| [1867829](https://me.sap.com/notes/1867829) | List of SNC Error Codes | SNC error code reference for troubleshooting |
| [2653733](https://me.sap.com/notes/2653733) | Enabling SNC on RFCs between AS ABAP | Step-by-step SNC enablement for RFC connections |
| [2573413](https://me.sap.com/notes/2573413) | How to configure SNC from 7.1x onwards AS Java to AS ABAP | SNC configuration from Java AS to ABAP AS |
| [2425634](https://me.sap.com/notes/2425634) | SNC Error Code A2200223 - Peer certificate verification failed | SNC peer certificate verification error resolution |
| [2497505](https://me.sap.com/notes/2497505) | SNC Error Code A2200210 Peer certificate verification failed - Kerberos configuration | Kerberos-specific SNC certificate verification error |
| [2680913](https://me.sap.com/notes/2680913) | SNC Error Code A2200210:Peer certificate verification failed - Certificate X.509 configuration | X.509 certificate SNC error resolution |

### Certificate Management (STRUST)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3142481](https://me.sap.com/notes/3142481) | STRUST: How to extract required certificate response from provided file by CA vendor | Extract CA certificate response in STRUST |
| [3238733](https://me.sap.com/notes/3238733) | How to Import a Certificate Into a STRUST PSE's Certificate List | Import certificates into STRUST PSE |
| [3545535](https://me.sap.com/notes/3545535) | How to export a certificate from a STRUST PSE | Export certificates from STRUST |
| [2801396](https://me.sap.com/notes/2801396) | SAP Global Trust List | SAP-maintained list of trusted CAs |
| [3472211](https://me.sap.com/notes/3472211) | BTP Trust Store: Collection of TLS Server Root CA certificates used by SAP BTP | SAP BTP uses Root CAs from DigiCert, Let's Encrypt, and SAP Cloud Root CA. Customers must import these into ABAP STRUST (SSL Client PSE) to ensure disruption-free TLS with BTP services. Official repo: **https://github.com/sap-software/btp-trust-store** — regularly updated by SAP with sufficient lead time before CA changes. Critical for PCE systems connecting to BTP via Cloud Connector or HTTPS destinations. |
| [3410386](https://me.sap.com/notes/3410386) | How to manage SSL certificates in Enterprise Cloud Services - Guided Answer | Guided Answer decision tree for ECS SSL certificate management: (1) monitor/check certificate details, (2) import a customer domain SSL certificate, (3) request a new certificate. Entry point via Guided Answers portal. **In PCE, customers cannot directly manage system SSL certs** — all operations go through ECS via Service Request or this Guided Answer flow. |
| [3563155](https://me.sap.com/notes/3563155) | HTTPS certificate expiration issue for CN=*....hana.ondemand.com | HANA Cloud certificate expiration handling |
| [3544856](https://me.sap.com/notes/3544856) | Multi-Bank Connectivity Server Certificate Is Expiring in STRUST | MBC certificate renewal in STRUST |
| [3411144](https://me.sap.com/notes/3411144) | Action required for notification email "ACTION REQUIRED: Expiring certificate in Identity Authentication" | Handling expiring IAS certificates |
| [2475246](https://me.sap.com/notes/2475246) | How to Secure Connections from NetWeaver ABAP instances to HANA Database | Error "only secure connections are allowed" = HANA has sslenforce=TRUE (global.ini). Fix: export HANA cert from sapsrv.pse via `sapgenpse export_own_cert` → import into ABAP STRUST (SSL Client PSE SAPSSLC.pse). Test via DBCO with CONNECT string `ENCRYPT=TRUE,sslCryptoProvider=commoncrypto,sslKeyStore=SAPSSLC.pse`. Enable system-wide via DEFAULT.PFL parameter `dbs/hdb/connect_property=ENCRYPT=TRUE` (requires restart). For tp/R3trans: set env var `dbs_hdb_connect_property=ENCRYPT=TRUE,...`. From HANA 2.0 SPS06: use ClientPKI — see Note 3346006. |

### Virus Scan Interface (VSI)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3052386](https://me.sap.com/notes/3052386) | FAQ \| Virus Scan Interface (VSI) | **VSI is NOT provided by default in RISE** — customer must install a 3rd-party antivirus adapter (ICC certification discontinued Dec 2023; check Note 1494278 for vendor list). Setup: VSCANPROFILE + VSCANGROUP + VSCANTEST + /n/IWFND/VIRUS_SCAN. Dummy adapter "vssap" = test use only, not for production. SAL logs virus infections via events **BU8** (virus found) and **BU9** (scan error). CCMS monitoring: RZ20 → "SAP CCMS Monitors for Optional Components" → Virus Scan Servers. Deactivation: requires clearing VSCAN + VSCANGROUP + VSCANPROFILE. |
| [2437892](https://me.sap.com/notes/2437892) | Error: "No default virus profile active or found. Please check the official guide" | VSI profile configuration error |
| [3197408](https://me.sap.com/notes/3197408) | Configuring the Virus Scanner for MIME Upload | VSI configuration for MIME upload scanning |
| [1636724](https://me.sap.com/notes/1636724) | Virus scan information missing in BDC Browser IMG document | VSI information in BDC context |

### Web Application Firewall (WAF) and Network Security

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3219363](https://me.sap.com/notes/3219363) | No Web Application Firewall (WAF) in front of custom application running in BTP CF | WAF not available by default for BTP CF custom apps — security consideration |
| [3770579](https://me.sap.com/notes/3570779) | BTP Security Recommendations/Penetration Testing Request/Security Vulnerabilities | BTP security recommendations and pentest process |

### Identity Authentication (IAS) and SSO

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3080900](https://me.sap.com/notes/3080900) | Using 3rd party/Corporate IdP with SAP Cloud Identity Services - Identity Authentication for Enterprise | Configuring corporate IdP (Azure AD, Okta) with SAP IAS |
| [2945035](https://me.sap.com/notes/2945035) | How to connect Microsoft Entra ID (Azure Active Directory) to Identity Authentication Service | Step-by-step: Azure AD → SAP IAS federation |
| [3507340](https://me.sap.com/notes/3507340) | Test this application in Microsoft Entra ID to trigger IdP-Initiated SSO for Application using IAS | Test IdP-initiated SSO with Entra ID and IAS |
| [3508345](https://me.sap.com/notes/3508345) | How to renew expiring Microsoft Entra ID certificate in IAS administration console | Renew Entra ID signing certificate in IAS |
| [3432984](https://me.sap.com/notes/3432984) | How to Update Signing Certificates on IAS | Update signing certificates in IAS |
| [2300234](https://me.sap.com/notes/2300234) | SAP Single Sign-On 3.0: Central Note | Central note for SAP SSO 3.0 — X.509 certificates, SNC, Kerberos |
| [2461862](https://me.sap.com/notes/2461862) | Collecting SAML traces with Chrome, Edge or Firefox | SAML trace collection for SSO debugging |

### Authorization and Role Management

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1631929](https://me.sap.com/notes/1631929) | Using trace evaluation to maintain menus and authorizations | Authorization trace evaluation with SUIM |
| [1861370](https://me.sap.com/notes/1861370) | PFCG: Menu maintenance via authorization trace | Role menu maintenance using authorization traces |
| [1405975](https://me.sap.com/notes/1405975) | Minimum Authorization Profile for Remote Service Delivery | Minimum authorizations needed for SAP ECS remote access |
| [2219873](https://me.sap.com/notes/2219873) | Troubleshooting authorization errors | General authorization error troubleshooting guide |
| [2927665](https://me.sap.com/notes/2927665) | Task list suspended: First call Transaction SU25 and fill Profile Generator tables | SU25 required before role transport — Profile Generator initialization |

---

### GRC & Access Control

> Notes for SAP GRC Access Control (on-premise 12.0) and SAP Cloud Identity Access Governance (IAG), including the IAG Bridge scenario that integrates both systems. See also `cross-cutting/identity-and-access.md` for IAS/IPS and role management.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2638578](https://me.sap.com/notes/2638578) | What's new in GRC Access Control 12.0 | Feature overview of GRC Access Control 12.0: new UX (Fiori-based), enhanced role management, emergency access management (EAM) improvements, connector framework updates. Reference for customers upgrading from GRC 10.x on PCE. |
| [2646456](https://me.sap.com/notes/2646456) | FAQ: SAP Cloud Identity Access Governance (IAG) | Central FAQ for SAP Cloud Identity Access Governance (IAG) — the cloud-based successor to GRC Access Control. Covers provisioning, access request, risk analysis, and IAG Bridge integration. Entry point for all IAG support questions. |
| [3344437](https://me.sap.com/notes/3344437) | Roadmap for GRC products | Strategic roadmap for GRC product portfolio: GRC Access Control, Process Control, Risk Management, and their cloud evolution paths. Critical for PCE customers planning GRC long-term direction alongside RISE with SAP adoption. |
| [3326989](https://me.sap.com/notes/3326989) | Announcement of the Upcoming Release of SAP Access Control, Process Control and Risk Management | Announcement of next-generation GRC platform (SAP GRC edition for SAP HANA). Details the transition from current on-premise GRC 12.0 to the new platform, planned Q1 2026. PCE customers on GRC 12.0 should assess migration timeline. |
| [3376776](https://me.sap.com/notes/3376776) | SAP Access Control 12.0 SP23 Release Information Note | Release information for GRC AC 12.0 SP23: new features, bug fixes, and known restrictions. Includes HANA compatibility matrix and prerequisite notes. Check SP-specific release notes before applying each GRC support package in PCE. |
| [3258752](https://me.sap.com/notes/3258752) | SAP Cloud IAG — How-To's and Guides | Central collection of IAG how-to guides: access request workflow, role certification, risk analysis, emergency access, IAG Bridge setup, connector configuration. Essential reference for IAG administrators supporting PCE. |
| [3602657](https://me.sap.com/notes/3602657) | Central KBA for IAG Bridge Note collection | Master index of IAG Bridge notes organized by Support Package. The IAG Bridge enables IAG to provision roles directly to S/4HANA PCE (replacing GRC-based provisioning for bridge-enabled scenarios). Navigate by SP to find relevant bridge fixes and setup notes. |
| [3437714](https://me.sap.com/notes/3437714) | IAG — Best Practice for maintaining rulesets for IAG Bridge Scenario | Best practices for managing SoD rulesets in the IAG Bridge scenario: ruleset synchronization between IAG and GRC AC, conflict resolution procedures, and recommended maintenance cadence. Prevents authorization drift in PCE GRC landscape. |
| [2913548](https://me.sap.com/notes/2913548) | IAG Privileged Access Management Launch for ABAP | Configuration guide for launching IAG Privileged Access Management (PAM/Firefighter) for ABAP backend systems. Covers IAG PAM setup for S/4HANA PCE: ABAP connector, EAM owner/controller roles, and firefighter log retrieval. |
| [3081715](https://me.sap.com/notes/3081715) | IAG Bridge — Multiple issues with provisioning | Collective note for IAG Bridge provisioning failures: roles not provisioned, user sync errors, repository sync issues, workflow stuck. Organized by error symptom with resolution steps. Essential troubleshooting reference for IAG Bridge in PCE landscapes. |

### HTTP Security, Certificates & Emergency Access

| Note | Title | Relevance |
|------|-------|-----------|
| [2223891](https://me.sap.com/notes/2223891) | Configuring the HTTP_WHITELIST Table for Public ICF Services | How to configure the `HTTP_WHITELIST` table (transaction SE16 on table `HTTP_WHITELIST`) to allow specific external URLs to be accessed from AS ABAP — required for SAML2 metadata downloads, IAS metadata, and external OAuth endpoints in PCE |
| [2478552](https://me.sap.com/notes/2478552) | List of Certificate Authorities (CAs) Supported by SAP Cloud Integration | Reference list of trusted CA root certificates pre-loaded in SAP Cloud Integration — use when setting up mTLS or certificate-based authentication between CPI and on-premise S/4HANA PCE endpoints |
| [2300234](https://me.sap.com/notes/2300234) | SAP Single Sign-On 3.0: Central Note | Central reference for SAP SSO 3.0 (Secure Login Server / Secure Login Client) — covers X.509 certificate-based SSO for SAP GUI, prerequisites for PCE deployment, and compatibility with IAS |
| [2333305](https://me.sap.com/notes/2333305) | Tutorial: Restore Emergency User SAP* [VIDEO] | Procedure for recovering emergency access to an S/4HANA system when all admin users are locked — requires setting profile parameter `login/no_automatic_user_sapstar=0` and restarting the instance. Critical break-glass procedure for PCE; coordinate with ECS for parameter change in managed systems |
| [1928533](https://me.sap.com/notes/1928533) | SAP Applications on Microsoft Azure: Supported Products and Azure VM Types | Supported SAP product/VM type combinations on Azure — reference for verifying PCE infrastructure compatibility when Microsoft Azure is the chosen hyperscaler. Also used for sizing validation and ISV add-on support scoping |
| [2219598](https://me.sap.com/notes/2219598) | SAP Business Technology Platform Forms Service by Adobe | Activation and configuration of Adobe Document Services (ADS) on BTP — covers certificate-based RFC connection from S/4HANA PCE to BTP ADS, trust configuration, and output management integration |
| [1580877](https://me.sap.com/notes/1580877) | Best practices in storage management for Access Control Risk Analysis jobs | Provides GRC Access Control storage and performance best practices for SoD risk analysis batch and ad-hoc jobs, including database vs. file-system trade-offs and violation table cleanup; relevant to PCE security and audit operations. |
| [2405410](https://me.sap.com/notes/2405410) | How to avoid redirecting Fiori Launchpad from HTTP to HTTPS | Explains how to configure SICF service to prevent automatic HTTP-to-HTTPS protocol switching in Fiori Launchpad; SAP recommends against disabling HTTPS enforcement as it results in credentials being transmitted in plain text. |
| [2407161](https://me.sap.com/notes/2407161) | Launchpad or application fails to load with "Our service is not available at the moment" | Covers Web Dispatcher SSL handshake failures (SSSLERR_PEER_CERT_UNTRUSTED) and permfile authorization mismatches as causes for Fiori/WebGUI unavailability in HEC/PCE environments; troubleshooting guidance specific to SAP HANA Enterprise Cloud (PCO-OPS component). |
| [2667053](https://me.sap.com/notes/2667053) | CX_HTTP_WHITELIST was raised | Explains the HTTP allowlist (UCON HTTP Allowlist / HTTP_WHITELIST table) security mechanism that blocks URLs for clickjacking protection, SSO redirects, and other entry types; provides resolution via UCON_CHW transaction; relevant to PCE security hardening and UCON configuration. |
| [2681625](https://me.sap.com/notes/2681625) | How to Get SOC1, SOC2 or ISO 27001 Reports for Audits in SAP Business ByDesign | Explains how to request SOC 1, SOC 2, and ISO 27001 audit certification reports via the SAP Cloud Trust Center; the process and report types are applicable to RISE with SAP compliance requests by customers needing audit evidence. |
| [2692908](https://me.sap.com/notes/2692908) | Considerations Note – UI Data Protection Masking for SAP S/4HANA | Describes the technical constraints and scope of UI Data Protection Masking (UISM) for SAP S/4HANA on-premise and Private Cloud Edition; the product is explicitly not available in S/4HANA Public Cloud, making it specifically relevant to PCE data privacy and UI masking configurations. |
| [2984760](https://me.sap.com/notes/2984760) | WDA: Web Dynpro Exception: URL for redirect does not exist in HTTP white list / allow list | Explains the `UNCAUGHT_EXCEPTION / CX_WD_GENERAL` error caused by missing entries in the HTTP allowlist when Web Dynpro ABAP performs cross-domain redirects; relevant to hardening SAP S/4HANA PCE systems against open-redirect attacks. |
| [2985997](https://me.sap.com/notes/2985997) | Explanation of components below BC-SEC | Reference guide for all BC-SEC sub-components (SAL, AUT, SSF, SSL, LGN, SNC, RAL, etc.) to route ABAP security-layer support cases; useful in PCE operations for correctly categorising security incidents and support tickets. |
| [3220866](https://me.sap.com/notes/3220866) | RFC Server fails with "Initialization of destination XXX failed: Name or password is incorrect (repeat logon)" after enabling SNC - SAP Data Services | Covers misconfiguration of SNC in SAP Data Services RFC Server connections to BW systems, specifically the missing SNC name in SU01 for the BW user account; relevant to PCE environments using SAP Data Services with SNC-secured RFC connections. |
| [3342217](https://me.sap.com/notes/3342217) | How To Import A Root CA Certificate Into a Local Windows Workstation | Explains the procedure to import a Root CA certificate into the Windows Trusted Root Certification Authorities store, applicable for establishing trust with SAP system certificates in PCE landscapes; also covers the `sapgenpse` command-line approach as an alternative to STRUST. |
| [3362505](https://me.sap.com/notes/3362505) | Intermediate DigiCert certificate will be updated - SAP Cloud Integration for data services | Covers the 2023 DigiCert intermediate certificate rotation for SAP Cloud Integration for data services, including actions required for agents and datastores; relevant to PCE customers who use integration agents and must ensure TLS/SSL trust chains remain valid. |

---

**Last Updated**: 2026-03-21
**Sources verified**: 2026-03-21
