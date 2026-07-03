# Grep-based Retrieval Protocol — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give the `sap-pce-expert` skill precise, low-context, cross-file retrieval with zero user setup, by adding a two-stage Retrieval Protocol and a Keyword Index to `SKILL.md`.

**Architecture:** Instructions-for-Claude only. **Stage 1 (locate, always on):** Claude expands the query into English SAP terms, greps the `references/` files, and reads only matching rows/sections (cross-file) to pinpoint topic + SAP Note IDs. **Stage 2 (augment, optional & graceful):** if the already-hosted `sap-docs` MCP is configured (URL only), use the pinpointed anchors to fetch current Help/Community content; if absent, answer from the curated rows. Note text always comes from the curated `.md`. Falls back to the Content Routing Guide if grep finds nothing. No code, no local runtime, no hard dependency. (Our own hosted MCP is a future Phase 2, separate plan.)

**Tech Stack:** Markdown. Claude Code built-in tools (Grep, Read). No new packages.

**Spec:** `docs/superpowers/specs/2026-07-03-grep-retrieval-design.md`

**Note on git:** the repo has uncommitted v1.6.0 work on `main`. Do this work on a dedicated branch (e.g. `feat/grep-retrieval`) so it stays separate. Confirm branch strategy with the user at execution handoff.

**Note on validation:** this feature is a prompt, not executable code. "Tests" are grep commands whose output must contain the expected SAP Note IDs and span multiple files. Run them from the repo root.

---

## File Structure

| File | Responsibility | Change |
|---|---|---|
| `skills/sap-pce-expert/SKILL.md` | Skill entry point + routing | Add `## Retrieval Protocol` and `## Keyword Index`; keep Content Routing Guide as fallback |
| `skills/sap-pce-expert/retrieval-tests.md` | Durable validation set | Create: 6 queries + expected note IDs. **Lives outside `references/`** so the protocol's grep never matches it |
| `CLAUDE.md` | Maintainer guidance | Add short note documenting the retrieval protocol |
| `skills/sap-pce-expert/references/*.md` (the 11) | Knowledge content | **No change** |

---

## Task 1: Establish the durable validation set (the "tests" first)

**Files:**
- Create: `skills/sap-pce-expert/retrieval-tests.md` (outside `references/` so the protocol grep never matches it)

- [ ] **Step 1: Confirm expected note IDs actually exist and are grep-surfaced**

Run each grep from repo root and record which Note IDs surface and from which files. Note the
quoted `--include='*.md'` — required under zsh, where a bare `*.md` glob aborts the command:

```bash
cd /Users/gabriele.rendina/tools/sap-pce-expert
R=skills/sap-pce-expert/references
echo "== backup ==";  grep -rniE 'backup|restore|retention|3572444' $R --include='*.md' -l
echo "== sso ==";      grep -rniE 'SAML|IAS\b|SSO|SPNEGO' $R --include='*.md' -l
echo "== clean core =="; grep -rniE 'clean core|maturity model' $R --include='*.md' -l
echo "== bgrfc ==";    grep -rniE 'bgRFC|SBGRFCMON|SRT_MONI' $R --include='*.md' -l
echo "== fue ==";      grep -rniE '\bFUE\b|full use equivalent' $R --include='*.md' -l
echo "== nomatch ==";  grep -rniE 'meteo|weather forecast' $R --include='*.md' -l || echo "(no match — fallback expected)"
```

Expected: the first five each list ≥1 file (backup and sso should list **multiple** files → cross-file coverage); the last returns nothing.

- [ ] **Step 2: Write the validation set file**

Create `skills/sap-pce-expert/retrieval-tests.md` with a table capturing each query, its English-expanded terms, and the note IDs/files that must surface (fill IDs from Step 1 output):

