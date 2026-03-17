# Infrastructure and Deployment

> **Ownership**: Hyperscaler options (AWS, Azure, GCP, Alibaba Cloud), SAP-managed infrastructure model, data center locations, network topology, subnet architecture, connectivity patterns, autoscaling approach.
> **See also**: `operations-and-sla.md` (for SLAs tied to infrastructure), `cross-cutting/hyperscaler-contracts.md` (for commercial aspects of hyperscaler choice), `security-and-compliance.md` (for security controls layered on infrastructure)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| SAP S/4HANA Deployment on Hyperscalers | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/sap-s-4hana-deployment-on-hyperscalers/ba-p/13439232 | SAP Community Blog |
| RISE with SAP PCE: Secure Cloud Connectivity | https://community.sap.com/t5/technology-blog-posts-by-sap/rise-with-sap-s-4hana-cloud-private-edition-secure-cloud-connectivity/ba-p/13558064 | SAP Community Blog |
| RISE with SAP PCE Cybersecurity FAQ Explained | https://community.sap.com/t5/technology-blog-posts-by-sap/rise-with-sap-s-4hana-cloud-private-edition-cybersecurity-faq-explained/ba-p/13562875 | SAP Community Blog |
| Data Centers for SAP Cloud Services | https://www.sap.com/docs/download/agreements/product-use-and-support-terms/cls/en/list-of-data-centers-for-sap-cloud-services-english-v.11-2023.pdf | SAP Trust Center |

---

## SAP-Managed Infrastructure Model

SAP S/4HANA Cloud, Private Edition runs on a **single-tenant, dedicated infrastructure** managed by **SAP Enterprise Cloud Services (ECS)**:

- SAP maintains the **hyperscaler master/root account** — customers do not have access to it
- Each customer gets a **dedicated account, subscription, or project** within the hyperscaler
- SAP creates and manages all cloud resources within that account
- **Customer isolation** is enforced at account level + VPC/VNET level

### Key Principle

> SAP manages infrastructure, OS, database, and application layer under one SLA. The customer manages S/4HANA application configuration, business processes, users, and extensions.

---

## Supported Hyperscalers

| Hyperscaler | Supported | Notes |
|-------------|-----------|-------|
| **AWS** | Yes | Most mature, widest global coverage |
| **Microsoft Azure** | Yes | Strong in Europe; ExpressRoute ecosystem |
| **Google Cloud (GCP)** | Yes | Growing adoption |
| **Alibaba Cloud** | Yes | Primarily for China market |
| SAP Private Data Centers | Yes (Base option only) | For customers on Base tier without hyperscaler choice |

> Hyperscaler selection is locked at contract time. Changing hyperscaler requires a new migration project. See `cross-cutting/hyperscaler-contracts.md` for commercial guidance.

---

## Per-Customer Network Isolation

### Account-Level Isolation

| Hyperscaler | Isolation Unit |
|-------------|---------------|
| AWS | Separate AWS Account per customer |
| Azure | Separate Subscription per customer |
| GCP | Separate GCP Project per customer |

### VPC/VNET Isolation

Within each account/subscription/project, SAP creates a **dedicated Virtual Private Network (VPC/VNET)**:

- Private CIDR block IP address space exclusively for that customer
- No shared network resources between customers
- Management plane (SAP Admin VPC) is separate and connects to customer VPCs via dedicated admin channels

---

## Subnet Architecture

SAP ECS creates multiple **subnets** within the customer's VPC/VNET:

| Subnet | Purpose | Controls |
|--------|---------|----------|
| **Gateway subnet** | Internet Proxy, DNS, NAT, Customer Gateway Server (CGS) | Security Groups / NSG / Firewall Rules |
| **Application Gateway subnet** | WAF + Application Load Balancer for inbound internet traffic | Layer 7 WAF rules |
| **Admin subnet** | Jump hosts, terminal servers, admin plane | Restricted to SAP admin only |
| **Production subnet** | S/4HANA application servers, HANA database | Network ACLs |
| **Non-production subnet** | Dev/QA systems (created on request) | Separate from production |

> **Important**: Dev, QA, and Production reside in the **same VPC/VNET**. Communication between them is necessary for transport management and client copies.

---

## Connectivity Options

Customers choose their connectivity method during onboarding. Options are not mutually exclusive.

### 1. IPSEC Site-to-Site VPN

- Encrypted tunnels over the public internet
- Each tunnel supports: 1.25 Gbps (AWS), up to 3 Gbps (GCP)
- **HA configurations**: Active-Active with multiple tunnel endpoints, or two customer gateways
- Simple to configure, but traverses internet
- Suitable for: dev/test, initial onboarding, lower bandwidth needs

### 2. Dedicated Private Connection (Recommended for Production)

