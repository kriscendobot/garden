---
title: Safe telemetry discovery
source: packages/gatekeeper-cloudflare/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1931a1b175d52ed88109d880b90e23d130cca2ad
source_date: 2026-08-18
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [worker-observability, capability-mediated-integrations, capability-security]
status: current
---

Telemetry schema discovery switches from cheap metadata endpoints to sampled event queries whenever a resource or caller filter must constrain the answer.

Cloudflare's key and value endpoints accept filters but answer for the whole account, which would reveal foreign field names and values through a Worker binding. The Gatekeeper instead derives constrained keys and values from an event sample produced by the correctly filtered query endpoint. Only unconstrained account-wide discovery uses the cheaper metadata calls. This converts a provider semantic mismatch into a cost tradeoff instead of a confidentiality failure.

Source: [packages/gatekeeper-cloudflare/README.md](https://github.com/cloudflare/cloudflare-os/blob/1931a1b175d52ed88109d880b90e23d130cca2ad/packages/gatekeeper-cloudflare/README.md) at commit `1931a1b1`.
