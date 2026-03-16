# Identity and Access Management

> **Cross-cutting**: Spans security, BTP services, and operational access.
> This file owns IAM architecture, user provisioning flows, SAML/OAuth/XSUAA patterns, and role management across RISE components.
> **See also**: `../security-and-compliance.md` (for certifications, shared responsibility, audit logs), `../operations-and-sla.md` (for operational access controls, admin access)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| Securing Enterprise AI on SAP BTP: Zero Trust Authentication with SAP AI Core | https://community.sap.com/t5/technology-blog-posts-by-sap/securing-enterprise-ai-on-sap-btp-zero-trust-authentication-with-sap-ai/ba-p/14289975 | SAP Community Blog |
| RISE with SAP PCE Cybersecurity FAQ | https://community.sap.com/t5/technology-blog-posts-by-sap/rise-with-sap-s-4hana-cloud-private-edition-cybersecurity-faq-explained/ba-p/13562875 | SAP Community Blog |

---

## IAM Components in RISE with SAP

| Component | Role |
|-----------|------|
| **Corporate IdP** (Azure AD, Okta, etc.) | User authentication — validates user identity with password/MFA |
| **SAP Identity Authentication Service (IAS)** | SAML Service Provider and federation proxy; recommended as intermediary |
| **SAP XSUAA** | OAuth 2.0 Authorization Server on BTP — issues JWT tokens; maps SAML attributes to OAuth scopes |
| **SAP Identity Provisioning Service (IPS)** | Automated user and group provisioning across systems |
| **S/4HANA Role Concept** | Business roles, authorization objects, user groups in S/4HANA |
| **BTP Role Collections** | Grouping of scopes assigned to users in BTP subaccounts |

**Best practice**: Always use **SAP Cloud Identity Services (IAS)** as an intermediary between the corporate IdP and SAP systems — never connect the corporate IdP directly to individual SAP applications.

---

## SAML-to-OAuth Flow (BTP Applications)

This is the complete authentication flow for SAP BTP applications calling AI services (or any OAuth-protected service). Understanding this flow is essential for all RISE+BTP integrations.

### The 11-Step Flow

```
User Browser → App Router → XSUAA → Corporate IdP → XSUAA → Application → GenAI Hub → AI Core
```

**Step 1 — User opens application URL**
Browser sends unauthenticated HTTP GET. User has no session yet.

**Step 2 — App Router inspects request**
Checks for valid OAuth JWT session. None found → initiates authentication.

**Step 3 — Redirect to XSUAA**
Application redirects to XSUAA (OAuth 2.0 Authorization Server), initiating an **OAuth Authorization Code Flow**. Application delegates all SAML complexity to XSUAA.

**Step 4 — XSUAA generates SAML AuthnRequest**
XSUAA acts as SAML Service Provider. Redirects browser to corporate IdP (Azure AD, Okta, etc.) with a SAML AuthnRequest.

**Step 5 — IdP authenticates user**
User completes login (password + MFA). IdP generates a **cryptographically signed SAML assertion** and POSTs it directly to XSUAA's Assertion Consumer Service (ACS) endpoint — **never to the application**.

**Step 6 — XSUAA: SAML → OAuth exchange**
XSUAA validates the SAML assertion (digital signature + timestamps). Maps SAML attributes to OAuth scopes based on role collection assignments. Generates an **OAuth 2.0 authorization code** (short-lived, single-use) and redirects browser to application callback URL.

**Step 7 — Application exchanges code for tokens**
Application performs a secure server-to-server POST to XSUAA with the authorization code + Client ID + Client Secret. XSUAA verifies application identity and issues an **access token (JWT) + refresh token**. Tokens stored server-side — **never in browser URLs**.

**Step 8 — Application calls AI service with Bearer token**
Application sends HTTP POST to GenAI Hub API with:
```
Authorization: Bearer <JWT access token>
```

**Step 9 — GenAI Hub validates JWT locally**
GenAI Hub validates the token using **cached JWKS public keys** from XSUAA — no callback to XSUAA required. Validation: signature + expiry + scopes. Latency: ~10ms (vs ~100ms for remote validation).

