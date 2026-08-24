---
title: Concurrent integration-test storage isolation
source: packages/integration-tests/README.md
source_repo: cloudflare/cloudflare-os
source_commit: ba4036b9366070a5d396b1bf76bc62b4fb50c9ab
source_date: 2026-08-14
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, cloudflare-workers-agent-hosting]
status: current
---

Integration tests share one persistent harness and run concurrently, so correctness depends on fresh identities, per-test resource URLs, and suite-level escape assertions rather than resettable storage.

No test assumes a clean slate. `nextUsernames()` allocates identities, account labels are unique, and each test chooses fresh resource URLs. Because `it.concurrent` cases overlap, an escape assertion belongs in `afterAll`: placing it in `afterEach` would inspect and clear interceptor state still being used by sibling cases.

Source: [packages/integration-tests/README.md](https://github.com/cloudflare/cloudflare-os/blob/ba4036b9366070a5d396b1bf76bc62b4fb50c9ab/packages/integration-tests/README.md) at commit `ba4036b9`.
