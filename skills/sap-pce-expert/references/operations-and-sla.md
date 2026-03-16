# Operations and SLA

> **Ownership**: SAP-managed operations model, patching cadence (SPS, SP), backup and restore procedures, SLA definitions and targets, monitoring responsibilities, support model (incident management, escalation), Operations View Dashboard, scheduled downtime windows.
> **See also**: `security-and-compliance.md` (for compliance-related ops, SOC, certifications), `cross-cutting/identity-and-access.md` (for admin access controls), `cross-cutting/clean-core-strategy.md` (for clean core KPIs in Operations View)

---

## Sources

| Source | URL | Type |
|--------|-----|------|
| RISE with SAP PCE Cybersecurity FAQ Explained | https://community.sap.com/t5/technology-blog-posts-by-sap/rise-with-sap-s-4hana-cloud-private-edition-cybersecurity-faq-explained/ba-p/13562875 | SAP Community Blog |
| RISE with SAP: Shared Security Responsibility for SAP Cloud Services | https://community.sap.com/t5/technology-blog-posts-by-sap/rise-with-sap-shared-security-responsibility-for-sap-cloud-services/ba-p/13497110 | SAP Community Blog |
| RISE with SAP: Navigating Vulnerability and Patch Management in SAP ECS – Part 1 | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/rise-with-sap-navigating-vulnerability-and-patch-management-in-sap/ba-p/13579850 | SAP Community Blog |
| Introducing the RISE with SAP Methodology Dashboard: Operations View | https://community.sap.com/t5/enterprise-resource-planning-blog-posts-by-sap/introducing-the-new-rise-with-sap-methodology-dashboard-operations-view/ba-p/14131775 | SAP Community Blog |
| RISE Roles and Responsibilities document | https://www.sap.com/sea/about/agreements/policies/hec-services.html | SAP Agreements |

---

## SAP Success Plans (March 2026)

SAP transitioned to a **cloud-first, AI-driven engagement model** for support in March 2026. The portfolio consists of three tiers:

| Plan | Availability | Focus |
|------|--------------|-------|
| **Foundational Success Plan** | **Included** with all cloud subscriptions | Onboarding, technical cloud operations, and preventive support. |
| **Advanced Success Plan** | Additional fee | Risk detection, optimization, and AI-powered activation sessions. |
| **Max Success Plan** | Premium fee (evolved MaxAttention) | Dedicated Success Plan Manager, cross-solution process improvement, and AI scaling. |

### Key Features of the Foundational Success Plan

- **Operational Continuity**: Essential monitoring and basic cloud efficiency.
- **AI-Enabled Support**: Preventive mission-critical support powered by AI (Joule).
- **Application Lifecycle Management (ALM)**: Included via SAP Cloud ALM for structured transformation.

---

## SAP-Managed Operations Model

SAP Enterprise Cloud Services (ECS) operates the full technology stack under one end-to-end SLA:

| Layer | SAP Responsibility |
|-------|-------------------|
| Infrastructure (hyperscaler) | VM, storage, networking, provisioning |
| Operating System | OS installation, hardening, patching |
| HANA Database | Installation, configuration, patching, HANA replication |
| S/4HANA Application | Technical basis support, kernel updates, SPS/SP patching |
| Security Operations | 24×7 SOC, vulnerability management, EDR, SIEM |
| Backup & Restore | Automated backups, encryption, restore operations |
| HA / DR | HANA System Replication, autorestart, optional DR |

### Customer-Managed Scope

| Responsibility | Owner |
|---------------|-------|
| S/4HANA application configuration and business processes | Customer |
| User identity, roles, and authorizations | Customer |
| Custom development and extensions | Customer |
| Integration and third-party system connections | Customer |
| Application security audit logging | Customer |
| Application change management (transports) | Customer |
| Dedicated private connectivity to hyperscaler | Customer |
| Application regression testing after patches | Customer |

---

## System Availability SLA

| SLA Metric | Value |
|------------|-------|
| **Standard System Availability SLA** | **99.7%** |
| Scope | Infrastructure + OS + DB + Application layer (end-to-end) |
| SAP responsibility boundary | Technical availability of the stack |
| Customer responsibility | Logical integrity of business data |

### HA Architecture

