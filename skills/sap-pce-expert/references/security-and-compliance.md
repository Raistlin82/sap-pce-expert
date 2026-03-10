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
