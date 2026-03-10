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
