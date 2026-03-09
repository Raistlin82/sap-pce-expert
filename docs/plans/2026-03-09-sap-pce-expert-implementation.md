# sap-pce-expert Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a Claude Code plugin that gives Claude comprehensive knowledge of SAP Private Cloud ERP (RISE with SAP) for architects, basis consultants, developers, and project managers.

**Architecture:** Single skill following the `sap-btp-best-practices` pattern — a `SKILL.md` entry point with embedded content routing logic, backed by topic-specific `references/` markdown files and a `cross-cutting/` subfolder for multi-domain content.

**Tech Stack:** Markdown, Claude Code plugin system (plugin.json, SKILL.md), GPL-3.0

---

## Task 1: Create Directory Structure

**Files:**
- Create: `sap-pce-expert/.claude-plugin/`
- Create: `sap-pce-expert/skills/sap-pce-expert/references/cross-cutting/`

**Step 1: Create all directories**

```bash
cd ~/sap-pce-expert
mkdir -p .claude-plugin
mkdir -p skills/sap-pce-expert/references/cross-cutting
```

**Step 2: Verify structure**

```bash
find . -type d | sort
```

Expected output:
```
.
./.claude-plugin
./docs
./docs/plans
./skills
./skills/sap-pce-expert
./skills/sap-pce-expert/references
./skills/sap-pce-expert/references/cross-cutting
```

**Step 3: Commit**

```bash
git add -A
git commit -m "chore: scaffold plugin directory structure"
```

---

## Task 2: Write plugin.json

**Files:**
- Create: `.claude-plugin/plugin.json`

**Step 1: Create the manifest**

```json
{
  "name": "sap-pce-expert",
  "description": "Comprehensive knowledge of SAP Private Cloud ERP (RISE with SAP) including architecture, migration, operations, security, extensibility, integration, and licensing. Use when working with RISE with SAP, S/4HANA Cloud Private Edition, PCE migrations, SAP-managed infrastructure, clean core, ABAP Cloud, hyperscaler deployments, or RISE contracts. Keywords: RISE with SAP, SAP Private Cloud ERP, S/4HANA Cloud Private Edition, PCE, brownfield, greenfield, bluefield, selective data transition, HUoM, SAPS, SAP-managed operations, clean core, ABAP Cloud, SAP Signavio, SAP Business Network",
  "version": "1.0.0",
  "author": {
    "name": "gabriele.rendina"
  },
  "license": "GPL-3.0",
  "keywords": [
    "rise",
    "rise with sap",
    "s4hana",
    "s/4hana cloud private edition",
    "pce",
    "private cloud",
    "erp",
    "migration",
    "brownfield",
    "greenfield",
    "clean core",
    "abap cloud",
    "hana",
    "hyperscaler",
    "sap managed",
    "signavio",
    "business network",
    "sap-pce-expert"
  ]
}
```

Save to: `.claude-plugin/plugin.json`

**Step 2: Verify JSON is valid**

```bash
cat .claude-plugin/plugin.json | python3 -m json.tool > /dev/null && echo "Valid JSON"
```

Expected: `Valid JSON`

**Step 3: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "feat: add plugin.json manifest"
```

---

## Task 3: Write SKILL.md

**Files:**
- Create: `skills/sap-pce-expert/SKILL.md`

**Step 1: Create SKILL.md**

```markdown
---
name: sap-pce-expert
description: |
  Comprehensive knowledge of SAP Private Cloud ERP (RISE with SAP) for architects, basis consultants, developers, and project managers. Use when working with RISE with SAP implementations, S/4HANA Cloud Private Edition, PCE migrations (brownfield/greenfield/bluefield/selective data transition), SAP-managed infrastructure on hyperscalers (AWS, Azure, GCP, Alibaba), clean core strategy, ABAP Cloud extensibility, SAP Integration Suite, SAP Signavio, SAP Business Network, or RISE licensing and contracts.

  Keywords: RISE with SAP, SAP Private Cloud ERP, S/4HANA Cloud Private Edition, PCE, brownfield, greenfield, bluefield, selective data transition, SUM, DMLT, HUoM, SAPS, SAP-managed operations, clean core, ABAP Cloud, key user extensibility, developer extensibility, BTP extensions, SAP Signavio, SAP Business Network, hyperscaler, AWS, Azure, GCP, Alibaba Cloud, SAP Integration Suite, RISE contract, SLA, patching cadence, backup restore, ISO 27001, SOC 2, GDPR
