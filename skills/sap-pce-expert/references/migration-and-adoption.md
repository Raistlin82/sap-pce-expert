# Migration and Adoption

> **Ownership**: Migration paths (greenfield, brownfield, bluefield, selective data transition), migration tools (SUM, DMLT, Readiness Check, DTV), project phases, timelines, partner roles, go-live checklist, RISE Methodology framework.
> **See also**: `cross-cutting/clean-core-strategy.md` (for clean core approach during migration), `extensibility-and-development.md` (for custom code remediation), `operations-and-sla.md` (for post-go-live operations)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| RISE with SAP Methodology: A Practical Guide | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/rise-with-sap-methodology-a-practical-guide-to-modernizing-with-confidence/ba-p/14277250 | SAP Community Blog |
| Data Transition Validation Tool | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/data-transition-validation-the-tool-to-validate-business-data-after/ba-p/13499558 | SAP Community Blog |
| SAP Activate Methodology for S/4HANA Transformation | https://go.support.sap.com/roadmapviewer/#/group/AAE80671-5087-430B-9AA7-8FBE881CF548 | SAP Activate |
| RISE with SAP Methodology overview | https://www.sap.com/products/erp/rise/methodology.html | SAP.com |
| RISE Onboarding Resource Center | https://support.sap.com/en/product/onboarding-resource-center/rise/rise-private.html | SAP Support |

---

## RISE with SAP Methodology

The **RISE with SAP Methodology** is SAP's proven, structured approach to guiding cloud transformation. It is a **mandatory starting point** for any S/4HANA PCE project.

### Three Essential Elements

| Element | Description |
|---------|-------------|
| **Standardized Framework** | Clear structure with phases, quality gates, and broad project experience base |
| **Integrated Toolchain** | Connected tools that fit together throughout the transformation journey |
| **Dedicated Expert Guidance** | Comprehensive guided service supported by SAP and SAP-qualified partners |

### Proven Results

Customers using RISE with SAP Methodology have achieved:
- Up to **30%** reduction in transformation costs
- Up to **35%** faster realization of business benefits
- Up to **70%** increase in business agility
- Up to **40%** acceleration in innovation cycles

### Methodology Blog Series (2025–2026)

SAP published a 5-part series documenting the methodology:

| Part | Title | Date |
|------|-------|------|
| 1/5 | [A Practical Guide to Modernizing with Confidence](https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/rise-with-sap-methodology-a-practical-guide-to-modernizing-with-confidence/ba-p/14277250) | Dec 3, 2025 |
| 2/5 | [Deep Dive: Inside the Framework](https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/deep-dive-inside-the-framework-of-rise-with-sap-methodology/ba-p/14284060) | Dec 10, 2025 |
| 3/5 | [The Integrated Toolchain in a Nutshell](https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/the-integrated-toolchain-in-a-nutshell/ba-p/14305651) | Jan 14, 2026 |
| 4/5 | [Expert Guidance: Your Guided Transformation Accelerator](https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/expert-guidance-your-guided-transformation-accelerator/ba-p/14308680) | Jan 28, 2026 |
| 5/5 | [The Combined Power of SAP Joule and AI](https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/the-combined-power-of-sap-joule-and-ai-for-the-rise-with-sap-methodology/ba-p/14324150) | Feb 11, 2026 |

---

