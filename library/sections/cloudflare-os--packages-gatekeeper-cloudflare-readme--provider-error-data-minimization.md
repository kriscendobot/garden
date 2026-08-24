---
title: Provider error data minimization
source: packages/gatekeeper-cloudflare/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1931a1b175d52ed88109d880b90e23d130cca2ad
source_date: 2026-08-18
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [worker-observability, errors, capability-security]
status: current
---

The Cloudflare Gatekeeper keeps caller-controlled filter values out of logs even when the provider reflects those values through an error message.

Provider errors carry numeric codes separately from their text, and request logs record codes rather than messages. Because Cloudflare sometimes emits no code, the error also distinguishes provider-authored text from local text: local messages may be logged, while a provider failure without codes is reduced to its status. The original message still returns to the caller that caused it, preserving diagnostics without widening its audience through the audit trail.

Source: [packages/gatekeeper-cloudflare/README.md](https://github.com/cloudflare/cloudflare-os/blob/1931a1b175d52ed88109d880b90e23d130cca2ad/packages/gatekeeper-cloudflare/README.md) at commit `1931a1b1`.
