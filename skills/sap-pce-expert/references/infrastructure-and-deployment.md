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
