---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 509
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 3099
created_at: 2026-06-23T06:16:00Z
last_appended_at: 2026-06-23T06:16:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#509

PR mirrors `endojs/endo#3099` (perf(bundle-source) cut multi-entry agoric bundling time and add detailed profiling). Substantive perf-code defects belong upstream; this ledger records them for revisit at merge time (per-merge of either the bot mirror or the upstream PR).

## Items

- [ ] Pre-existing `no-inline-import-jsdoc` (8 locations across `packages/bundle-source/src/endo.js:132`, `packages/compartment-mapper/src/import-hook.js:77`, `packages/compartment-mapper/src/parse-archive-mjs.js:117`, `packages/compartment-mapper/src/parse-mjs.js:42`, `packages/evasive-transform/src/index.js:69,72`, `packages/evasive-transform/src/transform-comment.js:36,79`, `packages/zip/src/format-writer.js:195,196,211`, `packages/zip/src/writer.js:94,98,102`). All locations pre-existed upstream; this PR did not introduce any new inline-import JSDoc forms.  
  **Source juror(s)**: purist, cleaner gate  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: Open a separate sweep PR converting inline `import('...')` JSDoc to `@import` form across the touched packages. Apply at the bot-fork level or upstream; do not couple to this mirror.

- [ ] Pre-existing `test-package-no-main` finding on `packages/chacha12-fast-check-test/package.json` (the package declares `"exports": {"./package.json": "./package.json"}`; test packages should not declare exports). Not modified by this PR.  
  **Source juror(s)**: cleaner gate  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: Sweep separately across all test packages with the same issue. Open a tracking issue if no PR is immediately staged.

- [ ] `packages/bundle-source/test/profiling.test.js` only guards instrumentation presence (the trace file exists and contains expected span names). It does not guard speedup or cache hit behavior. Add a test that bundles a multi-entry fixture twice and asserts cache hit on the second call (count cache hit spans, or assert second-call duration is strictly less than first).  
  **Source juror(s)**: prover  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: For upstream consideration. File against `endojs/endo#3099` after merge, or open a follow-up PR.

- [ ] Reference benchmark report. The PR claims 42.8% speedup (13180ms to 7538ms) but the headline numbers lack reproducer rigor: no run count, no variance, no hardware class, no Node version, no agoric-sdk SHA. Add `packages/bundle-source/BENCH.md` capturing one canonical baseline-vs-latest table with named hardware, Node version, agoric-sdk SHA, run count, mean / median / stddev. Future perf PRs regress against this baseline.  
  **Source juror(s)**: prover, benchmarker  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: For upstream consideration. Open a follow-up PR adding `BENCH.md` once the canonical workload is settled.

- [ ] Property-based tests for the zip writer. `packages/zip` is exactly the kind of structural-format package where `fast-check` invariants pay (random byte content, random filenames, random ordering; round-trip property; size estimate vs actual). Out of scope for this PR.  
  **Source juror(s)**: fast-checker  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: Open a tracking issue against `endojs/endo` to add `fast-check` tests for `packages/zip` after merge.

- [ ] Module-scope mutable cache idiom. `parseArchiveMjsCache` in `packages/compartment-mapper/src/parse-archive-mjs.js` is a process-shared `Map` with no factory. Endo idiom prefers caller-controlled state. Refactor to a factory that returns a per-call cache, or document explicitly that process-shared semantics are intentional.  
  **Source juror(s)**: purist, saboteur  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: For upstream consideration. Folds into a broader review of cache idioms across compartment-mapper.

- [ ] `nominateCandidates` already-suffixed-skip behavior change. The PR's new fast path (skip suffix expansion when the specifier already ends with one of the known suffixes) is a behavior change that the PR body does not call out. Add a regression test that names a fixture relying on the old expansion behavior (if any exists) and confirms it still resolves under the new logic, OR document the change as a deliberate removal in `endojs/endo`'s release notes.  
  **Source juror(s)**: corner-prober, changeset-auditor  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: For upstream consideration. Tracking via `endojs/endo#3099`.

- [ ] Cross-package threading type duplication. `ProfilingOptions` shape is duplicated across `compartment-mapper/types/external.ts`, `evasive-transform/src/index.js`, `module-source/types/module-source.ts`. Define once in `compartment-mapper` and re-export from the other packages to avoid drift.  
  **Source juror(s)**: integrator  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: For upstream consideration. Folds into the larger profiling-thread cleanup after the perf PR lands.

- [ ] `@ts-ignore` downgrades in `packages/module-source/src/babel-plugin.js` and `packages/module-source/src/transform-analyze.js`. Several `@ts-expect-error` were downgraded to `@ts-ignore` (commit `c55f8efb9` "tolerate babel type drift"). When `@babel/*` types stabilize, restore `@ts-expect-error` so the next type-stabilization round surfaces the now-unneeded suppressions.  
  **Source juror(s)**: typist  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: Revisit on next `@babel/*` dependency bump. Track via `endojs/endo` upstream.

- [ ] `maxConcurrentReads` silent clamp in `packages/compartment-mapper/src/node-powers.js`. The constructor clamps invalid input (`0`, `NaN`, negative, non-integer) silently to `1`. Project posture is loud failure on invalid input. Either throw on invalid input or document the clamp policy in the JSDoc.  
  **Source juror(s)**: saboteur, corner-prober  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: For upstream consideration; small change.

- [ ] Per-bundle read cache eviction policy. When a single inserted entry exceeds `readCacheMaxBytes`, the eviction loop in `cacheReadValue` (in `packages/bundle-source/src/zip-base64.js`) evicts every other entry but keeps the offender, leaving total bytes over budget. Either evict the offender or document that bigger-than-budget reads are uncacheable.  
  **Source juror(s)**: saboteur  
  **Round**: 1 (barrister-8ee5cb)  
  **Recommended action**: For upstream consideration. One-line fix or one-paragraph doc.
