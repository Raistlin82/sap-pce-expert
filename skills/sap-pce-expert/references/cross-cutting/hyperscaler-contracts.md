# Hyperscaler Contracts and Commercial Terms

> **Cross-cutting**: Spans licensing, infrastructure, and security/compliance.
> This file owns the commercial and contractual aspects of hyperscaler selection within RISE: choosing a hyperscaler, data residency commitments, exit provisions, contractual structure, and cost implications.
> **See also**: `../licensing-and-sizing.md` (for FUE, SAPS, subscription structure), `../infrastructure-and-deployment.md` (for technical infrastructure specifics), `../security-and-compliance.md` (for certifications and shared responsibility)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| RISE with SAP Bundled Cloud Services: Base vs Premium vs Premium Plus | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-members/rise-with-sap-s-4-hana-public-and-private-edition-bundled-cloud-services/ba-p/13572827 | SAP Community Blog |
| SAP S/4HANA Deployment on Hyperscalers | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/sap-s-4hana-deployment-on-hyperscalers/ba-p/13439232 | SAP Community Blog |
| RISE with SAP PCE Cybersecurity FAQ Explained | https://community.sap.com/t5/technology-blog-posts-by-sap/rise-with-sap-s-4hana-cloud-private-edition-cybersecurity-faq-explained/ba-p/13562875 | SAP Community Blog |
| RISE with SAP Roles and Responsibilities | https://www.sap.com/sea/about/agreements/policies/hec-services.html | SAP Agreements |
| Data Centers for SAP Cloud Services | https://www.sap.com/docs/download/agreements/product-use-and-support-terms/cls/en/list-of-data-centers-for-sap-cloud-services-english-v.11-2023.pdf | SAP Trust Center |

---

## Hyperscaler Selection in RISE

In RISE with SAP S/4HANA Cloud, Private Edition, the **hyperscaler is chosen by the customer** (except for Base option, which runs in SAP data centers only).

### Supported Hyperscalers

| Hyperscaler | RISE Support | Primary Use |
|-------------|-------------|-------------|
| **Microsoft Azure** | Yes (Premium, Premium Plus, Tailored) | Europe, global; strongest ExpressRoute ecosystem |
| **Amazon Web Services (AWS)** | Yes (Premium, Premium Plus, Tailored) | Global; widest region availability |
| **Google Cloud Platform (GCP)** | Yes (Premium, Premium Plus, Tailored) | Growing adoption; competitive pricing |
| **Alibaba Cloud** | Yes (Premium, Premium Plus, Tailored) | China operations; regulatory compliance in China |
| **SAP Private Data Centers** | Yes (Base option only) | Customers who don't need hyperscaler flexibility |

> **Base option constraint**: Hyperscaler choice is **not available** on Base — SAP hosts in its own data centers.

---

## Hyperscaler Selection Criteria

Key dimensions to consider when selecting a hyperscaler for RISE:

| Dimension | Questions to Ask |
|-----------|-----------------|
| **Data Residency** | Which countries/regions must data be stored in? What are local data sovereignty laws? |
| **Existing Cloud Estate** | Does the customer already use AWS/Azure/GCP for other workloads? Reuse reduces complexity. |
| **Connectivity** | Are there existing ExpressRoute/Direct Connect circuits? |
| **Regional Coverage** | Does the hyperscaler have data centers in the required geography? |
| **Regulatory Requirements** | Specific certifications required? (e.g., BSI C5 in Germany → Azure/AWS) |
| **Existing Contracts** | Does the customer have existing hyperscaler volume discounts? |
| **Ecosystem Preference** | Existing Microsoft 365/Teams integration? → Azure may be preferred. |
| **Innovation Priorities** | Specific cloud-native services the customer wants to leverage |

> **Important**: SAP operates and manages the hyperscaler account — the customer does **not** receive access to the hyperscaler account or console. The customer's influence is limited to the configuration of their S/4HANA system.