SAP deploys High Availability technology to maintain the SLA:
- **HANA System Replication (HSR)**: synchronous in-region replication
- **Auto-Restart**: application server automatically restarted on failure
- **Reserved Instances**: predictable capacity, no auto-scaling

> Autoscaling in the traditional IaaS sense is **not applicable** for PCE. Capacity is based on Reserved Instances for the contract term. Changes require a formal Change Request.

---

## Disaster Recovery

DR is an **optional service** — not included by default. Customers must explicitly contract DR.

| DR Option | RPO | RTO |
|-----------|-----|-----|
| Short Distance DR (same metro area) | 0 (synchronous) | 12 hours |
| Long Distance DR (cross-region) | 30 minutes | 12 hours |
| Enhanced DR | Per agreement | 4 hours |

> Contact Cloud Architect Advisory (CAA) to design and price a DR solution.

---

## Backup and Restore

SAP ECS manages all backup operations (SAP Note 3572444):

| System Type | Full Backup | Log Backup | Retention |
|-------------|------------|------------|-----------|
| **Production (PRD)** | Daily | Every 10 minutes | 30 days |
| **Non-Production (QAS/DEV/SBX)** | Weekly | — | 14 days |

- Backups are **encrypted** (AES-256 via IaaS Server-Side Encryption)
- Restore operations performed by SAP ECS **on request via Customer Dashboard** — customers cannot trigger restore independently
- Upon contract expiry: customers can receive a **system export** or **native database backup** (restorable on their own hyperscaler)

---

## Security Patch Management

SAP operates a structured vulnerability and patch management program under CVSS v3.1 scoring:

### Vulnerability Severity Levels (CVSS v3.1)

| Severity | CVSS Score |
|----------|-----------|
| Critical | 9.0 – 10.0 |
| High | 7.0 – 8.9 |
| Medium | 4.0 – 6.9 |
| Low | 0.1 – 3.9 |

### SAP Vulnerability Advisory Services (VAS)

- Internal SAP team monitoring NIST NVD daily feeds + software vendor security advisories
- Risk-based prioritization: environment (DEV/PRD), severity, likelihood, existing controls
- Publishes SAP CERT Notifications (SCNs) for relevant vulnerabilities

### SAP ECS Patch Management Process

1. SAP examines available patches and creates **deployment bundles**
2. Patches are **tested** before release
3. Customers submit a **Service Request via Customer Dashboard**
4. Customers authorize **downtime during Maintenance Period**
5. SAP ECS applies the patches
6. Customer performs **application regression testing** post-patching

> **Shared responsibility**: SAP patches infrastructure/OS/DB. Customers patch their application layer and perform regression testing.

### Zero-Day Vulnerabilities

When no patch is available:
- SAP ECS performs a **risk assessment** with the risk coordinator
- **Mitigating controls** are applied to prevent exploitation
- Exception requests follow the established exception management process

---

## S/4HANA Application Patching Cadence

| Update Type | Frequency | Description |
|-------------|-----------|-------------|
| **SPS (Support Package Stack)** | ~Annual | Major S/4HANA functional update bundle |
| **SP (Support Package)** | Within SPS cycle | Specific functional corrections |
| **Kernel patches** | Per SAP schedule | Technical infrastructure below application |
| **OS/DB patches** | Regular (per contract) | Infrastructure security and stability |

> **PCE release cycle**: Two-year major release cycle (vs 6-month for Public Edition). Maintenance windows are seven years per release.

---

## Monitoring and Observability

### SAP Cloud ALM for Operations

Available to all RISE customers:

| App | Purpose |
|-----|---------|
| **Health Monitoring** | System health metrics: availability, connectivity, performance |
| **Integration & Exception Monitoring** | ABAP Runtime Errors, System Log, Application Log |
| **Job & Automation Monitoring** | Background job status and failure tracking |
| **Real User Monitoring** | End-user experience monitoring |

### Operations View Dashboard (RISE Methodology Dashboard)

A daily report on system health aligned to clean core operations principles:

**System Health Score**: Calculated from 4 KPIs:

| KPI | Weight | What It Measures |
|-----|--------|-----------------|
| **Connectivity** | 50% | SAP Cloud ALM connectivity to managed systems |
| **Exceptions** | 25% | ABAP Runtime Errors and System Log anomalies |
| **Background Processing** | 15% | Failed background jobs |
| **Performance** | 10% | Average response time (<4s SLA), Max response time (<200s) |

**Score thresholds**:
- ≥ 85%: Green (good)
- 70–84%: Warning (investigate)
- < 70%: Critical (action required)

**Setup requirements**:
1. Role: `Operations Dashboard Viewer` assigned in SAP Cloud ALM
2. Health Monitoring and Integration & Exception Monitoring apps configured for S/4HANA systems
3. Categories activated: **ABAP Runtime**, **ABAP System Log**, **ABAP Application Log**
4. ST-PI add-on version: **ST-PI 740 SP28** minimum

> Data collected daily. Up to 30 days of historical data available. Productive systems only.

---

## Audit Logging

| Log Type | Managed by | Customer Access |
|----------|-----------|-----------------|
| Application Security Audit Logs | Customer | Full access |
| Infrastructure Logs (Firewalls, LBs, Proxies, DBs) | SAP ECS | Centrally managed; event correlation shared |
| OS/DB Logs | SAP ECS | Available near-real-time via **LogServ** additional service (SIEM integration) |

---

## Support Model

### Incident Channels