```markdown
# Retrieval Protocol — Validation Set

> Re-run after content refreshes to confirm the Retrieval Protocol still surfaces the right notes.
> These are behavioral checks (grep), not code tests. Run greps from repo root against `skills/sap-pce-expert/references/`.
> This file lives OUTSIDE `references/` on purpose, so the Retrieval Protocol's grep never matches it.

| # | Query (as user asks) | Expanded EN terms | Must surface (files / sample note IDs) |
|---|---|---|---|
| 1 | come gestisco i backup in RISE? | backup, restore, retention, RPO, RTO, HSR | operations-and-sla.md + security-and-compliance.md + infrastructure-and-deployment.md |
| 2 | SSO con SAML | SSO, SAML, IAS, IPS, SNC, SPNEGO | cross-cutting/identity-and-access.md (+ security) |
| 3 | clean core cosa significa | clean core, maturity model, tiers | cross-cutting/clean-core-strategy.md + extensibility-and-development.md |
| 4 | bgRFC bloccati dopo system copy | bgRFC, SBGRFCMON, SRT_MONI | operations-and-sla.md (e.g. 1755745, 1839315) |
| 5 | quanto costa / FUE | FUE, full use equivalent, licensing | licensing-and-sizing.md |
| 6 | meteo | (no SAP mapping) | none → clean fallback to routing, no error |
```

- [ ] **Step 3: Commit**

```bash
git add skills/sap-pce-expert/retrieval-tests.md
git commit -m "test: add retrieval protocol validation set"
```

---

## Task 2: Add the Keyword Index to SKILL.md

**Files:**
- Modify: `skills/sap-pce-expert/SKILL.md` (insert after the existing Content Routing Guide section)

- [ ] **Step 1: Insert the Keyword Index section**

Add this section immediately after the Content Routing Guide table (before `## Overview`):

```markdown
## Keyword Index

Use this to form Grep queries (expand the user's question into these English SAP terms) and to
know the fallback file. One row per topic area; not an exhaustive tcode list.

| Area | Terms / tcodes to grep | File |
|---|---|---|
| RISE bundle / S/4HANA overview | RISE, bundle, S/4HANA, Signavio, Business Network, SAPUI5, SOAMANAGER | architecture-and-components.md |
| Hyperscaler / network / data center | hyperscaler, AWS, Azure, GCP, Alibaba, VPC, VNET, Direct Connect, ExpressRoute, data center | infrastructure-and-deployment.md |
| Disaster Recovery infrastructure | DR, disaster recovery, RPO, RTO, replication | infrastructure-and-deployment.md |
| Migration / conversion tools | migration, brownfield, greenfield, bluefield, SUM, DMLT, Readiness Check, selective data transition | migration-and-adoption.md |
| Operations / SLA / patching | SLA, patching, SPS, SP, EWA, SGEN, service request, ECS, number range | operations-and-sla.md |
| Backup / restore | backup, restore, retention, HSR, 3572444 | operations-and-sla.md |
| bgRFC / async processing | bgRFC, SBGRFCMON, SRT_MONI, qRFC | operations-and-sla.md |
| Security / compliance | ISO 27001, SOC, GDPR, encryption, penetration test, vulnerability, RSBDCOS0, HTTP_WHITELIST, UCON | security-and-compliance.md |
| Extensibility / ABAP Cloud / BTP | ABAP Cloud, clean core, key user, RAP, BAdI, SICF, Web Dynpro, ATO, S_ATO_SETUP | extensibility-and-development.md |
| Integration | Integration Suite, Cloud Connector, iFlow, API, SDI, DP Agent, RFC, IDoc | integration.md |
| Licensing / sizing | licensing, FUE, HUoM, SAPS, subscription, contract, Global Account | licensing-and-sizing.md |
| Clean core strategy | clean core, maturity model, tiers, KPIs | cross-cutting/clean-core-strategy.md |
| Identity / SSO / access | SSO, SAML, IAS, IPS, SNC, SPNEGO, XSUAA, STRUST | cross-cutting/identity-and-access.md |
| Hyperscaler contracts | hyperscaler agreement, BYOL, contract, region | cross-cutting/hyperscaler-contracts.md |
```

- [ ] **Step 2: Verify every File value maps to a real file**