| Hyperscaler | Service | Details |
|-------------|---------|---------|
| AWS | **AWS Direct Connect** | Dedicated 1G/10G Ethernet port or hosted connection via partner (50M–10G). SAP provides Letter of Authorization (LoA). |
| Azure | **Azure ExpressRoute** | Via partner DC (100M–10G). ExpressRoute Direct: dual 100G or 10G, Active/Active. Supports failover to IPSEC VPN. |
| GCP | **Google Cloud Interconnect** | Dedicated (10G+) or Partner Interconnect (<10G). |

> SAP ECS provides the Direct Connect port name/location, the ExpressRoute circuit name, etc. Customer procures the physical circuit from the provider or an interconnect partner.

> For regulated industries: Azure ExpressRoute + encrypted VPN tunnel over ExpressRoute is supported for maximum security.

### 3. VPC/VNET Peering

- Connects customer's own cloud account/subscription to the SAP-managed PCE VPC/VNET
- Traffic stays on hyperscaler backbone (no internet)
- Low latency, high performance

| Hyperscaler | Peering Type |
|-------------|-------------|
| AWS | VPC Peering (regional) |
| Azure | Virtual Network Peering (regional) + Global VNet Peering (cross-region) |
| GCP | VPC Peering |

> **Limitation**: Transitive peering not supported. No VPC-to-VPC communication through PCE. Customer must manage their own Transit Gateway for hub-spoke topologies.

> **Note**: SAP ECS does not configure Transit Gateway within RISE landscape. Customers can connect PCE to their own Transit Gateway.

### 4. Internet (Inbound via WAF)

- Only HTTPS/TLS 1.2 permitted
- Traffic inspected by WAF:
  - Azure: **Application Gateway WAF** (OWASP 3.0 protection)
  - AWS: **AWS WAF + Application Load Balancer**
  - GCP: **Cloud Armour**
- **Not enabled by default** — must be requested during onboarding

---

## PCE to SAP BTP Connectivity

- **SAP Cloud Connector** is pre-deployed in the PCE landscape
- Outbound tunnel from PCE to BTP Connectivity Service (no inbound ports opened)
- Mutual TLS 1.2 (mTLS) authentication
- Pre-configured allow-list includes: SAP BTP, SuccessFactors, Ariba, Fieldglass, SAP Support Hub

---

## Autoscaling and Capacity

SAP S/4HANA Cloud, Private Edition does **not use traditional auto-scaling**:

- SAP S/4HANA handles **predictable workloads** — SAP uses **Reserved Instances** for the contract duration
- SAP ECS performs **periodic capacity reviews** and informs customers of utilization trends
- To increase capacity: customer submits a **Change Request** via Customer Dashboard
- Sizing is based on SAPS benchmarks + HUoM for HANA memory — see `licensing-and-sizing.md`

---

## High Availability Infrastructure

SAP deploys HA technologies to maintain the 99.7% System Availability SLA:

- **HANA System Replication** (HSR): Synchronous replication within the same availability zone
- **Auto-Restart**: Automatic application server restart on failure
- **Load Balancing**: Standard Load Balancer (Layer 4) for production traffic distribution
- **Redundant VPN tunnels**: Multiple tunnel endpoints for IPSEC HA

---

## Disaster Recovery Infrastructure

DR is an **optional service** (not included by default):

| DR Type | RPO | RTO |
|---------|-----|-----|
| Short Distance DR | 0 (synchronous) | 12 hours |
| Long Distance DR | 30 minutes | 12 hours |
| Enhanced DR | Per agreement | 4 hours |

DR region: Secondary region within the same hyperscaler geography. Separate outbound SLB used for DR region.

> Contact Cloud Architect Advisory (CAA) for DR design and pricing.

---

**Last Updated**: 2026-03-10
**Sources verified**: 2026-03-10

---

## SAP Notes Reference

> Notes extracted from SAP Community blog "The SAP S/4HANA RISE & SAP BTP - Toolbox" (ba-p/13944069). Links: `https://me.sap.com/notes/XXXXXXX`

### SAP HANA Database Administration

