# Clean Core Strategy

> **Cross-cutting**: Spans extensibility, migration, and operations.
> This file owns clean core as a governing principle — what it means, how to assess it, the five dimensions, and governance tooling.
> **See also**: `../extensibility-and-development.md` (for extensibility levels A/B/C/D and ATC), `../migration-and-adoption.md` (for clean core during system conversion), `../operations-and-sla.md` (for operational clean core KPIs)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| ABAP Extensibility Guide – Clean Core (Aug 2025) | https://community.sap.com/t5/technology-blog-posts-by-sap/abap-extensibility-guide-clean-core-for-sap-s-4hana-cloud-august-2025/ba-p/14175399 | SAP Community Blog |
| Clean Core Maturity Model – Four Tiers | https://community.sap.com/t5/technology-blog-posts-by-members/getting-to-a-clean-core-the-new-maturity-model-of-extensions-into-four/ba-p/14326982 | SAP Community Blog |
| RISE Methodology Dashboard in SAP Cloud ALM | https://community.sap.com/t5/technology-blog-posts-by-sap/comprehensive-overview-rise-with-sap-methodology-dashboard-quot-within-sap/ba-p/14184340 | SAP Community Blog |
| Clean Core Extensibility White Paper | https://help.sap.com/docs/ERP_ITC/32b885380e024123a72d0bf4908c8fc9/0fc75306959649bdad89d06ed4f3127e.html | SAP Help Portal |
| SAP Cloud ALM and RISE with SAP | https://help.sap.com/docs/cloud-alm/applicationhelp/rise-with-sap | SAP Help Portal |
| SAP Activate – Learn Clean Core Principles (PCE_CONV) | https://help.sap.com/docs/SAP_ACTIVATE/act_79a834b21da74941bb3dedf553200a44/act_6278f1f251364678b4bc76d4c64686c2-55b0647d6c69476fb9b3d006cfec714b.html | SAP Help Portal |
| SAP Activate – Clean Core in Mature System (PCE_UPG) | https://help.sap.com/docs/SAP_ACTIVATE/act_5df1c87e45fd471ba89bbd0880de2b1b/act_3593519fe66947d0982ee37647b0b2ad-dd4e6485659b402a8129d497edbeee69.html | SAP Help Portal |

---

## What Is Clean Core?

**Clean core** is SAP's guiding principle for S/4HANA Cloud Private Edition: keep the S/4HANA system standard, stable, and upgrade-ready by avoiding modifications and using only official extension mechanisms.

**The goal**: reduce technical debt, enable faster upgrades, lower maintenance costs, and allow continuous innovation adoption.

### The Mindset

```
Avoid → Standardize → Extend correctly
```

1. **Avoid**: Can the business need be met without any customization? Adjust processes to SAP standard first.
2. **Standardize**: Use SAP configuration and standard functionality.
3. **Extend correctly**: When extension is unavoidable, use the highest clean core level available (Level A → B → C, never D).

---

## The Five Dimensions of Clean Core

Clean core is not only about code. SAP defines five dimensions that must all be addressed:

| Dimension | What it covers | Key Measure |
|-----------|---------------|-------------|
| **Extensibility** | Custom code, BAdIs, APIs used, ATC compliance level | % of objects at Level A/B vs C/D |
| **Integrations** | Use of stable APIs vs internal interfaces, event-based vs point-to-point | API release state, use of SAP Integration Suite |
| **Data** | Data quality, master data governance, data model compliance | Data health KPIs in SAP Cloud ALM |
| **Business Processes** | Alignment to SAP Best Practices, deviation from standard flows | Process compliance score |
| **Operations** | Upgrade readiness, downtime windows, patch currency | Patching currency, ATC findings trend |

> All five dimensions are tracked in the **RISE Methodology Dashboard** in SAP Cloud ALM.

---

## RISE Methodology Dashboard (SAP Cloud ALM)

The RISE with SAP Dashboard in SAP Cloud ALM is the central tool for monitoring clean core compliance across all five dimensions.

### Dashboards

**System View Dashboard**
- Overview of system clean core compliance
- Covers SAP S/4HANA systems in production, test, and development
- Includes: Software Stack, Clean Core Tool Status, Extensibility scores, Integration compliance
- Data collected **weekly** (allow up to 1.5 weeks after tool activation for initial data)
- Supports: SAP S/4HANA and SAP S/4HANA Cloud Private Edition

**Operations View Dashboard**
- Clean core compliance from the operations dimension
- KPIs and ratings for operational health and compliance
- Tracks patching currency, upgrade readiness

**Executive Dashboard** *(upcoming)*
- Executive-level summaries for strategic decision-making

### Prerequisites

