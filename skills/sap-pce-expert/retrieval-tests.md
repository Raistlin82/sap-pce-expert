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
