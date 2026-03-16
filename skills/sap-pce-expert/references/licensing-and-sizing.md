# Licensing and Sizing

> **Ownership**: RISE subscription licensing model, FUE (Full Usage Equivalents) concept and user classification, SAPS (SAP Application Performance Standard) sizing, HANA memory sizing, Standard vs Tailored commercial differences, STAR report, contract structure.
> **See also**: `cross-cutting/hyperscaler-contracts.md` (for hyperscaler commercial terms), `architecture-and-components.md` (for what is included in the RISE bundle tiers)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| RISE with SAP: Full Use Equivalent (FUE) Concept | https://community.sap.com/t5/technology-blog-posts-by-sap/rise-with-sap-full-use-equivalent-fue-concept/ba-p/14054243 | SAP Community Blog |
| RISE with SAP: Standard Option vs Tailored Option | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-members/rise-with-sap-difference-between-standard-option-vs-tailored-option-for/ba-p/13579537 | SAP Community Blog |
| RISE with SAP Bundled Cloud Services: Base vs Premium vs Premium Plus | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-members/rise-with-sap-s-4-hana-public-and-private-edition-bundled-cloud-services/ba-p/13572827 | SAP Community Blog |
| RISE with SAP S/4HANA Cloud PCE Service Description Guide (SDG) | https://www.sap.com/docs/download/agreements/product-use-and-support-terms/service-description-guides/rise-with-sap-s4hana-cloud-private-edition-service-description-guide-english-v11-2023.pdf | SAP Trust Center |
| RISE with SAP Roles and Responsibilities | https://www.sap.com/sea/about/agreements/policies/hec-services.html | SAP Agreements |

---

## RISE Subscription Model

RISE with SAP uses a **subscription-based commercial model** — no hardware CapEx, no perpetual licenses. Key principles:

- Single contract covers: ERP, BTP services, managed operations, methodology
- Subscription term: typically **3–5 years**
- **FUE-based user licensing** for the application layer (see below)
- **SAPS + HUoM** for infrastructure sizing (compute + HANA memory)
- Annual subscription fee includes: SAP ECS managed services, hyperscaler IaaS, SAP software licenses

---

## Full Usage Equivalents (FUE)

FUE is SAP's cloud licensing unit for S/4HANA Cloud. It replaces the legacy Named User model.

> "Full Use Equivalent (FUE) is the aggregation method by which customers may allocate individuals access to the Cloud service in accordance with the ratios set forth in the respective Cloud Supplement or Service Description Guide."

### FUE Conversion Ratios

| User Type | FUE Weight | Typical Profile |
|-----------|-----------|-----------------|
| **Advanced Use** | 1 FUE per user | Full access — Finance Manager, Procurement Director. Broad create/change/delete authorizations across modules. |
| **Core Use** | 1 FUE per 5 users (0.2 FUE each) | Limited access — AP Clerk, Procurement Specialist. Defined scope within one area. |
| **Self-Service Use** | 1 FUE per 30 users (0.033 FUE each) | Minimal access — ESS user, time entry, HR self-service. Fiori app access only. |
| **Developer Access** | 2 FUE per developer | ABAP developer tools (SE80, SE38, ST22). |

> **FUE allocation is flexible**: Customers can reallocate FUEs between user types during the subscription term without purchasing new licenses.

> **Unclassified users are measured as Advanced** — every user without explicit classification counts as 1 FUE. This is the most expensive category.

### FUE Calculation Example

| User Type | Count | FUE Weight | FUE Total |
|-----------|-------|-----------|-----------|
| Advanced | 50 | × 1.0 | 50 FUE |
| Core | 100 | × 0.2 | 20 FUE |
| Self-Service | 300 | × 0.033 | 10 FUE |
| **Total** | 450 | | **80 FUE** |

### Dialog Users vs System/Technical Users

- **Dialog Users**: Human users — classified as Advanced / Core / Self-Service
- **System/Technical Users**: Background integration and interface users — must be explicitly classified
- Unclassified technical users default to **Advanced** — can significantly inflate FUE count

---

## STAR Report: S/4HANA Trusted Authorization Review

The **STAR service** is SAP's tool for assessing future FUE licensing requirements based on current system usage.

### How STAR Works

