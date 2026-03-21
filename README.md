# sap-pce-expert

A Claude Code plugin providing comprehensive knowledge of **SAP Private Cloud ERP** (RISE with SAP / S/4HANA Cloud, Private Edition).

Designed for architects, basis/operations consultants, developers, and project managers working on RISE with SAP engagements.

---

## What It Covers

| Area | Topics |
|------|--------|
| **Architecture** | RISE bundle components, S/4HANA Cloud PCE product options (Standard/Tailored), included BTP services by tier (Base/Premium/Premium Plus), SAP Signavio, SAP Business Network |
| **Infrastructure** | Hyperscaler options (AWS, Azure, GCP, Alibaba Cloud), SAP-managed infrastructure model, network topology, VPC/VNET isolation, connectivity patterns, sizing and DR |
| **Migration** | Greenfield/brownfield/bluefield/selective data transition paths, SUM/DMLT tools, Readiness Check, migration timelines, System Transition Workbench |
| **Operations** | SAP ECS managed operations model, patching cadence (SPS/SP), backup/restore, SLAs, monitoring, support model (Foundational/Advanced/Max Success Plans), Operations View Dashboard |
| **Security** | ISO 27001/SOC 2/GDPR certifications, shared responsibility model, penetration testing policy, vulnerability management, network security, encryption, 24×7 SOC |
| **Extensibility** | ABAP Cloud (clean core levels A/B/C/D), BTP side-by-side extensions, key user extensibility, developer extensibility (RAP, BAdIs), Fiori & UI activation, AI & Joule integration |
| **Integration** | SAP Integration Suite, hybrid integration patterns, Cloud Connector, Business Network connectivity, APIs |
| **Licensing** | RISE licensing model, HUoM/SAPS sizing, subscription vs consumption, contract structure, FUE measurement |
| **Cross-cutting** | Clean core strategy, identity and access management (IAS/IPS/SAML2/BTP), hyperscaler contract considerations |

Each area includes curated **SAP Notes references** with relevance descriptions specific to PCE contexts.

---

## Installation

### From GitHub (direct)

In a Claude Code session:

```
/plugin marketplace add Raistlin82/sap-pce-expert
/plugin install sap-pce-expert@sap-pce-expert
```

Restart Claude Code after installation.

### Update

```
/plugin marketplace update sap-pce-expert
/plugin update sap-pce-expert@sap-pce-expert
```

### Uninstall

```
/plugin uninstall sap-pce-expert@sap-pce-expert
```

---

## How It Works

The skill is automatically loaded by Claude Code when your query matches any of the trigger keywords defined in `SKILL.md` — for example: *RISE with SAP*, *PCE*, *S/4HANA Cloud Private Edition*, *brownfield migration*, *clean core*, *HUoM*, *SAP-managed operations*, *Joule*, *patching*, *SAPS*.

Once loaded, the skill provides:
- A **Content Routing Guide** so Claude knows which reference file owns each topic
- Detailed knowledge in 8 topic files + 3 cross-cutting files under `skills/sap-pce-expert/references/`

---

## Plugin Structure

```
sap-pce-expert/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest (name, version, keywords)
│   └── marketplace.json     # Marketplace source config
└── skills/
    └── sap-pce-expert/
        ├── SKILL.md         # Skill entry point: trigger keywords, routing guide
        ├── README.md        # Skill-level description (shown in /plugin UI)
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

---

## Versioning

| Version | Highlights |
|---------|------------|
| 1.5.0 | Massive addition of SAP Notes tracking for Private Cloud architectures. Fixed ENAMETOOLONG installation bug by making marketplace source path relative. |
| 1.4.0 | Added SAP Notes reference sections for IAS/BTP SSO diagnostics, S/4HANA 2025 release compatibility, and HTTP security & certificate management |
| 1.3.0 | Added SAP Notes reference sections for Fiori & UI, AI & Joule, HANA Database, Basis Administration, SAC/BDC, GRC & Access Control |
| 1.2.0 | Enriched all reference files with real SAP Note content; added IAS/SAML2/BTP identity notes; CLAUDE.md |
| 1.1.0 | Initial full content across all 8 topic files and 3 cross-cutting files |
| 1.0.0 | Initial release |

---

## Contributing

Content is organized following a strict ownership model — each topic has a single owning file to avoid duplication. Before adding content:

1. Check the **Content Routing Guide** in `SKILL.md` to find the correct owning file
2. For content spanning multiple topics, add the full content to the owning file and `> See also:` cross-references elsewhere
3. For genuinely cross-cutting content, use `references/cross-cutting/`

---

## License

GPL-3.0 — see [LICENSE](LICENSE) or [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