- **SAP ONE Support Launchpad**: Primary incident submission channel
  - URL: [launchpad.support.sap.com](https://launchpad.support.sap.com/)
  - Reference: SAP Note 1296527
- **Customer Dashboard**: Used for Service Requests (patch authorization, capacity changes, etc.)

### Security Incident Response

SAP SOC follows a structured incident response process:

```
Detection → Analysis → Containment → Eradication → Recovery → Post-Incident Analysis
```

Playbooks maintained for:
- Phishing
- Malware/virus outbreak
- Privilege escalation
- Improper usage
- Unauthorized access
- Unauthorized disclosure
- Data deletion
- Data theft

> SAP SOC operates **24×7** following one global process. All operations staff are trained in incident response execution.

---

## Customer Dashboard

The Customer Dashboard is the primary self-service portal for RISE with SAP customers:

- Submit Service Requests (patches, capacity changes, DR testing)
- View system status and availability
- Manage maintenance windows and downtime authorizations
- Access to operational KPIs

---

## Scheduled Maintenance

- Customers must define and authorize **Maintenance Windows** for downtime-requiring activities
- SAP executes patches and maintenance only within authorized windows
- **Protect Production, Protect the Program**: non-negotiable principle — no unauthorized production changes

---

**Last Updated**: 2026-03-10
**Sources verified**: 2026-03-10

---

## SAP Notes Reference

> Key SAP Notes for Operations and SLA. Full master list: see `sap-notes-master-list.md` in workspace root.

### EarlyWatch Alert (EWA)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1257308](https://me.sap.com/notes/1257308) | FAQ: Using EarlyWatch Alert | Comprehensive FAQ: EWA generation (SM20/SDCCN), EWA report navigation (chapters/sub-chapters), alert rating logic (red/yellow/green), and how to act on EWA findings. In PCE, EWA is auto-generated; customers access it via SAP for Me. Contains guidance on ICF Security, Number Ranges, ABAP Runtime Errors, and system performance sub-chapters. |
| [2520319](https://me.sap.com/notes/2520319) | How to access the SAP EarlyWatch Alert apps in SAP for Me | Access EWA via SAP for Me (new portal) |
| [2902989](https://me.sap.com/notes/2902989) | Information on EWA - Red rating for sub-chapter Critical Number Ranges | Rolling NR object exhaustion = no issue (numbers reused from start, EWA red is informational). Non-rolling NR exhaustion = critical — consult application owner to extend or reorganize. EWA also shows predictive estimated end date based on current consumption rate. Stale (unused) NR objects automatically removed from EWA display after 3 weeks. |
| [3416010](https://me.sap.com/notes/3416010) | EWA - Exhausted Number Range Buffers | Number range buffer exhaustion: EWA alert and resolution |
| [3553081](https://me.sap.com/notes/3553081) | EWA - Number Range Trace | Tracing number range issues flagged in EWA |
| [3067195](https://me.sap.com/notes/3067195) | EarlyWatch Alert Dashboard: User Experience section is missing | Troubleshooting missing UX section in EWA dashboard |
| [3658231](https://me.sap.com/notes/3658231) | Automating Email Notifications for EarlyWatch Alerts in Solution Finder | Automate EWA alert notifications |
| [3613154](https://me.sap.com/notes/3613154) | Cannot send EWA via email from RISE with SAP system | Known restriction: EWA email sending from PCE systems |
| [2947886](https://me.sap.com/notes/2947886) | Getting started with Custom Code Analytics based on EWA | Using EWA data for custom code analytics in ATC |

### SGEN (System Generation)

> **Key rule**: Run SGEN immediately after systems are delivered and before GoLives.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1989778](https://me.sap.com/notes/1989778) | FAQ: SGEN | Comprehensive FAQ for SGEN — when, why, and how to execute system generation |

### ECS Service Requests and Customer Dashboard

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3399927](https://me.sap.com/notes/3399927) | How to create a case when support is needed for an SAP Enterprise Cloud Services (ECS) system | How to open support cases for ECS-managed RISE systems |
| [3441135](https://me.sap.com/notes/3441135) | System Copy - Service Request Handling for ECS managed Systems | System copy service requests in ECS-managed environments |
| [3432011](https://me.sap.com/notes/3432011) | How to check the closed/confirmed Service Requests | Check status of closed ECS service requests |
| [3239384](https://me.sap.com/notes/3239384) | How to use Service Requests application | Using the Service Requests app in Customer Dashboard |
| [2720477](https://me.sap.com/notes/2720477) | How to access Private Cloud Service Requests | Accessing RISE/PCE service requests |
| [2669783](https://me.sap.com/notes/2669783) | S-user authorizations required for the Private Cloud Service Request application | Required S-user roles for service request access |
| [3463116](https://me.sap.com/notes/3463116) | Missing template(s) when creating service request | Troubleshooting missing SR templates |
| [3547344](https://me.sap.com/notes/3547344) | "Access to Service Request is not released yet" error when creating a new service request | Error resolution for SR access issues |

### Backup Policy in RISE

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3572444](https://me.sap.com/notes/3572444) | What is the standard backup policy in RISE for production and non-production systems? | **PRD**: daily full backup, 30-day retention, log backup every 10 minutes. **Non-PRD** (QAS/DEV/SBX): weekly full backup, 14-day retention. All backups encrypted. Restore via Customer Dashboard Service Request only — customer cannot trigger restore independently. |

### ECS Parameter Management

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3460793](https://me.sap.com/notes/3460793) | [ECS] Cannot modify Default Profile in transaction (RZ10) in Business Clients | RZ10 modification restrictions in ECS-managed systems |
| [3517086](https://me.sap.com/notes/3517086) | Non-Security Parameters for ABAP systems in SAP Enterprise Cloud Services (ECS) | Which non-security parameters customers can request to be changed in ECS |
| [3435333](https://me.sap.com/notes/3435333) | AL11 Usage, Restrictions, and Support for HEC/ECS Managed Systems | AL11 file browser restrictions in ECS environment |

### SAP Cloud ALM Operations Integration

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3396216](https://me.sap.com/notes/3396216) | SAP Cloud ALM on-premise system prerequisites for successful registration, Implementation and Operations | Prerequisites for SAP Cloud ALM registration (on-premise and PCE systems) |
| [3454314](https://me.sap.com/notes/3454314) | What to request of SAP Private Cloud (formerly ECS/HEC) when they need to allow SAP Cloud ALM Registration | Firewall/allowlist requests needed to register PCE systems in Cloud ALM |
| [3576114](https://me.sap.com/notes/3576114) | No systems shown in RISE with SAP - System View in Cloud ALM | Troubleshooting missing systems in Cloud ALM System View |
| [3209256](https://me.sap.com/notes/3209256) | Creating User Stories and Sub-Tasks in SAP Cloud ALM | User story management in Cloud ALM |

### Technical Job Management (SJOBREPO)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3236399](https://me.sap.com/notes/3236399) | FAQ - Technical Job Repository (SJOBREPO) | Master FAQ for SJOBREPO — critical for PCE Basis teams |
| [3085988](https://me.sap.com/notes/3085988) | Technical Job not Scheduled in S/4HANA SJOBREPO due to "Not in Scope" Status | Jobs with "Not in Scope" status — how to investigate and resolve |
| [3194839](https://me.sap.com/notes/3194839) | How to change the step user for standard jobs | Changing step user for standard SJOBREPO jobs |
| [3465195](https://me.sap.com/notes/3465195) | Why DDIC or SAP_SYSTEM users are assigned as step users in SJOBREPO? | Explanation of default step users in technical jobs |
| [3190922](https://me.sap.com/notes/3190922) | New authorization concept for application jobs | New authorization model for application jobs (S/4HANA 2022+) |
| [2731999](https://me.sap.com/notes/2731999) | Assign custom step user for Technical Job Repository (SJOBREPO) | How to assign custom users as job step users |
| [3438433](https://me.sap.com/notes/3438433) | Show technical users in the 'Maintain Job Users' app | Show technical users in job user maintenance app |
| [3580119](https://me.sap.com/notes/3580119) | Change Application Job user to a technical user / batch user in OnPrem or Private Cloud (HEC) system | Change job user to batch user in PCE |
| [3441346](https://me.sap.com/notes/3441346) | Enable 'Maintain Job Users' app for OnPremise | Enabling Maintain Job Users app on PCE/on-premise |
| [3712902](https://me.sap.com/notes/3712902) | Check when BTCTRNS1 / BTCTRNS2 were run | Verify background transfer job execution times |

### System Performance

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2689405](https://me.sap.com/notes/2689405) | FAQ: SAP S/4HANA Performance Best Practices - Collective Note | Collective note for S/4HANA performance — covers work processes, memory, I/O |
| [2178632](https://me.sap.com/notes/2178632) | Key Monitoring Metrics for SAP on Microsoft Azure | Azure-specific monitoring metrics for SAP workloads |
| [2469354](https://me.sap.com/notes/2469354) | Key Monitoring Metrics for SAP on IaaS Infrastructure | General IaaS monitoring metrics (applies to all hyperscalers) |
| [3218414](https://me.sap.com/notes/3218414) | Determining the Number of Work Processes for Linux/Unix | Work process sizing on Linux (relevant for SAP on Azure/AWS/GCP) |
| [1382721](https://me.sap.com/notes/1382721) | Linux: Interpreting the output of the command 'free' | Understanding Linux memory output on SAP systems |
| [2085980](https://me.sap.com/notes/2085980) | New features in memory management as of Kernel Release 7.40 | Memory management improvements in newer kernel versions |

### Transport Management in PCE

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2597323](https://me.sap.com/notes/2597323) | Transport directory between SAP RISE environment and OnPremise TMS landscape | TMS configuration between RISE and on-premise systems |
| [3482742](https://me.sap.com/notes/3482742) | Transport Management in S/4HANA Cloud - Central KBA | Central KBA for transport management in S/4HANA Cloud (PCE) |
| [2660797](https://me.sap.com/notes/2660797) | Transport Extensibility Objects SAP S/4HANA | Transporting extensibility objects (custom fields, BAdI implementations) |
| [1688610](https://me.sap.com/notes/1688610) | TMS import queue warning message: 'Does not match component version' or 'Checking components of the | Common TMS warning: component version mismatch resolution |
| [1742547](https://me.sap.com/notes/1742547) | Information about component version check in TMS | Component version check behavior in TMS import queues |
| [1803986](https://me.sap.com/notes/1803986) | Rules to use SUM or SPAM/SAINT to apply SPs for ABAP stacks | When to use SUM vs SPAM/SAINT for SP application |

### Client Management

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1998094](https://me.sap.com/notes/1998094) | Multiple Productive Clients - SCC4 | Managing multiple productive clients — restrictions in PCE |
| [2953662](https://me.sap.com/notes/2953662) | Recommendations for remote client copy performance improvements in S/4HANA | Performance optimization for remote client copies |
| [1922762](https://me.sap.com/notes/1922762) | System Copy: Task Content (6. Improvements) | System copy task list details |
| [3441097](https://me.sap.com/notes/3441097) | Client administrative actions restrictions for Server Status Change - Shutdown control | Restrictions on client admin actions in ECS-managed systems |

### Number Range Management

> **Key rule**: EWA "Critical Number Ranges" red alerts must be distinguished by buffering type — rolling exhaustion is harmless, non-rolling is critical.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2230754](https://me.sap.com/notes/2230754) | Critical Number Ranges: How to Set Up Number Range Monitoring in RZ20/RZ21 | Setup via RZ21: create method **CCMS_NRHOT_COLLECT** (report RSNUMCCM, params MAXALERT/NOROLL) and **CCMS_NRHOT_ANALYZE** (FM NUMBER_RANGE_CCM_ANALYZE). Alerts appear in RZ20 under "SAP CCMS Technical Expert Monitor". MAXALERT = threshold % for alert; NOROLL = flag to alert only on non-rolling ranges. |
| [1843002](https://me.sap.com/notes/1843002) | Number Ranges - Gaps in Number Ranges | 4 buffering types: **Main Memory** (gaps expected — numbers lost on rollback/system restart); **Parallel Buffering** (no numbers lost, but chronological order not guaranteed); **Parallel Buffering pseudo-ascending** (documented gaps stored in NRIV_DOCU, visible via RSSNR0S1); **No Buffering** (no gaps, significant performance impact). Use SNUM or SNRO to check buffering type for any NR object. |
| [2292041](https://me.sap.com/notes/2292041) | Number Ranges - Monitoring Intervals | Report **RSNUMHOT** checks NR intervals over warning threshold %. Transaction **SNUM_CCMS** for direct display. Key columns: Maxalert (red = over threshold), Definition (red = reached object warning%), non-roll (X = non-rolling). **Rolling**: when exhausted, reuses from start — no action needed. **Non-rolling**: must extend or consult application team before exhaustion. |

### Cloud Connector Connectivity

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2377425](https://me.sap.com/notes/2377425) | Cloud Connector: Connectivity Requirements | Cloud Connector requires only **outbound port 443** to SAP BTP regional host — no inbound ports required. For HA setup (two SCC nodes), **port 8443** must be open between nodes for shadow/master communication. Firewall rules are customer-managed for on-premise side; ECS manages the BTP-side allowlist. Reference: Help Portal "Prerequisites" by BTP region for exact target hostnames. |

### ECS Proactive Notifications

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3291540](https://me.sap.com/notes/3291540) | ECS Proactive Notification: How to Respond to SAP ECS Emails | When ECS sends a **proactive email recommending customer action** (e.g., apply patch, perform parameter change), the correct channel is to open a **Service Request via Customer Dashboard** (me.sap.com) — **NOT** a standard SAP Support incident, unless the email explicitly states to open an incident. Opening an incident for ECS-managed action requests causes routing delays. |

### ECS ABAP User Management

> **Key rule**: In ECS-managed PCE systems, SAP manages OS/DB users; customers get a defined set of ABAP dialog/system users.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [3351928](https://me.sap.com/notes/3351928) | ECS ABAP User Management — Standard Users and Emergency Procedures | Standard ECS user set: **[SID]_ADMIN** (productive client, initial dialog user for greenfield delivery), **CUST1/CUST2/CUST3/CUST4** (client 000 dialog users), **CUSTRFC** (client 000 system user for 3rd-party RFC connections), **CUST_TC** (one-time config user, 96h validity), **CUST_LM** (SPAM/SAINT addon import, 14-day validity). Emergency lockout recovery: SR template "Enable SAP* user in customer client" — requires 2 maintenance windows minimum 4h apart, predefined password, limited time window. Customers cannot create OS-level users. |

### ICF Service Deactivation via EWA

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [2989913](https://me.sap.com/notes/2989913) | How to Deactivate ICF Services Using EWA Report | Step-by-step: EWA report → ICF Security sub-chapter → download inactive service list as **XLSX** → convert to CSV → SA38 → report **RS_ICF_SERV_MASS_PROCESSING** → option "Deactivate for All Virtual Hosts Listed in CSV File" → verify result in SICF transaction. Recommended after system delivery to reduce attack surface. EWA flags ICF services active but not needed for the current system usage pattern. |

---

**Last Updated**: 2026-03-16
**Sources verified**: 2026-03-16 (note titles from RISE BTP Toolbox community blog)