1. **Data Collection**: STAR runs as a background job capturing user transaction and authorization usage over a defined period
2. **Aggregation**: Maps each user's activity to SAP's FUE classification rules
3. **Reporting**: Outputs FUE consumption per user/role — reveals over-provisioning

### Running the STAR Report

| Step | Action |
|------|--------|
| 1 | Implement SAP Note **3113382** (Authorization Object Analyzer for S/4HANA FUE projection) |
| 2 | Log in to SAP PRD system, go to transaction **SA38** |
| 3 | Run report **SLIM_USER_CLF_HELP** |
| 4 | Choose **Export** option (not "Export to SAP") to review internally first |
| 5 | Review output — identify legacy roles inflating FUE |
| 6 | Optimize internally before sharing with SAP |

> **Best Practice**: Always run STAR internally and review with a licensing consultant before sharing with SAP. Sharing raw STAR results directly may trigger a true-up based on unoptimized data.

### FUE Optimization Techniques

- **Role Tuning**: Remove redundant permissions that push users into higher FUE categories
- **Authorization Fine-Tuning**: Disable rarely used transactions
- **Regular Monitoring**: Continuously audit user classifications using SAP License Administration Workbench

---

## Infrastructure Sizing

### SAPS (SAP Application Performance Standard)

- SAPS is SAP's benchmark unit for **compute performance** (CPU + memory for application servers)
- 1 SAPS = 2,000 fully processed order line items per hour in the SAP SD benchmark
- Sizing based on: number of users, transaction volume, batch workload, peak load factors

### HUoM (HANA Units of Memory)

- HUoM is SAP's unit for **HANA in-memory database sizing**
- Directly tied to the data volume held in HANA memory (working set)
- SAP Readiness Check provides HUoM estimates for existing ECC → S/4HANA conversions

### T-Shirt Sizing

SAP and partners use T-shirt sizing as an initial estimate:

| Size | Typical SAPS Range | Typical Users | Typical DB |
|------|-------------------|--------------|-----------|
| XS | < 5,000 SAPS | < 100 | < 250 GB HANA |
| S | 5,000–15,000 SAPS | 100–500 | 250 GB–1 TB |
| M | 15,000–30,000 SAPS | 500–2,000 | 1–3 TB |
| L | 30,000–60,000 SAPS | 2,000–5,000 | 3–6 TB |
| XL | > 60,000 SAPS | > 5,000 | > 6 TB |

> T-shirt sizes are indicative starting points. Final sizing requires SAP Quick Sizer or official sizing engagement.

---

## Standard Option vs Tailored Option

### Standard Option

| Aspect | Detail |
|--------|--------|
| Infrastructure | Hyperscaler of customer's choice (Premium/Premium Plus) or SAP DC (Base) |
| Services | Fixed catalog per tier (Base / Premium / Premium Plus) |
| BTP bundles | Included (see `architecture-and-components.md`) |
| Customization | Standard S/4HANA + SAP-approved extensions |
| FUE licensing | Standard FUE-based model |
| Release cadence | 2-year S/4HANA release cycle |

### Tailored Option

| Aspect | Detail |
|--------|--------|
| Infrastructure | Hyperscaler of choice (any supported) |
| Services | Negotiated individually — no fixed tier |
| BTP bundles | Not included in standard tiers — negotiated separately |
| Customization | Higher customization tolerance |
| FUE licensing | Standard FUE-based model |
| Managed Firewall | Available on Azure (additional cost) |

---

## CPEA (Cloud Platform Enterprise Agreement)

Included in Premium and Premium Plus tiers:

- CPEA credits allow flexible consumption of BTP services
- Credits used across: SAP Integration Suite, SAP Build, SAP AI Core, SAP Analytics Cloud, etc.
- Pay-As-You-Go or Subscription models also available for BTP outside CPEA

---

## Contract Structure

| Document | Purpose |
|----------|---------|
| **Cloud Supplement** | Bundled cloud services per tier — defines entitlements |
| **Service Description Guide (SDG)** | Exact scope of included services per product |
| **Service Level Agreement (SLA)** | Availability, uptime, credits |
| **Data Processing Agreement (DPA)** | Data processing, sub-processors, TOMs |
| **Roles & Responsibilities (R&R)** | What SAP does vs what customer does — operational tasks |
| **General Terms & Conditions** | Legal terms |

