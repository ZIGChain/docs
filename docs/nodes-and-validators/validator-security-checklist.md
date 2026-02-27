# Validator Security Checklist

This checklist provides baseline security and operational guidance for validators running on a Linux system. It is intended as a **starting point** for self-assessment and does not replace a full security audit.

---

## 1. System & Host Security

| Check | Description |
|------|-------------|
| Non-root operation | Validator process runs as a dedicated, unprivileged user. |
| OS updates | Operating system and kernel are kept up to date. |
| Automatic security updates | Automatic installation of security patches is enabled where appropriate. |
| Minimal services | Unnecessary services and packages are removed or disabled. |
| Mandatory access control | SELinux, AppArmor, or equivalent is enabled and enforced. |
| Secure bootloader | Bootloader access is protected (e.g., GRUB password). |
| File permissions | Validator configuration and data directories are readable only by the validator user. |

---

## 2. Account & Remote Access Hardening

| Check | Description |
|------|-------------|
| SSH key authentication only | Password authentication over SSH is disabled. |
| SSH key protection | SSH private keys are encrypted with a strong passphrase. |
| Root login disabled | Direct SSH access as `root` is disabled. |
| Restricted SSH access | SSH access limited to specific users and/or IP ranges. |
| Brute-force protection | Intrusion prevention tools (e.g., Fail2Ban) are enabled. |

---

## 3. Key & Signing Security

| Check | Description |
|------|-------------|
| External signer | Validator signing keys are not stored on the validator node (e.g., TMKMS or remote signer). |
| Hardware-backed keys | Signing keys are stored in HSMs or hardware wallets where possible. |
| No key duplication | The same validator key is never used on multiple validator instances. |
| Double-sign protection | `double_sign_check_height` or equivalent protection is enabled. |
| Secure backups | Encrypted backups of critical keys are stored offline. |

---

## 4. Networking & Firewall

| Check | Description |
|------|-------------|
| Firewall enabled | Host-level or cloud firewall rules are enforced. |
| Restricted ports | Only required ports are open (e.g., 26656 for P2P, 26660 for monitoring access from monitoring infrastructure). |
| RPC protection | RPC / gRPC endpoints are not publicly exposed. |
| Peer restrictions | Validator node only accepts traffic from trusted sentry nodes. |
| Outgoing traffic controls | Egress traffic is restricted and/or monitored to detect unexpected outbound connections. |
| Rate limiting | Network-level protections against abuse or DoS are applied where possible. |

---

## 5. Sentry Node Architecture

| Check | Description |
|------|-------------|
| Validator isolation | Validator node is not directly exposed to the public internet. |
| Sentry nodes deployed | One or more sentry nodes handle public P2P traffic. |
| Geographic diversity | Sentry nodes are deployed across different regions or providers. |
| Firewall enforcement | Validator firewall allows inbound connections only from sentry nodes. |

---

## 6. Monitoring & Alerting

| Check | Description |
|------|-------------|
| Node metrics | Validator and host metrics are collected (CPU, disk, memory, consensus). |
| Alerting configured | Alerts exist for downtime, missed blocks, disk exhaustion, and peer count. |
| External uptime checks | Independent uptime monitoring is in place. |
| Alert delivery | Alerts are delivered via reliable channels (e.g., PagerDuty, Slack). |

---

## 7. Redundancy & High Availability

| Check | Description |
|------|-------------|
| Standby node | A standby or backup node is prepared for rapid failover. |
| Snapshot backups | Regular snapshots are taken to enable fast recovery. |
| Infrastructure diversity | Validator and sentries are not all hosted on the same provider. |

---

## 8. Updates, Upgrades & Configuration Management

| Check | Description |
|------|-------------|
| Non-breaking upgrades | Tendermint / Cosmos SDK binaries are kept current for non-state-breaking upgrades. |
| State-breaking upgrades | Validator binaries are upgraded in advance of state-breaking network upgrades. |
| Config management | Configuration files are versioned and reproducible (e.g., Git, IaC). |
| Upgrade testing | Upgrades are tested on non-validator nodes before production rollout. |

---

## 9. Communication & Governance Awareness

| Check | Description |
|------|-------------|
| Validator communication channels | Official validator communication channels are known and accessible. |
| Regular monitoring | Instant messaging channels (e.g., Discord, Telegram) are regularly checked for urgent notices. |
| Governance awareness | Governance proposals and upgrade announcements are actively monitored. |

---

## 10. Cloud Provider Security (if applicable)

| Check | Description |
|------|-------------|
| Root account protection | Cloud root account access is tightly restricted and protected with MFA. |
| Least-privilege IAM | Administrative roles follow the principle of least privilege. |
| Network segmentation | Use of security groups, VPCs, and network ACLs to isolate validator infrastructure. |
| Audit logging | Cloud audit logs (e.g., AWS CloudTrail) are enabled and monitored. |

---

## 11. Physical & Infrastructure Security

| Check | Description |
|------|-------------|
| Data center security | Hosting provider enforces physical access controls. |
| Redundant power | Power redundancy (UPS, generators) is available. |
| Network reliability | Minimum required bandwidth and low-latency connectivity are guaranteed. |
| Hardware reliability | Storage and hardware are suitable for continuous operation. |
| Environmental protections | Protection against overheating, fire, and hardware failure is in place. |

---

## 12. Incident Response

| Check | Description |
|------|-------------|
| Node breach plan | A documented response plan exists for a node compromise. |
| Sentry failure response | Clear steps exist for responding to sentry node outages. |
| Validator breach plan | A response plan exists for validator key or host compromise. |
| Validator downtime response | Clear procedures exist for restoring validator operation after downtime. |
| Roles & escalation | Responsibilities and escalation paths are clearly defined. |

---

### Notes
- This checklist is intended as **baseline guidance** for validators.
- Operators should adapt it to their scale, threat model, and hosting environment.
- Completing all checks does not guarantee security but significantly reduces common risks.
