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
