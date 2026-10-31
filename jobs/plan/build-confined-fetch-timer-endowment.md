---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1588
priority: normal
posted_by: producer
posted_at: 2026-10-31T07:23:50Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build Phase 4 ("Confined-worker time") of `designs/endo-fetch.md` in endojs/endo-but-for-bots (base `llm`), as decided in § Time in a confined worker (commit 6aa23df64c on the head of draft PR https://github.com/endojs/endo-but-for-bots/pull/1588). Thread `delay`/`now` seams and `@endo/cancel` cancel-kit cancellation through `@endo/http-confine` and `@endo/exo-http-client`, drop `AbortController` from both, add the unconfined `Timer` capability and the required `timer` power to `@endo/confined-fetch`. Test it in a Compartment endowed like `packages/daemon/src/worker.js` `endowments`. Resolve the design's open question about which package exports the Timer maker per the maintainer's answer on #1588; default to `@endo/fetch/timer.js`. Stack on #1588 or wait until it merges.