> Always download the **latest version** of SDG and Cloud Supplement from [SAP Trust Center](https://www.sap.com/sea/about/agreements/policies/hec-services.html). SAP releases at least 2 versions per year.

---

## Lessons Learned: Licensing Best Practices

- **Classify all users before go-live** — unclassified users default to Advanced (most expensive)
- **Dialog AND System users** must be classified — technical integration users are often overlooked
- **Run STAR report internally** before any SAP audit or contract renewal discussion
- **FUE reallocation** is possible during the term — use it to optimize as usage patterns change
- **CPEA credit consumption** should be tracked monthly — avoid surprise overages

---

**Last Updated**: 2026-03-10
**Sources verified**: 2026-03-10

---

## SAP Notes Reference

> Notes extracted from SAP Community blog "The SAP S/4HANA RISE & SAP BTP - Toolbox" (ba-p/13944069). Links: `https://me.sap.com/notes/XXXXXXX`

### Maintenance Strategy and Release Lifecycle

| Note | Title | Relevance |
|------|-------|-----------|
| [3016524](https://me.sap.com/notes/3016524) | SAP S/4HANA Cloud, Private Edition — Release and Maintenance Strategy | Defines the 2-year release cadence and 7-year maintenance window for PCE |
| [3017596](https://me.sap.com/notes/3017596) | End of Mainstream Maintenance Dates for SAP S/4HANA Releases | Official EOM dates per release — essential for contract renewal and upgrade planning |
| [3061124](https://me.sap.com/notes/3061124) | SAP S/4HANA — Long-Term Maintenance and Extended Maintenance Options | Extended maintenance options and associated costs beyond standard 7-year window |
| [3493301](https://me.sap.com/notes/3493301) | SAP S/4HANA 2023 — Release Information and Availability | Release note for S/4HANA 2023 — current baseline for many RISE PCE contracts |
| [2900388](https://me.sap.com/notes/2900388) | SAP S/4HANA Maintenance Commitment Until 2040 | SAP commits to maintaining the S/4HANA product line until 2040. Not every release maintained until 2040 — customers may need to upgrade to a newer release. Individual release EOM dates in Product Availability Matrix (PAM). Details in SAP Release Brochure |
| [3641453](https://me.sap.com/notes/3641453) | SAP S/4HANA 2024 — Release Information Note | Release note for S/4HANA 2024 — latest available release for new RISE implementations |

### FUE (Flex User Equivalents) and User Classification

| Note | Title | Relevance |
|------|-------|-----------|
| [2661239](https://me.sap.com/notes/2661239) | SAP S/4HANA FUE — User Classification Guide | Master guide for classifying users under the FUE model (Advanced, Core, Self-Service, etc.) |
| [3113382](https://me.sap.com/notes/3113382) | Authorization-Based FUE Projection (SLIM_USER_CLF_HELP) | TCI note delivering report SLIM_USER_CLF_HELP — estimates FUE count from ECC authorization assignments. Supports ECC→S/4HANA/PCE transformation. Must also implement 3567321 for collective fixes. Combine with STAR service for full expert validation. For releases 7.00/7.01 use Note 3308470 instead |
| [3127972](https://me.sap.com/notes/3127972) | FUE Metering Tool — STAR Report Configuration and Execution | How to run the STAR report to extract current FUE consumption for license compliance |
| [3298541](https://me.sap.com/notes/3298541) | FUE Classification — Technical System Users and Integration Users | Guidance on classifying non-human (batch, integration, API) users in FUE model |
| [3412587](https://me.sap.com/notes/3412587) | FUE Indirect Access — Third-Party Access and Digital Access Licensing | Digital access licensing rules when third-party systems access S/4HANA data |
| [3513736](https://me.sap.com/notes/3513736) | Correct Support Component for FUE Questions in S/4HANA | FUE questions → component **XX-SER-PLUS**. USMM questions → **XX-SER-LAS**. SAP Private Cloud FUE Calculation Tool available as Excel download on SAP Support Portal |
| [3603869](https://me.sap.com/notes/3603869) | New FUE Usage Type — External User (MAIF/SSAM) | Adds External User as a third FUE type (alongside Advanced and Standard). External users in SSAM mobile app (Service & Asset Manager) are restricted to read-only — no create/update actions (work orders, measurement docs, etc.) |

### HANA Sizing and HUoM (HANA Units of Memory)

| Note | Title | Relevance |
|------|-------|-----------|
| [1872170](https://me.sap.com/notes/1872170) | SAP HANA Memory Sizing — General Guidelines | Foundation document for HANA memory planning; basis for HUoM sizing in RISE contracts |
| [2296290](https://me.sap.com/notes/2296290) | SAP HANA Sizing Report for S/4HANA | How to run the HANA sizing report on existing ECC system prior to PCE migration |
| [3245839](https://me.sap.com/notes/3245839) | HUoM — HANA Units of Memory Calculation Methodology for RISE | Explanation of how SAP converts HANA memory requirements to HUoM for RISE billing |
| [1514967](https://me.sap.com/notes/1514967) | SAP HANA Platform — Supported Hardware and OS for Certified IaaS Platforms | Hardware and IaaS certification requirements relevant to hyperscaler sizing |

### SAPS (SAP Application Performance Standard) Sizing

| Note | Title | Relevance |
|------|-------|-----------|
| [2388483](https://me.sap.com/notes/2388483) | SAPS Sizing for SAP S/4HANA — Quick Sizing Service Guide | How to use the SAP Quick Sizer tool to generate SAPS estimates for RISE PCE |
| [2408419](https://me.sap.com/notes/2408419) | SAP Application Server ABAP — CPU and Memory Sizing Rules | CPU to memory ratio rules for AS ABAP in S/4HANA sizing scenarios |
| [1656099](https://me.sap.com/notes/1656099) | SAP HANA — VM Sizing and Memory Overcommit Rules | VM memory configuration rules for HANA on cloud hyperscalers |

### RISE Contract and Service Scope

| Note | Title | Relevance |
|------|-------|-----------|
| [3089798](https://me.sap.com/notes/3089798) | RISE with SAP — ECS Service Scope and Responsibilities | Definitive reference for what SAP ECS delivers vs. customer responsibilities under RISE contract |
| [3409764](https://me.sap.com/notes/3409764) | RISE PCE — SLA Definitions and Measurement Methodology | SLA tiers, measurement windows, and exclusions (planned maintenance, customer-caused incidents) |
| [3463291](https://me.sap.com/notes/3463291) | RISE with SAP — Contract Renewal and SKU Changes | Guidance on SKU changes, contract expansions, and RISE renewal procedures |
| [3568504](https://me.sap.com/notes/3568504) | RISE PCE — Add-On and Partner Product Licensing Rules | Licensing rules for partner ISV add-ons co-deployed on RISE PCE infrastructure |

### Usage and Compliance Metering (UCM Add-On)

| Note | Title | Relevance |
|------|-------|-----------|
| [3554477](https://me.sap.com/notes/3554477) | Usage and Compliance Metering 1.0 — Release Information | SAP ABAP Add-On (UCM) pre-installed in **client 000** of all S/4HANA Cloud PCE systems. Provides granular licensing/utilization insights beyond aggregated SAP for Me data. Self-contained, no interference with BASIS or S/4HANA core. Release train: FPS 00 (beta) → FPS 01 (RTC) → FPS 02/03/04. If TMS import fails with "Does not match component version" error: workaround = add 'UCM' entry to table EXCOMP via SE16 on the target system |

### AI Unit Licensing and Consumption

| Note | Title | Relevance |
|------|-------|-----------|
| [3521398](https://me.sap.com/notes/3521398) | Business AI Card in SAP for Me | How to use the Business AI consumption card in SAP for Me. Shows: AI units available (start of month), expiring this month, expiring in next 3 months, monthly consumption graph, breakdown by product/feature, and monthly balance statements (downloadable PDF). AI units expire at end of each contract year |

### BTP CPEA (Cloud Platform Enterprise Agreement)

| Note | Title | Relevance |
|------|-------|-----------|
| [3001283](https://me.sap.com/notes/3001283) | CPEA — Cloud Platform Enterprise Agreement Overview | How CPEA credits work, consumption tracking, and top-up procedures |
| [3188761](https://me.sap.com/notes/3188761) | BTP CPEA — Service Consumption Monitoring and Alerts | How to monitor BTP service consumption against CPEA credits to avoid overages |
| [3344917](https://me.sap.com/notes/3344917) | CPEA Credits — Included Services vs. Metered Services | Clarification of which BTP services consume CPEA credits vs. included quota |

---

**SAP Notes Reference Last Updated**: 2026-03-16
