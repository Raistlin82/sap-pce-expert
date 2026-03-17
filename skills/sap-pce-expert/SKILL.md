---
name: sap-pce-expert
description: |
  Comprehensive knowledge of SAP Private Cloud ERP (RISE with SAP) for architects, basis consultants, developers, and project managers. Use when working with RISE with SAP implementations, S/4HANA Cloud Private Edition (including 2025 FPS01 release with Agentic AI), PCE migrations (brownfield/greenfield/bluefield/selective data transition), SAP-managed infrastructure on hyperscalers (AWS, Azure, GCP, Alibaba), clean core strategy, ABAP Cloud extensibility, SAP Integration Suite, SAP Signavio, SAP Business Network, or RISE licensing and contracts.

  Keywords: RISE with SAP, SAP Private Cloud ERP, S/4HANA Cloud Private Edition, PCE, 2025 FPS01, Agentic AI, Joule, brownfield, greenfield, bluefield, selective data transition, SUM, DMLT, HUoM, SAPS, SAP-managed operations, clean core, ABAP Cloud, key user extensibility, developer extensibility, BTP extensions, SAP Signavio, SAP Business Network, hyperscaler, AWS, Azure, GCP, Alibaba Cloud, SAP Integration Suite, RISE contract, SLA, patching cadence, backup restore, ISO 27001, SOC 2, GDPR, Foundational Success Plan
license: GPL-3.0
metadata:
  version: "1.4.0"
  last_verified: "2026-03-17"
---

# SAP Private Cloud ERP Expert (RISE with SAP)

## Related Skills

- **sap-btp-best-practices**: Use for SAP BTP platform architecture, account hierarchy, CI/CD, and governance
- **sap-btp-developer-guide**: Use for CAP application development on BTP
- **sap-abap**: Use for ABAP development syntax, internal tables, and ABAP-specific patterns
- **sap-btp-integration-suite**: Use for SAP Integration Suite iFlow design and configuration
- **sap-btp-cloud-platform**: Use for BTP runtime environments and CLI commands

---

## Content Routing Guide

When source documentation spans multiple topics, route content using this table:

| Topic | Primary File | Cross-Cutting File |
|-------|-------------|-------------------|
| RISE bundle components, S/4HANA overview | `architecture-and-components.md` | — |
| Hyperscalers, data centers, network topology | `infrastructure-and-deployment.md` | `cross-cutting/hyperscaler-contracts.md` |
| Migration approaches, tools, timelines | `migration-and-adoption.md` | `cross-cutting/clean-core-strategy.md` |
| SAP-managed ops, patching, backup, SLAs | `operations-and-sla.md` | — |
| Certifications, compliance, shared responsibility | `security-and-compliance.md` | `cross-cutting/identity-and-access.md` |
| ABAP Cloud, BTP extensions, extensibility | `extensibility-and-development.md` | `cross-cutting/clean-core-strategy.md` |
| Integration Suite, APIs, hybrid patterns | `integration.md` | — |
| Licensing model, HUoM, SAPS, contracts | `licensing-and-sizing.md` | `cross-cutting/hyperscaler-contracts.md` |
| Clean core (spans migration + extensibility + ops) | — | `cross-cutting/clean-core-strategy.md` |
| IAM (spans security + BTP + ops) | — | `cross-cutting/identity-and-access.md` |
| Hyperscaler agreements (spans licensing + infra + security) | — | `cross-cutting/hyperscaler-contracts.md` |

---

## Overview

RISE with SAP is SAP's bundled offering that combines S/4HANA Cloud Private Edition with SAP Business Technology Platform, SAP Signavio, SAP Business Network, and SAP-managed infrastructure on a hyperscaler of choice.

**Quick Links**:
- **SAP Help Portal**: [https://help.sap.com/docs/rise-with-sap](https://help.sap.com/docs/rise-with-sap)
- **SAP RISE Overview**: [https://www.sap.com/products/erp/rise.html](https://www.sap.com/products/erp/rise.html)

---

## Table of Contents

1. [Architecture and Components](#architecture-and-components)
2. [Infrastructure and Deployment](#infrastructure-and-deployment)
3. [Migration and Adoption](#migration-and-adoption)
4. [Operations and SLA](#operations-and-sla)
5. [Security and Compliance](#security-and-compliance)
6. [Extensibility and Development](#extensibility-and-development)
7. [Integration](#integration)
8. [Licensing and Sizing](#licensing-and-sizing)

---

## Architecture and Components

See `references/architecture-and-components.md` for complete detail.

> RISE with SAP bundles: S/4HANA Cloud Private Edition + SAP BTP + SAP Signavio + SAP Business Network + SAP-managed infrastructure.

---

## Infrastructure and Deployment

See `references/infrastructure-and-deployment.md` for complete detail.

> Hyperscaler options: AWS, Microsoft Azure, Google Cloud, Alibaba Cloud. SAP manages the infrastructure; customers choose the hyperscaler and region.

---

## Migration and Adoption

See `references/migration-and-adoption.md` and `references/cross-cutting/clean-core-strategy.md`.

> Four adoption paths: Greenfield (new implementation), Brownfield (system conversion), Bluefield (selective), Selective Data Transition.

---

## Operations and SLA

See `references/operations-and-sla.md` for complete detail.

> SAP manages: infrastructure, OS, HANA DB, S/4HANA patching. Customer manages: business configuration, extensions, integrations.

---

## Security and Compliance

See `references/security-and-compliance.md` and `references/cross-cutting/identity-and-access.md`.

> Certifications include ISO 27001, SOC 1/2, GDPR. Shared responsibility model clearly defines SAP vs. customer scope.

---

## Extensibility and Development

See `references/extensibility-and-development.md` and `references/cross-cutting/clean-core-strategy.md`.

> Clean core principle: keep S/4HANA standard, extend via ABAP Cloud (in-app) or SAP BTP (side-by-side).

---

## Integration

See `references/integration.md` for complete detail.

> Integration hub: SAP Integration Suite on BTP. Supports cloud-to-cloud, cloud-to-on-premise, and hybrid scenarios.

---

## Licensing and Sizing

See `references/licensing-and-sizing.md` and `references/cross-cutting/hyperscaler-contracts.md`.

> RISE is subscription-based. Sizing uses HUoM (HANA Units of Memory) and SAPS (SAP Application Performance Standard).

---

## Bundled References

| File | Content |
|------|---------|
| `references/architecture-and-components.md` | RISE bundle overview, component details |
| `references/infrastructure-and-deployment.md` | Hyperscalers, network, regions, SAP-managed infra |
| `references/migration-and-adoption.md` | Migration paths, tools (SUM, DMLT), timelines |
| `references/operations-and-sla.md` | Managed ops model, patching, backup, SLAs, support |
| `references/security-and-compliance.md` | Certifications, shared responsibility, security controls |
| `references/extensibility-and-development.md` | ABAP Cloud, BTP extensions, clean core guidance |
| `references/integration.md` | SAP Integration Suite, APIs, hybrid patterns |
| `references/licensing-and-sizing.md` | Licensing model, HUoM, SAPS, contract structure |
| `references/cross-cutting/clean-core-strategy.md` | Clean core spanning migration + extensibility + ops |
| `references/cross-cutting/identity-and-access.md` | IAM spanning security + BTP + operations |
| `references/cross-cutting/hyperscaler-contracts.md` | Hyperscaler agreements spanning licensing + infra + security |

---

**Last Updated**: 2026-03-09
**Next Review**: 2026-06-09 (quarterly)
