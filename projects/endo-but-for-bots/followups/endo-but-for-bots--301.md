---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 301
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-20T04:31:17Z
last_appended_at: 2026-05-20T04:31:17Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#301

Created from the code-panel verdict (23 seats, in-band fallback) on `feat(daemon,cli): error tracing aggregator and 'endo trace' verb` (branch `kriskowal-error-trace`). The PR adds an end-to-end error trace facility (worker -> daemon aggregator -> privileged `EndoHost.traces()` -> `endo trace` CLI verb and inline chat enrichment). Three deferrals warrant revisit when the PR (or its upstream mirror, if one is later ferried) merges.

## Items

- [ ] **Chat-package coverage gap.**
  **Source juror(s)**: prover, surfacer.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR adding `packages/chat/test/error-trace.test.js`.
  The cleaner skipped this surface (2-package budget per engagement) and the 257-LOC chat error-trace module (`formatTraceReport`, `logTraceReport`, `fetchTraceForError`) currently has zero unit-test coverage.
  The DOM bits can be exercised via jsdom or by passing the function a string sink the way `error-trace-format.test.js` does for the CLI.

- [ ] **Design-document drift.**
  **Source juror(s)**: archivist, integrator, scribe.
  **Round**: 1.
  **Recommended action**: open a follow-up PR amending `docs/error-tracing-design.md` to match the landed code.
  Three known deltas:
    1. ENV var names changed from the design's `ENDO_TRACE_LRU_*` to the code's `ENDO_TRACE_RECORDS` / `_BYTES` / `_WORKERS`.
    2. The `@network:${hostId}` synthetic worker-id sentinel is not mentioned in *Aggregation*.
    3. The `marshalLoadError` fail-soft semantics (catch and log on hook throw) are not captured in *On the wire*.

- [ ] **Aggregator byte-budget eviction edge cases.**
  **Source juror(s)**: saboteur, breaker, benchmarker.
  **Round**: 1.
  **Recommended action**: open a follow-up implementation PR adding either a fuzz harness or one carefully-shaped integration test for `trace-aggregator.js` lines 215-216, 225-227, 320-321.
  All three are correctness-relevant under load: the byte-budget loop's "deleted worker entry while iterating" path, the "target survived but a cause was evicted" partial-flag path, and the related window's "preceding longer than window" partial-flag path.
  The cleaner left these uncovered for the right reason ("contortion is a smell") but the behavior under budget pressure deserves explicit verification before the facility carries load in production.
