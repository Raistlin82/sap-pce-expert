# Architecture and Components

> **Ownership**: RISE with SAP bundle overview, S/4HANA Cloud Private Edition product details, Standard vs Tailored option, included BTP services entitlements (Base/Premium/Premium Plus), SAP Signavio, SAP Business Network.
> **See also**: `infrastructure-and-deployment.md` (for hyperscaler infrastructure specifics), `licensing-and-sizing.md` (for FUE and contract terms), `security-and-compliance.md` (for security architecture)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| RISE with SAP Bundled Cloud Services: Base vs Premium vs Premium Plus | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-members/rise-with-sap-s-4-hana-public-and-private-edition-bundled-cloud-services/ba-p/13572827 | SAP Community Blog |
| RISE with SAP: Standard Option vs Tailored Option for Private Edition | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-members/rise-with-sap-difference-between-standard-option-vs-tailored-option-for/ba-p/13579537 | SAP Community Blog |
| SAP S/4HANA Deployment on Hyperscalers | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/sap-s-4hana-deployment-on-hyperscalers/ba-p/13439232 | SAP Community Blog |
| RISE with SAP S/4HANA Cloud PCE Service Description Guide (SDG) | https://www.sap.com/docs/download/agreements/product-use-and-support-terms/service-description-guides/rise-with-sap-s4hana-cloud-private-edition-service-description-guide-english-v11-2023.pdf | SAP Trust Center |
| RISE with SAP Roles and Responsibilities | https://www.sap.com/sea/about/agreements/policies/hec-services.html | SAP Agreements |

---

## RISE with SAP: What Is It?

**RISE with SAP** is SAP's comprehensive cloud transformation bundle. It packages ERP, cloud services, and managed operations into a **single subscription contract** under SAP responsibility.

### RISE Bundle Core Components

| Component | Description |
|-----------|-------------|
| **SAP S/4HANA Cloud, Private Edition** | The ERP core — S/4HANA application managed by SAP Enterprise Cloud Services (ECS) |
| **SAP Business Technology Platform (BTP)** | Extension, integration, and analytics platform — bundled services depend on tier |
| **SAP Business Network Starter Pack** | Supply chain collaboration and procurement network access |
| **SAP Signavio Process Intelligence** | Business process intelligence and mining (from Premium tier) |
| **SAP Cloud ALM** | Application lifecycle management — monitoring, testing, change management |
| **RISE Methodology** | SAP's structured transformation methodology with toolchain and expert guidance |

---

## S/4HANA Cloud Private Edition: Two Product Options

### Standard Option

- SAP manages and operates the S/4HANA system on a **hyperscaler of customer's choice** (AWS, Azure, GCP, Alibaba Cloud) or SAP's own data centers
- Full SAP ECS managed services: OS, DB, application layer
- Customers use SAP S/4HANA with standard configuration plus approved extensions
- Two-year release cycle (vs 6-month for Public Edition)
- Seven-year maintenance window
- **Bundled Cloud Services (Base, Premium, Premium Plus)** are available under Standard option

### Tailored Option

- Designed for customers with **complex, highly customized S/4HANA landscapes**
- Deeper customization is allowed than Standard
- Additional managed services available (e.g., Managed Firewall on Azure)
- **No Bundled Cloud Services tiers** — services negotiated separately
- Requires dedicated Cloud Architect Advisory (CAA) engagement

> **Key difference**: Standard = fixed service catalog with BTP bundles. Tailored = flexible scope, no BTP bundle tiers, higher customization tolerance.

---

## Bundled Cloud Services: Base vs Premium vs Premium Plus

Bundled Cloud Services are **additional BTP and SAP services** included in the Standard Option subscription at no additional cost.

### Base Option

- Targeted at customers with **minimal BTP usage**
- S/4HANA system hosted in **SAP's own private data centers only** (not hyperscaler of choice)
- No CPEA (Cloud Platform Enterprise Agreement) credits included
- **Included BTP service**: SAP Build Work Zone (standard edition)

### Premium Option