license: GPL-3.0
metadata:
  version: "1.0.0"
  last_verified: "2026-03-09"
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
```

**Step 2: Verify file exists**

```bash
ls -la skills/sap-pce-expert/SKILL.md
```

**Step 3: Commit**

```bash
git add skills/sap-pce-expert/SKILL.md
git commit -m "feat: add SKILL.md with content routing guide and overview"
```

---

## Task 4: Create Reference File Skeletons

**Files:**
- Create: `skills/sap-pce-expert/references/architecture-and-components.md`
- Create: `skills/sap-pce-expert/references/infrastructure-and-deployment.md`
- Create: `skills/sap-pce-expert/references/migration-and-adoption.md`
- Create: `skills/sap-pce-expert/references/operations-and-sla.md`
- Create: `skills/sap-pce-expert/references/security-and-compliance.md`
- Create: `skills/sap-pce-expert/references/extensibility-and-development.md`
- Create: `skills/sap-pce-expert/references/integration.md`
- Create: `skills/sap-pce-expert/references/licensing-and-sizing.md`

**Step 1: Create each reference file with ownership header**

Each file follows this skeleton pattern:

```markdown
# [Topic Title]

> **Ownership**: This file owns [specific topics]. For cross-cutting topics see `cross-cutting/`.
> **See also**: [list related reference files]

---

<!-- Content goes here. Add documentation by topic section. -->
```

Create `references/architecture-and-components.md`:
```markdown
# Architecture and Components

> **Ownership**: RISE with SAP bundle overview, S/4HANA Cloud Private Edition product details, included BTP services entitlements, SAP Signavio, SAP Business Network, SAP-managed vs customer-managed scope at the product level.
> **See also**: `infrastructure-and-deployment.md` (for infrastructure specifics), `licensing-and-sizing.md` (for what is included in the contract)

---

<!-- Add: RISE bundle components, S/4HANA Cloud PE architecture, included BTP services, Signavio capabilities, Business Network -->
```

Create `references/infrastructure-and-deployment.md`:
```markdown
# Infrastructure and Deployment

> **Ownership**: Hyperscaler options (AWS, Azure, GCP, Alibaba Cloud), SAP-managed infrastructure model, data center locations, network topology, availability zones, disaster recovery infrastructure.
> **See also**: `operations-and-sla.md` (for SLAs tied to infrastructure), `cross-cutting/hyperscaler-contracts.md` (for commercial aspects of hyperscaler choice)

---

<!-- Add: Hyperscaler comparison, region availability, network architecture, SAP-managed infra model, infrastructure SLAs -->
```

Create `references/migration-and-adoption.md`:
```markdown
# Migration and Adoption

> **Ownership**: Migration paths (greenfield, brownfield, bluefield, selective data transition), migration tools (SUM, DMLT, Readiness Check), project phases, timelines, partner roles, go-live checklist.
> **See also**: `cross-cutting/clean-core-strategy.md` (for clean core approach during migration), `extensibility-and-development.md` (for what to do with custom code)

---

<!-- Add: Migration path comparison, SUM/DMLT tool guides, Readiness Check, timeline templates, custom code remediation -->
```

Create `references/operations-and-sla.md`:
```markdown
# Operations and SLA

> **Ownership**: SAP-managed operations model, patching cadence (SPS, SP), backup and restore procedures, SLA definitions and targets, monitoring responsibilities, support model (incident management, escalation), scheduled downtime windows.
> **See also**: `security-and-compliance.md` (for compliance-related ops), `cross-cutting/identity-and-access.md` (for access to operational tools)

---

<!-- Add: Patching schedule, backup RPO/RTO, SLA tiers, support channels, operational runbooks, downtime windows -->
```

Create `references/security-and-compliance.md`:
```markdown
# Security and Compliance

> **Ownership**: Certifications (ISO 27001, SOC 1/2, GDPR, etc.), shared responsibility model, penetration testing policy, vulnerability management, network security controls, data residency, audit logging.
> **See also**: `cross-cutting/identity-and-access.md` (for IAM and user provisioning), `infrastructure-and-deployment.md` (for network-level security)

---

<!-- Add: Certification list, shared responsibility matrix, security controls, data residency options, audit log access -->
```

Create `references/extensibility-and-development.md`:
```markdown
# Extensibility and Development

> **Ownership**: ABAP Cloud (in-app extensibility), BTP side-by-side extensions, key user extensibility (Fiori adaptation, custom fields/logic), developer extensibility (RAP, Business Add-Ins), released APIs catalog approach.
> **See also**: `cross-cutting/clean-core-strategy.md` (for the governing principle), `integration.md` (for connecting extensions to external systems)

---

