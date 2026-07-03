# Design: Grep-based Retrieval for sap-pce-expert

**Date**: 2026-07-03
**Status**: Approved (pending spec review)
**Scope**: `skills/sap-pce-expert/SKILL.md` (+ a documentation note in `CLAUDE.md`)

## Problem

The `sap-pce-expert` skill holds ~930 SAP Notes across 11 markdown reference files. Its
current retrieval works by *topic routing*: `SKILL.md` maps a topic to its owning file,
and Claude opens the **entire** file to answer.

Two costs follow:

1. **Context waste.** A focused question ("how does backup work in RISE PCE?") loads all of
   `operations-and-sla.md` — ~14,660 tokens, 163 notes, of which ~159 are unrelated to
   backup (patching, jobs, ICF, number ranges, …). Measured: the genuinely relevant
   fragments are ~470 tokens.
2. **No cross-file coverage.** Routing opens one file. Backup-relevant content also lives in
   `security-and-compliance.md` (encryption at rest) and `infrastructure-and-deployment.md`
   (DR infrastructure). The router does not open those, so the answer is partial.

A vector RAG would solve both, but was rejected: the plugin is **distributed** to other
users, and a local vector RAG forces every user to install Python, download a ~2 GB
embedding model, and run an MCP server. That breaks the plugin's zero-setup install. Even a
prebuilt index needs a local embedding model to vectorize the query at answer time.

## Goal

Give the skill RAG-like retrieval — precise, low-context, cross-file — with **zero setup for
any user**, using only tools Claude Code already provides (Grep, Read). Then, when a live
source is available, use the pinpointed anchors to fetch **current, complete** content on top
of the curated corpus. Preserve today's behavior as a fallback so there is no regression.

## Design shape: two stages

1. **Locate (curated, always on).** The curated `.md` act as a precise, PCE-contextualized
   index. Grep + routing pinpoint the topic, the exact SAP Note IDs, and the right terms.