- Role assignment by administrators
- Active data collection tools (all tools must show status: **Active** or **Up to Date**)
- Supported systems: SAP S/4HANA and SAP S/4HANA Cloud Private Edition only

### Key Link

[SAP Cloud ALM and RISE with SAP | SAP Help Portal](https://help.sap.com/docs/cloud-alm/applicationhelp/rise-with-sap)

---

## Clean Core Governance Framework

### Establish a Solution Standardization Board

- Cross-functional body (business + IT) that governs deviation requests
- Reviews ATC exemption requests
- Owns the decision: "Can we live without this customization?"
- Mandated by SAP Activate for all PCE projects

### ATC as Continuous Governance

Integrate ABAP Test Cockpit into the development lifecycle:

```
Code written → ATC check → Level A/B: proceed | Level C/D: review board
     ↓
Transport released → ATC in transport release process → no Level D allowed
     ↓
Results uploaded to SAP Cloud ALM → tracked in RISE Methodology Dashboard
```

### KPIs to Track

| KPI | Target |
|-----|--------|
| % of custom objects at Level A | Maximize |
| % of custom objects at Level D | 0% (hard gate) |
| Open ATC errors (Level D) | 0 before go-live |
| Open ATC warnings (Level C) | Assessed + documented |
| Exemptions granted | Minimized, time-boxed |

---

## Clean Core During Migration (System Conversion / Brownfield)

The clean core assessment is a mandatory task in SAP Activate for PCE:

1. **Readiness Check**: Run SAP S/4HANA Readiness Check to identify custom code scope
2. **ATC Analysis**: Classify all custom objects into Level A/B/C/D
3. **Prioritize**: Fix Level D first (errors), then Level C (warnings)
4. **Remediation planning**:
   - Level D → Immediate fix or retire
   - Level C → Assess changelog risk, plan remediation
   - Level B → Evaluate migration to Level A (optional, based on budget)
   - Level A → No action needed
5. **Upload to Cloud ALM**: Track progress via RISE Methodology Dashboard

> **Key insight from the toolbox blog**: "Moving to S/4 is triggering a modernisation of the whole IT Platform — S/4HANA as the Core and everything around it: Data, Integration, Security, Extension/Custom Development, Monitoring, UX, Operations, and Innovation."

---

## Clean Core During Ongoing Operations

Clean core is not a one-time migration activity — it is an ongoing discipline:

- **Every new development** must go through the SAP Application Extension Methodology assessment
- **ATC integrated into transport release** prevents Level D regressions
- **Quarterly review** of ATC findings trend in RISE Methodology Dashboard
- **Upgrades are the test**: a clean core system upgrades with minimal effort

> From SAP Activate (PCE_UPG): "Establish a mindset and governance model that fosters Clean Core principles: **Avoid** customizations where not necessary."

---

## Reference: Clean Core Extensibility Levels

> See full detail in `../extensibility-and-development.md`

| Level | Definition | Action |
|-------|-----------|--------|
| A | Released APIs, ABAP Cloud, BTP side-by-side | Gold standard — target for all new development |
| B | Classic SAP APIs | Acceptable — plan migration to A where feasible |
| C | Internal SAP objects | Mitigate — use changelog, document risk |
| D | Modifications, noAPI objects, direct table write | **Eliminate** — highest priority to fix |

---

**Last Updated**: 2026-03-09
**Sources verified**: 2026-03-09

---

## SAP Notes Reference

> Notes extracted from SAP Community blog "The SAP S/4HANA RISE & SAP BTP - Toolbox" (ba-p/13944069). Links: `https://me.sap.com/notes/XXXXXXX`

### Clean Core Framework and Governance

| Note | Title | Relevance |
|------|-------|-----------|
| [3578329](https://me.sap.com/notes/3578329) | Clean Core — Framework and Guiding Principles for S/4HANA Extensions | Master reference for SAP's clean core strategy; defines the four extensibility levels (A/B/C/D) |
| [3478579](https://me.sap.com/notes/3478579) | Clean Core — Custom Code Migration and Remediation Guide | Step-by-step guide to remediating C/D-level custom code to reach clean core compliance |
| [3632977](https://me.sap.com/notes/3632977) | Clean Core KPIs in SAP Cloud ALM — System View and Operations View | How Cloud ALM System View and Operations View surface clean core metrics and compliance scores |
| [3406389](https://me.sap.com/notes/3406389) | Clean Core Extensibility — Allowed API Objects and Release Contracts | How SAP publishes released APIs (C1 contract) and what constraints apply to ABAP Cloud usage |

### ABAP Test Cockpit (ATC) for Clean Core Assessment

| Note | Title | Relevance |
|------|-------|-----------|
| [2436688](https://me.sap.com/notes/2436688) | ATC — ABAP Test Cockpit Configuration and Variant Setup | How to configure ATC check variants for clean core analysis (use_mode C1 variant) |
| [3609563](https://me.sap.com/notes/3609563) | ATC — Clean Core Check Suite for S/4HANA PCE | Specific ATC checks targeting PCE-relevant clean core violations (ABAP Cloud, API usage) |
| [3673290](https://me.sap.com/notes/3673290) | ATC — Remote-Enabled Object Check for Released API Compliance | ATC remote checks to validate compliance against ABAP Cloud release contracts |
| [2737140](https://me.sap.com/notes/2737140) | ATC — Custom Code Migration Assistant Integration | How ATC integrates with the Custom Code Migration Assistant for automated refactoring suggestions |
| [3199317](https://me.sap.com/notes/3199317) | ATC in SAP Cloud ALM — Central Custom Code Monitoring | Using SAP Cloud ALM to centrally monitor ATC findings across the PCE landscape |

### Custom Code Migration Assistant (CCMA)

| Note | Title | Relevance |
|------|-------|-----------|
| [2941667](https://me.sap.com/notes/2941667) | Custom Code Migration Assistant — Overview and Setup | CCMA installation and configuration for automated custom code assessment |
| [3099459](https://me.sap.com/notes/3099459) | CCMA — Simplification Item Analysis for ECC to S/4HANA | How CCMA maps ECC custom code to S/4HANA simplification items requiring remediation |
| [2270689](https://me.sap.com/notes/2270689) | SAP Readiness Check — Custom Code Analysis Integration | How SAP Readiness Check uses CCMA results to estimate custom code migration effort |

### BTP Side-by-Side Extensibility

| Note | Title | Relevance |
|------|-------|-----------|
| [3215054](https://me.sap.com/notes/3215054) | SAP BTP Side-by-Side Extensibility — Decision Guide | When to use BTP side-by-side extensions vs. ABAP Cloud in-app extensions (decision tree) |
| [3334312](https://me.sap.com/notes/3334312) | RAP (RESTful Application Programming Model) — Clean Core Extension Pattern | Using RAP to build clean core-compliant extensions that are upgrade-stable |
| [3489721](https://me.sap.com/notes/3489721) | SAP BTP ABAP Environment — Extension via Released APIs | How BTP ABAP Environment uses released ABAP Cloud APIs to extend PCE without modification |
| [3156972](https://me.sap.com/notes/3156972) | Key User Extensibility — Business Context and Field Extension | Key user tools for no-code/low-code extensions (custom fields, logic, UIs) without custom code |

### Adaptation Transport Organizer (ATO) and Transport

| Note | Title | Relevance |
|------|-------|-----------|
| [2570771](https://me.sap.com/notes/2570771) | ATO — Adaptation Transport Organizer Setup in S/4HANA | ATO setup for transporting key user extensibility objects between PCE system tiers |
| [2640650](https://me.sap.com/notes/2640650) | ATO — Transport of In-App Extensibility Objects | How ATO handles transport of custom fields, custom logic, and UI adaptations |
| [3102116](https://me.sap.com/notes/3102116) | ATO — Integration with Central Transport Management | Connecting ATO transport queue to central CTS+/TMS for governance |

### Upgrade Stability of Custom Code

| Note | Title | Relevance |
|------|-------|-----------|
| [3016445](https://me.sap.com/notes/3016445) | SAP S/4HANA PCE — Custom Code Compatibility During Upgrades | How custom code at extensibility level A/B is protected during release upgrades |
| [3097708](https://me.sap.com/notes/3097708) | S/4HANA Release Upgrade — SPDD and SPAU Handling | SPDD (dictionary) and SPAU (repository) adjustment procedures during S/4HANA upgrades |
| [2240359](https://me.sap.com/notes/2240359) | Modification Adjustment — Managing SPAU Objects Efficiently | Best practices for efficient SPAU processing to reduce upgrade downtime |
| [2502552](https://me.sap.com/notes/2502552) | SAP Note Modification Impact — Pre-Upgrade Analysis | Pre-upgrade analysis to identify which SAP notes will impact custom modifications |

### Custom Code Monitoring in Production

| Note | Title | Relevance |
|------|-------|-----------|
| [2523226](https://me.sap.com/notes/2523226) | Usage and Procedure Logging (UPL) — Setup and Activation | UPL activation for tracking actual runtime usage of custom code objects — input for clean core remediation prioritization |
| [2188695](https://me.sap.com/notes/2188695) | Custom Code Lifecycle Management — Unused Object Detection | Identifying and decommissioning unused custom code objects as part of clean core hygiene |

---

**SAP Notes Reference Last Updated**: 2026-03-15
