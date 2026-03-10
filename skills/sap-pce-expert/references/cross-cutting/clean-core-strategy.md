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
