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

## Retrieval at Answer Time

`SKILL.md` defines a two-stage **Retrieval Protocol**. Stage 1 (locate): Claude expands the
user's question into English SAP terms, greps `references/` for them, and reads only the
matching rows/sections (cross-file), falling back to the Content Routing Guide if grep finds
nothing. Stage 2 (augment, optional): if the hosted `sap-docs` MCP is configured, it enriches
the answer with current Help/Community content; if absent, the curated content answers alone.
SAP Note text always comes from the curated `.md`. The **Keyword Index** in `SKILL.md` maps
topic areas to grep terms and their fallback file. When adding content, keep SAP Notes as
`| Note ID | Title | Relevance |` rows (greppable) and, for a new topic area, add a Keyword
Index row. Validation queries live in `skills/sap-pce-expert/retrieval-tests.md` (kept outside
`references/` so the protocol's grep never matches the test scaffolding).

## SAP Notes Enrichment Workflow

Recent releases (1.3.0–1.5.0) enrich the reference files with curated SAP Notes. Four tracking files live at the repo **root** (outside the plugin/skill dirs — they are working artifacts, not shipped content):

- `sap-notes-master-list.md` — master reference: ~891 notes classified by category, each row mapping a note ID to its owning skill reference file. **Gitignored** (not committed), so it won't appear in `git status`; treat it as the source of truth for what to integrate.
- `all_master_notes.txt` — every note ID in the master list (the full set).
- `analyzed_notes.txt` — note IDs already integrated into the reference files.
- `missing_notes_total.txt` — note IDs still to integrate.

To add notes to a reference file: find the note's target file in `sap-notes-master-list.md`, add it there (as a linked `[ID](https://me.sap.com/notes/ID) | Title | file` row and in the relevant reference file's SAP Notes section), then move its ID from `missing_notes_total.txt` to `analyzed_notes.txt`.

## Versioning and Release

Version is tracked in **three** places — keep them in sync on every release:
- `.claude-plugin/plugin.json` → `"version"` field
- `.claude-plugin/marketplace.json` → `plugins[0].version` field
- `skills/sap-pce-expert/SKILL.md` → `metadata.version` in frontmatter

Also bump the dated fields in `SKILL.md` when content changes: `metadata.last_verified`, and the `**Last Updated**` / `**Next Review**` lines at the bottom (review cadence is quarterly). Add a row to the version table in `README.md`.

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

Production installs use the GitHub shorthand (`/plugin marketplace add Raistlin82/sap-pce-expert`), per `README.md`.

**Do not change `marketplace.json` `source` to an absolute/HTTPS URL.** It is deliberately set to the relative path `"./"` — an absolute path caused an `ENAMETOOLONG` cache-recursion error (see commits `7dde1f4`, `c3d1cd6`). Keep `plugin.json` `description` short for the same reason.