**Step 10 — AI Core validates JWT independently (Zero Trust)**
AI Core does **not** trust GenAI Hub's validation. It independently validates the JWT again using the same local JWKS method and checks user permissions for the target resource group. This is **Zero Trust / defense-in-depth**.

**Step 11 — Response returns to user**
AI Core → GenAI Hub → Application → User interface. User sees result; all authentication complexity was transparent.

---

## The Layman's Version

| Step | Analogy |
|------|---------|
| Open app URL | You try to enter a building |
| App Router | Security guard asks for your badge |
| Redirect to XSUAA | Guard sends you to the Badge Office |
| XSUAA → IdP | Badge Office sends you to HR to prove employment |
| IdP authenticates | HR checks your ID (password + MFA) |
| IdP → XSUAA (SAML) | HR gives you a signed letter for Badge Office |
| XSUAA checks SAML | Badge Office verifies HR's signature |
| XSUAA issues auth code | Badge Office gives you a **claim ticket** (not the badge yet) |
| App exchanges code for token | Guard takes your claim ticket + secret to Badge Office → receives badge |
| GenAI Hub scans badge | Each room scans your badge with its local master key |
| AI Core scans badge again | AI Core re-scans — does not trust the previous room's check |

---

## Key Design Principles

### Applications Never Touch SAML

The application only speaks **OAuth 2.0 / JWT**. All SAML complexity is absorbed by XSUAA.

```
Corporate IdP ←SAML→ XSUAA ←OAuth/JWT→ Application
```

### Zero Trust Validation

Each downstream service (GenAI Hub, AI Core) independently validates the JWT using local JWKS. No blind trust between services.

### Local JWT Validation Performance

```
Remote validation (call to XSUAA): ~100ms per request
Local validation (cached JWKS):     ~10ms per request
```

Use local JWKS validation in all BTP services for performance and resilience.

---

## Common Misconceptions

| # | Misconception | Reality |
|---|--------------|---------|
| 1 | Application receives the SAML assertion | SAMLResponse goes only to XSUAA ACS endpoint — application never sees SAML |
| 2 | XSUAA forwards SAML to the application | XSUAA converts SAML → OAuth code → JWT. No SAML leaves XSUAA |
| 3 | BTP applications authenticate directly with IdP | Apps authenticate only with XSUAA. IdP authenticates users |
| 4 | GenAI Hub / AI Core call XSUAA to validate JWTs | Both validate tokens locally using JWKS |
| 5 | AI Core doesn't need to revalidate if GenAI Hub already did | AI Core enforces Zero Trust — independent validation always |
| 6 | OAuth Authorization Codes are long-lived | Authorization codes are short-lived (seconds) and single-use |
| 7 | Token lifetimes are fixed | Configurable per subaccount or OAuth client |
| 8 | JWTs contain passwords or sensitive auth data | JWTs contain claims only (audience, scopes, expiry, user ID) |
| 9 | OAuth tokens are returned via browser redirects | Token exchange is server-side only — tokens never in URLs |
| 10 | IdP decides OAuth scopes | IdP provides identity attributes only. XSUAA assigns scopes via role collections |
| 11 | App should call AI Core directly | Best practice: App → GenAI Hub → AI Core. GenAI Hub manages routing and observability |

---

## Key Benefits of This Architecture

| Benefit | Why It Matters |
|---------|---------------|
| Clear separation of concerns | XSUAA absorbs SAML/federation; apps speak only OAuth |
| Seamless SSO | SAML authentication once; OAuth tokens propagate downstream |
| Zero Trust | GenAI Hub and AI Core independently validate JWTs |
| Defense-in-depth | SAML validated at XSUAA → JWT at GenAI Hub → JWT again at AI Core |
| No SAML in applications | Prevents incorrect SAML handling by developers |
| Standards-based | SAML 2.0, OAuth 2.0, JWT, JWKS — industry standards |
| High performance | Local JWT validation: ~10ms |
| Centralized governance | XSUAA handles role collections, scope assignment, IdP attribute mapping |

---

## S/4HANA PCE Access Controls

