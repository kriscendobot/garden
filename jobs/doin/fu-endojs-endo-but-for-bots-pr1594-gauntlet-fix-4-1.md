---
posted_at: 2026-10-31T22:19:05Z
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots (PR #1594 context), fix the `test/endo.test.js` failures under `test:rust` (Rust supervisor plus XS manager): 31 failing tests (session owners, native sessions, stored blobs, garbage collection), plus the load-time crash under `ENDO_BIN` without `ENDO_NODE_WORKER_BIN` (`testNeedsNodeWorker.serial is not a function`), so `test:rust` can run in CI.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-31T22:20:14Z
