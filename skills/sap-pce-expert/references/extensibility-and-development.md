# Extensibility and Development

> **Ownership**: ABAP Cloud (in-app extensibility), BTP side-by-side extensions, key user extensibility (Fiori adaptation, custom fields/logic), developer extensibility (RAP, Business Add-Ins), released APIs catalog approach, ATC governance.
> **See also**: `cross-cutting/clean-core-strategy.md` (for the governing principle and five dimensions), `integration.md` (for connecting extensions to external systems), `migration-and-adoption.md` (for custom code remediation during migration)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| SAP Application Extension Methodology | https://help.sap.com/docs/sap-btp-guidance-framework/sap-application-extension-methodology/sap-application-extension-methodology-overview | SAP Help Portal |
| Extension Architecture Guide | https://help.sap.com/docs/sap-btp-guidance-framework/extension-architecture-guide/what-is-extension-architecture-guide | SAP Help Portal |
| ABAP Extensibility Guide – Clean Core (Aug 2025) | https://community.sap.com/t5/technology-blog-posts-by-sap/abap-extensibility-guide-clean-core-for-sap-s-4hana-cloud-august-2025/ba-p/14175399 | SAP Community Blog |
| Clean Core Maturity Model – Four Tiers | https://community.sap.com/t5/technology-blog-posts-by-members/getting-to-a-clean-core-the-new-maturity-model-of-extensions-into-four/ba-p/14326982 | SAP Community Blog |
| SAP Application Extension Methodology PDF | https://help.sap.com/doc/87e18fdb75fd42f8aee59e3c76de7cd7/Cloud/en-US/sap.application.extension.methodology.pdf | PDF |
| Clean Core Extensibility White Paper | https://help.sap.com/docs/ERP_ITC/32b885380e024123a72d0bf4908c8fc9/0fc75306959649bdad89d06ed4f3127e.html | SAP Help Portal |
| SAP Note 3578329 – Frameworks & Technologies in Clean Core | https://me.sap.com/notes/3578329 | SAP Note |

---

## Clean Core Extensibility Levels (A/B/C/D)

The clean core approach for extensibility categorizes extensions into **four levels** based on architectural integrity, upgrade safety, and alignment with clean core principles.

| Level | Name | Description | Risk |
|-------|------|-------------|------|
| **A** | Cloud development + released APIs | Fully compliant. Uses only publicly released, stable APIs with formal stability contracts. Achieved via BTP side-by-side extensions, Key User Extensions, or ABAP Cloud development. | None |
| **B** | Classic APIs | Classic SAP APIs and technologies. Well-defined, documented, and generally upgrade-stable. Acceptable but not gold standard. | Low |
| **C** | Internal SAP objects | Conditionally compliant. Relies on SAP internal objects. SAP provides a changelog to identify incompatible changes early. | Medium |
| **D** | Not recommended | Objects marked as "noAPI", modifications to SAP objects, direct write access to SAP tables, implicit enhancements. Highest risk and technical debt. | **High — fix first** |

**Gold standard**: Level A — extensions built in SAP BTP and ABAP Cloud.

**Important**: Extensibility options are not exclusive. A custom solution can combine both on-stack (ABAP Cloud) and side-by-side (BTP) extensibility.

---

## Extensibility Options Overview

### Tier 1 — Key User Extensibility (no-code/low-code, in-app)

Available to business power users via SAP Fiori apps. No ABAP development required.

| Tool | Capability |
|------|------------|
| Custom Fields and Logic | Add custom fields to standard objects, add logic via BAdI |
| Adaptation Transport Organizer | Transport UI adaptations across landscapes |
| Custom Business Objects | Create lightweight standalone objects |
| Business Rules | Define decision logic without code |
| Workflow | Create simple workflows via SAP Build Process Automation |

> These are Level A by definition — they use released extension points.

### Tier 2 — Developer Extensibility (ABAP Cloud, in-app)

Available to ABAP developers. Uses the **ABAP Cloud development model** — a restricted ABAP language version that only allows consumption of released APIs.

**Available from**: SAP S/4HANA 2022 (on-premise and PCE), SAP BTP ABAP Environment.

Key patterns:
- **RAP (RESTful ABAP Programming Model)** — build transactional apps and extensions
- **Business Add-Ins (BAdIs)** via released extension points
- **OData services** via released CDS views

```
ABAP Cloud restrictions:
- Only released APIs (C1 release contract) allowed
- No direct database access to SAP tables
- No classic ABAP statements that bypass APIs
- Enforced by ABAP language version check in ATC
```

### Tier 3 — Side-by-Side Extensions (SAP BTP)

Build extensions as separate applications on SAP BTP, consuming S/4HANA APIs.

