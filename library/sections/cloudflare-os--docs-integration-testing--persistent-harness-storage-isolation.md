---
title: Persistent harness storage isolation
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

The integration harness keeps storage for its full lifetime, so tests isolate themselves with fresh identities and defer global escape assertions until concurrent siblings have finished.

Resetting the server costs about three seconds, changes its URL, and destroys every live WebSocket session; it is teardown rather than a per-test storage wipe. Tests therefore allocate unique users, resource URLs, and account labels. With concurrent tests, checking and clearing intercepted network traffic in `afterEach` would race siblings, so the no-internet-escape assertion belongs in `afterAll`.

Source: [docs/integration-testing.md](https://github.com/cloudflare/cloudflare-os/blob/0d1825625808d6855c99c530affb496eb050a7d2/docs/integration-testing.md) at commit `0d182562`.
