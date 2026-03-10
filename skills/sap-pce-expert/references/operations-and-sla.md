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

SAP ECS manages all backup operations:

- **Automated regular backups** of HANA database, data files, log files
- Backups are **encrypted** (AES-256 via IaaS Server-Side Encryption)
- Restore operations performed by SAP ECS on request via Customer Dashboard
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
