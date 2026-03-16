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

## S/4HANA Cloud Private Edition 2025 FPS01 (March 2026)

The **2025 FPS01** release introduces **Agentic AI**—a shift from assistive AI to autonomous agents that can analyze data and propose actions.

### Agentic AI & Joule Enhancements

| Feature | Description |
|---------|-------------|
| **Cash Management Agent** | Autonomously checks bank statement completeness, validates opening balances, and prepares cash-flow forecasts. |
| **Change Record Management Agent** | Analyzes the impact of engineering changes (R&D) and proposes next steps for faster change cycles. |
| **Joule Conversational Shortcuts** | Use natural language (voice/text) to search for service contracts, extend sales prices, or retrieve batch master data. |
| **Warehouse Management (Joule)** | Confirm warehouse tasks and search for outbound delivery orders via Joule. |
| **Multistage Intercompany Sales** | Automated orchestration of sales and stock transfers across multiple legal entities (covers two-entity transfers). |

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

---

## SAP Notes Reference

> Key SAP Notes for Architecture and Components. Full master list: see `sap-notes-master-list.md` in workspace root.
> Source: RISE & BTP Toolbox Blog (community.sap.com/t5/...ba-p/13944069)

### Release and Maintenance Strategy

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3016524](https://me.sap.com/notes/3016524) | RISE with SAP S/4HANA, private cloud edition: Information about the release and maintenance strategy | Master note for RISE PCE release strategy (launched Jan 2021). S/4HANA core committed to 2040 via release sequence. SAP Business Suite 7 products: mainstream maintenance until end of 2027, optional extended until end of 2030. Customer responsible for requesting upgrades before entering CSM. Partner/3rd-party products follow their own maintenance commitments. |
| [3017596](https://me.sap.com/notes/3017596) | RISE with SAP S/4HANA, private cloud edition and SAP ERP, private cloud edition: Information about maintenance availability | Three tiers: (1) S/4HANA & BW/4HANA → committed until 2040 (ref Note 2900388); (2) SAP Business Suite 7 / NW 7.5 → mainstream until end 2027, extended until end 2030; (3) Customer-specific maintenance NOT offered for SAP ERP PCE. Check PAM for exact product dates. |
| [3061124](https://me.sap.com/notes/3061124) | SAP S/4HANA Cloud Private Edition - Release Information | PCE-specific release information |
| [3493301](https://me.sap.com/notes/3493301) | SAP S/4HANA 2025: Release Information Note | S/4HANA 2025 release (on-premise and PCE) |
| [3658070](https://me.sap.com/notes/3658070) | SAP S/4HANA Cloud Private Edition 2025: Release Information Note | PCE-specific 2025 release note |
| [3568504](https://me.sap.com/notes/3568504) | SAP S/4HANA FOUNDATION 2025: Release Information Note | Foundation layer release note for S/4HANA 2025 |
| [2900388](https://me.sap.com/notes/2900388) | SAP S/4HANA maintenance commitment until 2040 | Official SAP long-term maintenance commitment — critical for ROI discussions |
| [3641453](https://me.sap.com/notes/3641453) | SAP S/4HANA 2023: Support Package Stack Additional Release Information | SPS additional release details for 2023 |

### Compatible Partner Products and Solution Extensions

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3418615](https://me.sap.com/notes/3418615) | SAP S/4HANA Cloud, private edition: Partner Products compatible with S/4HANA 2023 | ISV compatibility matrix for PCE 2023 |
| [3634480](https://me.sap.com/notes/3634480) | SAP S/4HANA Cloud Private Edition 2025: Compatible versions of SAP Solution extensions | SAP Solution Extensions compatibility for PCE 2025 |
| [2788939](https://me.sap.com/notes/2788939) | Compatible versions of SAP Solution extensions for SAP S/4HANA On-Premise | Solution Extensions compatibility reference (on-premise baseline) |
| [3654390](https://me.sap.com/notes/3654390) | SAP S/4HANA, on-premise edition 2025: Compatible partner products | Partner products for on-premise 2025 (cross-reference) |
| [3634338](https://me.sap.com/notes/3634338) | Pre-requisite notes for compatibility with SAP S/4HANA 2025 | Checklist of prerequisite notes before upgrading to 2025 |
| [3659273](https://me.sap.com/notes/3659273) | SAP S/4HANA Cloud Private Edition 2025: Restriction notes | Known restrictions in PCE 2025 |

### RISE ECS Managed Service Scope

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3424346](https://me.sap.com/notes/3424346) | SAP S/4HANA Cloud Safekeeper - Description of maintenance-related service elements | Safekeeper bridges the gap when PCE customers enter Customer Specific Maintenance (CSM). Max 27 months coverage (48 months for releases 1503/1605). Covers security fixes but NOT new features. Start dates by release: 1709/1809/1909/2020 → Jan 2026; 2021 → Jan 2027; 2022 → Jan 2028; 2023 → Jan 2031. AS Java excluded after Jan 2031. Applies to full system landscape (DEV, QA, PROD). Request quotation via SAP account executive or Partner Manager. Single source of truth: PAM (support.sap.com/pam). |
| [3549985](https://me.sap.com/notes/3549985) | Best Practices and Boundary Conditions for Convergent Mediation Systems hosted in SAP ECS (RISE) | Boundary conditions for specialized systems on RISE ECS |
| [3091143](https://me.sap.com/notes/3091143) | Installation and Upgrade of Assurance and Compliance Software in Enterprise Cloud Services | A&C software installation in ECS context |

### SAP Business Data Cloud (BDC) — Strategic Direction

> **Key insight**: BW/4HANA and legacy BW systems move to **SAP Business Data Cloud (BDC) PCE**, not to RISE ECS. BDC is a separate Private Cloud offering managed on BDC infrastructure, not on SAP ECS.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3539174](https://me.sap.com/notes/3539174) | Integration of SAP S/4HANA Cloud Private Edition with SAP Business Data Cloud | Integration architecture: S/4HANA PCE ↔ BDC |
| [3603670](https://me.sap.com/notes/3603670) | SAP Business Data Cloud Release Schedule | BDC release cadence reference |
| [3568017](https://me.sap.com/notes/3568017) | Guidelines for SAP Business Data Cloud (BDC) Cases | How to open BDC support cases correctly |
| [3653821](https://me.sap.com/notes/3653821) | BDC Frequently Asked Questions (FAQ) | Comprehensive BDC FAQ |
| [3590935](https://me.sap.com/notes/3590935) | Guidance on installation of Business Data Cloud packages through BDC Cockpit | BDC Cockpit package installation guide |
| [3500131](https://me.sap.com/notes/3500131) | ABAP Data Integration for SAP Business Data Cloud | ABAP integration with BDC |
| [3670698](https://me.sap.com/notes/3670698) | SAP BPC Compatibility with SAP Business Data Cloud (BDC) | BPC compatibility in BDC context |
| [2383530](https://me.sap.com/notes/2383530) | Conversion from SAP BW to SAP BW/4HANA | BW → BW/4HANA conversion as predecessor step before BDC |
| [2303900](https://me.sap.com/notes/2303900) | Latest Information about BW Setup in S/4HANA Systems | BW setup information in S/4HANA |

### Specialized Applications on PCE (GTS, EHP, etc.)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3185896](https://me.sap.com/notes/3185896) | Measurement function for SAP Global Trade Services, edition for SAP HANA, private cloud edition | GTS PCE measurement and sizing |
| [3429848](https://me.sap.com/notes/3429848) | SAP S/4HANA Cloud Private Edition: Integration with SAP Start - Restrictions | SAP Start integration restrictions for PCE |

### GTP Pre-Migration Checks (Guided Transition to ECS Preparation)

> **Key insight**: Before any system transition to ECS, a structured set of pre-flight checks (GTP) must pass. These are mandatory, not optional.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3409764](https://me.sap.com/notes/3409764) | Guided Transition to SAP Enterprise Cloud Services Preparation (GTP) Checks – Central SAP Note | Central umbrella note for all GTP checks. Implement via TCI Note 3604767 (Shipment 09/2025, preferred) or non-TCI Note 3632974 (Shipment 08/2025). 19 checks covering: security files (gw/prxy_info, gw/reg_info, gw/sec_info), SICK, aborted DDIC conversions, cancelled update tasks, missing DB objects, extractor queue entries, HANA migration readiness, pending RFC calls (inbound/outbound), silent data migration status, Secure Store, inactive objects, profile naming, OCS queue, open transports, server/logon groups, server state, SPDD modifications. Component: BC-UPG-TLS-GTP. |
| [3425775](https://me.sap.com/notes/3425775) | FAQ for the Guided Transition to SAP Enterprise Cloud Services Preparation | GTP checks run at 3 stages: (1) source system on-premise, (2) intermediate system post-migration pre-switch-back, (3) target system post-switch-back. Results viewable in SLG1 (Object: GTP). Switch-back procedure: app servers on migration VM shut down, then switched to ECS main server — HDBUSERSTORE key 'DEFAULT' credentials and schema user updated in profile. Issues with ABAP implementation of checks → component BC-UPG-TLS-GTP. Not for SLOCON/HANA Tenant Copy/SUM issues. |
| [3539699](https://me.sap.com/notes/3539699) | Phase three Delivery of Guided Transition Preparation | GTP Shipment 12/2024 — reference only (superseded by 3632974). |

### PCE Readiness Check & Licensing Estimation

> **Use before contract negotiation**: Run the PCE Readiness Check tools on the existing ECC system to estimate FUE and Engine license requirements for the new PCE contract.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3548791](https://me.sap.com/notes/3548791) | SAP PCE Readiness Check - Umbrella Note | TCI umbrella note bundling 3 tools: (1) Note 3113382 → FUE requirements for Production core (report SLIM_USER_CLF_HELP); (2) Note 3333812 → FUE requirements for Developer Users in DEV systems (report SLIM_DEV_CLF_HELP); (3) Note 3487429 → PCE Engine Measurement (report RSUVM_PCE). Purpose: estimate transformation from legacy ECC Named Users + Engine licenses to FUE and new Engine license requirements. Implement via SNOTE with TCI enabled. |

### RISE System Transition Workbench

> **Migration tooling**: The RISE with SAP System Transition Workbench is the official SAP-managed toolchain for moving customer ABAP systems into ECS. Partners must hold at minimum "Essential Level" for SAP Cloud ERP Private competency.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3462243](https://me.sap.com/notes/3462243) | RISE with SAP System Transition Workbench | 5 scenarios, all GA as of 2025-12-19: HANA Tenant Copy (since Oct 2024), HANA Backup & Recovery (since Oct 2024), Homogeneous Update & Copy, System Conversion SUM DMO with System Move, System Conversion DMOVE2S4. Key restrictions: ECS internal ops + qualified migration partners only; no SAP NS2 support; no HANA scale-out targets; MSSQL not supported for DMOVE2S4; SPAM version 93 causes post-processing issues — avoid. Current tool version: 1.1.0. Source HANA: SP05+ (without TLS) or SP06+ (with TLS). |

### ECS Landscape & Operational Tools

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3344326](https://me.sap.com/notes/3344326) | FAQ : Private Cloud Landscape (ECS Landscape) | Access via SAP for Me → Systems and Provisioning → Landscape Applications (direct: me.sap.com/privcloudlandscape). Shows hostnames, IPs, service ports, storage per host. HEC-Host name = primary network device → use in firewall rules. VH-Names = application instances (format: `vh + CustomerID + SID + InstanceType + Index`). Storage (GB) = shared + block storage; FUE-based contracts size storage for SLA only — additional storage (e.g., SFTP) requires purchase or remote mount via CIFS (see Note 3358252). |
| [3380895](https://me.sap.com/notes/3380895) | FAQ : ECS Service Request | Plan and raise Service Requests at least 1 week in advance. Execution time = downtime window for tasks requiring service down. ECS operates 24x5 for non-PRD systems. Validate scope in Roles & Responsibilities document before raising. Use "Assisted Service Request" template when no specific template exists. Service Request list (with downtime info) downloadable as Excel from SAP for Me. Process flows documented at help.sap.com (ECS Service Process Flows PDF). |
| [3517086](https://me.sap.com/notes/3517086) | Non-Security Parameters for ABAP systems in SAP Enterprise Cloud Services (ECS) | ECS standard non-security ABAP parameters reference. Core principle: Zero-Administration-Memory-Management (SAP Note 2085980) — configure only essential params, rely on kernel defaults for all others. All system-level parameters in DEFAULT.PFL only (not instance profiles). "Allowed Ranges" only for single-parameter exceptions; combining multiple upper-range values can cause outages. Applies to NW Kernel 7.40+. For changes outside standard, contact CDM / TSM / CAA / dCEM. |

---

**Last Updated**: 2026-03-16
**Sources verified**: 2026-03-16 (enriched with real SAP Note content via sap_note_get)
