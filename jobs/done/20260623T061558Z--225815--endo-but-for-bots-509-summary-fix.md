---
job: 225815
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-06-23T06:15:58Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 509
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
  - steward
refs:
  - entries/2026/06/22/054455Z-dispatch-liaison-4c5f8d.md
preconditions: []
---

# Summary-fix bundle for endo-but-for-bots#509 (round 1)

Nine summary-fix items from the barrister code-panel round-1 review at PR #509 (https://github.com/endojs/endo-but-for-bots/pull/509, review https://github.com/endojs/endo-but-for-bots/pull/509#pullrequestreview-4550516085). PR mirrors endojs/endo#3099 (perf bundle-source). Address all nine in one fixer dispatch (no panel re-run). Posture: the PR's content is upstream's, but these are local cleanups and changeset polish that are appropriate to land on the mirror before un-draft.

## Items

1. **`packages/bundle-source/README.md:137`**: split the two-sentence line "Each bundle call writes one `*.trace.json` file. Open these in Chrome tracing tools or convert for Speedscope." into one sentence per line (project sentence-per-line-md gate).

2. **`packages/bundle-source/README.md` § Profiling**: document the `ENDO_BUNDLE_SOURCE_READ_CACHE_MAX_BYTES` env var alongside the four already-documented `ENDO_BUNDLE_SOURCE_PROFILE*` env vars (or mark it explicitly internal-only with a one-line note).

3. **`.changeset/bundle-source-profiling.md`**: extend the body with a "## Behavior changes" subsection naming (a) `.node` and `/index.node` no longer in `nodejsConventionSearchSuffixes`, (b) `nominateCandidates` skips suffix expansion when the specifier already ends with a known suffix, (c) `versionNeeded: 10` in zip local file header (was `0` with TODO); downstream `endoZipBase64Sha512` consumers may see hash changes.

4. **`.changeset/bundle-source-profiling.md`**: bump `@endo/compartment-mapper` from `patch` to `minor` to reflect the two `import-hook.js` behavior changes (the suffix-removal and the already-suffixed-skip). Other packages stay at `patch`.

5. **`packages/bundle-source/src/profile.js:60`** (the `makeBundleProfiler` JSDoc): add a one-line note clarifying the returned object is internal-only and not exposed to compartments.

6. **`packages/compartment-mapper/src/generic-graph.js:329`** (the `makeShortestPathFromSource` JSDoc): state the precondition that the graph not be mutated between the constructor call and any subsequent `shortestPath(target)` call. The function caches a Dijkstra context; mutation invalidates it.

7. **`packages/compartment-mapper/src/parse-archive-mjs.js:14`**: add a one-line code comment explaining the empirical workload that justifies `MAX_PARSE_ARCHIVE_MJS_CACHE_ENTRIES = 20_000`. A pointer like "agoric-sdk bundling crosses Nk parses per workspace; 20k allows M workspaces in cache" with the right N and M; if the numbers are unknown, state the policy is a heuristic.

8. **`packages/bundle-source/src/zip-base64.js` and `packages/bundle-source/src/script.js`** (the final `await profiler.flush(...)` in the outer `try/finally`): wrap the flush in its own `try/catch` so a flush failure (for example, disk full when writing the trace JSON) does not mask the underlying bundling error. Log the flush error to stderr and continue.

9. **`packages/compartment-mapper/src/parse-archive-mjs.js`** (above the `parseArchiveMjsCache` declaration): add a paragraph code comment documenting the module-scope cache as process-shared and FIFO-by-first-touch eviction. State the tenant-isolation surface (one process's parser output is reused across all callers in that process; cache keys are `(sourceUrl, source, sourceMapKey)`).

## Acceptance

- All nine edits land in one fixer dispatch (no panel re-run).
- The changeset file remains valid YAML at the front and renders cleanly.
- README sentence-per-line gate passes after edit 1.
- HEAD remains `367b9dcce` ancestry until the fixer pushes; lease anchor unchanged.

## Out of scope (not part of this bundle)

- The 8 pre-existing `no-inline-import-jsdoc` locations are NOT for this fixer pass; they belong upstream and to a separate sweep PR. Same for the pre-existing `test-package-no-main` finding on `packages/chacha12-fast-check-test`.
- Substantive perf-code defects flagged by the panel (the module-scope cache idiom, the `maxConcurrentReads` clamp, the read-cache eviction policy when a single value exceeds budget, the `TOCTOU` window on `pendingReads` rejection) belong upstream to `endojs/endo#3099`. They are recorded in the followup ledger at `journal/projects/endo/followups/endo-but-for-bots--509.md` and will revisit at merge time per the steward's parked-followup discipline.