- For **all existing RISE customers** (legacy default tier)
- S/4HANA hosted on **hyperscaler of customer's choice** (AWS, Azure, GCP, Alibaba)
- CPEA credits included for flexible BTP consumption

| Included BTP Service | Description |
|---------------------|-------------|
| SAP Build Work Zone | Digital workplace and launchpad |
| SAP Build Process Automation | Workflow automation + RPA |
| SAP Build Apps | Low-code app builder |
| SAP Signavio (Process Intelligence) | Process mining and transformation suite |
| CPEA credits | Flexible BTP service consumption |

### Premium Plus Option

- Introduced October 2023
- All Premium services **plus** additional data and AI capabilities
- Targeted at customers needing advanced analytics, sustainability insights, and generative AI

| Additional Services (vs Premium) | Description |
|----------------------------------|-------------|
| SAP Datasphere | Enterprise data fabric and federation |
| SAP Analytics Cloud (planning) | Planning and analytics |
| AI Units | Generative AI consumption (SAP AI Core) |

> **Note**: Cloud Features (BTP services) may be provisioned in a **different data center** from S/4HANA. They do not carry the same SLA as the S/4HANA system itself.

**Upgrade path**: Existing Premium customers can upgrade to Premium Plus via SKU `XYEER` (RISE with SAP S/4HANA Cloud, private edition, premium, upgrade option).

---

## SAP S/4HANA Cloud Private Edition vs Public Edition

| Dimension | Private Edition (PCE) | Public Edition |
|-----------|----------------------|----------------|
| Deployment | Dedicated single-tenant on hyperscaler | Multi-tenant SAP-managed SaaS |
| Release cadence | 2-year cycles (PCE) | 6-month cycles |
| Maintenance | 7-year window | Continuous |
| Customization | High (Standard + Tailored options) | Low (cloud-compliant extensions only) |
| Industry scope | Comprehensive, sub-vertical tailored | Core Finance, HR, basic processes |
| Target | Complex manufacturing, product-centric, retail | Mid-market, standardized industries |
| BTP bundles | Base / Premium / Premium Plus | Base / Premium (no Premium Plus) |

---

## SAP Signavio in RISE

SAP Signavio (Process Intelligence) is included from Premium tier. Capabilities:

- **Process Mining**: Discover actual process flows from system event logs
- **Process Design**: Model target process using BPMN notation
- **Transformation Management**: Define and track improvement initiatives
- **Benchmarking**: Compare processes against industry best practices
- **S/4HANA Integration**: Pre-built connectors to S/4HANA event data

> Joule (SAP AI Copilot) can be integrated with SAP Signavio Process Transformation Suite for AI-assisted process analysis.

---

## SAP Business Network Starter Pack

Included in RISE to enable supply chain collaboration:

- Access to **SAP Business Network** (Ariba Network, Logistics Business Network)
- Supplier onboarding and collaboration
- Procurement and supply chain document exchange
- **Starter Pack**: limited transactions included; full access requires additional subscription

---

## SAP Cloud ALM

Included with all RISE subscriptions:

| Capability | Description |
|------------|-------------|
| Implementation Management | SAP Activate task management, fit-to-standard tracking |
| Operations Monitoring | Health monitoring, integration & exception monitoring |
| Change Management | Transport management and change control |
| Testing | Test automation and management |
| RISE Methodology Dashboard | Clean core KPIs (System View, Operations View) |

---

## Service Description Guide (SDG)

The **Service Description Guide (SDG)** is the contractual document defining exactly what services are included in the RISE subscription. Always download the **latest version** from SAP Trust Center.

| SDG | Link |
|-----|------|
| RISE with SAP S/4HANA Cloud, Private Edition SDG | Available at SAP Trust Center |
| SAP BTP SDG | Available at SAP Trust Center |
| SAP AI Services and AI Units Supplemental Terms | Available at SAP Trust Center |

**Trust Center**: [SAP Trust Center – Agreements](https://www.sap.com/sea/about/agreements/policies/hec-services.html)

---

**Last Updated**: 2026-03-10
**Sources verified**: 2026-03-10