| [2983860](https://me.sap.com/notes/2983860) | How to check 'Activation History'? | Use T-code /n/SMB/BBI (Implementation Assistant) to monitor detailed logs and timestamps of Best Practice activation steps in PCE. |
| [2819010](https://me.sap.com/notes/2819010) | How to check if scope item is activated in the system? | Verify solution scope via 'Manage Your Solution' or CBC to confirm which localized Best Practices are active in the S/4HANA environment. |
| [2692715](https://me.sap.com/notes/2692715) | Migration Cockpit: How to correctly fill data into XML template | Technical guide to avoid common errors (mandatory fields, data types) when using XML templates for PCE data migration. |
| [2733253](https://me.sap.com/notes/2733253) | FAQ for Migration Cockpit - Transfer Data from Staging Tables | Comprehensive reference for the staging approach in PCE, including DB support and naming conventions. |
| [2886747](https://me.sap.com/notes/2886747) | How to find Migration Cockpit logs | Accessing backend logs via SLG1 (Object DMC) to troubleshoot migration object errors. |
| [2971632](https://me.sap.com/notes/2971632) | Switch remains active after business function deactivation | Technical explanation of SFW5 behavior regarding active switches after deactivating reversible BFs. |
| [1734333](https://me.sap.com/notes/1734333) | BW Pre and Post Upgrade and Migration Tasks | Use automated task lists (STC01) for BW-specific upgrade steps in PCE. |
| [2960272](https://me.sap.com/notes/2960272) | Recommendations on DS agent migration | Best practices for moving Data Services agents to new machines during PCE transition without connectivity loss. |
| [1555208](https://me.sap.com/notes/1555208) | ICF services become inactive after upgrade | Secure-by-default behavior: use RS_ICF_SERV_MASS_PROCESSING to reactivate services post-upgrade. |
| [3405369](https://me.sap.com/notes/3405369) | Information required for CI-DS Agent migration to RISE | Mandatory info (Tenant URL, Org Name, Credentials) required for ECS delivery to migrate CI-DS agents. |
| [3544232](https://me.sap.com/notes/3544232) | HANA System Replication RISE migration | Confirms HSR feasibility for lift-and-shift to PCE; details port requirements and SSFS key sync. |
| [3637337](https://me.sap.com/notes/3637337) | HANA NSE setting migration in RISE with SAP | Guide to retaining Native Storage Extension (warm data) settings during PCE migration. |
| [2907976](https://me.sap.com/notes/2907976) | Silent Data Migration (SDMI) FAQ | Critical for release upgrades: SDMI allows data migration during system uptime, reducing the maintenance window in PCE. |
| [1803986](https://me.sap.com/notes/1803986) | Rules for SUM vs SPAM/SAINT | When to use SUM (Software Update Manager) for complex SP stacks vs SPAM for small updates in PCE. |
| [1970888](https://me.sap.com/notes/1970888) | SPDD/SPAU handling during Update | Best practices for modification adjustments during PCE technical upgrades. |
| [1641394](https://me.sap.com/notes/1641394) | SFW5: How-to activate Business Function | Procedure for activating BF in PCE; highlights irreversible activations. |

### Migration Paths to S/4HANA PCE

### Overview

| Path | Also Called | Starting Point | Description |
|------|-------------|---------------|-------------|
| **Greenfield** | New Implementation | Any ERP or no ERP | Build fresh on SAP Best Practices. Maximum process standardization. |
| **Brownfield** | System Conversion | Existing SAP ERP/ECC | Convert existing system to S/4HANA. Keeps historical data. Most common for large enterprises. |
| **Bluefield** | Selective / Mix & Match | Existing SAP ERP/ECC | Selective approach — combine new implementation with data migration. |
| **Selective Data Transition (SDT)** | Selective Data Migration | Existing SAP ERP/ECC | Move selected entities (company codes, plants) to a new S/4HANA system. High flexibility, high complexity. |

### Choosing a Path

```
Highly customized ECC system with years of data → Brownfield (system conversion)
Starting from scratch or major process redesign → Greenfield
Want to restructure + keep selective data → Bluefield or SDT
Separating business units / carve-out → SDT
```

> **SAP Activate defines separate project tracks** for each path: PCE_CONV (system conversion), PCE_SDT (selective data transition), PCE_UPG (upgrade).

---

## SAP Activate Methodology

SAP Activate is the project methodology for all S/4HANA implementations. It provides:
- Phase-by-phase guidance with quality gates
- Accelerators (templates, configuration guides, test scripts)
- Roadmap Viewer with tasks per phase

**Roadmap Viewer**: [SAP Activate for S/4HANA Transformation](https://go.support.sap.com/roadmapviewer/#/group/AAE80671-5087-430B-9AA7-8FBE881CF548)

### Phases

| Phase | Key Activities |
|-------|---------------|
| **Discover** | Business case, transformation strategy, readiness check |
| **Prepare** | Project governance, system provisioning, team setup, Phase 0 |
| **Explore** | Fit-to-standard workshops, delta design, clean core assessment |
| **Realize** | Configuration, custom development, integration build, testing |
| **Deploy** | Go-live preparation, cutover, hypercare |
| **Run** | Operations, continuous improvement, upgrades |

> **Do not skip Phase 0 (Prepare)**. Give it the time it deserves. It establishes governance, team readiness, and prevents costly delays.

---

## Migration Tools Update (2025 FPS01)

The **2025 FPS01** release (March 2026) introduced several key tools and services for migration:

| Tool | Enhancement |
|------|-------------|
| **Explore Migration Objects** | New app providing interactive graphs to visualize predecessor migration objects (mandatory/optional) before project start. |
| **Release Navigator for SAP Cloud ERP Private** | Updated February 2026 to include all 2025 FPS01 documentation, webinars, and workshops. |
| **Currency Changeover (CA-LCC)** | New guided service for conversion projects (e.g., Euro conversions). Technical execution handled by SAP with three mandatory test cycles. |

---

## Key Migration Tools

### SAP Readiness Check

**When to use**: Early in Discover/Prepare phase — before the project starts.

- Analyzes the existing SAP system landscape
- Identifies custom code volume and complexity
- Highlights simplifications and deprecated functionality
- Provides sizing recommendations

**Access**: [SAP for Me – Readiness Check](https://me.sap.com/readinesscheck/home)

Reference SAP Notes:
- 2913617 — SAP Readiness Check for SAP S/4HANA
- 3059197 — SAP Readiness Check for upgrades

### Software Update Manager (SUM) with DMO

**When to use**: Brownfield system conversion (PCE_CONV).

- Performs the technical conversion from ECC/ERP to S/4HANA
- Database Migration Option (DMO): migrates from non-HANA database to HANA in one step
- Includes downtime minimization techniques (near-zero downtime)

> Integrated Tool Chain Approach: Process Design → Solution Design → Build → Test → Implement → Enable

### Data Migration Landscape Transformation (DMLT)

**When to use**: Selective Data Transition (SDT), bluefield scenarios.

- Enables selective migration of organizational units (company codes, plants)
- Supports complex landscape restructuring
- Coordinates with SUM for technical migration

### ABAP Test Cockpit (ATC)

**When to use**: Explore phase — clean core assessment of existing custom code.

> See full ATC guidance in `extensibility-and-development.md` and `cross-cutting/clean-core-strategy.md`.

- Classifies custom code into Level A/B/C/D
- Identifies technical debt before conversion
- Results uploadable to SAP Cloud ALM RISE Methodology Dashboard

---

## Data Transition Validation (DTV) Tool

**Purpose**: Validate that business data is consistent **before and after** system conversion.

### When to Use

- During system conversion (brownfield/SDT) projects
- In test runs — not only at final go-live
- To avoid manual validation of every document

### How It Works

1. **Define a project** in the DTV tool (transaction code `DTV`)
2. **Select validation reports** from the delivered SAP report catalog
3. **Extract data before downtime** (shortly before entering the conversion downtime window)
4. **Run the conversion** (SUM/DMLT)
5. **Extract data after conversion** on the target release
6. **Compare results** — DTV highlights discrepancies

### Availability

- Available from: **SAP S/4HANA 2021** (target release) and higher
- Delivered as part of SAP BASIS software on the target system
- Available on source system via TCI SAP Notes
- Available to customers and partners (no SAP expert required, though recommended)

### Key References

- Transaction code: **`DTV`**
- SAP Note 3117879 — DTV Tool Central Note (list of available check reports)
- [Data Transition Validation – SAP Help Portal](https://help.sap.com/viewer/9d6aa238582042678952ab3b4aa5cc71/202110.000/en-US/0d8c47a6cb2440a58e804f6e0e4877d4.html)

---

## Clean Core During Migration

> See `cross-cutting/clean-core-strategy.md` for the full governance framework.

Key steps during system conversion (PCE_CONV):

1. **Run Readiness Check** → understand custom code scope
2. **ATC Analysis** → classify all custom objects (Level A/B/C/D)
3. **Prioritize remediation**:
   - Level D (Errors): Fix immediately — highest risk
   - Level C (Warnings): Assess via changelog, plan remediation
   - Level B → A: Optional, budget-permitting
4. **Establish Solution Standardization Board** → governs deviations
5. **Upload ATC results to SAP Cloud ALM** → track via RISE Methodology Dashboard
6. **Define Phase Zero activities** for clean core including remediation timeline

---

## Lessons Learned & Best Practices

From experienced RISE practitioners:

### Program Management

- **Dedicate a program team** — don't share Operations people with the transformation program part-time. A 1-month delay costs more than dedicated headcount.
- **Protect Production, Protect the Program** — these are the two non-negotiable principles.
- **Don't skip Phase 0** — give preparation the time it deserves.
- **If the program is working, don't cut costs** — the first go-live must succeed.

### Technical Go-Live vs Business Go-Live

- **Separate them** — run Technical Go-Live several months before Business Go-Live.
- Technical cutover validates system stability without business pressure.
- Business Go-Live can then focus on user adoption, not technical issues.

### Non-SAP Team Dependencies

- If the program depends on deliveries from non-SAP teams (Salesforce, ServiceNow, etc.), ensure those teams have **dedicated resource capacity** — missing this has caused full program delays.

### Data and Integration

- Data mappings and transformations must happen **outside of S/4HANA** — never inside the core.
- This upholds clean core for data and integrations.

### FUE Licensing

- **Classify all users** (Dialog and System/Technical) carefully.
- Unclassified users are measured as **Advanced** and charged accordingly.
- FUE (Full Usage Equivalents) measurement is automatic.

### Key Users

- Key Users are your **ambassadors** — train them thoroughly and give them all support they need.
- A successful go-live depends heavily on prepared Key Users.

### S/4HANA Upgrades

- Plan upgrades in a **Project Dual Line Landscape** — never upgrade in production without a dedicated landscape.
- Club releases and upgrades together where possible.
- Run **SGEN** immediately after systems are delivered and before go-lives.

---

**Last Updated**: 2026-03-09
**Sources verified**: 2026-03-09

---

## SAP Notes Reference

> Key SAP Notes for Migration and Adoption. Full master list: see `sap-notes-master-list.md` in workspace root.

### SAP Readiness Check

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2913617](https://me.sap.com/notes/2913617) | SAP Readiness Check for SAP S/4HANA | Central note for Readiness Check — lists all prerequisite notes and setup steps |
| [3059197](https://me.sap.com/notes/3059197) | SAP Readiness Check for SAP S/4HANA upgrades | Readiness Check variant for upgrade projects (PCE_UPG) |
| [3548791](https://me.sap.com/notes/3548791) | SAP PCE Readiness Check - Umbrella Note | PCE-specific readiness check umbrella note |

### Transition Paths and Engagement

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3018442](https://me.sap.com/notes/3018442) | Selective Data Transition and Selective Data Transition Engagement | SDT methodology and how to engage SAP for SDT projects |
| [3035880](https://me.sap.com/notes/3035880) | Recommendations for greenfield implementations of RISE with SAP S/4HANA Cloud, private edition following a cloud mindset | Official SAP greenfield best practices for PCE with cloud mindset principles |
| [3393071](https://me.sap.com/notes/3393071) | Technical Preparation Services for SAP S/4HANA Movement for Private Cloud | Technical preparation service scope for moving to PCE |
| [3462243](https://me.sap.com/notes/3462243) | RISE with SAP System Transition Workbench | System Transition Workbench tooling for RISE migration |
| [3591251](https://me.sap.com/notes/3591251) | Navigating Your RISE with SAP Journey – SAP ERP, Private Edition, Transition Option | ERP PCE transition option guidance |

### ECS Brownfield and Guided Transition Preparation

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3089798](https://me.sap.com/notes/3089798) | ECS Brownfield setup pro-active checks | Pro-active checklist for brownfield PCE setup — run before ECS provisioning |
| [3409764](https://me.sap.com/notes/3409764) | Guided Transition to SAP Enterprise Cloud Services Preparation (GTP) Checks – Central SAP Note | Central note for GTP checks — mandatory pre-migration checklist |
| [3425775](https://me.sap.com/notes/3425775) | FAQ for the Guided Transition to SAP Enterprise Cloud Services Preparation | FAQ for GTP process |
| [3539699](https://me.sap.com/notes/3539699) | Phase three Delivery of Guided Transition Preparation | Phase 3 GTP delivery specifics |

### Release Upgrade (PCE Landscape)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3097708](https://me.sap.com/notes/3097708) | Release upgrade for RISE with SAP S/4HANA Cloud 2-System and 3-System Landscape | How to perform release upgrades in 2- and 3-system PCE landscapes |

### SPDD/SPAU Handling During Upgrades

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1970888](https://me.sap.com/notes/1970888) | How To: SPDD/SPAU handling during the Update/Upgrade | SPDD covers: domains, data elements, tables, DDLS (basis 755+), DB views (basis 756+). **CRITICAL: Never skip SPDD** — missing DDIC adjustments cause data loss. SPAM: create separate WB requests for SPDD and SPAU; assign to SAP_ADJUST CTS project via "Assign Transport". SUM phases: SPDD in ACT_TRANS/ACT_UPG, SPAU in SPAUINFO. S/4HANA 2021+ target: SUM handles TR release. 14-day SSCR-free window applies only to SPAU. S/4HANA with NW 7.51+: no SSCR key required at all. SPAM/SUM support only ONE SPDD TR and ONE SPAU TR per run. |
| [2276187](https://me.sap.com/notes/2276187) | New version of transaction SPDD | SPDD transaction enhancements |
| [2286852](https://me.sap.com/notes/2286852) | SPAU/SPDD: Display report for reset candidates | Identify SPAU/SPDD reset candidates before upgrade |
| [2969181](https://me.sap.com/notes/2969181) | SPDD Transport Request is not released after the SUM Upgrade is finished | Post-SUM SPDD transport issue resolution |
| [3590234](https://me.sap.com/notes/3590234) | SPDD objects appear after upgrade | Handling residual SPDD objects post-upgrade |
| [3611052](https://me.sap.com/notes/3611052) | Manual Adjustment Process with Standard Structures During System Upgrade in SPDD | Manual SPDD adjustment process for standard structure modifications |

### SAP Maintenance Planner

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2921927](https://me.sap.com/notes/2921927) | Enhanced Maintenance Planner Onboarding | Onboarding to the enhanced Maintenance Planner features |
| [2973010](https://me.sap.com/notes/2973010) | Frequently asked questions for maintenance planner new innovations onboarding | FAQ for Maintenance Planner innovations |
| [2287046](https://me.sap.com/notes/2287046) | How to Generate the System Info XML and upload to Maintenance Planner | Required for system registration in Maintenance Planner |
| [2838895](https://me.sap.com/notes/2838895) | How to find the Active Business Functions in Maintenance Planner | Identify active BFs when uploading to Maintenance Planner |
| [1978965](https://me.sap.com/notes/1978965) | How to find the equivalent support package for your release | SP lookup for target release planning |

### SAP S/4HANA Migration Cockpit

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2538700](https://me.sap.com/notes/2538700) | Collective SAP Note and FAQ for SAP S/4HANA Migration Cockpit - File/Staging (Cloud/SAPSCORE) | File/Staging approach only; SAPSCORE-based S/4HANA Cloud (verify from template header: "SAPSCORE + 3 digits"; if "S4CORE" see Note 2537549). Role required: SAP_BR_CONFIG_EXPERT_DATA_MIG. Cockpit NOT for mass changes or interfaces (see Note 2684818). Object not visible? → scope item not activated. G/L Account migration NOT allowed in Cloud. Migration blocked during Blue-Green Deployment weekends. Objects without parallel job support: see Note 3294684. Key migration object notes: Material (2811788), Fixed Asset (2827574), Business Partner (2848224), G/L Balance/AP/AR (2853964), Purchase Order (3532254). Tool issues: CA-LT-MC; content issues: CA-GTF-MIG. |
| [2470789](https://me.sap.com/notes/2470789) | SAP S/4HANA Migration Cockpit (Cloud) - Sample data migration templates | Sample templates for cloud-based migration cockpit |
| [2596400](https://me.sap.com/notes/2596400) | Migration objects available in the Migration Cockpit | Complete list of supported migration objects |
| [2663579](https://me.sap.com/notes/2663579) | Migration Cockpit: Validation of data after migration | Post-migration data validation steps |
| [3066336](https://me.sap.com/notes/3066336) | Modifying Data Transfer Jobs to improve the data transfer performance of the SAP S/4HANA Migration Cockpit | Performance tuning for migration cockpit data transfer |
| [2517820](https://me.sap.com/notes/2517820) | Get latest error information / logs from SAP S/4HANA Migration Cockpit (LTMC) | Log analysis for LTMC migration cockpit |
| [3209755](https://me.sap.com/notes/3209755) | SAP S/4HANA Migration Cockpit (Direct Transfer) – System Compatibility Information | Compatibility matrix for "Transfer Data Directly from SAP System" approach (requires DMIS 2011 in source). **DMIS 2011 SP23+**: compatible with S/4HANA 2022 FPS0+ ONLY (NOT 2021/2020/1909). **DMIS 2011 SP22-**: compatible with S/4HANA 2021/2020/1909 ONLY (NOT 2022+). Incompatible combinations: contact SAP on CA-LT-PE. Source: SAP ECC migrating to S/4HANA. |
| [2973957](https://me.sap.com/notes/2973957) | SAP S/4HANA Migration Cockpit: Composite Note for Transfer Data Directly from SAP System | Direct-transfer composite note |
| [2684818](https://me.sap.com/notes/2684818) | SAP S/4HANA Migration Cockpit usage for mass processing data or as interface or deletion | Mass processing use cases for Migration Cockpit |
| [3428275](https://me.sap.com/notes/3428275) | SAP S/4HANA Migration Cockpit: Migration tasks are stuck (long runtimes) | Troubleshooting stuck migration tasks |

### SAP Best Practices Activation

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3039705](https://me.sap.com/notes/3039705) | SAP Best Practices Activation process and questionnaire for RISE with SAP S/4HANA Cloud, private edition and SAP HANA Enterprise Cloud, advanced edition | Official activation process and questionnaire for PCE Best Practices |
| [3140618](https://me.sap.com/notes/3140618) | SAP Best Practice Activation FAQ | BP activation always in CLEAN client (never in existing/configured). Latest BP content needed in DEV only — transported to QAS/PRD via TRs. Additional scope items can be added post-activation ONLY if: no FPS/release upgrade done AND existing BP config not modified. **Currency must be set BEFORE activation** (cannot change after). Recommended logon language: English. Deactivation of scope items: see Note 2906656. After a system upgrade: use NEW client for BP + Fit/Gap analysis. BP transport NOT to existing/running PRD client. **BP transport requires same release and SP level** on source and target. Demo data NOT transported (full client copy only). |
| [1301301](https://me.sap.com/notes/1301301) | Release Strategy for SAP Best Practices Package ABAP Add-ons | Release strategy for BP add-ons |
| [2870129](https://me.sap.com/notes/2870129) | Best Practice activation on already existing client | BP activation on already-configured client is NOT supported — except for 4 scope items: **1SG** (Group Reporting - Financial Consolidation, from 1809), **40Y** (Intercompany Reconciliation, from 1909), **28B** (Group Reporting - Plan Consolidation), **3LX** (Group Reporting - Matrix Consolidation). Even for these: follow specific prerequisite notes (2659672, 2815304); do NOT activate any other scope item in an existing client. Each scope item creates org structures — partial/mixed activation disrupts configuration. |
| [2936334](https://me.sap.com/notes/2936334) | Best Practice activation - move to production | **Greenfield only** (DEV/QAS/PRD start from clean client 000 copy). Before moving to QAS: first transport prerequisite notes, merged client activities, and scope item activities. QAS/PRD: set client currency manually (same as DEV). Transport sequence: workbench first, then customizing (in creation order). "Manual rework required" steps: confirm each step manually in QAS and PRD. **BP transport NOT to existing/running PRD client** (can overwrite business processes). **NOT possible between different release or SP levels.** |
| [3577937](https://me.sap.com/notes/3577937) | Concerns Regarding Activation of SAP Best Practices and Additional Licenses Requirement | License implications of Best Practices activation |
| [3631601](https://me.sap.com/notes/3631601) | Scope selection of the activation of SAP standard content (SSC) for a RISE contract entitlement | SSC scope selection for RISE contracts |

### Business Functions Activation

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1641394](https://me.sap.com/notes/1641394) | SFW5: How-to activate Business Function | Business Function activation via SFW5 |
| [2515814](https://me.sap.com/notes/2515814) | Deactivate Business Functions in SFW5 | Business Function deactivation (restricted in PCE) |
| [2517797](https://me.sap.com/notes/2517797) | How to transport Business Functions from development system to next systems | Transport of activated BFs |
| [2883695](https://me.sap.com/notes/2883695) | Required Enterprise Business Functions activation in Q and PROD system | BF activation requirements for Q and Production |
| [3192490](https://me.sap.com/notes/3192490) | How to find the activated BC Sets in the system | Check which BC Sets are active |
| [3608883](https://me.sap.com/notes/3608883) | Irreversible Activation of Business Function /SHCM/EE_BP_1 in S/4HANA and Options for Reverting | Specific BF that cannot be reversed — important warning |

### Silent Data Migration (SDMI)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2907976](https://me.sap.com/notes/2907976) | Silent Data Migration (SDMI) - FAQ | SDMI available from S/4HANA 1909 (first upgrade 1809→1909). Key transactions: SDM_MON (monitor/config), SDM_USER (technical user), SJOBREPO (job). **SDMI MUST complete before next upgrade** (blocks via Simplification Item SI22/DO_SDMI_CHECK). Jump upgrades (skipped releases): skipped-release SDMIs run in SUM downtime phases PARRUN_SILENT_DATA_MIGR. Technical SDMI user required in every client (SAP_ALL or per note 2850918). SDMI starts after BTCTRNS2 runs; job SAP_SDM_EXECUTOR_ONLINE_MIGR runs every 30 min. DTV (Data Transition Validation) must finish before SDMI starts. Per-release SDMI class reference: 3258388 (2020), 3258425 (2021), 3239704 (2022), 3382097 (2023), 3635357 (2025). |

### Release Upgrade Management (RUM) Application

> **Key tool for PCE upgrade planning**: Free application in SAP for Me that automates upgrade project planning for ECS-managed systems.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3372118](https://me.sap.com/notes/3372118) | Introduction to the Release Upgrade Management (RUM) Application | Free planning tool at me.sap.com/privcloudrum. RUM 2.0 released July 25, 2025 (supersedes 1.0 from Sept 2023). Key capabilities: define upgrade path, auto-determine OS/DB versions, recommend connected agents for upgrade, generate high-level timeline, create required Service Request list, track execution tasks with TDO statistics integration. **Planning tool only** — customer creates actual SRs manually. Requires S-user with "Display Service Requests" authorization (Note 2669783). Systems below S/4HANA 2023 FPS02 show under product "SAP S/4HANA" (not "Cloud Private Edition"). Available to all ECS customers. |

### SUM Upgrade Common Errors

> **Reference for troubleshooting SUM upgrade failures**: Collective note with practical corrections for the most frequent SUM/upgrade errors across SAP ECC and S/4HANA (On-Premise and PCE).

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3310175](https://me.sap.com/notes/3310175) | FAQ - SAP ECC, SAP S/4HANA Upgrade Best Practices / Common Errors Collective Note | Collective KBA with upgrade error corrections by component. Key error categories: (1) BC-DB-HDB-PFW: SHDB Parallelization Framework timeout (DELTA_MERGE_CONTROL=NO_CONTROL) → Note 3059463; (2) BC-UPG-NA: SPDD data loss during exchange upgrade (new DDIC objects) → Note 2535651; (3) BC-UPG-NZ-DT: NZDT Mass Transfer ID issues → Notes 3305842, 3271693; (4) BC-UPG-OCS-SPA: UNRESOLVED_CONFLICTS_FOUND in CONFLICT_CHECK → Note 2944943; (5) BC-UPG-TLS-TLA: ACT_UPG GLO_S_ASSET_KEY activation error → Note 2938948; shadow import EOF errors → Note 3018699; SHADOW_IMPORT EU_CLONE_MIG_VIEW_CREATE → Note 2742444. Guide: "Upgrading SAP S/4HANA" PDF (sap.com/documents/2020/06/94ca0995). |

---

**Last Updated**: 2026-03-16
**Sources verified**: 2026-03-16 (enriched with real SAP Note content via sap_note_get)
