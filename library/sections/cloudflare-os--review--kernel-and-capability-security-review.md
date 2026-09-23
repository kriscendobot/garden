---
title: Kernel and capability-security review
source: REVIEW.md
source_repo: cloudflare/cloudflare-os
source_commit: da895450d81e674c03e62bd6c940acf57bc0224c
source_date: 2026-08-18
source_authors: [Maximo Guk, Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [repository-governance, capability-security, capability-mediated-integrations]
status: current
---

Reviewers prioritize the kernel and public API first, then capability-security chokepoints: ambient authority must come from configuration, Gatekeeper capabilities must pass through the central policy check, and authentication settings stay outside mutable admin configuration.

`workshop-shared` exports require documentation, unsafe mirrored RPC interfaces are rejected, and large kernel work is separated from UI. `AdminSettings` alone writes authoritative admin configuration. MCP tool annotations are read only at the trust boundary; observations require a declared read-only hint, auto-applied writes additionally require a vetted endpoint, and SDK OAuth calls retain endpoint and SSRF checks across redirects. Deployed blueprint IDs are immutable because installs and promotions key on them.

Source: [REVIEW.md](https://github.com/cloudflare/cloudflare-os/blob/da895450d81e674c03e62bd6c940acf57bc0224c/REVIEW.md) at commit `da895450`.
