---
source_kind: source-cluster
source_repo: endojs/endo
source_path: packages/init/{index.js,debug.js,unsafe-fast.js,legacy.js,debug-async-hooks.js,pre.js,pre-remoting.js,pre-bundle-source.js}
source_line_range: 1-66 (across 8 files; 6-12 lines each)
file_commit_range: 7622f5f7..dd24b13d
file_commit_date: 2022-01-13 to 2025-12-04
file_commit_author: Kris Kowal + Endo contributors
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 344 chat-lane ingest. Cluster of 8 tiny @endo/init
  source files (6-12 lines each; ~66 lines total). Adjacent
  forward pair with cycle 343 designs-lane @endo/init
  README. **TWELFTH INSTANCE of one-cycle README↔source
  pattern** (cycle 343 → 344 same-package); §the-named-
  streak-resumes-with-twelfth-instance.

  **SEVENTH complementary-lens re-ingest** (after cycles
  322 + 324 + 330 + 332 + 336 + 342); §seven-cycles-with-
  named-complementary-lens-re-ingest. Cycle 183 ingested
  12 init+lockdown files as comment-fragment; cycle 344
  takes the implementation-side view of just the @endo/init
  subset (8 files).

  Single most structurally interesting move: §the-named-
  README-curates-subset-of-implementation-rungs — cycle
  343's README named THREE rungs (`@endo/init` default +
  `@endo/init/debug.js` + `@endo/init/unsafe-fast.js`);
  cycle 344's implementation reveals FIVE rungs plus three
  preamble files. The README's three rungs are a curated
  user-facing subset; the implementation has five rungs
  (adding `legacy.js` and `debug-async-hooks.js` for
  specific niches). §the-named-curated-vs-full-API-
  distinction as tier-3 meta-pattern — README documentation
  can DELIBERATELY UNDERSTATE the implementation's
  complexity to keep the user-facing surface tractable.

  Other key first-explicit-observations: §the-named-two-
  shapes-of-tolerance-ladder-rung — re-export-from-variant
  (index.js + debug.js + debug-async-hooks.js use `export *
  from '@endo/lockdown/commit*.js'`) vs direct-call-with-
  options (unsafe-fast.js + legacy.js import lockdown and
  call with options); §three-shapes-of-tolerance-ladder-
  implementation (cycle 183 separate-entry-point-files +
  cycle 344 re-export-from-variant + cycle 344 direct-call-
  with-options). §the-named-orchestration-via-import-graph
  — 8 files form an import graph that IS the architecture;
  no file exceeds 12 lines because the graph carries the
  complexity; §the-named-tiny-files-where-the-COMPOSITION-
  is-the-content; §two-shapes-of-substrate-package-
  implementation (cycle 338 single-substantial-file 471
  lines + cycle 344 tiny-files-orchestrated 8 × ~8 lines).
  §the-named-layered-shim-with-named-addition (pre-remoting
  is pre + eventual-send-shim); §the-named-base64-and-
  promise-kit-as-canonical-pre-lockdown-shims (pre.js
  installs three pre-lockdown shims: lockdown +
  @endo/base64 + @endo/promise-kit).

  §the-named-deprecated-with-named-replacement-in-source
  (pre-bundle-source.js's file-header comment names TWO
  replacements: `import '@endo/init';` simple + `import
  '@endo/init/pre.js';` advanced); §five-shapes-of-
  deprecation-discipline (cycle 326 @deprecated-with-
  canonical-pointer + cycle 337 deprecated-with-named-
  regret + cycle 343 deprecated-with-named-aspiration-to-
  remove + cycle 344 deprecated-with-named-replacement-in-
  source + cycle 211 deprecated-with-forwarding-comment).

  §the-named-async_hooks-patch-with-named-platform-
  limitation ("This patch may not work in Node.js 24+");
  §the-named-platform-version-window-named-explicitly.
  §the-named-doubled-underscores-as-internal-API-marker
  (`__hardenTaming__: 'unsafe'`); §two-shapes-of-internal-
  API-marker (build-condition + doubled-underscores).

  Closes nine citation arcs: cycle 343 (1 cycle adjacent
  forward pair) + cycle 342 (2 cycles) + cycle 341 (3
  cycles) + cycle 183 (161 cycles SEVENTH complementary-
  lens re-ingest) + cycle 187 (157 cycles shim cluster) +
  cycle 152 (192 cycles memo-race installed by promise-kit
  shim) + cycle 326 (18 cycles deprecation-discipline
  sibling) + cycle 337 (7 cycles prepare-* convention) +
  cycle 211 (133 cycles common's deprecation discipline).
  Pushes citation-arc-closures-in-pivot to ONE-HUNDRED-
  FIVE (98 + 7 net new) — **CROSSES THE 100-ARC MILESTONE**.

  §seven-cycles-with-named-substrate-package-introduction
  (337-344); §the-named-substrate-package-cluster-
  introduction-trend-extends-to-eight-cycles.
---

> Abstract: 8-file source cluster (~66 lines total; each
> file 6-12 lines) under `packages/init/`. Adjacent forward
> pair with cycle 343 README. **Twelfth INSTANCE** of
> one-cycle README↔source pattern; **SEVENTH complementary-
> lens re-ingest** (§seven-cycles-with-named-complementary-
> lens-re-ingest).
>
> **Single most structurally interesting move**: §the-named-
> README-curates-subset-of-implementation-rungs — cycle
> 343's README named three rungs; cycle 344 reveals FIVE
> rungs (adding legacy.js + debug-async-hooks.js for
> specific niches). §the-named-curated-vs-full-API-
> distinction as tier-3 meta-pattern — README documentation
> can deliberately understate implementation complexity for
> user-facing tractability.
>
> §the-named-two-shapes-of-tolerance-ladder-rung — re-
> export-from-variant + direct-call-with-options; §three-
> shapes-of-tolerance-ladder-implementation.
>
> §the-named-orchestration-via-import-graph — tiny files
> connected via imports encode full architecture; §the-
> named-tiny-files-where-the-COMPOSITION-is-the-content;
> §two-shapes-of-substrate-package-implementation.
>
> §the-named-layered-shim-with-named-addition; §the-named-
> base64-and-promise-kit-as-canonical-pre-lockdown-shims.
>
> §five-shapes-of-deprecation-discipline (326 + 337 + 343 +
> 344 + 211) — five distinct deprecation patterns now named.
>
> §the-named-async_hooks-patch-with-named-platform-
> limitation; §the-named-platform-version-window-named-
> explicitly. §the-named-doubled-underscores-as-internal-
> API-marker.
>
> Closes nine citation arcs; **crosses the 100-arc milestone**
> (§one-hundred-five-citation-arc-closures-in-pivot-now).
> §seven-cycles-with-named-substrate-package-introduction
> (337-344); §the-named-substrate-package-cluster-
> introduction-trend-extends-to-eight-cycles.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [seventh-complementary-lens-README-curates-subset-of-implementation-rungs](../sections/endo--packages-init-source-cluster--seventh-complementary-lens-README-curates-subset-of-implementation-rungs.md) | hardened-javascript, init-orchestration, tolerance-ladder-implementation, import-graph-architecture, deprecation-discipline, README-vs-implementation | current (cycle 344, chat-lane) |

8-file cluster. One dense section covering README-curates-subset + two-shapes-of-tolerance-ladder-rung + orchestration-via-import-graph + layered-shim + five-shapes-of-deprecation-discipline + platform-version-window + doubled-underscores marker.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` via the local clone.
- File-commit-range: 7622f5f7 (Jan 2022) through dd24b13d (Dec 2025).
- Apache-2.0 license per package LICENSE file.
- **Thirty-fifth consecutive non-garden source after the pivot** (cycles 310-344).
- **Twelfth INSTANCE of one-cycle README↔source pattern** (cycle 343 → 344 same-package).
- **SEVENTH complementary-lens re-ingest** (after cycles 322 + 324 + 330 + 332 + 336 + 342).
- §seven-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341 + 342 + 343 + 344); §the-named-substrate-package-cluster-introduction-trend-extends-to-eight-cycles.
- Cycle 344 closes **nine citation arcs** and **crosses the 100-arc milestone** for §citation-arc-closures-in-pivot.