```bash
cd /Users/gabriele.rendina/tools/sap-pce-expert
awk -F'|' '/\.md \|$/{gsub(/^ *| *$/,"",$4); if($4 ~ /\.md$/) print $4}' skills/sap-pce-expert/SKILL.md | sort -u | while read f; do [ -f "skills/sap-pce-expert/references/$f" ] && echo "OK $f" || echo "MISSING $f"; done
```

Expected: every line prints `OK` (no `MISSING`).

- [ ] **Step 3: Commit**

```bash
git add skills/sap-pce-expert/SKILL.md
git commit -m "feat: add Keyword Index to sap-pce-expert skill"
```

---

## Task 3: Add the Retrieval Protocol to SKILL.md

**Files:**
- Modify: `skills/sap-pce-expert/SKILL.md` (insert immediately before the `## Content Routing Guide` section, so the protocol is read first and the routing guide reads as its fallback)

- [ ] **Step 1: Insert the Retrieval Protocol section**

```markdown
## Retrieval Protocol

Follow this BEFORE composing an answer. It keeps context small and covers content that spans
multiple files.

1. **Expand the query into English SAP terminology.** The reference content is English; the
   user may ask in any language (often Italian). List the key concepts plus SAP synonyms and
   transaction codes. Use the Keyword Index below to help.
   - "come gestisco i backup?" → backup, restore, retention, RPO, RTO, HSR
   - "autenticazione SSO" → authentication, SSO, SAML, IAS, IPS, SNC, SPNEGO
2. **Grep the reference files (Stage 1 — locate).** Search this skill's `references/`
   directory (the folder next to this SKILL.md), case-insensitive, with context, for the
   expanded terms. Search ALL files — do not pre-limit to one topic.
3. **Read only the matching rows/sections.** Do not load whole files. When a match is in a
   SAP Notes table (`| Note ID | Title | Relevance |`), read the whole row (all three
   columns — the explanation is in Relevance). Collect matches across files: a topic often
   spans files (e.g. backup touches operations, security, and infrastructure). You now have
   the pinpointed topic and SAP Note IDs.
4. **Augment with live content (Stage 2 — optional, graceful).** If the `sap-docs` MCP is
   available, use the pinpointed terms/topic to fetch current SAP Help/Community content and
   enrich the answer. If `sap-docs` is not configured or errors, skip this step silently and
   answer from the curated rows. **SAP Note text always comes from the curated `.md`** — do
   not attempt live note-by-ID fetch here. Indicate when content is curated vs. live.
5. **Fallback.** If grep (step 2) yields nothing useful, use the Content Routing Guide below
   to open the owning file — the prior behavior.
6. **Answer, citing the SAP Note IDs** you used.

Prefer specific terms first; widen only if needed. Stage 2 is a bonus layer — the skill must
answer fully from the curated content when no live MCP is present.
```

- [ ] **Step 2: Verify both new sections are present and ordered correctly**

```bash
cd /Users/gabriele.rendina/tools/sap-pce-expert
grep -n '^## Retrieval Protocol\|^## Keyword Index\|^## Content Routing Guide' skills/sap-pce-expert/SKILL.md
```

Expected: `## Retrieval Protocol` appears, followed by `## Content Routing Guide`, and `## Keyword Index` is present. (Order: Retrieval Protocol → Content Routing Guide … → Keyword Index is acceptable as long as Retrieval Protocol precedes the routing guide.)

- [ ] **Step 3: Commit**

```bash
git add skills/sap-pce-expert/SKILL.md
git commit -m "feat: add Grep-based Retrieval Protocol to sap-pce-expert skill"
```

---

## Task 4: Document the protocol in CLAUDE.md

**Files:**
- Modify: `CLAUDE.md` (add a short subsection under the existing "Content Routing" area)

- [ ] **Step 1: Add the maintainer note**

Add after the Content Routing section in `CLAUDE.md`:

