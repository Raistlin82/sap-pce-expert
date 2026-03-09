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

## Adding Documentation

Route content to the correct reference file using the **Content Routing Guide** in `SKILL.md`.

For content spanning multiple topics:
1. Place full content in the file that most closely **owns** it
2. Add `> See also: [filename]` cross-reference in other relevant files
3. For truly cross-cutting content with no single owner, use `references/cross-cutting/`

**Recommended content population order:**
1. `references/architecture-and-components.md`
2. `references/migration-and-adoption.md` + `references/cross-cutting/clean-core-strategy.md`
3. `references/operations-and-sla.md`
4. `references/extensibility-and-development.md`
5. `references/licensing-and-sizing.md`
6. `references/security-and-compliance.md`
7. `references/infrastructure-and-deployment.md` + `references/cross-cutting/hyperscaler-contracts.md`
8. `references/integration.md`
9. `references/cross-cutting/identity-and-access.md`

## License

GPL-3.0
