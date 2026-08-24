---
title: Cross-process time and fixture control
source: docs/integration-testing.md
source_repo: cloudflare/cloudflare-os
source_commit: 0d1825625808d6855c99c530affb496eb050a7d2
source_date: 2026-08-12
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, cloudflare-workers-agent-hosting]
status: current
---

Fake timers cannot alter workerd's clock, and overseer tests use a protocol-real fixture Gatekeeper rather than test hooks in production Gatekeepers.

`vi.useFakeTimers()` patches only the Vitest process, while token-expiry checks run in a separate Worker isolate. The fixture Worker can be instructed over a control route to accept or reject an observer, preserving the actual Gatekeeper protocol without requiring a full vendor OAuth surface or circularly mutating the production observation tracker.

Source: [docs/integration-testing.md](https://github.com/cloudflare/cloudflare-os/blob/0d1825625808d6855c99c530affb496eb050a7d2/docs/integration-testing.md) at commit `0d182562`.
