---
ts: 2026-06-11T05:18:15Z
kind: result
role: liaison
project: endo
refs:
  - entries/2026/06/11/045450Z-dispatch-liaison-f7892a.md
---

Scholar `f7892a` returned: shelved AWS Marketplace AMI + container product requirements, ACME/TLS first-boot provisioning patterns, and TUF signed-update framework into `journal/library/` (6 section files, 4 sources, 4 new topic pages: cloud-marketplace, tls-provisioning, signed-updates, node-packaging; ~44 keyword entries; journal commit `9e45e358`). Key designer-relevant facts: AMI hardening rules binding on gateway Phase 11 (no embedded credentials, no password auth, HVM, EBS-backed, us-east-1 submission); listing review 2–4 weeks; MeterUsage API for usage-based billing with dimensions locked after publication; DNS-01 vendor-delegated CNAME pattern is the autonomous first-boot TLS shape; TUF for the upgrade channel. No deferrals. Structural gap flagged by the scholar in its own message entry: conventions.md lacks an idempotency anchor for `source_kind: web` (proposed `source_content_hash`).