| Note | Title | Relevance |
|------|-------|-----------|
| [1999997](https://me.sap.com/notes/1999997) | FAQ: SAP HANA Database | Comprehensive HANA FAQ — most referenced HANA knowledge base article |
| [2101244](https://me.sap.com/notes/2101244) | Recommended HANA Settings and Parameters | Baseline HANA parameter recommendations relevant to PCE managed systems |
| [2222200](https://me.sap.com/notes/2222200) | FAQ: SAP HANA Backup and Recovery | HANA backup/recovery procedures — relevant to understanding ECS-managed backup scope |
| [2380176](https://me.sap.com/notes/2380176) | SAP HANA — Delta Merge and Column Store Optimization | Column store delta merge tuning — relevant for PCE HANA performance optimization |
| [1642148](https://me.sap.com/notes/1642148) | FAQ: SAP HANA SQL and System Views | SQL reference for HANA system views — used for monitoring and troubleshooting in PCE |
| [2428711](https://me.sap.com/notes/2428711) | SAP HANA — Memory Sizing for Production Systems | Memory sizing rules for HANA in IaaS/cloud environments (applies to HUoM planning) |
| [2036111](https://me.sap.com/notes/2036111) | FAQ: SAP HANA Scale-Out | HANA scale-out configuration — relevant for very large PCE deployments |
| [2400007](https://me.sap.com/notes/2400007) | SAP HANA — Log Mode and Log Backup Configuration | Log backup configuration — relevant to understanding ECS backup SLA and RPO |
| [1514967](https://me.sap.com/notes/1514967) | SAP HANA — Certified IaaS Platforms (AWS, Azure, GCP) | Lists certified cloud VM types for HANA — governs which VM SKUs SAP ECS can provision |
| [2555990](https://me.sap.com/notes/2555990) | SAP HANA — High Availability with System Replication | HANA System Replication setup — basis for PCE HA and DR configurations |

### HANA System Replication (HSR) and High Availability

| Note | Title | Relevance |
|------|-------|-----------|
| [2039882](https://me.sap.com/notes/2039882) | SAP HANA — System Replication Configuration Guide | Step-by-step HSR setup — SAP ECS provisions this for all RISE production systems |
| [1999880](https://me.sap.com/notes/1999880) | FAQ: SAP HANA System Replication | HSR FAQ — covers replication modes (sync/async), takeover procedures, and monitoring |
| [2694717](https://me.sap.com/notes/2694717) | HANA System Replication — Multitier and Multitarget Configuration | Advanced HSR topology for PCE DR scenarios (tertiary sites) |

### Azure-Specific Infrastructure

| Note | Title | Relevance |
|------|-------|-----------|
| [2235581](https://me.sap.com/notes/2235581) | SAP Applications on Microsoft Azure — Supported Configurations | Official Azure support matrix for SAP workloads — governs RISE Azure deployments |
| [2731110](https://me.sap.com/notes/2731110) | SAP HANA on Azure — Certified VM Types and Configurations | Azure VM SKUs certified for HANA (Mv2, Mv3 series) — relevant to PCE sizing on Azure |
| [2684254](https://me.sap.com/notes/2684254) | Azure — Write Accelerator for SAP HANA Log Volumes | Azure Write Accelerator configuration required for HANA log volumes on Mv2 VMs |
| [2952028](https://me.sap.com/notes/2952028) | Azure NetApp Files for SAP HANA Shared and Data Volumes | ANF configuration for HANA shared, data, and log volumes on Azure PCE |

### AWS-Specific Infrastructure

| Note | Title | Relevance |
|------|-------|-----------|
| [1656250](https://me.sap.com/notes/1656250) | SAP HANA on AWS — Certified Instance Types | AWS EC2 instance types certified for HANA (x1e, u-*tb1) — relevant to PCE sizing on AWS |
| [2578899](https://me.sap.com/notes/2578899) | SAP on AWS — Network and Storage Best Practices | AWS VPC, EBS, and EFS configuration best practices for SAP workloads |
| [2927211](https://me.sap.com/notes/2927211) | SAP HANA on AWS — EBS Volume Configuration | EBS gp3/io2 volume configuration for HANA data and log volumes on AWS |

### GCP-Specific Infrastructure

| Note | Title | Relevance |
|------|-------|-----------|
| [2456432](https://me.sap.com/notes/2456432) | SAP HANA on Google Cloud Platform — Certified Machine Types | GCP certified machine types for HANA (m2-ultramem, m3 series) — PCE sizing on GCP |
| [2870592](https://me.sap.com/notes/2870592) | SAP on GCP — Persistent Disk Configuration for HANA | GCP Persistent Disk (SSD/Hyperdisk) configuration for HANA data and log volumes |

### Network Topology and Connectivity

| Note | Title | Relevance |
|------|-------|-----------|
| [3012244](https://me.sap.com/notes/3012244) | RISE with SAP — Network Architecture and Connectivity Options | Network topology options for RISE PCE: VPN, ExpressRoute/Direct Connect, peering |
| [3052832](https://me.sap.com/notes/3052832) | RISE PCE — Customer VNet/VPC Peering Configuration | VNet peering (Azure) and VPC peering (AWS/GCP) setup for RISE customer connectivity |
| [2844111](https://me.sap.com/notes/2844111) | SAP Private Link Service for BTP and PCE | Private Link configuration to avoid public internet exposure for BTP-to-PCE traffic |
| [3267559](https://me.sap.com/notes/3267559) | RISE PCE — Firewall Rules and Port Reference | Required firewall port matrix for S/4HANA PCE (SAP GUI, HTTPS, RFC, admin ports) |

### System Sizing and Infrastructure Scaling

| Note | Title | Relevance |
|------|-------|-----------|
| [1872170](https://me.sap.com/notes/1872170) | SAP HANA Memory Sizing — General Guidelines | Master sizing document for HANA memory; used to calculate initial PCE deployment size |
| [2296290](https://me.sap.com/notes/2296290) | SAP HANA Sizing Report for S/4HANA Migration | Pre-migration sizing report to capture current system footprint for PCE sizing |
| [1656099](https://me.sap.com/notes/1656099) | SAP HANA — VM and Memory Overcommit Rules on IaaS | Memory overcommit constraints on cloud VMs — impacts RISE ECS provisioning decisions |
| [2669325](https://me.sap.com/notes/2669325) | SAP HANA Scale-Up vs Scale-Out Decision Guide | Decision framework for scale-up vs. scale-out HANA deployments in RISE PCE |

### Disaster Recovery and Backup Infrastructure

| Note | Title | Relevance |
|------|-------|-----------|
| [3572444](https://me.sap.com/notes/3572444) | RISE PCE — Backup Policy and Retention Configuration | SAP ECS-managed backup schedule: hourly data backups, 35-day log retention, monthly archives |
| [2781788](https://me.sap.com/notes/2781788) | SAP HANA — Disaster Recovery with Cross-Region System Replication | Cross-region HSR configuration for long-distance DR in RISE PCE |
| [3247998](https://me.sap.com/notes/3247998) | RISE PCE — DR Runbook and Failover Procedures | Documented DR failover procedures and RTO/RPO targets under SAP ECS management |

---

### SAP HANA Database Administration

> Key notes for HANA performance analysis, auditing, and data management in SAP-managed PCE environments. Most operational tasks are ECS-owned; customers interact primarily via DBACOCKPIT and Service Requests.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1969700](https://me.sap.com/notes/1969700) | SQL Statement Collection for SAP HANA | Master toolbox of SQL scripts for HANA analysis and monitoring (memory, CPU, disk, sessions, alerts, traces, blocking, locks). Use via DBACOCKPIT SQL console. Reference for ECS to diagnose performance issues in PCE. Scripts regularly updated — apply latest version. |
| [2222220](https://me.sap.com/notes/2222220) | FAQ: SAP HANA DBACOCKPIT | Comprehensive FAQ for DBACOCKPIT (transaction DBACOCKPIT) in S/4HANA. Covers connection setup, authorization requirements, HANA-specific monitoring panels (memory, disk, alerts, SQL cache), and known issues. Primary HANA admin UI available to customers in PCE. |
| [2453269](https://me.sap.com/notes/2453269) | DB Size History for SAP HANA in DBACOCKPIT | How to view HANA database size history via DBACOCKPIT. Important for storage capacity planning and identifying growth trends in PCE. ECS provisions storage per FUE contract sizing — request additional storage via Service Request. |
| [2689405](https://me.sap.com/notes/2689405) | FAQ: SAP S/4HANA Performance Best Practices — Collective Note | Collective note for S/4HANA on HANA performance best practices. Covers table partitioning, statistics, missing indexes, buffer pool, and SQL plan cache optimization. Apply proactively in PCE to stay within ECS SLA performance baselines. |
| [3205281](https://me.sap.com/notes/3205281) | How to maintain HANA database audit log by retention period | Configure audit log retention period in HANA Tenant Database. In PCE, HANA audit logs are ECS-managed; customer can request retention changes via Service Request. Relevant for GDPR and ISO 27001 audit trail requirements. |
| [3348393](https://me.sap.com/notes/3348393) | Overview of the data management process in the context of SAP HANA | Overview of HANA data management lifecycle: memory management, persistence, backup, archiving, and tiering strategies. Foundational reference for understanding PCE storage architecture and ECS responsibilities. |
| [3384248](https://me.sap.com/notes/3384248) | How to configure HANA audit log to SYSLOG in the Tenant Database | Configure HANA audit trail output to OS SYSLOG for forwarding to external SIEM. In PCE, coordinate SIEM integration requirements with ECS via Service Request. |
| [3421606](https://me.sap.com/notes/3421606) | FAQ: SAP HANA Auditing Activity | FAQ for HANA database audit policy configuration: what can be audited, audit trail targets (CSV/SYSLOG/table), and performance impact. Customer is responsible for defining audit scope; ECS manages HANA system configuration. |
| [3582156](https://me.sap.com/notes/3582156) | Archiving / Archive Strategies for table(s) from the perspective of SAP HANA | HANA-level archiving and data tiering strategies for managing table growth (ILM archiving, dynamic tiering, near-line storage). Relevant for PCE customers approaching storage limits defined in FUE-based contracts. |

---

**SAP Notes Reference Last Updated**: 2026-03-17
