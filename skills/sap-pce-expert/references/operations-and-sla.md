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


### Additional Notes (2026 Enrichment)

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1177315](https://me.sap.com/notes/1177315) | ADS RFC destination test return 403 / 404 / 405 / 500 code | ADS RFC SM59 connection-test HTTP 403/404/405/500 codes are harmless; validate Adobe Document Services form processing with report FP_PDF_TEST_00 instead. |
| [1616303](https://me.sap.com/notes/1616303) | No further processing of bgRFC units | bgRFC scheduler troubleshooting via SBGRFCCONF/SBGRFCMON/SM12 (watchdog RS_BGRFC_SCHEDULER_STARTUP, supervisor destination auth) relevant to basis operating async processing on PCE S/4HANA. |
| [1662432](https://me.sap.com/notes/1662432) | Launching transaction to start webgui | Transaction WEBGUI launches SAP GUI for HTML over HTTPS in a new browser, relevant to browser-based access to PCE S/4HANA where native SAP GUI is restricted. |
| [1679938](https://me.sap.com/notes/1679938) | DiskFullEvent on Log Volume | HANA log-volume-full recovery (symlink workaround, ALTER SYSTEM RECLAIM LOG, reserved backup segments SPS06+) relevant to HANA DB operations and backup handling on PCE. |
| [1755745](https://me.sap.com/notes/1755745) | ASSERTION_FAILED dumps at User switch statement in bgRFC | After a PCE system/client copy or app server change, bgRFC units cause ASSERTION_FAILED user-switch dumps; delete stale units in all clients via SBGRFCMON mass operations or report RS_BGRFC_MASS_PROCESSING (soft delete). |
| [1839315](https://me.sap.com/notes/1839315) | Cannot delete bgRFC units after a system copy | When bgRFC user-switch dumps persist and SBGRFCMON blocks deletion of WS/SRT units, temporarily deactivate the check class in SBGRFCCONF (Scheduler:Destination tab) to delete the unit, then re-enable; relevant after PCE system copies. |
| [1914112](https://me.sap.com/notes/1914112) | HTTP session times out before the time limit defined in rdisp/plugin_auto_logout or rdisp/gui_auto_logout | Fiori/WebGUI users disconnect early because http/security_session_timeout is lower than rdisp/gui_auto_logout / rdisp/plugin_auto_logout; align the parameters and check SICF service SESSION TIMEOUT (SM21 R2G entries). |
| [2025332](https://me.sap.com/notes/2025332) | Urgent change import and Normal Change import fails with requests does not match the component version of the target system - Solution Manager | ChaRM/TMS imports fail on component-version mismatch (XT216/AGS_TD824); set SP_TRANS_SYNC=OFF to bypass, relevant to transport operations across PCE system tracks. |
| [2200503](https://me.sap.com/notes/2200503) | FAQ Number ranges (BC-SRV-NUM component) | Number range troubleshooting (SNUM buffering, NRIV/NRIVSHADOW locks, gaps/duplicates, NK_REORGANIZE, trace via NK_SET_SYSLOG_PARMS); core basis operations task in PCE. |
| [2211659](https://me.sap.com/notes/2211659) | High memory usage or long responses times for program SAPMS380 | Set abap/rabax_no_debug=on to stop SAPMS380 dump-display holding memory after TSV_TNEW_PAGE_ALLOC_FAILED; a memory-tuning profile parameter for PCE basis operations. |
| [2231751](https://me.sap.com/notes/2231751) | NR: Monitoring | Adds number-range interval monitoring (RSNUMCCM/RSNUMHOT, NUMBER_RANGE_CCM_ANALYZE) to flag intervals near their warning-percentage threshold; proactive basis monitoring in PCE. |
| [2309399](https://me.sap.com/notes/2309399) | How to use SBGRFCCONF effectively? | SBGRFCCONF bgRFC scheduler tuning (scheduler count, open connections, retries, inbound/supervisor destinations); operations/performance config for S/4HANA PCE queue processing. |
| [2314083](https://me.sap.com/notes/2314083) | Not able to implement an SAP note | SNOTE implementation failures explained by SP level vs correction-instruction validity range; generic note-application troubleshooting applicable to S/4HANA PCE maintenance. |
| [2342391](https://me.sap.com/notes/2342391) | How to access and use the SAP HotNews application - SAP for Me | Using the SAP for Me HotNews app to review, filter, confirm and subscribe to Priority-1 SAP Notes per favorite system, key for staying on top of critical fixes in PCE operations. |
| [2362875](https://me.sap.com/notes/2362875) | UI2 Caches and their synchronization with the database | UI2 server-side caches (/UI2/PAGE_BUILDER, INTEROP, START_UP) on the Fiori Frontend Server; explains event/non-event-driven invalidation and warns against manual invalidation (report /UI2/INVALIDATE_GLOBAL_CACHES) to preserve FLP performance. |
| [2385767](https://me.sap.com/notes/2385767) | How to run the generation tools in common use for ABAP programs | ABAP load generation tools SGEN and TOUCHSRC/TAB/INC/ALL to resolve LOAD_*_MISMATCH dumps after upgrades/patches; TOUCHALL restricted to off-hours with SAP approval, relevant to PCE patching/upgrade operations. |
| [2391632](https://me.sap.com/notes/2391632) | TA133 : Target client is productive and protected against client copy | SCC9/SCCL/SCC1 error TA133 caused by SCC4 client role 'Productive' (not the copy-protection level); temporarily change client role to run client copy, relevant to client administration in PCE systems. |
| [2394975](https://me.sap.com/notes/2394975) | FAQ: CQC Service Results | Interpreting CQC / EarlyWatch service reports (parameters, security, sizing, performance ratings); Q5 directs ECS customers to raise 'Analyze Recommendations from EWA/CQC' requests via the ECS Service Request app, relevant to PCE managed-service operations. |
| [2407161](https://me.sap.com/notes/2407161) | Launchpad or application fails to load with the error "Our service is not available at the moment" | Web Dispatcher generic error (SSL handshake SSSLERR_PEER_CERT_UNTRUSTED / permfile permission denied); note directs HEC/managed-cloud systems to raise the availability issue with SAP ops (component PCO-OPS) per RISE shared-responsibility. |
| [2457912](https://me.sap.com/notes/2457912) | How to create a content repository in OAC0? | OAC0 content repository setup against SAP Content Server (ArchiveLink) for S/4HANA document archiving in PCE, incl. CSADMIN, signatures, RSCMST test report. |

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

| [3002279](https://me.sap.com/notes/3002279) | How to check the SAP HANA Database backup status? | Use monitoring views M_BACKUP_CATALOG and M_BACKUP_PROGRESS (via DBACOCKPIT or DB02) to verify full/log backup status and progress in PCE. |
| [3006773](https://me.sap.com/notes/3006773) | How to check DB SIZE HISTORY | Use DBACOCKPIT or SQL collection (Note 1969700) to monitor HANA disk and memory usage trends over time. |
| [3398620](https://me.sap.com/notes/3398620) | System alias configuration for taskprocessing service | Verification of SPRO settings for TASKPROCESSING (OData V2) essential for Fiori "My Inbox" in PCE. |
| [3556427](https://me.sap.com/notes/3556427) | Check apps assigned to specific users in FLP | Use /UI2/FLIA (Launchpad Intent Analysis) to troubleshoot app visibility and role assignments in PCE. |
| [3712902](https://me.sap.com/notes/3712902) | Check when BTCTRNS1 / BTCTRNS2 were run | Monitoring system suspension/release times for background jobs during PCE maintenance windows. |
| [3640031](https://me.sap.com/notes/3640031) | External Debugging in SAP-RISE systems | Configuration guide for ABAP external debugging (HTTP/RFC) considering PCE network restrictions and debug user setup. |

| [3192420](https://me.sap.com/notes/3192420) | SAP ECS Operations Guide for Customers | The definitive guide for PCE customers: covers support processes, maintenance windows, and standard service catalog. |
| [3302322](https://me.sap.com/notes/3302322) | SAP ECS Shared Responsibility Model | Clarifies the boundary between SAP (Infra/DB/OS) and Customer (App/Data/Users) management. |
| [3239384](https://me.sap.com/notes/3239384) | Using Service Requests application | Instructions for requesting standard ECS tasks (refreshes, parameter changes) via SAP for Me. |
| [3158023](https://me.sap.com/notes/3158023) | How to request a kernel upgrade in ECS | Process for customer-triggered kernel updates via service requests. |
| [3262621](https://me.sap.com/notes/3262621) | ECS Patching Policy | Guidelines on the delivery and application of security patches and Support Packages in PCE. |
| [3218503](https://me.sap.com/notes/3218503) | How to request a system copy in ECS | Procedure for system refreshes (e.g., PRD to QAS) within the PCE managed environment. |
| [3139361](https://me.sap.com/notes/3139361) | ECS Backup Strategy and Retention | Standard backup frequencies and 30-day retention policies for production systems. |
| [1843002](https://me.sap.com/notes/1843002) | Gaps and jumps in number range assignment | Explains technically why gaps occur (buffering) and why they are not signs of data loss in PCE. |
| [2230754](https://me.sap.com/notes/2230754) | Critical Number Ranges in RZ20 | Guide to setting up CCMS alerts for number range exhaustion. |
| [2520319](https://me.sap.com/notes/2520319) | How to access the SAP EarlyWatch Alert apps in SAP for Me | Requirements for accessing health reports provided by SAP ECS. |
| [2731999](https://me.sap.com/notes/2731999) | Custom step user for Technical Job Repository (SJOBREPO) | Managing background job scheduling via the modern V2 repository in PCE. |

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

### Basis Administration — ICF and RFC

> Notes for managing ICF services (SICF) and RFC connectivity in S/4HANA PCE. ICF hardening and RFC callback controls are customer responsibility; ECS handles OS/network layer.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1455095](https://me.sap.com/notes/1455095) | ICF verification services | Lists ICF verification/test services that should be **deactivated in production**. Activate temporarily in DEV/QA for diagnostics; disable immediately after. Standard hardening step recommended by ECS upon system delivery and flagged in EarlyWatch Alert. |
| [1498575](https://me.sap.com/notes/1498575) | Mass processing of ICF services | Report `RS_ICF_SERV_ADMIN_TASKS` for bulk ICF service activation/deactivation. Supports CSV-based mass operations. Used in combination with EWA report to deactivate unused services (see Note 2989913 for EWA-driven workflow). |
| [2330899](https://me.sap.com/notes/2330899) | ICF Ping Service | The ICF Ping service (`/sap/bc/ping`) — lightweight availability check endpoint. Use to verify ICF stack reachability from Web Dispatcher or monitoring tools. Should be activated but access-controlled in production. |
| [2661761](https://me.sap.com/notes/2661761) | ICF Services — what is mandatory and what can be deactivated? | Decision guide for ICF service hardening: which services are mandatory for S/4HANA operation vs. which are optional and can be safely deactivated. Essential reference for security hardening in PCE after system delivery. |
| [2573379](https://me.sap.com/notes/2573379) | How to adjust the logon procedure list of an ICF service | Configure the authentication/logon procedures (basic auth, SAML2, SPNEGO, X.509 certificate) accepted per ICF service node. Relevant for tightening authentication on Fiori and OData endpoints in PCE. |
| [3317801](https://me.sap.com/notes/3317801) | Connecting to Message Server of ASCS instance for HTTP load balancing | Configure HTTP load balancing via the Message Server (ASCS instance). Relevant for Web Dispatcher setup in PCE — ECS manages the ASCS; customer configures Web Dispatcher routing rules via Service Request. |
| [3372505](https://me.sap.com/notes/3372505) | ICF — How to transport SICF services | Procedure to transport ICF service configurations (activation status, logon procedures, handlers) across landscapes using change request transport. Critical for propagating ICF hardening from DEV → QAS → PRD in PCE. |
| [2941068](https://me.sap.com/notes/2941068) | SM59/Callback allowlist input validation missing | Security note: SM59 RFC callback allowlist (positive list) input validation fix. In PCE, configure RFC callback positive lists in SM59 to restrict which systems can register RFC server programs — relevant for RFC server security hardening. |
| [2203325](https://me.sap.com/notes/2203325) | Configuration of e-mail using SMTP (inbound) | Step-by-step configuration for SMTP inbound mail processing in AS ABAP (SAPconnect, SCOT). In PCE, outbound SMTP relay is ECS-managed; inbound SMTP configuration (SAPconnect routing, SOST) is customer responsibility. |
| [1640509](https://me.sap.com/notes/1640509) | FAQ about the setup of SCM Optimizer | FAQ covering the SCM Optimizer component's system landscape integration, HA/failover behavior, sizing methodology, multi-core parallelism, and update procedures without downtime; relevant to SCM/TM workloads on PCE and optimization server operations. |
| [2366252](https://me.sap.com/notes/2366252) | Transaction SWU3 explained | Explains every step of SAP Business Workflow automatic customizing via SWU3, covering RFC destinations, background jobs, and the SAP_WFRT system user introduced in S/4HANA 1709; in PCE environments, workflow must be configured per client after system copies and refreshes, and background jobs are managed via Technical Job Repository (SJOBREPO). |
| [2392606](https://me.sap.com/notes/2392606) | Initialization of Web Service Configuration | Provides report SRT_WSP_INITIALIZE_WS_CFG to reset all Web Service configurations (logical ports, endpoints, service registries) after a system copy when PCA tool is not used; directly relevant to post-system-copy cleanup procedures in PCE managed operations. |
| [2980634](https://me.sap.com/notes/2980634) | Release strategy and Maintenance Information for the ABAP add-on UIDP | Covers installation, support package, and upgrade planning for the UIDP 100 add-on (S/4HANA UI Masking + UI Logging) across S4CORE 104–109 / SAP_BASIS 754–816; relevant for PCE customers using data masking or UI logging capabilities and planning upgrades via SUM. |
| [3230401](https://me.sap.com/notes/3230401) | Restrictions and Implementation Recommendations for Production Planning and Detailed Scheduling in SAP S/4HANA 2022 | Consolidates all restriction and implementation recommendation notes for PP/DS embedded in SAP S/4HANA 2022; relevant to PCE customers running S/4HANA 2022 with embedded PP/DS who need to understand scope limitations before go-live. |
| [3348799](https://me.sap.com/notes/3348799) | Print Queues in On Premise Systems | Explains how to enable print queues (access method Q) in S/4HANA Private Cloud and on-premise systems, particularly relevant where standard SPAD printer access methods do not work in PCE environments; requires a specific kernel fix and ABAP correction from note 3420465. |
| [3355416](https://me.sap.com/notes/3355416) | Can a service request be deleted in SAP for Me? | Clarifies lifecycle management of service requests in the SAP for Me Private Cloud Workspace, including cancellation rules, auto-confirmation timelines, and escalation behavior; directly relevant to PCE operational workflows for requesting managed services from SAP Technical Operations. |
| [3358694](https://me.sap.com/notes/3358694) | Integration between SAP Cloud ALM Deployment and SAP Cloud Transport Management service | Describes how to connect SAP Cloud ALM deployment features with the Cloud Transport Management service (cTMS) for cross-account transports, including BTP destination configuration; relevant for PCE customers using Cloud ALM and cTMS as their change transport orchestration layer. |
| [3456190](https://me.sap.com/notes/3456190) | Change application job owner / user | Covers changing job owner or step user of application jobs in on-premise S/4HANA systems using report APJ_CHANGE_JOB_USER or the "Maintain Job Users" Fiori app, available from BASIS 7.57 SP04; relevant for PCE operators managing scheduled job ownership and the new authorization concept for application jobs. |

### High Availability — Standalone Gateway (ASCS)

> Notes for HA-protecting external RFC server programs in the (A)SCS cluster. In PCE, ECS owns the HA cluster (ASCS/ERS); profile changes are requested via Service Request.

| Note ID | Title | Relevance |
|---------|-------|-----------|
| [1010990](https://me.sap.com/notes/1010990) | Configuring a Standalone Gateway in an HA ASCS instance | In an HA/failover cluster where only the (A)SCS instance runs clustered, there is no failover-protected SAP gateway for external RFC server programs (SM59 "Registered Server Program" / "Start on Explicit Host"). Solution: add a standalone gateway (`gwrd`) to the ASCS instance profile so the gateway fails over with the ASCS resource group. Requires kernel PL 640/189, 700/116, or 710+ initial. In PCE the ASCS is ECS-managed — profile edits (`.lst`, instance profile `Start_Program_xx`, `gw/netstat_once`, `services` ports) and cluster resource restart go through a Service Request. Relevant when HA-critical external connectors (EDI, tax, output management) must register against a highly-available gateway. |
| [2430473](https://me.sap.com/notes/2430473) | How to know when a SICF service was last called or used? | Report RS_ICF_SERV_ADMIN_TASKS (table ICF_SERV_STAT, BAdI WORKLOAD_STATISTIC) reveals when a SICF/ICF service was last called - useful in PCE for identifying and deactivating unused HTTP services during hardening, with the caveat that HTTP-trace extraction hits production performance. |
| [2481529](https://me.sap.com/notes/2481529) | ESI - Deletion of WS bgRFC queues via bgRFCMonitor is not possible | Cancel/delete stuck async Web Service messages in PCE via SRT_MONI (Terminate Sequence/Hard Termination), report SRT_UTIL_CANCEL and job SAP_SOAP_RUNTIME_MANAGEMENT — not SBGRFCMON. |
| [2505725](https://me.sap.com/notes/2505725) | How to create HTTP trace in Fiori Launchpad using Google Chrome, Edge or Mozilla Firefox | Capture browser HAR HTTP traces (with 'Allow HAR with sensitive data' for cookies) to diagnose Fiori Launchpad load/app failures for SAP support cases in PCE. |
| [2557255](https://me.sap.com/notes/2557255) | T-code "WEBGUI" usage in SAP GUI for HTML and Fiori | Do not use transaction WEBGUI (nor SMEN) as an FLP target mapping; map specific transactions instead to avoid Launchpad fallback errors when embedding SAP GUI for HTML in PCE. |
| [2626107](https://me.sap.com/notes/2626107) | How to execute task list SAP_ESH_INITIAL_SETUP_WRK_CLIENT | Set up Embedded/Enterprise Search connectors per working client via task list SAP_ESH_INITIAL_SETUP_WRK_CLIENT in STC01 (RFC/DB connection to HANA, pick SAPAPPLH on HANA, then ESH_REFRESH_RUNTIME_BUFFER); enables Fiori Launchpad search on PCE S/4HANA. |
| [2672408](https://me.sap.com/notes/2672408) | Error: "The server took too long to respond" when opening transaction or Web Dynpro apps - Fiori Launchpad | Fiori Launchpad transactional/Web Dynpro apps failing with "server took too long": correct the type-H SM59 destination (host/port, SSL active for _HTTPS / inactive for _HTTP) tied to the app's target-mapping alias, a common PCE Fiori frontend config check. |
| [2731749](https://me.sap.com/notes/2731749) | SAPGUI Apps not opening from Fiori Launchpad | Fix FLP tiles launching SAPGUI apps timing out (server took too long to respond) by clearing system caches per KBA 2319491 — routine Fiori Launchpad operations fix on S/4HANA. |
| [2737656](https://me.sap.com/notes/2737656) | How to increase DP Agent memory - SAP HANA Smart Data Integration | Resolve SDI DP Agent OutOfMemory (GC overhead) by tuning -Xmx/-Xms in dpagent.ini per the sizing guide; note that in ECS-managed PCE this must be requested via a Service Request to SAP. |
| [2861371](https://me.sap.com/notes/2861371) | ES: Changes on CDS-view not effective in Enterprise Search | After a note updates an Enterprise Search CDS view, changes need manual reactivation via ESH_DASHBOARD > Trouble Shooting > CDS Search Views > Activation (R3TR/SESA has no correction instruction) - post-note step for Fiori/Enterprise Search on PCE. |
| [2865994](https://me.sap.com/notes/2865994) | How to add new task in Tasklist? | Add tasks to standard task lists (e.g. SAP_FIORI_CONTENT_ACTIVATION) in STC01 by inserting a class such as CL_STCT_SET_TRANSPORT_OPTIONS - relevant for tailoring basis/Fiori activation task lists on S/4HANA. |
| [2896358](https://me.sap.com/notes/2896358) | How to deactivate CDS connectors in Enterprise Search | Deactivate unwanted CDS search connectors (named <SID>ALL~<CONNECTOR>~ in ESH_ADM_STATUS) via ESH_DASHBOARD > Connectors > Connector details when ESH_COCKPIT delete fails - Enterprise Search admin on S/4HANA. |
| [2948006](https://me.sap.com/notes/2948006) | WDA: Summary on how to check UNCAUGHT_EXCEPTION dump raised in Application Component BC-WD-ABA* | Analyze Web Dynpro ABAP UNCAUGHT_EXCEPTION dumps in ST22 (search "Universal resource ID" for the app) and rule out known framework bugs - practical dump-triage for PCE operations. |
| [3018243](https://me.sap.com/notes/3018243) | Mass delete or unlock bgRFC units in background | Report RS_BGRFC_MASS_OPERATIONS mass-deletes/unlocks bgRFC units in background when SBGRFCMON times out or dumps on large backlogs (mind WS check-class in SBGRFCCONF) - backlog cleanup for basis ops. |
| [3018839](https://me.sap.com/notes/3018839) | Activation/Deactivation of CDS Search Connectors | ESH_COCKPIT/ESH_DASHBOARD activate or deactivate CDS Enterprise Search connectors (@EnterpriseSearch.enabled); on PCE either toggle locally per system or transport the generated #CUSTOMER MDE, never both, or the active/inactive result becomes random. |
| [3073717](https://me.sap.com/notes/3073717) | General Restrictions and Implementation Recommendations for Production Planning and Detailed Scheduling for SAP S/4HANA 2021 | Embedded PP/DS on S/4HANA 2021 requires integrated liveCache setup (SLCA_INIT_FOLLOW_UP, /SAPAPO/OM_CREATE_LC_TABLES, LCA03) plus operational jobs per the install guide; liveCache provisioning/ops is a Basis concern on PCE. |
| [3095424](https://me.sap.com/notes/3095424) | How to execute report /UI5/UPD_ODATA_METADATA_CACHE | Report /UI5/UPD_ODATA_METADATA_CACHE for OData metadata cache is auto-managed/scheduled by the platform in S/4HANA Cloud (PCE); never schedule manually and never run it in dev. |
| [3195506](https://me.sap.com/notes/3195506) | Enterprise CDS search connector ESH_U_SYNCUNIT not found | Embedded Enterprise Search (ESH_DASHBOARD): CDS-based search connector not found on S/4HANA on-premise; resolve via note 2979921 to disable CDS search models in maintenance releases, relevant to PCE search config. |
| [3204802](https://me.sap.com/notes/3204802) | Gaps in Number Range assignment - Guided Answers | Basis Number Range Management (SNRO/SM56, NRIV/NRIVSHADOW buffering) gap and jump analysis for FI/MM/SD document numbering; relevant to PCE compliance and operations troubleshooting. |
| [3211618](https://me.sap.com/notes/3211618) | ESH_COCKPIT can not be used on SAP clould system | On S/4HANA Cloud PCE, ESH_COCKPIT/ESH_MODELER/ESH_SEARCH are blocked (whitelisted URL error); use ESH_DASHBOARD instead for Enterprise Search datasource administration. |
| [3256285](https://me.sap.com/notes/3256285) | "Productive client cannot be used as target client" error happens when schedule the client copy with SCC9N/SCCLN | SCC9N/SCCLN/SCC8N client copy fails with SCCR 059 when SCC4 'Client Copy and Comparison Tool Protection' is Level 1; set it to Level 0 — Basis client-copy admin in PCE. |
| [3257704](https://me.sap.com/notes/3257704) | ADS RFC connection test fails with: 'Create failed' | ADS RFC test in SM59 fails 'Create failed/SR000' from ADS_OAUTH2_PROFILE misconfig; diagnose with OA2C_GENERIC_ACCESS and add ECS proxy per note 3518358 — SAP Forms by Adobe (BTP) setup on S/4HANA PCE. |
| [3288247](https://me.sap.com/notes/3288247) | How to Display logs for SAP NetWeaver User Interface Services | Transaction /UI2/LOG (SLG1 object /UI2/BE) displays Fiori Launchpad UI2 OData/REST logs by subobject (PAGE_BUILDER, TRACE, SANITY_CHECKS); core for troubleshooting Fiori launchpad issues in PCE. |
| [3295193](https://me.sap.com/notes/3295193) | Under which User can an Application Job run? | Explains application-job 'job owner' vs 'job user', external scheduling via SAP_COM_0064/SAP_COM_0326 and API CL_APJ_RT_API, and the SAP_CORE_BC_APJ_JCE catalog for scheduling jobs for other users; relevant to clean-core job scheduling in PCE (no batch-user type). |
| [3301634](https://me.sap.com/notes/3301634) | RS_ICF_SERV_ADMIN_TASKS report exports inactive services too instead active services | Apply SAP Notes 3270421 and 3304446 to fix report RS_ICF_SERV_ADMIN_TASKS (SE38) so its 'Export active services to CSV' excludes inactive SICF services - relevant to ICF/SICF service inventory and hardening in PCE. |
| [3303799](https://me.sap.com/notes/3303799) | How to monitor the activation/deactivation of ICF services | Monitor SICF service state via report RS_ICF_SERV_ADMIN_TASKS (SE38, schedule job + CSV daily diff) and transaction UCON_CHG_DOCUMENTS (who activated/deactivated) - relevant to ICF security monitoring in PCE. |
| [3317058](https://me.sap.com/notes/3317058) | How to find the tp and R3trans version | Check transport tool versions by running program RSBDCOS0 (SE38) with OS command 'tp -v' or 'R3trans -v'; ensure they align with the system kernel release - relevant to PCE transport/upgrade troubleshooting. |
| [3324421](https://me.sap.com/notes/3324421) | How long it will take effect after re-activating the jobs manually in SJOBREPO | SJOBREPO job (de)activation only takes effect after the rdisp/job_repo_activate_time cycle elapses, key for basis managing the Technical Job Repository in PCE. |
| [3365758](https://me.sap.com/notes/3365758) | Why is on-premise system not collecting data in SAP Cloud ALM? | Troubleshoots SAP Cloud ALM Health Monitoring 'No Data' for managed S/4HANA via /sdf/alm_setup push data provider, SLG1 object /SDF/CALM, and unregister/register re-connect. |
| [3389524](https://me.sap.com/notes/3389524) | Jobs in the Technical Job Repository (SJOBREPO) in SAP S/4HANA 2023 | S/4HANA background jobs are JOBD job definitions auto-scheduled by the Technical Job Repository; use SJOBREPO (not SM36/SM37 delete) to deactivate, reschedule, set variants/target servers or email alerts in a PCE system. |
| [3389673](https://me.sap.com/notes/3389673) | How to increase spool number range | SPOOL_INTERNAL_ERROR/spool overflow at 32000 limit; in client 000 via SNRO object SPO_NUM delete extra intervals and raise interval 01 upper bound (e.g. to 999999) - routine PCE basis housekeeping. |
| [3394018](https://me.sap.com/notes/3394018) | How to update bgRFC Supervisor destination | bgRFC Supervisor destination must be maintained in SBGRFCCONF (not SM59); to change it delete the SM59 entry then recreate under Maintain Supervisor Dest - avoid the WS_SRV_ prefix. Relevant to PCE bgRFC config. |
| [3396267](https://me.sap.com/notes/3396267) | FAQs about applications of 'SAP For Me' | SAP for Me portal (me.sap.com) for PCE lifecycle: Systems & Provisioning (availability, connectivity, keys), Finance & Legal (licenses/invoices/consumption), and Services & Support case creation/CIC phone for opening SAP cases. |
| [3404282](https://me.sap.com/notes/3404282) | Connection test in SM59 fails with 'Error when opening an RFC connection (LB: service '***' unknown at SAP-Serv)' | SM59 RFC test fails with message-server service/hostname unresolved; fix /etc/services on all app servers (notes 52959/52967) and verify with niping -v -S via SE38 RSBDCOS0 - basis RFC troubleshooting in PCE. |
| [3420465](https://me.sap.com/notes/3420465) | Print Queues in On-Premise Systems | Print queues (access method Q) for S/4HANA Private Cloud output management where standard SPAD access methods fail; requires kernel patch (Note 3348799) and Internet Inbound (https) setup. |
| [3448332](https://me.sap.com/notes/3448332) | Documentation for Setting Up the My Home in SAP S/4HANA for OP 2023 FPS01 | Configuration to enable the My Home Fiori launchpad homepage on S/4HANA OP 2023 FPS01 (requires all Fiori versions upgraded to 2023 FPS01); setup doc in note attachments. |
| [3480600](https://me.sap.com/notes/3480600) | Getting the user count in Fiori | Determine Fiori app/user usage counts via ST03 workload analysis (on the Gateway, plus SMGW) and report /UI2/FLIA for per-tile FLP access logs; useful for S/4HANA PCE adoption/usage monitoring. |
| [3492298](https://me.sap.com/notes/3492298) | Delete bgRFCs entries from SBGRFCMON | Clear stuck bgRFC units in SBGRFCMON via Mass Operations or report RS_BGRFC_MASS_OPERATIONS on S/4HANA; routine basis housekeeping in a RISE-managed system. |
| [3497859](https://me.sap.com/notes/3497859) | How to use report RSRFCCHK? | Run report RSRFCCHK (Display all RFC destinations) to audit SM59 destinations for trusted/same-user, SNC and stored credentials; RFC-security review in a RISE landscape. |
| [3501423](https://me.sap.com/notes/3501423) | Post mortem debugger is started during dump display | Under memory shortage a dump display can spawn the post-mortem debugger; close the popup or set profile parameter abap/rabax_no_debug, dump still available in ST22; ABAP runtime ops on S/4HANA. |
| [3505803](https://me.sap.com/notes/3505803) | Error MDG_ES_SEARCH000 "Search Object Connector MDG_MATERIAL not Found" occurs | Activate Enterprise Search connectors MDG_MATERIAL/MDG_BUSINESS_PARTNER via STC01 task list SAP_ESH_CREATE_INDEX_SC (SW component MDG_APPL) and verify in ESH_COCKPIT to fix the Manage Material Governance Fiori search error on S/4HANA PCE. |
| [3515405](https://me.sap.com/notes/3515405) | Explanation of Provisioning Status - SAP for Me | SAP for Me Provisioning Status card states (Request Submitted, Provisioning/Conversion Triggered, Error, Provided, Blocking/Blocked read-only at contract end, Unblocking) for tracking RISE cloud-system provisioning lifecycle. |
| [3516937](https://me.sap.com/notes/3516937) | Does Cloud ALM support CTS+ (non-ABAP transport migration)? | SAP Cloud ALM Change & Deployment Management does not (and will not) support CTS+ transport tracks with virtual-only systems for non-ABAP transports (PI/PO, native HANA, BODS); plan an alternative as Solution Manager retires 2027. |
| [3548490](https://me.sap.com/notes/3548490) | Can be transported the setting Security Requirement in SICF? | SICF Security Requirement (field PROTSEC in ICFSERVICE) is transportable, prompting for a transport request on change; relevant to managing ICF/HTTP service security consistently across PCE transport landscape. |
| [3565395](https://me.sap.com/notes/3565395) | Retrieve a List of All Documents Present in the CMIS Repository | Bug fix for report RSCMSLST returning incomplete KPro/CMIS document list (SCMS_DOC_IDLIST); apply note or SP for correct content management document retrieval in S/4HANA. |
| [3581278](https://me.sap.com/notes/3581278) | ADS RFC Connection Test Fails with "Create Failed" - Error in OA2C_GENERIC_ACCESS (NIECONN_REFUSED) | SM59 ADS RFC test to cloud SAP Forms Service by Adobe fails (NIECONN_REFUSED in OA2C_GENERIC_ACCESS); fix the OAuth 2.0 client profile endpoint by using the "url" not "uri" value, relevant for PCE form output. |
| [3607862](https://me.sap.com/notes/3607862) | How to configure Fiori with Rapid Activation procedure for multiple clients in S/4HANA systems with Embedded Deployment | Rerun STC01 Rapid Activation task lists per new client (client-dependent vs client-independent steps) to activate Fiori in embedded-deployment S/4HANA; task lists are idempotent and never overwrite existing settings. |
| [3629081](https://me.sap.com/notes/3629081) | Shared Memory Area of CMIS Client | Fixes a program error where the first connection attempt from S/4HANA (CMIS/SAP Document Integration client) to BTP Document Management Service fails before auto-recovering; apply the correction in PCE systems using DMS document integration. |
| [3658409](https://me.sap.com/notes/3658409) | Issues related to SAP Rise | RISE/PCE support routing: S/4HANA Cloud Private Edition (HEC-managed) issues go via CAA/CDM/TSM roles, else open a ticket under component ECSCTOCH — not standard SAP support. |

---

**Last Updated**: 2026-03-21
**Sources verified**: 2026-03-21 (enriched with real SAP Note content via sap_note_get)