| Pattern | Use Case |
|---------|----------|
| SAP BTP, Cloud Foundry | Multi-language apps (CAP, Java, Node.js) |
| SAP BTP, Kyma | Kubernetes-based, event-driven |
| SAP BTP, ABAP Environment | ABAP-based extensions in the cloud |
| SAP Build Apps | Low-code app building |
| SAP Build Process Automation | Workflow + RPA |

**Connection to S/4HANA**: via SAP Integration Suite (APIs) or event-based (SAP Event Mesh).

---

## SAP Application Extension Methodology

A structured three-phase approach for evaluating and designing extensions.

### Phase 1: Assess Extension Need

- Can the business need be met with SAP standard? → Adjust process first.
- Can it be met with configuration? → Use configuration.
- Only if neither works → proceed to extension.

### Phase 2: Assess Extension Technology

Use the **Extension Technology Mapping** to select the right technology:

1. Is the use case achievable with Key User Extensibility? → **Use it (Level A)**
2. Can it be done with ABAP Cloud on-stack? → **Use it (Level A)**
3. Does it need a standalone app or cross-system logic? → **Side-by-side on BTP (Level A)**
4. Classic API available? → **Level B (acceptable)**
5. Only internal objects available? → **Level C (mitigate risk)**
6. None of the above → **Level D (avoid)**

### Phase 3: Design and Govern

- Define the target solution architecture
- Establish ATC governance (see below)
- Plan transport and lifecycle management

---

## ATC Governance for Clean Core

**ABAP Test Cockpit (ATC)** is SAP's recommended tool for governing ABAP developments for clean core in S/4HANA PCE.

### Setup

1. Use **Central ATC in SAP BTP ABAP Environment** (recommended for PCE and on-premise)
2. Create a copy of the default ATC variant `ABAP_CLOUD_DEVELOPMENT_DEFAULT`
3. Enable the following checks:
   - Allowed SAP enhancement technologies
   - Usage of APIs
   - Search for customer modifications
   - Critical statements
   - Code Vulnerability Analyzer (CVA) *(additional license may apply)*

### Interpreting Results

| Severity | Clean Core Level | Action |
|----------|-----------------|--------|
| **Error** | Level D | Fix immediately — highest priority |
| **Warning** | Level C | Assess using SAP changelog — fix as second priority |
| **Info** | Level B | Classic APIs — stable but aim for Level A |
| **No findings** | Level A | Clean core compliant |

### Integrate into Transport Process

```
Best practice:
- Integrate ATC checks into the transport release process
- Establish a structured exemption process for necessary deviations
- Upload ATC results to SAP Cloud ALM (RISE Methodology Dashboard)
- Foster culture of transparency by sharing exemption results
```

### SAP Note 3578329

Describes the classification of frameworks, technologies, and development patterns regarding clean core extensibility. **Must-read** for any PCE extensibility project.

---

## Custom Code Remediation Procedure

### For Existing Code (System Conversion / SDT)

1. **Set up ATC central check system**
   - Review Custom Code Migration Guide for SAP S/4HANA 2025 (section 2)
   - Implement SAP Note 3627152 prerequisites

2. **Run ATC with clean core variant**
   - Filter results by Error (Level D) → fix first
   - Filter by Warning (Level C) → use changelog to assess risk

3. **Upload results to SAP Cloud ALM**
   - Use RISE Methodology Dashboard for tracking
   - Track extensibility KPIs over time

4. **Plan remediation**
   - Level D: Immediate action required
   - Level C: Changelog-based assessment, plan remediation
   - Level B → Level A: Optional but recommended for long-term clean core

5. **For Level B → Level A migration** (optional second run):
   Enable additional ATC checks:
   - API Release (all items)
   - ABAP Language Version Check
   - Allowed Object Types in Cloud Development
   - Usage of Released APIs (Cloudification Repository)

### For New Code

1. Check if SAP Standard can fulfill the requirement
2. Use SAP Application Extension Methodology to select technology
3. Default to Level A (ABAP Cloud or BTP side-by-side)
4. Use Level B only when Level A is not feasible for the use case
5. Set up ATC in transport release process from day 1

---

## Released APIs — How to Find Them

| Resource | What it contains |
|----------|-----------------|
| SAP Business Accelerator Hub | Published OData and REST APIs for S/4HANA |
| ABAP Development Tools (ADT) — API State | C1-released objects visible in Eclipse |
| Cloudification Repository | Maps classic APIs to released successors |
| Custom Code Migration Guide | Successor API recommendations by object type |

---

## Key Principles

> **Always strive for the highest extensibility level available.** Classic APIs (Level B) are acceptable only when the use case cannot be achieved with released APIs.

> **Keep S/4HANA standard.** Every modification or internal object usage creates upgrade debt. The goal is zero Level D findings.

> **Separate concerns.** On-stack extensions (ABAP Cloud) for S/4HANA-specific logic. Side-by-side (BTP) for standalone apps, cross-system processes, and UI.