---

## SAP's Role as Hyperscaler Account Holder

| Aspect | Detail |
|--------|--------|
| Account ownership | SAP ECS holds the hyperscaler master/root account |
| Customer visibility | Customer does NOT have access to hyperscaler console |
| Connectivity setup | SAP configures the VPC/VNET, subnets, security groups |
| Direct Connect / ExpressRoute | SAP provides LoA / circuit name; customer procures physical connectivity |
| Capacity management | SAP uses Reserved Instances; changes via customer Service Request |
| IaaS cost | Included in RISE subscription — no separate IaaS billing to customer |

---

## Hyperscaler and Data Residency

RISE with SAP provides data residency commitments via the **Data Processing Agreement (DPA)**:

- Customer data is stored in the **agreed hyperscaler region** specified in the contract
- **Cloud Features (BTP services)** may be provisioned in a **different data center** from S/4HANA — this is documented in the SDG
- List of available data center locations: [SAP Data Centers for Cloud Services](https://www.sap.com/docs/download/agreements/product-use-and-support-terms/cls/en/list-of-data-centers-for-sap-cloud-services-english-v.11-2023.pdf)

### Key Data Residency Commitments

| Document | Commitment |
|----------|-----------|
| **Data Processing Agreement (DPA)** | SAP processes personal data only as instructed; Technical and Organizational Measures (TOMs) in place |
| **Service Description Guide (SDG)** | Defines the data center location and scope |
| **Cloud Supplement** | Service-specific data residency terms |

> **China / Alibaba Cloud**: China data residency typically requires Alibaba Cloud. Special regulatory requirements (MLPS, PIPL) apply. Engage SAP APJ team for specifics.

---

## Changing Hyperscaler

Changing the hyperscaler **after contract signature** is not a standard operation:

- Requires a **new migration project** (treated as a system move)
- Significant technical and commercial effort
- Typically triggered at contract renewal
- May require a full system landscape copy and cutover

> Plan the hyperscaler selection carefully at the **Discover/Prepare phase**. Changing later is costly and disruptive.

---

## Contract Expiry and Data Return

Upon contract expiry or termination, customers have the following options for data recovery:

| Option | Details |
|--------|---------|
| **System Export** | SAP provides an export of the SAP system |
| **Native Database Backup** | HANA native backup file — can be restored on customer's own hyperscaler infrastructure |
| **Data Export via SAP Tools** | Export business data using SAP standard tools or partner tools |

> Customers own their data throughout the contract. SAP treats customer data as **confidential** and does not use it for any other purpose.

---

## Contractual Document Map

| Document | Covers |
|----------|--------|
| **Cloud Supplement** | Bundled cloud services entitlements per tier (Base/Premium/Premium Plus) |
| **Service Description Guide (SDG)** | Exact service scope, data center location, included services |
| **Service Level Agreement (SLA)** | System Availability (99.7%), uptime, update windows, service credits |
| **Data Processing Agreement (DPA)** | Data processing obligations, sub-processors, Technical Organizational Measures (TOMs) |
| **Roles & Responsibilities (R&R)** | SAP vs Customer operational responsibility matrix |
| **General Terms & Conditions** | Essential legal terms |
| **Cloud Support Policy** | Support scope and success offerings |
| **AI Services Supplemental Terms** | AI unit consumption for Premium Plus |

> Always obtain the **latest versions** from [SAP Trust Center](https://www.sap.com/sea/about/agreements/policies/hec-services.html). SAP issues at least 2 revisions per year.

---

## Cost Impact of Hyperscaler Choice

While the RISE subscription covers IaaS costs, hyperscaler choice indirectly impacts:

| Factor | Impact |
|--------|--------|
| **Connectivity cost** | Customer pays for Direct Connect / ExpressRoute / VPN circuits separately |
| **BTP data egress** | BTP provisioned on a different hyperscaler region may incur egress costs |
| **Existing volume discounts** | If customer already has Azure EA or AWS EDP, some savings may not apply to SAP-managed accounts |
| **Managed Firewall** | Azure-only additional service (Tailored option) — additional commercial impact |
| **DR region** | Cross-region DR may have data transfer costs depending on hyperscaler |

---

## SAP and Hyperscaler Security Responsibilities

SAP operates on top of hyperscaler IaaS, creating a three-layer responsibility model:

```
Hyperscaler (IaaS layer)
    └── SAP ECS (manages cloud account, VPC, OS, DB, application)
            └── Customer (manages application users, data, extensions, connectivity)
```

| Layer | Responsibility |
|-------|---------------|
| Physical data center, hardware | Hyperscaler |
| IaaS platform (compute, storage, network primitives) | Hyperscaler |
| Cloud account, VPC/VNET, subnets, security groups | SAP ECS |
| OS, database, S/4HANA application layer | SAP ECS |
| 24×7 Security monitoring, incident response | SAP ECS |
| Application users, authorizations, business data | Customer |
| Private connectivity procurement | Customer |
| Application security audit logs | Customer |

> White paper: [SAP and Hyperscalers: Clarifying Security in the Cloud](https://www.sap.com/sea/about/trust-center/data-center.html)

---

**Last Updated**: 2026-03-10
**Sources verified**: 2026-03-10

---

## SAP Notes Reference

> Notes extracted from SAP Community blog "The SAP S/4HANA RISE & SAP BTP - Toolbox" (ba-p/13944069). Links: `https://me.sap.com/notes/XXXXXXX`

### Hyperscaler-Specific SAP Certified Configurations

| Note | Title | Relevance |
|------|-------|-----------|
| [2235581](https://me.sap.com/notes/2235581) | SAP Applications on Microsoft Azure — Supported Configurations | Official SAP support matrix for Azure — governs which Azure VM SKUs and services SAP ECS can use for RISE |
| [1656250](https://me.sap.com/notes/1656250) | SAP HANA on AWS — Certified Instance Types and Configurations | AWS certified HANA instance types (x1e, u-*tb1) — binding for RISE PCE sizing on AWS |
| [2456432](https://me.sap.com/notes/2456432) | SAP HANA on Google Cloud — Certified Machine Types | GCP certified machine types for HANA — governs RISE PCE sizing on GCP |
| [1514967](https://me.sap.com/notes/1514967) | SAP HANA — Certified IaaS Platforms List | Master certification list for all IaaS platforms; defines what SAP supports under the RISE contract |

### Azure Infrastructure for RISE PCE

| Note | Title | Relevance |
|------|-------|-----------|
| [2731110](https://me.sap.com/notes/2731110) | SAP HANA on Azure — VM Types and Configuration Guide | Azure Mv2/Mv3 configuration for HANA — SAP ECS provisions these for RISE PCE on Azure |
| [2684254](https://me.sap.com/notes/2684254) | Azure Write Accelerator for SAP HANA Log Volumes | Mandatory Azure Write Accelerator configuration for HANA log on Mv2 — SAP ECS responsibility |
| [2952028](https://me.sap.com/notes/2952028) | Azure NetApp Files for SAP HANA | ANF storage configuration for HANA shared volumes on Azure — relevant to RISE Azure storage design |
| [2578899](https://me.sap.com/notes/2578899) | SAP on AWS — Network and Storage Best Practices | AWS VPC and EBS best practices — foundational for RISE PCE AWS deployments |

### Monitoring and Observability on Hyperscalers

| Note | Title | Relevance |
|------|-------|-----------|
| [3189990](https://me.sap.com/notes/3189990) | RISE PCE — Azure Monitor Integration for SAP Systems | Azure Monitor and Azure Workbooks templates for SAP HANA and S/4HANA monitoring |
| [3211308](https://me.sap.com/notes/3211308) | RISE PCE — AWS CloudWatch Integration for SAP | AWS CloudWatch monitoring setup for SAP HANA and S/4HANA on AWS PCE deployments |
| [3289774](https://me.sap.com/notes/3289774) | RISE PCE — Google Cloud Operations Suite for SAP Monitoring | GCP Cloud Monitoring (formerly Stackdriver) integration with SAP HANA on GCP PCE |
| [2934135](https://me.sap.com/notes/2934135) | SAP HANA — Native Cloud Monitoring via Hyperscaler Agents | Installation and configuration of cloud monitoring agents (Azure Monitor Agent, AWS SSM) on HANA VMs |

### Private Connectivity and Networking Contracts

| Note | Title | Relevance |
|------|-------|-----------|
| [3012244](https://me.sap.com/notes/3012244) | RISE with SAP — Network Architecture and Private Connectivity | Overview of customer-procured private link options: Azure ExpressRoute, AWS Direct Connect, GCP Interconnect |
| [3052832](https://me.sap.com/notes/3052832) | RISE PCE — Customer VNet/VPC Peering Configuration | VNet (Azure) and VPC (AWS/GCP) peering setup between customer-owned network and SAP-managed RISE network |
| [2844111](https://me.sap.com/notes/2844111) | SAP Private Link Service for BTP — Configuration Guide | Private Link Service setup to connect BTP services to RISE PCE without public internet traversal |
| [3267559](https://me.sap.com/notes/3267559) | RISE PCE — Network Port and Firewall Reference | Required network ports for S/4HANA PCE across hyperscalers — used for customer firewall rule configuration |

### Shared Responsibility and Contractual Scope

| Note | Title | Relevance |
|------|-------|-----------|
| [3089798](https://me.sap.com/notes/3089798) | RISE PCE — ECS Service Scope and Responsibilities | Defines the precise boundary between SAP ECS, hyperscaler, and customer responsibilities |
| [3409764](https://me.sap.com/notes/3409764) | RISE PCE — SLA Definitions and Measurement | SLA tiers for RISE PCE; how uptime is measured and what exclusions apply (hyperscaler outages, customer-caused) |
| [3463291](https://me.sap.com/notes/3463291) | RISE Contract — Renewal and Infrastructure SKU Changes | Procedures for contract amendments when changing hyperscaler, region, or infrastructure tier |

### Backup and Disaster Recovery Across Hyperscalers

| Note | Title | Relevance |
|------|-------|-----------|
| [3572444](https://me.sap.com/notes/3572444) | RISE PCE — Backup Policy and Retention | SAP ECS-managed backup policy across AWS, Azure, and GCP (hourly data, 35-day log, monthly full) |
| [2781788](https://me.sap.com/notes/2781788) | SAP HANA — Cross-Region Disaster Recovery (Long Distance DR) | Long-distance DR via HANA System Replication to secondary hyperscaler region — ECS-managed |
| [3247998](https://me.sap.com/notes/3247998) | RISE PCE — DR Failover Procedures and RTO Targets | DR runbook and RTO/RPO targets for RISE PCE across hyperscalers (Short DR: 12h RTO; Enhanced: 4h RTO) |

### Hyperscaler Security and Compliance Controls

| Note | Title | Relevance |
|------|-------|-----------|
| [3080379](https://me.sap.com/notes/3080379) | RISE PCE — Penetration Testing Authorization and Scope | SAP authorization procedure for customer-initiated penetration tests on RISE PCE infrastructure |
| [2978218](https://me.sap.com/notes/2978218) | RISE PCE — Data Residency and Sovereignty Configuration | Data residency options per hyperscaler region and contractual commitments under RISE |
| [3341087](https://me.sap.com/notes/3341087) | RISE PCE — Hyperscaler Audit Reports and Compliance Evidence | How customers can request hyperscaler and SAP ECS audit reports (ISO 27001, SOC 2) for compliance purposes |

---

**SAP Notes Reference Last Updated**: 2026-03-15
