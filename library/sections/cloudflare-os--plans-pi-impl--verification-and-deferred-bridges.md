---
title: Verification and deferred bridges
source: plans/pi-impl.md
source_repo: cloudflare/cloudflare-os
source_commit: bdb6dc75560e8fa3833e99c9399cae90446d12e1
source_date: 2026-08-03
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, llm-agent-frameworks, repository-governance]
status: current
---

The migration gate combines build, lint, and test suites with manual multi-provider smoke coverage of chat creation, file tools, streaming, merge and revert, callbacks, connection suspension, abort and resume, compaction, and legacy replay.

Provider-routing unit tests must be rewritten against returned pi model handles and injected fetch behavior rather than deleted SDK mocks. A second Anthropic turn checks that cache reads actually occur. Deferred work is explicit: PDF payload bridges, injected-fetch Workers binding transport, upstream runtime and metadata improvements, steering and follow-up UI, immediate cost display, and custom message types are separate changes rather than compatibility layers inside Phase 1.

Source: [plans/pi-impl.md](https://github.com/cloudflare/cloudflare-os/blob/bdb6dc75560e8fa3833e99c9399cae90446d12e1/plans/pi-impl.md) at commit `bdb6dc75`.