<!-- Add: Extensibility tiers, ABAP Cloud restrictions, RAP patterns, BTP extension scenarios, key user tools, released API policy -->
```

Create `references/integration.md`:
```markdown
# Integration

> **Ownership**: SAP Integration Suite on BTP (iFlows, APIs), integration patterns for cloud-to-cloud and hybrid, SAP Business Network connectivity, prebuilt integration content, API Management.
> **See also**: `architecture-and-components.md` (for Integration Suite as a RISE bundle component), `extensibility-and-development.md` (for extension integration patterns)

---

<!-- Add: Integration Suite capabilities, prebuilt packages, hybrid integration patterns, API Management, Business Network APIs -->
```

Create `references/licensing-and-sizing.md`:
```markdown
# Licensing and Sizing

> **Ownership**: RISE subscription licensing model, HUoM (HANA Units of Memory) sizing, SAPS (SAP Application Performance Standard) benchmarking, T-shirt sizing methodology, contract structure, add-on options.
> **See also**: `cross-cutting/hyperscaler-contracts.md` (for hyperscaler-specific commercial terms), `architecture-and-components.md` (for what is included in the RISE bundle)

---

<!-- Add: HUoM sizing guide, SAPS benchmarks, T-shirt size reference table, contract terms, renewal process, add-ons -->
```

**Step 2: Verify all files exist**

```bash
ls skills/sap-pce-expert/references/
```

Expected:
```
architecture-and-components.md
extensibility-and-development.md
infrastructure-and-deployment.md
integration.md
licensing-and-sizing.md
migration-and-adoption.md
operations-and-sla.md
security-and-compliance.md
cross-cutting/
```

**Step 3: Commit**

```bash
git add skills/sap-pce-expert/references/
git commit -m "feat: add reference file skeletons with ownership headers"
```

---

## Task 5: Create Cross-Cutting Reference Files

**Files:**
- Create: `skills/sap-pce-expert/references/cross-cutting/clean-core-strategy.md`
- Create: `skills/sap-pce-expert/references/cross-cutting/identity-and-access.md`
- Create: `skills/sap-pce-expert/references/cross-cutting/hyperscaler-contracts.md`

**Step 1: Create each cross-cutting file**

Create `references/cross-cutting/clean-core-strategy.md`:
```markdown
# Clean Core Strategy

> **Cross-cutting**: Spans extensibility, migration, and operations.
> This file owns clean core as a governing principle — what it means, how to assess it, how to enforce it.
> **See also**: `../extensibility-and-development.md`, `../migration-and-adoption.md`, `../operations-and-sla.md`

---

<!-- Add: Clean core definition, three pillars (processes/data/integrations/extensions), assessment tools, KPIs, remediation approach -->
```

Create `references/cross-cutting/identity-and-access.md`:
```markdown
# Identity and Access Management

> **Cross-cutting**: Spans security, BTP services, and operational access.
> This file owns IAM architecture, user provisioning flows, and role management across RISE components.
> **See also**: `../security-and-compliance.md`, `../operations-and-sla.md`

---

<!-- Add: SAP Cloud Identity Services, Identity Authentication (IAS), Identity Provisioning (IPS), role concept in S/4HANA, BTP role collections -->
```

Create `references/cross-cutting/hyperscaler-contracts.md`:
```markdown
# Hyperscaler Contracts and Commercial Terms

> **Cross-cutting**: Spans licensing, infrastructure, and security/compliance.
> This file owns the commercial and contractual aspects of hyperscaler selection within RISE.
> **See also**: `../licensing-and-sizing.md`, `../infrastructure-and-deployment.md`, `../security-and-compliance.md`

---

<!-- Add: Hyperscaler selection criteria, data residency commitments, exit clauses, Bring Your Own License (BYOL), cost impact of hyperscaler choice -->
```

**Step 2: Verify**

```bash
ls skills/sap-pce-expert/references/cross-cutting/
```

Expected:
```
clean-core-strategy.md
hyperscaler-contracts.md
identity-and-access.md
```

**Step 3: Commit**

```bash
git add skills/sap-pce-expert/references/cross-cutting/
git commit -m "feat: add cross-cutting reference files"
```

---

## Task 6: Write README.md

**Files:**
- Create: `skills/sap-pce-expert/README.md`

**Step 1: Create README**

```markdown
# sap-pce-expert

Claude Code skill providing comprehensive knowledge of SAP Private Cloud ERP (RISE with SAP).

## What it covers

