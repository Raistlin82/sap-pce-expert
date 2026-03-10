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
