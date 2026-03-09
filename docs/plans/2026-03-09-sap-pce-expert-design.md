# sap-pce-expert Plugin Design

**Date:** 2026-03-09
**Author:** gabriele.rendina
**Status:** Approved

---

## Overview

A Claude Code plugin that gives Claude comprehensive knowledge of SAP Private Cloud ERP (RISE with SAP). Targets all personas: architects, basis/operations consultants, developers, and project managers.

## Pattern

Single comprehensive skill following the `sap-btp-best-practices` pattern from the `sap-skills` ecosystem:
- One `SKILL.md` with trigger logic, overview, and content routing guide
- `references/` directory with topic-specific markdown files
- `cross-cutting/` subfolder for content that spans multiple topics

## Plugin Structure

```
sap-pce-expert/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── sap-pce-expert/
        ├── SKILL.md
        ├── README.md
        └── references/
            ├── architecture-and-components.md
            ├── infrastructure-and-deployment.md
            ├── migration-and-adoption.md
            ├── operations-and-sla.md
            ├── security-and-compliance.md
            ├── extensibility-and-development.md
            ├── integration.md
            ├── licensing-and-sizing.md
            └── cross-cutting/
                ├── clean-core-strategy.md
                ├── identity-and-access.md
                └── hyperscaler-contracts.md
```

## Reference File Ownership

| File | Owns |
|------|------|
| `architecture-and-components.md` | RISE bundle overview, S/4HANA Cloud PE, included BTP services, SAP Signavio, SAP Business Network |
| `infrastructure-and-deployment.md` | Hyperscalers (AWS/Azure/GCP/Alibaba), SAP-managed infra, regions, data centers, network topology |
| `migration-and-adoption.md` | Greenfield/brownfield/bluefield/selective data transition, SUM/DMLT tools, timelines, Readiness Check |
| `operations-and-sla.md` | SAP-managed ops model, patching cadence, backup/restore, SLAs, monitoring, support model |
| `security-and-compliance.md` | ISO 27001/SOC 2/GDPR, shared responsibility model, penetration testing, vulnerability management |
| `extensibility-and-development.md` | ABAP Cloud, BTP extensions, key user extensibility, developer extensibility, clean core guidance |
| `integration.md` | SAP Integration Suite, hybrid integration patterns, Business Network connectivity, APIs |
| `licensing-and-sizing.md` | RISE licensing model, HUoM, SAPS, subscription vs consumption, contract structure, T-shirt sizing |
| `cross-cutting/clean-core-strategy.md` | Clean core principles spanning extensibility + migration + operations |
| `cross-cutting/identity-and-access.md` | IAM spanning security + BTP services + operational access |
| `cross-cutting/hyperscaler-contracts.md` | Hyperscaler agreements spanning licensing + infrastructure + security/compliance |

## Cross-Topic Content Routing

When source documentation spans multiple topics:
1. Place primary content in the file that **owns** the topic
2. Add `> See also: [topic](../cross-cutting/...)` cross-references in other relevant files
3. If no single file clearly owns the content, place it in the appropriate `cross-cutting/` file

## Distribution

- Public, via GitHub
- Follows `sap-skills` conventions for compatibility with the existing ecosystem
- License: GPL-3.0 (matching sap-skills family)

## SKILL.md Trigger Keywords

RISE with SAP, SAP Private Cloud ERP, S/4HANA Cloud Private Edition, PCE, hyperscaler, brownfield migration, greenfield, ABAP Cloud, clean core, HUoM, SAPS, SAP-managed operations, SAP Signavio, SAP Business Network, RISE contract, SLA, patching