---

**Last Updated**: 2026-03-09
**Sources verified**: 2026-03-09

---

## SAP Notes Reference

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2436688](https://me.sap.com/notes/2436688) | Recommended SAP Notes for S/4HANA Custom Code Checks in ATC | Master note for setting up ATC (ABAP Test Cockpit) to perform readiness checks and Clean Core compliance in PCE. |
| [2807979](https://me.sap.com/notes/2807979) | Setup Adaptation Transport Organizer (ATO) via S_ATO_SETUP | Mandatory setup for Key User Extensibility (In-App) to enable transport of Fiori-based extensions in PCE. |
| [2948977](https://me.sap.com/notes/2948977) | How to Register OData V4 Service in SAP Gateway System | Procedural guide for transaction /IWFND/V4_ADMIN; essential for deploying modern Fiori apps in S/4HANA PCE. |

> Key SAP Notes for Extensibility and Development. Full master list: see `sap-notes-master-list.md` in workspace root.

### Clean Core Extensibility Framework

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3578329](https://me.sap.com/notes/3578329) | Frameworks, Technologies and Development Patterns in Context of Clean Core Extensibility | **Central clean core note** — comprehensive lookup table mapping every SAP framework/technology/pattern to a clean core level. Key entries: BAdI (Kernel-based) = **Level A** (cloud-ready, upgrade stable); BAdI (classic) = **Level B** (upgrade stable, not cloud-ready → migrate to Kernel-based BAdI); FI-CA Events/FQEVENTS = **Level B** (upgrade stable, not cloud-ready → use specific BAdIs); own CDS Views = **Level A**; consuming SAP CDS Views = level depends on individual C-contract release. Some entries have conditional levels depending on usage pattern. **Must read before any PCE extensibility project.** |
| [3478579](https://me.sap.com/notes/3478579) | Business Object Repository in context of Clean Core | **BOR = legacy framework, not cloud-ready** (not available in S/4 Cloud Public or BTP ABAP Env). Preferred alternative: **RAP events** (available from S/4HANA 2022). If BOR events are required: consuming SAP-delivered BOR object events via SWE2 Event Linkages = **upgrade stable** (acceptable). Consumer function modules/classes must be ABAPLV5 (ABAP Cloud) compliant. **NOT clean core**: BOR methods/attributes, BAPIs associated with BOR objects, custom BOR objects for new events. A new version of this note is in preparation. |
| [3632977](https://me.sap.com/notes/3632977) | Clean Core Extensibility: DDIC Extensions | Clean core level per DDIC extension type: **Customizing Include** = Level B (customer system) or Level D (partner add-on — clash risk with other add-ons). **Append Structure** = Level A (via Key User Custom Fields app + released extension include OR via ABAP for Cloud Development + released extension include), Level B (manual Standard ABAP for extension include or for "promoted" tables), Level C (all other), Level D (for "must-not-be-used" tables). **Append View / Fixed Value Append / Extension Index / Append Search Help** = all Level B. No ATC check covers all these levels. Recommendation: prefer Key User or Developer Extensibility for Level A; if not feasible, use application's extension include. |
| [3406389](https://me.sap.com/notes/3406389) | Clean Core for SAP S/4HANA Utilities Cloud Private Edition | Utilities-specific clean core guide. Custom Fields available for: Installation (from OP2023 FPS1), Premise (OP2023 FPS1), Contract (OP2023 FPS2), Point of Delivery (OP2025 FPS0). RAP business events for Utilities objects (Connection Object, Premise, Installation, etc.) from OP2025 FPS0. **FI-CA Events/FQEVENTS = Level B** (upgrade stable, not cloud-ready → use specific BAdIs). Cloudification Repository for IS-U* components on GitHub (SAP Released APIs + Classic APIs views). New BAdIs replacing high-priority User-Exits being added per customer requests. |

### ABAP Test Cockpit (ATC) for Custom Code

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3609563](https://me.sap.com/notes/3609563) | ATC Configuration for Custom Code Analysis | Entry point for ATC setup in PCE. Recommends **Central ATC (one check system for multiple satellites)** — see SAP Community blog for step-by-step setup. Satellite systems connected to central check system via RFC. Findings can be exported to Excel. For PCE/on-premise: use central ATC in BTP ABAP Environment or Solution Manager 7.2. Covers object blocklist/allowlist management and relevant prerequisite notes. FAQs available in SAP Wiki. |
| [2436688](https://me.sap.com/notes/2436688) | Recommended SAP Notes for Using S/4HANA Custom Code Checks in ATC or Custom Code Migration App | Prerequisite notes for ATC custom code checks |
| [3673290](https://me.sap.com/notes/3673290) | FAQ: Remote Code Analysis in ATC | FAQ for remote code analysis — scanning code in connected systems |

### Adaptation Transport Organizer (ATO)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2807979](https://me.sap.com/notes/2807979) | How to setup Adaptation Transport Organizer for S/4HANA On Premise or Private Cloud system via S_ATO | ATO setup via transaction **S_ATO_SETUP**. **CRITICAL: never use packages starting with '$'** — deleted during upgrades (Note 2478895). Use prefix 'TEST' (e.g., TEST_YY_KEY_USER_LOCAL). **Local package** = transportable after reassignment. **Sandbox package** = local only, never transported. **CRITICAL: develop in ONE DEV system and client only** — multiple systems/clients cause ABAP dumps (Note 3367851). ATO in QAS/PRD = read-only mode only. |
| [2661114](https://me.sap.com/notes/2661114) | Transaction S_ATO_SUPPORT to support Management of Adaptation Transport Organizer (ATO) | ATO support transaction for troubleshooting |
| [2443841](https://me.sap.com/notes/2443841) | Setup ATO Read Only | ATO read-only setup for transport viewers |
| [3429556](https://me.sap.com/notes/3429556) | ATO Read Only Setup | Alternative ATO read-only configuration |
| [2638029](https://me.sap.com/notes/2638029) | ATO: How to resolve Dependencies of ATO items | Resolving ATO item dependencies during transport |
| [3496292](https://me.sap.com/notes/3496292) | ATO Consistency Check for Items | Run consistency checks on ATO items |
| [3413961](https://me.sap.com/notes/3413961) | Enable ATO for SAP Customer Activity Repository applications bundle 5.0 | ATO enablement for CARAB 5.0 |
| [3418870](https://me.sap.com/notes/3418870) | What is the purpose of Job ATO_REFRESH_READY_FOR_IMPORT_JOB? | Understanding the ATO import readiness refresh job |

### SAP Fiori and UI Extensibility

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2902673](https://me.sap.com/notes/2902673) | Rapid Activation for SAP Fiori in SAP S/4HANA - Overview | Master index note for all release-specific Rapid Activation composite notes. **Embedded deployment only**. Task lists: SAP_FIORI_FOUNDATION_S4 (FLP setup + roles), SAP_FIORI_CONTENT_ACTIVATION (SAP_BR* roles), SAP_FIORI_FCM_CONTENT_ACTIVATION (non-SAP_BR* or customer roles), SAP_FIORI_FCM_CATALOG_ACTIVATION (catalog-level). Used for new implementations and upgrades. Latest: 3686717 (2025 FPS01) |
| [3608355](https://me.sap.com/notes/3608355) | Composite Rapid Activation for SAP Fiori in SAP S/4HANA 2025 | S/4HANA 2025 setup: (1) New impl: run SAP_GW_FIORI_ERP_ONE_CLNT_SETUP (incl. SAPUI5 index calc). (2) Activate Embedded Analytics: BD54+SCC4 + Note 2289865. (3) Enterprise Search: SAP_ESH_INITIAL_SETUP_WRK_CLIENT (SAPAPPLH component). (4) SU25 Step 1 twice. (5) Run SAP_FIORI_FOUNDATION_S4 via STC01. (6) Run SAP_FIORI_CONTENT_ACTIVATION (max 100 roles per run; background mode for large sets). From S/4HANA 2023: OData V2 no longer needs ICF nodes. Known issue: SAP_BR_EXTENSIBILITY_SPEC activates deprecated APS_CDS_GKE_SRV → skip, use successor app F1866A. Client-independent and client-dependent tasks mixed — re-run after new client copies. Components UIAPFI70/UIS4HOP1 merged into UIS4H since 2025 |
| [3236624](https://me.sap.com/notes/3236624) | Composite SAP note: Rapid Activation for SAP Fiori in SAP S/4HANA 2022 | Composite note for Rapid Activation in S/4HANA 2022 |
| [3469488](https://me.sap.com/notes/3469488) | Composite SAP note: Rapid Activation for SAP Fiori in SAP S/4HANA 2023 FPS02 | Rapid Activation for S/4HANA 2023 FPS02 |
| [3524562](https://me.sap.com/notes/3524562) | Composite SAP note: Rapid Activation for SAP Fiori in SAP S/4HANA 2023 FPS03 | Rapid Activation for S/4HANA 2023 FPS03 |
| [3493254](https://me.sap.com/notes/3493254) | SAP Fiori for SAP S/4HANA 2025 — Release Information Note | Strict 1:1 dependency: SAP FIORI FES 2025 ↔ S/4HANA 2025 backend. SP stack must match. IE11 and Legacy Edge support ends. UIAPFI70 + UIS4HOP1 merged into single component **UIS4H** in 2025. Obsolete components UIHR001/UIILM001/UIMDC001/UITRV001 must be de-installed during upgrade to 2025 |
| [3574267](https://me.sap.com/notes/3574267) | SAP Fiori front-end server 2025 for SAP S/4HANA | Fiori FES 2025 — new Fiori Front-End Server version for S/4HANA 2025 |
| [2217489](https://me.sap.com/notes/2217489) | Maintenance and Update Strategy for SAP Fiori Front-End Server | FES maintenance and update strategy |
| [2590653](https://me.sap.com/notes/2590653) | SAP Fiori front-end server deployment for SAP S/4HANA | FES deployment patterns for S/4HANA. Official architecture recommendation: **embedded deployment** (FES co-deployed on S/4HANA backend system) |
| [2712785](https://me.sap.com/notes/2712785) | Fiori Setup: Updates for Task List SAP_FIORI_FOUNDATION_S4 | Cumulative changelog for SAP_FIORI_FOUNDATION_S4 task list. Key tasks: ICF activation (WebGUI/WebDynpro/NWBC), OData service activation, system alias creation (FIORI_MENU, LOCAL_TGW), FLP properties (Spaces/Pages, Notifications, Easy Access Menu), foundation role generation. Must implement latest version via SNOTE before running task list (transaction STC01) |
| [2813396](https://me.sap.com/notes/2813396) | Fiori Setup: Content Activation for Business Roles | Business role content activation for Fiori via Fiori Content Manager (FCM) — for non-SAP_BR* roles and customer namespace roles |
| [2686456](https://me.sap.com/notes/2686456) | Fiori Setup: Updates for Task List SAP_FIORI_CONTENT_ACTIVATION | Cumulative changelog for SAP_FIORI_CONTENT_ACTIVATION. Activates OData/ICF services for SAP_BR* business roles. Includes: OData V4 service group publishing (/IWFND/V4_ADMIN), automatic retry for failed OData activations, optional test user creation with role assignment, ChaRM integration (records on task not main request). Must implement latest version via SNOTE. Max 100 business roles per run — use background mode for large selections |
| [2916959](https://me.sap.com/notes/2916959) | Fiori Performance Troubleshooting | Structured troubleshooting guide for Fiori performance issues. Key recommendations: (1) Use Guided Answers decision tree. (2) Trace with ST12 + browser F12 (HAR export). (3) FLP startup: max **100 tiles**, reduce dynamic/KPI tiles, avoid invalidating UI2 cache. (4) Search: max **6-7 search connectors**. (5) Browser: enable cache, not private mode, enable HTTP compression. (6) SAPUI5: use latest patch, use Cache Buster. (7) WebGUI/WebDynpro: check kernel version + NWBC patches |
| [3168406](https://me.sap.com/notes/3168406) | Fiori Tiles Are Not Showing in Fiori Launchpad | Tiles added but not visible. Fix: (1) If group was personalized by user → reset group in Launchpad Designer. (2) Clean up cache following Note 2319491 |
| [3584217](https://me.sap.com/notes/3584217) | Fiori Launchpad Does Not Work ("An error has occurred") | FLP error after upgrade or FPS change. Root cause: stale "My Home" parameters. Fix: edit /UI2/FLP_SYS_CONF or /UI2/FLP_CUS_CONF and **remove** parameters: SPACES_CUSTOM_HOME_COMPONENT_ID, UI5_INSIGHTS, SPACES_CUSTOM_HOME |
| [2603238](https://me.sap.com/notes/2603238) | Analysis Tool for Fiori Configuration — /SDF/FIORI_ANALYSIS | Collective corrections for Fiori analysis report /SDF/FIORI_ANALYSIS (delivered with Notes 2549968/2553469). Shows app state, ICF service activation status, OData service status, namespace, SAPUI5 library usage, modification status. From SAP_GWFND 7.58: OData V2 no longer needs ICF node → column "Check if OData ICF service is active" auto-set to green |
| [2881803](https://me.sap.com/notes/2881803) | FAQ: S/4HANA Fiori Best Practices — Collective Note | Comprehensive Fiori FAQ and best practices collective note. Referenced by 2916959 for single Fiori app performance guidance |

### AI and Joule Extensions in PCE

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3523238](https://me.sap.com/notes/3523238) | Navigational and Transactional capabilities with Joule in SAP S/4HANA Cloud Private Edition | Joule capabilities in PCE — navigational and transactional features |
| [3558794](https://me.sap.com/notes/3558794) | AI Functionality in S/4HANA Cloud Private Edition | Overview of all AI features available in PCE |
| [3513374](https://me.sap.com/notes/3513374) | Generative Artificial Intelligence Software Development Kit for On-Premise release | Gen AI SDK for on-premise/PCE ABAP development |
| [3486932](https://me.sap.com/notes/3486932) | ABAP AI SDK powered by ISLM | ABAP AI SDK using ISLM (Intelligent Scenario Lifecycle Management) |
| [3490653](https://me.sap.com/notes/3490653) | ISLM support for custom Gen AI scenario | Extending ISLM for custom generative AI scenarios |
| [3248365](https://me.sap.com/notes/3248365) | Central SAP Note for SAP AI Core | Master note for SAP AI Core service |
| [3535359](https://me.sap.com/notes/3535359) | Availability of AI Functionality | Which AI features are available in which release/landscape |
| [3437766](https://me.sap.com/notes/3437766) | Availability of Generative AI Models | Available GenAI models via SAP AI Core GenAI Hub |
| [3459573](https://me.sap.com/notes/3459573) | AI-assisted sales order fulfillment monitoring in S/4HANA Cloud Private Edition | AI use case: sales order monitoring |
| [3570467](https://me.sap.com/notes/3570467) | AI-assisted goods receipt analysis in S/4HANA Cloud Private Edition | AI use case: goods receipt |
| [3573144](https://me.sap.com/notes/3573144) | AI-assisted Journal Upload in SAP S/4HANA Cloud Private Edition | AI use case: journal entry upload |
| [3573659](https://me.sap.com/notes/3573659) | AI-assisted change request in Master Data Governance, Central Governance for S/4HANA Cloud Private Edition | AI use case: MDG change requests |
| [3577116](https://me.sap.com/notes/3577116) | AI-assisted behavioral insights for contract accounting in S/4HANA Cloud Private Edition | AI use case: contract accounting |
| [3543683](https://me.sap.com/notes/3543683) | Documentation correction AI features in S/4HANA Cloud Private Edition 2023 FPS2 | AI features documentation correction note |
| [3645849](https://me.sap.com/notes/3645849) | S/4HANA CoPilot Skills 2025 | Joule/CoPilot skill catalog for S/4HANA 2025 |

### ABAP Add-On Management

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2011192](https://me.sap.com/notes/2011192) | Uninstalling ABAP add-ons | How to uninstall ABAP add-ons — important for PCE clean-up |
| [2431817](https://me.sap.com/notes/2431817) | Component SAP_APPL is already retrofitted into component version S4CORE rel.100 | Component version conflict resolution during PCE migration |
| [3602552](https://me.sap.com/notes/3602552) | Preparation of ABAP Add-On for PCE - Usage and Compliance Metering | Preparing ABAP add-ons for metering in PCE environment |

### Extensibility Transport Process

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2660797](https://me.sap.com/notes/2660797) | Transport Extensibility Objects SAP S/4HANA | Full transport workflow for key user extensibility items: (1) **S_ATO_SETUP** — set up packages and name ranges. (2) Create transportable package in SE21/SE80. (3) **Configure Software Packages app** — control TR creation mode (auto or manual via SE09). (4) Assign TR. (5) **Register Extensions for Transport app** — reassign extensibility items to the software package. (6) Release TR. Items created in local package (no change recording) by default. **Extensibility Inventory app** provides overview of all created extension items. |
| [3265181](https://me.sap.com/notes/3265181) | Is it required to configure ATO in QAS and PRD systems? | ATO setup (S_ATO_SETUP) in QAS/PRD is **optional** — transported extensibility items work without it. **S_ATO_SETUP settings cannot be transported** — must be configured per system individually. If ATO is configured in QAS/PRD, it **must be read-only mode only** (allows Key User Fiori review apps + Extensibility Inventory). Warning: some extensibility Fiori apps don't support ATO read-only in certain releases (see Notes 3475209, 2919095). |

### ABAP Runtime — Program Regeneration

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2296826](https://me.sap.com/notes/2296826) | [Best Practice] How to solve dump LOAD_PROGRAM_CLASS_MISMATCH | **LOAD_PROGRAM_CLASS_MISMATCH** = interface version mismatch between loaded programs after transport or activation. Fix options: (1) Re-activate specific programs in SE38. (2) TOUCHSRC for dependent programs of a specific class/interface. (3) **SGEN** for all programs (recommended). Emergency (system down): empty table REPOLOAD from DB + restart SAP. Post-fix: **restart all AS** (or use ok-code `/$PXA` to reset ABAP program buffer). Prevention: apply Notes 1838560/2503187/2549669 (kernel); minimize transports/activations during peak hours; use BTCTRNS1 to reschedule background jobs before imports. |

---

### Fiori & UI Configuration

> Core task lists and setup notes for SAP Fiori activation in S/4HANA PCE. Task lists executed via transaction STC01.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2712785](https://me.sap.com/notes/2712785) | Fiori Setup: Initial Setup for Fiori Applications S/4 (SAP_FIORI_FOUNDATION_S4) | Changelog and updates for task list SAP_FIORI_FOUNDATION_S4. Covers: system alias setup, ICF service activation for WEBGUI/NWBC/WCF, FLP configuration (Easy Access Menu, Notifications, Spaces & Pages, App Support), foundation OData/V4 service publication, Fiori Foundation role generation. Apply with SNOTE before running rapid activation. |
| [2902673](https://me.sap.com/notes/2902673) | Rapid Activation for SAP Fiori in SAP S/4HANA — Overview | Master index of release-specific rapid activation composite notes (1709 through 2025 FPS01). Entry point for finding the correct composite note for your S/4HANA release. Covers embedded deployment requirement — standalone hub requires separate setup. |
| [2686456](https://me.sap.com/notes/2686456) | Fiori Setup: Content Activation for SAP Business Roles (SAP_FIORI_CONTENT_ACTIVATION) | Changelog and updates for task list SAP_FIORI_CONTENT_ACTIVATION. Automates OData/ICF service determination and activation for selected SAP Business Roles (SAP_BR* scheme). Includes V4 service group publication, role assignment to users, recording support for ChaRM. Apply with SNOTE. |
| [2881803](https://me.sap.com/notes/2881803) | Single Fiori App Performance Troubleshooting | Collective KBA for diagnosing individual Fiori app performance. Covers SAPUI5 app types (Fiori elements, OVP, Smart Business, Design Studio), trace tools (ST12, HANA Performance Trace, HAR file), and app-specific performance restrictions by S/4HANA release. |
| [2603238](https://me.sap.com/notes/2603238) | Analysis Tool For FIORI Configuration: Various Errors | Bug fixes and enhancements for report `/SDF/FIORI_ANALYSIS` (SAP Fiori Configuration Analysis Tool). Use to identify activated but unused ICF services, OData V2/V4 activation status, app namespace, reuse components. Key for ICF cleanup in PCE systems. |
| [2916959](https://me.sap.com/notes/2916959) | Fiori Performance Troubleshooting | Comprehensive performance troubleshooting guide covering: FLP startup (tile count, UI2 cache), FLP Search (limit search connectors ≤10), single app performance, SAP GUI for HTML limitations, SAPUI5 resource (CDN, cache buster), network (latency, bandwidth). Iterative elimination process guide. |
| [2240690](https://me.sap.com/notes/2240690) | Front-end Network Bandwidth Sizing for SAP Fiori Apps and SAP S/4HANA | Network sizing guidance for Fiori in S/4HANA. Recommends 10–25 KB/user interaction step for initial sizing; 15 KB/step for mixed Fiori+WebDynpro+SAPGUI for HTML landscapes. Use ST03 on Frontend Server (Expert Mode) for expert sizing. |
| [3493254](https://me.sap.com/notes/3493254) | SAP FIORI FOR SAP S/4HANA 2025: Release Information Note | Release information note for SAP Fiori for S/4HANA 2025 (embedded deployment on SAP_UI 8.16 / SAPUI5 1.136). Lists supported FES, browser matrix, key notes, FPS dependencies. New: UIAPFI70 and UIS4HOP1 merged into UIS4H component. |
| [3574267](https://me.sap.com/notes/3574267) | SAP Fiori front-end server 2025 for SAP S/4HANA | Technical details of FES 2025 add-on product: SAP_UI 8.16 (SAPUI5 1.136, supported until 2032), deployment variants (embedded/hub on S/4HANA 2025 or S/4HANA Cloud PCE 2025 or S/4HANA Foundation 2025). UI for Basis Applications retrofitted to ABAP Platform — no longer part of FES PV. |

### AI & Joule Integration

> Notes for activating AI features in S/4HANA PCE via SAP AI Core, ISLM, ABAP AI SDK, and Joule. Requires BTP connectivity and AI Unit entitlement.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3248365](https://me.sap.com/notes/3248365) | Central SAP Note for SAP AI Core | Central reference for SAP AI Core — BTP service that provides the AI runtime for Joule and embedded AI use cases. Links to What's New documentation and Help Portal. Entry point for SAP AI Core support and feature tracking. |
| [3437766](https://me.sap.com/notes/3437766) | Availability of Generative AI Models | Reference list of generative AI models available via SAP AI Core Generative AI Hub (e.g., GPT-4, Claude, Gemini). Models are versioned and region-specific. Relevant when enabling Joule or ABAP AI SDK for PCE AI use cases. |
| [3486932](https://me.sap.com/notes/3486932) | ABAP AI SDK powered by ISLM | Introduces ABAP AI SDK integration with ISLM (Intelligent Scenario Lifecycle Management) for building GenAI use cases in S/4HANA. Enables pre-built and custom AI use cases via SAP Generative AI Hub in all S/4HANA editions and BTP ABAP Environment. |
| [3513374](https://me.sap.com/notes/3513374) | Generative AI SDK for On-Premise and Private Cloud release | TCI note delivering the ABAP AI SDK (LLM/completion API) for S/4HANA On-Premise and PCE. Prerequisite: ISLM note 3490653 must be applied first. Enables ABAP developers to call LLM models from ABAP code in PCE systems. |
| [3490653](https://me.sap.com/notes/3490653) | ISLM support for custom Gen AI scenario | ISLM downport enabling custom GenAI use case creation on earlier S/4HANA releases. Capabilities: custom/pre-built AI scenario lifecycle management, Generative AI Hub connectivity, prompt template management, auto-enablement (Turnkey) of AI use cases. Prerequisite for Note 3513374. |
| [3535359](https://me.sap.com/notes/3535359) | Availability of AI Functionality | Status note listing AI use cases with provisioning/commercialization issues: AI-assisted sales order monitoring, goods receipt, journal upload, maintenance orders, MDG, contract accounting. Consult before go-live to check AI unit billing status and provisioning readiness. |
| [3519499](https://me.sap.com/notes/3519499) | Enhanced Joule Data Center Consumption | Documents the Joule data center selection strategy: customers can now choose their Joule DC, enabling multi-DC and cross-region integration with SAP business applications. Provides DC mapping examples (AWS/Azure/GCP by region). Note data residency requirements for KSA/UAE/China. |
| [3521354](https://me.sap.com/notes/3521354) | FAQ: Business AI card does not display AI entitlements in SAP for Me | Troubleshooting guide for missing AI units in SAP for Me Business AI card. Root causes: missing S-user authorization (`Display Order Information`), AI units purchased Oct 2023–Aug 2024 not displayed (must be renewed), wrong SKU. |
| [3567445](https://me.sap.com/notes/3567445) | Unable to Access SAP Business AI-Assisted Features Due to Missing Business Catalogs | Resolution for AI-assisted feature access errors caused by missing Business Catalogs in the system. Required catalogs must be assigned via Business Roles before AI use cases can be launched from the Fiori Launchpad. |
| [3413498](https://me.sap.com/notes/3413498) | Master Data Governance Framework AI functionalities (AI-generated Summary/AI-assisted changes) | Overview of MDG AI use cases: AI-generated summary of MDG change requests and AI-assisted change creation. Covers setup prerequisites, required ISLM configuration, and authorization notes for developer access (see Note 3561334). |
| [1088717](https://me.sap.com/notes/1088717) | Active services for Web Dynpro ABAP in transaction SICF | Lists all ICF services that must be activated for Web Dynpro ABAP to function, including production vs. development-only restrictions; relevant for PCE systems where ICF service activation is a hardening step post-installation. |
| [2385767](https://me.sap.com/notes/2385767) | How to run the generation tools in common use for ABAP programs | Documents ABAP load generation tools (SGEN, TOUCHSRC, TOUCHTAB, TOUCHINC, TOUCHALL) used to regenerate program loads after structure changes or upgrades; relevant to PCE post-upgrade or post-transport steps where ABAP load inconsistencies must be resolved during system maintenance windows. |
| [2672408](https://me.sap.com/notes/2672408) | Error: "The server took too long to respond" when opening transaction or Web Dynpro apps – Fiori Launchpad | Covers troubleshooting of Fiori Launchpad app launch failures caused by incorrect SM59 HTTP/HTTPS destination configuration (wrong host, port, or SSL setting for alias-based routing); relevant to PCE Fiori Launchpad setup where back-end system aliases and SM59 destinations must be correctly configured. |
| [3571036](https://me.sap.com/notes/3571036) | Setup Guide for AI-Assisted Goods Receipt Analysis in Transportation Management | Step-by-step guide to enabling the AI-Assisted Goods Receipt Analysis feature in TM (S/4HANA on-premise/PCE), integrating the BTP Document Information Extraction service via ISLM, including ISLM connection setup, scenario activation, and TM customizing for attachment types. |
| [3574007](https://me.sap.com/notes/3574007) | AI-generated summary in Master Data Governance, Central Governance for S/4HANA Cloud Private Edition | Describes how to implement and configure the AI-generated change-request summary feature in MDG Central Governance for S/4HANA Cloud Private Edition (as of 2023 FPS02), using the USMD_AI_SUMMARY intelligent scenario via ISLM and BTP. |
| [3577311](https://me.sap.com/notes/3577311) | AI/ML based predictive labor demand planning in S/4HANA Cloud for EWM Private Edition | Setup and availability guide for the AI/ML predictive labor demand planning feature in EWM for S/4HANA Cloud Private Edition (RISE customers only), covering feature scope across 2023 FPS03 through 2025 FPS01 and BTP provisioning prerequisites. |

---

**Last Updated**: 2026-03-21
**Sources verified**: 2026-03-21 (enriched with real SAP Note content via sap_note_get)