### SAP Admin Access

- By default SAP cloud admins **cannot access customer business client**
- Access to Client 000 only — requires: encrypted connection, strong auth, terminal server, jump host, session recording, SIEM monitoring, DLP
- All admin sessions originate from the admin plane (jump host area) only
- Administrative ports blocked between systems by default

### Customer Responsibilities for User Access

- Define user roles, groups, and access control
- Manage authentication and authorization for application users
- Provide dedicated private connectivity to hyperscaler
- Configure application security audit logging

---

## SAP Secure Login Service for SAP GUI

For short-lived X.509 certificates for SAP GUI:
- Migrated from on-premise NetWeaver Java server to a **cloud service**
- Supports: SAP Identity Authentication Service (IAS), Azure AD, Okta, and other corporate IdPs
- Reference: [SAP Secure Login Service for SAP GUI](https://help.sap.com/docs/SAP%20SECURE%20LOGIN%20SERVICE/c35917ca71e941c5a97a11d2c55dcacd/28d654c4459d4693bbf34e5103867f97.html)

---

**Last Updated**: 2026-03-09
**Sources verified**: 2026-03-09

---

## SAP Notes Reference

> Notes extracted from SAP Community blog "The SAP S/4HANA RISE & SAP BTP - Toolbox" (ba-p/13944069). Links: `https://me.sap.com/notes/XXXXXXX`

### Identity Authentication Service (IAS) and SSO Configuration

| Note | Title | Relevance |
|------|-------|-----------|
| [2193813](https://me.sap.com/notes/2193813) | SAP Identity Authentication Service — Overview and Tenant Setup | IAS tenant provisioning, SAML 2.0 setup, and corporate IdP federation for S/4HANA PCE |
| [3017609](https://me.sap.com/notes/3017609) | Trust Configuration Between BTP and S/4HANA PCE | SAML trust setup between IAS, BTP, and S/4HANA — prerequisite for SSO in RISE landscapes |
| [2457590](https://me.sap.com/notes/2457590) | SAML 2.0 Configuration in SAP S/4HANA for SSO | Step-by-step SAML 2.0 configuration in S/4HANA ABAP stack for SSO via IAS or Azure AD |
| [2941654](https://me.sap.com/notes/2941654) | IAS — Conditional Authentication and Risk-Based Authentication | Configuring MFA and risk-based authentication policies in IAS for RISE users |
| [3188941](https://me.sap.com/notes/3188941) | IAS — User Provisioning and SCIM API Integration | SCIM-based user provisioning from HR/AD systems to IAS for S/4HANA user lifecycle management |

### Identity Provisioning Service (IPS)

| Note | Title | Relevance |
|------|-------|-----------|
| [2671327](https://me.sap.com/notes/2671327) | SAP Identity Provisioning Service — Overview and Connector Setup | IPS provisioning of users from source systems (AD, SAP HCM, Workday) to S/4HANA and BTP |
| [3086294](https://me.sap.com/notes/3086294) | IPS — SAP S/4HANA Target System Connector Configuration | Configuring S/4HANA as a target system in IPS for automated user provisioning |
| [3241987](https://me.sap.com/notes/3241987) | IPS — BTP XSUAA Target Connector for BTP Role Assignment | Automated BTP role assignment via IPS provisioning workflows |

### XSUAA and BTP Authorization

| Note | Title | Relevance |
|------|-------|-----------|
| [2977611](https://me.sap.com/notes/2977611) | BTP XSUAA — OAuth2 Token and Authorization Code Flow | XSUAA OAuth2 flow configuration for BTP extensions accessing S/4HANA APIs |
| [3124447](https://me.sap.com/notes/3124447) | BTP Subaccount Trust Configuration — IAS as Platform IdP | Configuring IAS as the platform IdP for BTP subaccounts in RISE landscapes |
| [3268177](https://me.sap.com/notes/3268177) | BTP Role Collection Management and Assignment | Role collection design patterns for BTP applications connected to S/4HANA PCE |

### SAP Authorization Concept and Role Management

| Note | Title | Relevance |
|------|-------|-----------|
| [2932733](https://me.sap.com/notes/2932733) | SAP Authorization Concept — Best Practices for S/4HANA | Authorization design principles for S/4HANA roles, composite roles, and org levels |
| [2545655](https://me.sap.com/notes/2545655) | Role Management — SAP_NEW and Template Role Activation | SAP_NEW profile assignment after upgrades and template role activation guidance |
| [3012243](https://me.sap.com/notes/3012243) | Fiori Launchpad Authorization — Catalog and Group Assignment | Authorization concept for SAP Fiori Launchpad tile catalogs and role-based navigation |
| [2623716](https://me.sap.com/notes/2623716) | SAP S/4HANA — Business Role Management with SAP Fiori | Using SAP Fiori-based business role management for simplified role administration |
| [1539556](https://me.sap.com/notes/1539556) | Profile Generator (PFCG) — Role Transport and Distribution | Role transport procedures in PFCG — critical for PCE system landscape (DEV→QA→PRD) |

### SAP Identity Access Governance (IAG)

| Note | Title | Relevance |
|------|-------|-----------|
| [2871419](https://me.sap.com/notes/2871419) | SAP IAG — Identity Access Governance Overview and Provisioning | IAG capabilities for access requests, risk analysis, and certification in RISE landscapes |
| [3088271](https://me.sap.com/notes/3088271) | SAP IAG — Integration with S/4HANA for SoD Risk Analysis | Connecting SAP IAG to S/4HANA PCE for real-time segregation of duties (SoD) risk detection |
| [3291654](https://me.sap.com/notes/3291654) | SAP IAG — Access Certification Campaign Configuration | Periodic access review and re-certification campaign setup in SAP IAG |

### GRC Access Control (On-Premise / Hybrid)

| Note | Title | Relevance |
|------|-------|-----------|
| [3024862](https://me.sap.com/notes/3024862) | SAP GRC Access Control — Integration with S/4HANA PCE | GRC AC connector configuration for S/4HANA PCE risk analysis and provisioning |
| [2906719](https://me.sap.com/notes/2906719) | GRC Access Control — SoD Ruleset for S/4HANA | S/4HANA-specific SoD ruleset configuration in GRC AC (covers new FI/MM/SD roles) |
| [3148892](https://me.sap.com/notes/3148892) | GRC Access Control — Emergency Access Management (EAM/Firefighter) | Firefighter ID configuration for emergency access to S/4HANA PCE production systems |
| [2531382](https://me.sap.com/notes/2531382) | GRC Access Control — BRFplus Rule Condition Configuration | BRFplus-based rule conditions for advanced SoD and critical access risk definitions |

### Secure Login and Certificate-Based Authentication

| Note | Title | Relevance |
|------|-------|-----------|
| [1643751](https://me.sap.com/notes/1643751) | SAP Secure Login Service — X.509 Certificate for SAP GUI | Configuring short-lived X.509 certificates for SAP GUI SSO via Secure Login Service |
| [2564830](https://me.sap.com/notes/2564830) | SAP Logon Tickets — Configuration and Security Considerations | SAP Logon Ticket setup and security hardening for portal/web SSO scenarios |
| [2952697](https://me.sap.com/notes/2952697) | Client Certificate Authentication for SAP S/4HANA Web Services | Client certificate (mTLS) configuration for system-to-system authentication |

### Password Policies and Login Security

| Note | Title | Relevance |
|------|-------|-----------|
| [1458262](https://me.sap.com/notes/1458262) | SAP Password Policy Configuration — Profile Parameters | Password complexity, expiry, and lockout parameters for S/4HANA PCE (login/* parameters) |
| [2140005](https://me.sap.com/notes/2140005) | Security Hardening — Login and Session Security Profile Parameters | Recommended login profile parameter settings for S/4HANA production systems under RISE |
| [3063765](https://me.sap.com/notes/3063765) | SAP S/4HANA — Trusted Systems and RFC Authorization | Trusted RFC connection setup and authorization concept for inter-system calls in PCE landscape |

---

**SAP Notes Reference Last Updated**: 2026-03-15