2. **Augment live (optional, graceful).** With those anchors, query a live source for fresh,
   complete content. Phase 1 reuses the **already-hosted** `sap-docs` MCP (configured by URL
   — no local install) for public SAP Help/Community content. If no live MCP is present, the
   curated content answers the question (today's behavior).

**SAP Notes stay local.** Note text comes from the curated `.md`; live note-by-ID fetch is
out of scope here (auth-gated, rate-limited — the fragility we hit during enrichment).

## Non-goals

- No vector embeddings, no vector store, no locally-installed MCP server, no per-user runtime
  in Phase 1. The optional live layer reuses the existing **hosted** `sap-docs` MCP (URL only).
- No live retrieval of auth-gated SAP Notes; notes are served from the curated `.md`.
- Building our **own** hosted MCP (independence + PCE-tuned ranking + serving our corpus) is
  **Phase 2** — a separate spec/plan, explicitly out of scope for this document.
- No splitting of reference files (rejected as invasive; Grep makes file size largely
  irrelevant because whole files are no longer loaded).
- No change to how reference content is authored or to the periodic-refresh workflow.

## Approach

Two parts, both living almost entirely in `SKILL.md`.

### A — Retrieval Protocol (the core)

Add a `## Retrieval Protocol` section to `SKILL.md` instructing Claude, at answer time, to:

1. **Expand** the user's question into English SAP terminology and synonyms/transaction
   codes. This is where the cross-lingual gap is closed: the user may ask in Italian, the
   corpus is English, and the LLM itself does the IT→EN translation before searching — so no
   multilingual embedding model is needed.
   - e.g. "come gestisco i backup?" → `backup, restore, retention, ECS, HANA, RPO, RTO`
   - e.g. "autenticazione SSO" → `authentication, SSO, SAML, IAS, IPS, SNC, SPNEGO`
2. **Grep** the reference files for those terms (case-insensitive, with surrounding
   context), across all files. The protocol must use a path Claude can resolve at answer
   time — grep the skill's own `references/` directory (relative to `SKILL.md`), not an
   assumed cwd.
3. **Read only the matching** table rows / sections — not whole files — including matches in
   more than one file (cross-file coverage). When a match lands in a SAP Notes table, read
   the **whole row** (all three columns: Note ID, Title, Relevance) — the explanatory text
   lives in the Relevance column, so a Title-only match still needs the full row.
4. **Augment live (optional, graceful — Stage 2).** If the `sap-docs` MCP is available, use
   the pinpointed terms / topic to fetch current SAP Help/Community content and enrich the
   answer. If it is not available, answer from the curated rows as-is. Note text always comes
   from the curated `.md` (no live note fetch). State when content is curated vs. live.
5. **Fallback**: if Grep returns nothing useful, use the existing Content Routing Guide and
   open the owning file, exactly as today.
6. **Synthesize** the answer, citing the relevant SAP Note IDs.

### B (light) — Grep-ability aids

- Add a `## Keyword Index` to `SKILL.md`: a compact table mapping *topic area → key SAP
  terms/transaction codes → owning file*. It helps Claude both form good Grep queries and
  know the fallback location. **Coverage target**: one row per topic area already in the
  Content Routing Guide, each enriched with high-frequency SAP terms/transaction codes for
  that area — not an exhaustive tcode dictionary. Example rows:

  | Area | Terms/tcodes to grep | File |
  |---|---|---|
  | Backup/Restore/DR | backup, restore, retention, RPO, RTO, HSR, 3572444 | operations-and-sla.md |
  | SSO/Identity | SSO, SAML, IAS, IPS, SNC, SPNEGO, STRUST | cross-cutting/identity-and-access.md |
  | bgRFC/async | bgRFC, SBGRFCMON, SRT_MONI, qRFC | operations-and-sla.md |

- **No edits to the 11 reference files.** Their SAP Notes sections are already
  `| Note ID | Title | Relevance |` tables — highly greppable as-is. Keeping them untouched
  makes this change low-risk.

- The existing **Content Routing Guide stays** as the fallback table (step 4).

## Data flow

```
User question (IT or EN)
  → 1. Claude expands key terms into English SAP terminology
  → 2. Grep the references/ files for those terms (case-insensitive, with context)  ── STAGE 1: LOCATE
  → 3. Read only matching rows/sections (may span multiple files) → pinpoint topic + note IDs
  → 4. If sap-docs MCP available → fetch current Help/Community content for the anchors ── STAGE 2: AUGMENT (optional)
       else → use curated rows as-is   (note text always from curated .md)
  → 5. If step 2 found nothing → fallback to Content Routing Guide (open owning file, as today)
  → 6. Synthesize answer citing SAP Note IDs (mark curated vs live where relevant)
```

## Files changed

| File | Change |
|---|---|
| `skills/sap-pce-expert/SKILL.md` | Add `## Retrieval Protocol` and `## Keyword Index`; keep the Content Routing Guide as fallback |
| `CLAUDE.md` | Short note documenting the retrieval protocol for future maintainers |
| reference `*.md` | none |

## Error handling / robustness

- **Empty grep** → deterministic fallback to routing (no worse than today).
- **Over-broad grep** (too many matches) → the protocol instructs Claude to prefer the most
  specific terms first and to read the SAP Notes tables' matching rows rather than dumping
  files.
- **Wrong term expansion** → fallback routing still covers the topic; and the Keyword Index
  anchors common areas to reduce mis-expansion.
- **Live MCP absent** → Stage 2 is skipped silently; the curated rows answer the question.
  The protocol must not fail or block when `sap-docs` is not configured.
- **Live MCP error/timeout** → treat as absent for that query; fall back to curated content.

## Phase 2 (out of scope here)

A **plugin-owned hosted MCP** — same URL-only deployment model as `sap-docs`, serving public
SAP content and our curated PCE corpus with PCE-tuned ranking — is a future evolution with its
own spec/plan. Phase 1 (this document) reuses the existing hosted `sap-docs` for the live layer.

## Validation

Behavioral (these are instructions for Claude, not code). Run a representative test set and
verify expected note IDs surface, cross-file coverage appears where relevant, and context is
smaller than opening whole files.

| Test query | Expected to surface |
|---|---|
| "come gestisco i backup in RISE?" | backup notes in operations + encryption in security + DR in infrastructure |
| "SSO con SAML" | IAS/SAML notes in identity-and-access |
| "clean core cosa significa" | clean-core-strategy + extensibility |
| "bgRFC bloccati dopo system copy" | SBGRFCMON/SRT_MONI notes in operations |
| "quanto costa / FUE" | licensing (FUE) |
| "meteo" (no match) | clean fallback to routing, no error |

**Method**: for each query, run the Grep with EN-expanded terms and confirm the expected
rows appear (including from multiple files); measure that the returned context is much
smaller than the owning file; confirm the no-match query falls back cleanly.

**Stage 2 (graceful)**: since Stage 2 is optional, the validation above runs entirely on
Stage 1 (grep) and must pass with `sap-docs` absent — proving the curated path never depends
on the live layer. When `sap-docs` is present, spot-check one query (e.g. a recent-release
topic) to confirm the protocol enriches with live content without breaking the curated answer.

**Success criteria**: for each query the expected IDs emerge from Grep; cross-file coverage
present where relevant; fallback does not break; Stage 1 works with no live MCP configured.

**Durable test set**: persist these six queries and their expected note IDs in a comment
block inside `SKILL.md` (or a small `references/_retrieval-tests.md`) so the same set can be
re-run after future content refreshes, rather than validating once and discarding.

## Impact

- **Users**: zero setup; works for everyone who installs the plugin.
- **Maintainers**: one file changed in substance (`SKILL.md`); content authoring unchanged.
- **Risk**: minimal — additive instructions with a preserved fallback path.
