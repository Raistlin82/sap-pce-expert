# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A **Claude Code plugin** that exposes a single skill (`sap-pce-expert`) with comprehensive knowledge of SAP Private Cloud ERP (RISE with SAP). There is no application code — the entire plugin is markdown content plus JSON manifests.

## Plugin Architecture

```
.claude-plugin/
  plugin.json          # Plugin manifest (name, version, keywords)
  marketplace.json     # Marketplace source config for installation

skills/sap-pce-expert/
  SKILL.md             # Skill entry point: frontmatter triggers, routing guide, overview
  README.md            # Human-readable description and install instructions
  references/
    architecture-and-components.md
    infrastructure-and-deployment.md
    migration-and-adoption.md
    operations-and-sla.md
    security-and-compliance.md
    extensibility-and-development.md
    integration.md
    licensing-and-sizing.md
    cross-cutting/
      clean-core-strategy.md    # Spans: extensibility + migration + ops
      identity-and-access.md    # Spans: security + BTP + ops
      hyperscaler-contracts.md  # Spans: licensing + infra + security
```

## How the Skill Works

`SKILL.md` is loaded by Claude Code when trigger keywords in its frontmatter match the user's query. It contains a **Content Routing Guide** table that maps topics to their owning reference files. The reference files hold the actual knowledge content.

**Trigger keywords** are defined in the `description` field of `SKILL.md` frontmatter — updating them requires editing both `SKILL.md` and `plugin.json`.

## Content Routing

Use the Content Routing Guide in `SKILL.md` to determine where documentation belongs:

| If content is about… | Primary file | Cross-cutting file |
|---|---|---|
| RISE bundle, S/4HANA overview | `architecture-and-components.md` | — |
| Hyperscalers, network, data centers | `infrastructure-and-deployment.md` | `cross-cutting/hyperscaler-contracts.md` |
| Migration paths, SUM/DMLT tools | `migration-and-adoption.md` | `cross-cutting/clean-core-strategy.md` |
| Patching, backup, SLAs, support | `operations-and-sla.md` | — |
| Certifications, shared responsibility | `security-and-compliance.md` | `cross-cutting/identity-and-access.md` |
| ABAP Cloud, BTP extensions | `extensibility-and-development.md` | `cross-cutting/clean-core-strategy.md` |
| Integration Suite, APIs, hybrid | `integration.md` | — |
| HUoM, SAPS, licensing, contracts | `licensing-and-sizing.md` | `cross-cutting/hyperscaler-contracts.md` |

For content spanning multiple topics: place the full content in the **owning** file, add `> See also:` cross-references in secondary files. For truly cross-cutting content with no single owner, use `references/cross-cutting/`.

## Versioning and Release

Version is tracked in two places — keep them in sync:
- `.claude-plugin/plugin.json` → `"version"` field
- `skills/sap-pce-expert/SKILL.md` → `metadata.version` in frontmatter

Release process:
```bash
git tag v<version>
git push origin main
git push origin v<version>
```

## Local Testing

```bash
# In a Claude Code session:
/plugin marketplace add ~/sap-pce-expert
/plugin install sap-pce-expert@sap-pce-expert
# Restart Claude Code, then test with a trigger question
/plugin uninstall sap-pce-expert@sap-pce-expert  # when done
```

The `marketplace.json` points to the GitHub HTTPS URL for production installs.
