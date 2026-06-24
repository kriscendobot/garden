---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 355
created_at: 2026-05-22T03:50:03Z
last_appended_at: 2026-05-22T03:50:03Z
status: parked
---

# Follow-ups for endo-but-for-bots#355

PR #355 mirrors endojs/endo#3099 (DRAFT upstream) onto endo-but-for-bots@master. Perf change on five packages (`@endo/bundle-source`, `@endo/compartment-mapper`, `@endo/evasive-transform`, `@endo/module-source`, `@endo/zip`) with new chrome-trace profiling instrumentation. Items below were raised by the panel-1 barrister review as `follow-up` disposition, to be revisited when this PR (or its upstream mirror, once the boatman ferries it) merges.

## Items

- [ ] `packages/bundle-source/tools/profile-agoric-bundling.mts` (new 662-line CLI harness) is not exercised by any CI script and risks silent rot.
  **Source juror(s)**: prover, benchmarker
  **Round**: 1
  **Recommended action**: open a follow-up PR adding a `yarn workspaces foreach --topological run profile-smoke` invocation that runs the harness against a tiny synthetic corpus (a handful of entrypoint files) to detect when the harness's API drifts away from the consuming packages.

- [ ] `packages/bundle-source/tools/trace-merge.js` (new 475-line chrome-trace merger) has no tests; its output is a public-ish data format (chrome trace JSON consumed by `chrome://tracing` and `speedscope`) that benefits from a snapshot regression to catch accidental field churn.
  **Source juror(s)**: prover
  **Round**: 1
  **Recommended action**: open a follow-up PR adding a snapshot test that feeds the merger a two-event fixture trace and asserts on `traceEvents.length`, `displayTimeUnit`, and one merged event's shape.

- [ ] `packages/compartment-mapper/src/generic-graph.js` `makeShortestPathFromSource` (new export added in this PR) has no JSDoc of its own; the documentation lives on the wrapped `makeShortestPath`.
  **Source juror(s)**: typist, surfacer
  **Round**: 1
  **Recommended action**: open a follow-up PR (or amend the upstream mirror) adding one paragraph of JSDoc on `makeShortestPathFromSource` naming the cache-by-source semantics and the relationship to `makeShortestPath`.

- [ ] `packages/bundle-source/src/zip-base64.js` module-scope read-cache state (`cachedReads`, `pendingReads`, `cachedReadBytes`) persists across `bundleZipBase64` calls with no `clearReadCache()` export; downstream tests that want a clean cache between cases cannot get one in-process.
  **Source juror(s)**: assessor, prover
  **Round**: 1
  **Recommended action**: open a follow-up PR exporting a `clearReadCache()` (and document the FIFO semantics from the summary-fix item posted on the same beat).

- [ ] `packages/compartment-mapper/src/import-hook.js` `nominateCandidates` skip-suffix optimization breaks the upstream `path-with-dot` fixture set (the root cause of the 11 acknowledged `fixtures-resolve` test failures inherited from upstream draft endo#3099).
  **Source juror(s)**: assessor, prover
  **Round**: 1
  **Recommended action**: when the mirror merges, either revisit the fixture (rename the `path-with-dot` cases to not require the suffix walk) or add a one-line opt-out for the skip-suffix path keyed on a `parserForLanguage` flag. This is the larger-scope item that the mirror PR cannot reasonably address; it belongs in the upstream PR's resolution.
