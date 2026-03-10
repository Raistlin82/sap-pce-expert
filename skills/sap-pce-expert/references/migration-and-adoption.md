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

## Migration Paths to S/4HANA PCE

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