```markdown
## Retrieval at Answer Time

`SKILL.md` defines a **Retrieval Protocol**: Claude expands the user's question into English
SAP terms, greps `references/` for them, and reads only the matching rows/sections (cross-file),
falling back to the Content Routing Guide if grep finds nothing. The **Keyword Index** in
`SKILL.md` maps topic areas to grep terms and their fallback file. When adding content, keep
SAP Notes as `| Note ID | Title | Relevance |` rows (greppable) and, for a new topic area, add
a Keyword Index row. Validation queries live in `skills/sap-pce-expert/retrieval-tests.md`
(kept outside `references/` so the protocol's grep never matches the test scaffolding).
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: document retrieval protocol in CLAUDE.md"
```

---

## Task 5: End-to-end behavioral validation

**Files:** none (validation only)

> The greps below exercise **Stage 1** only and use no live MCP — passing them proves the
> curated path is self-sufficient (Stage 2 absent = today's behavior). Stage 2 is a protocol
> property (graceful skip when `sap-docs` is missing); if `sap-docs` is configured, do the
> optional spot-check in Step 4.

- [ ] **Step 1: Run the validation set greps and confirm expectations**

```bash
cd /Users/gabriele.rendina/tools/sap-pce-expert
R=skills/sap-pce-expert/references
echo "== 1 backup (expect operations + security + infrastructure) ==";
  grep -rniE 'backup|restore|retention' $R --include='*.md' -l
echo "== 2 sso (expect identity-and-access, maybe security) ==";
  grep -rniE 'SAML|IAS\b|SSO' $R --include='*.md' -l
echo "== 3 clean core (expect clean-core-strategy + extensibility) ==";
  grep -rniE 'clean core|maturity model' $R --include='*.md' -l
echo "== 4 bgRFC (expect operations; look for note IDs 1755745 / 1839315) ==";
  grep -rniE 'SBGRFCMON|bgRFC' $R --include='*.md' | grep -oE '[0-9]{6,7}' | sort -u | head
echo "== 5 FUE (expect licensing) ==";
  grep -rniE '\bFUE\b|full use equivalent' $R --include='*.md' -l
echo "== 6 no-match (expect empty) ==";
  grep -rniE 'meteo|weather forecast' $R --include='*.md' -l || echo "EMPTY (fallback path)"
```

Expected: queries 1 and 2 list **multiple files** (cross-file coverage proven); 3 lists clean-core + extensibility; 4 shows the bgRFC note IDs; 5 lists licensing; 6 is empty.

- [ ] **Step 2: Confirm context reduction on a representative query**

```bash
cd /Users/gabriele.rendina/tools/sap-pce-expert
F=skills/sap-pce-expert/references/operations-and-sla.md
echo "whole file chars: $(wc -c < $F)  (~$(( $(wc -c < $F) / 4 )) tokens)"
echo "backup-relevant chars: $(grep -iE 'backup|restore|retention' $F | wc -c)  (~$(( $(grep -iE 'backup|restore|retention' $F | wc -c) / 4 )) tokens)"
```

Expected: relevant-fragment tokens are an order of magnitude smaller than whole-file tokens.

- [ ] **Step 4 (optional, only if `sap-docs` is configured): Stage 2 spot-check**

Ask one recent-release / evolving-topic question (e.g. "novità clean core S/4HANA 2025") and
confirm the protocol: (a) still greps the curated corpus first, (b) then enriches with live
`sap-docs` content, (c) would still answer from curated content if `sap-docs` were absent.
This is a behavioral read-through, not a shell command.

- [ ] **Step 5: Final commit (if any tracking/notes changed)**

```bash
git add -A
git commit -m "test: validate grep retrieval protocol end-to-end" || echo "nothing to commit"
```

---

## Done criteria

- `SKILL.md` contains `## Retrieval Protocol` (Stage 1 locate + Stage 2 optional augment, before the routing guide) and `## Keyword Index`.
- `skills/sap-pce-expert/retrieval-tests.md` exists with the 6-query set (outside `references/`).
- `CLAUDE.md` documents the protocol.
- The 11 reference files are unchanged.
- Validation greps (Stage 1) show cross-file coverage for backup and SSO, correct files for the others, and a clean empty result for the no-match query — all passing with no live MCP configured.
- The protocol skips Stage 2 gracefully when `sap-docs` is absent (curated content still answers).