- **Architecture**: RISE bundle components, S/4HANA Cloud Private Edition, included services
- **Infrastructure**: Hyperscaler options, SAP-managed infrastructure, network topology
- **Migration**: Greenfield/brownfield/bluefield/selective data transition, tools and timelines
- **Operations**: SAP-managed ops model, patching, backup/restore, SLAs
- **Security**: Certifications, shared responsibility, compliance, data residency
- **Extensibility**: ABAP Cloud, BTP extensions, clean core strategy
- **Integration**: SAP Integration Suite, hybrid patterns, Business Network
- **Licensing**: HUoM sizing, SAPS benchmarks, contract structure

## When Claude uses this skill

Claude automatically loads this skill when you ask about:
- RISE with SAP planning, architecture, or contracts
- S/4HANA Cloud Private Edition (PCE) migrations
- SAP-managed infrastructure or hyperscaler selection
- Clean core strategy and extensibility decisions
- RISE SLAs, patching, or operations

## Installation

```bash
/plugin marketplace add <marketplace-source>
/plugin install sap-pce-expert@<marketplace-name>
```

## Contributing

Add documentation to the appropriate reference file. See `SKILL.md` Content Routing Guide to determine which file owns each topic. For content spanning multiple topics, use the `references/cross-cutting/` files.

## License

GPL-3.0
```

**Step 2: Commit**

```bash
git add skills/sap-pce-expert/README.md
git commit -m "docs: add README"
```

---

## Task 7: Set Up Dev Marketplace and Test Installation

**Files:**
- Create: `.claude-plugin/marketplace.json` (temporary, for dev testing)

**Step 1: Create dev marketplace config**

```json
{
  "name": "sap-pce-dev",
  "plugins": [{
    "name": "sap-pce-expert",
    "source": "./"
  }]
}
```

Save to: `.claude-plugin/marketplace.json`

**Step 2: Install for testing**

In a Claude Code session:
```
/plugin marketplace add ~/sap-pce-expert
/plugin install sap-pce-expert@sap-pce-dev
```

Then restart Claude Code.

**Step 3: Verify skill appears in system prompt**

Ask Claude: "What do you know about RISE with SAP?" — the skill should load and Claude should respond using the skill content.

**Step 4: Test trigger keywords**

Verify each of these prompts triggers the skill:
- "Help me plan a brownfield migration to RISE with SAP"
- "What hyperscalers are supported in RISE?"
- "Explain clean core in the context of S/4HANA PCE"
- "What SLAs does SAP provide for managed operations?"
- "How does HUoM sizing work?"

**Step 5: Uninstall dev version when done**

```
/plugin uninstall sap-pce-expert@sap-pce-dev
```

**Step 6: Commit marketplace config**

```bash
git add .claude-plugin/marketplace.json
git commit -m "chore: add dev marketplace config for local testing"
```

---

## Task 8: Add Content from Documentation

This is the ongoing content population task. Each time you have SAP documentation to add:

**Step 1: Identify the primary topic of each section**

Use the Content Routing Guide in `SKILL.md` to determine which file owns it.

**Step 2: Add content to the correct file**

For cross-topic content:
- Place full content in the file that most closely owns it
- Add a `> See also: [filename]` cross-reference in other relevant files

**Step 3: Add cross-references**

In the secondary files, add:
```markdown
> See also: `../cross-cutting/clean-core-strategy.md` for [specific topic]
```

**Step 4: Commit after each documentation batch**

```bash
git add skills/sap-pce-expert/references/
git commit -m "docs: add [topic] content from [source]"
```

---

## Task 9: Release v1.0.0

**Step 1: Update version in plugin.json if needed**

Confirm `.claude-plugin/plugin.json` has `"version": "1.0.0"`.

**Step 2: Final verification**

```bash
# Confirm all files are present
find skills/ -name "*.md" | sort
find .claude-plugin/ -name "*.json" | sort
```

**Step 3: Tag the release**

```bash
git tag v1.0.0
git push origin main
git push origin v1.0.0
```

**Step 4: Test fresh install from GitHub**

```
/plugin marketplace add <your-github-org/sap-pce-expert>
/plugin install sap-pce-expert
```

---

## Content Population Order (recommended)

When adding documentation, work in this order for maximum coverage impact:

1. `architecture-and-components.md` — establishes the mental model
2. `migration-and-adoption.md` + `cross-cutting/clean-core-strategy.md` — highest demand from architects
3. `operations-and-sla.md` — critical for basis consultants
4. `extensibility-and-development.md` — critical for developers
5. `licensing-and-sizing.md` — critical for project managers
6. `security-and-compliance.md`
7. `infrastructure-and-deployment.md` + `cross-cutting/hyperscaler-contracts.md`
8. `integration.md`
9. `cross-cutting/identity-and-access.md`
