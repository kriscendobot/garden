---
source_kind: source
source_repo: endojs/endo
source_path: packages/benchmark/src/benchmark.js
source_line_range: 1-39
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 364 chat-lane ingest paired to cycle 363 designs-lane
  @endo/benchmark README. 39-line hand-rolled benchmark
  implementation. Twelfth AUTHORED conformant single-body
  section doc in post-refactor era. Fifty-four consecutive
  non-garden sources after the pivot (310-364). §fifty-four-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  substrate-non-use-in-substrate-benchmarking — the file uses
  NONE of the @endo substrate. Native Error throws (lines 21,
  25), not `@endo/errors`. Native Date.now (line 1), not the
  Date constructor pointedly-absent-in-locked-down (which
  this is measuring). Native console.log. No SES Assert
  machinery. Two hand-rolled assertion helpers (assert,
  truthy) totaling 6 lines. The benchmark MEASURES substrate;
  using substrate would corrupt the measurement. §the-named-
  circular-measurement-avoidance-explains-substrate-non-use —
  third-level reasoning: cross-engine + measuring substrate +
  can't use substrate → minimal native-only implementation.
  The cycle 363 README's "minimalistic" descriptor turns out
  to mean "minimal-substrate-use" not "minimal-code-effort".

  §The-named-four-shapes-of-design-vs-implementation-arc-from-
  README-to-source as REVISED tier-3 framing. Cycle 363
  positioned benchmark as outside-the-three-shapes-framing;
  cycle 364 reveals the README's "ava-like" claim is an
  ANALOGY hint that the source self-defines as a literal
  39-line subset of AVA's surface API. The four shapes:
  ABSTRACTING (cycle 357→358 zip) + UNDERCOUNTING (cycle
  359→360 eslint-plugin) + WHAT-VS-HOW (cycle 361→362
  ses-ava) + ANALOGY-VS-LITERAL (cycle 363→364 benchmark).
  §the-named-analogy-vs-literal-arc names the fourth shape:
  README points to an external reference loosely, source
  provides the literal self-contained definition that
  approximates the reference. Four instances establish the
  framing as a four-shapes taxonomy.

  §The-named-Date-now-times-million-for-nanoseconds — line 1
  `Date.now() * 1_000_000`. Date.now returns milliseconds;
  multiplication by a million yields nanosecond precision in
  the unit but FAKE precision in value (trailing six digits
  always zero). §the-named-fake-nanosecond-precision-for-
  cross-engine-compat — the deliberate compromise because
  XS may not have `performance.now()` or `process.hrtime`.

  §The-named-typo-fossil-in-private-package — parameter name
  `expedtedTime` (lines 3, 15, 16) is consistently misspelled.
  Pairs with cycle 363's NEW SHAPE §the-named-private-package-
  as-internal-tooling: a public package would have caught
  the typo through peer review; a private package consumed
  only via `yarn test` has no audience that sees the parameter
  name. §the-named-typo-as-evidence-of-missing-audience-effect
  as tier-3 meta-pattern. The shape has observable
  consequences in source.

  §The-named-eslint-disable-as-deliberate-rule-carveout —
  SECOND INSTANCE in two cycles (after cycle 362 ses-ava's
  no-restricted-exports). Line 7 here disables `no-await-in-
  loop` for line 8's `await fn();`. §the-named-await-in-loop-
  deliberate-for-sequential-iteration — the carve-out is
  necessary because the function under measurement is async
  and must be awaited sequentially (not concurrently) to
  measure cumulative time. §the-named-eslint-disable-as-
  recurring-carve-out-pattern-across-packages establishes
  the pattern across the trilogy (now with two instances
  recorded; first at ses-ava cycle 362, second at benchmark
  cycle 364).

  §The-named-await-null-as-microtask-yield — lines 4 and 29.
  `await null` yields to the microtask queue without waiting
  for anything specific. Forces the function body to start
  in a clean async tick before measurement begins. §the-
  named-microtask-yield-before-measurement names the purpose.

  §The-named-ava-like-is-just-try-catch — the `test` function
  on lines 28-37 is 10 lines: log + invoke fn with injected
  helpers + log pass-or-fail. No AVA at all. The cycle 363
  README's "ava-like interface" turned out to mean: a
  function named `test` that takes a name and a function and
  reports pass/fail with emoji. §the-named-ava-like-as-
  surface-similarity-not-implementation-derivation.

  §The-named-helper-injection-via-t-object — the test
  function passes `{ assert, truthy }` to the test fn (line
  32); the fn calls `benchmark(name, t, fn, expedtedTime)`
  where `t` is the same helpers object. §the-named-injected-
  helpers-as-the-t-pattern.

  §The-named-two-function-API — line 39 `export { benchmark,
  test }`. Entire package API is two functions. Pairs with
  cycle 363's §the-named-empty-index-js-private-package-
  pattern: the package's exports are minimal because the
  audience is the package's own test files, not external
  consumers.

  §The-named-emoji-in-private-package-output — ✅ (line 33)
  and ❌ (line 35) appear in log output. §the-named-emoji-
  consequence-of-private-shape — private packages can use
  emoji output without worrying about cross-environment
  rendering or terminal compatibility because the audience
  is the developers themselves.

  Closes seven citation arcs: cycle 363 (1, adjacent forward
  pair README → source; promotes three-shapes-framing to
  four-shapes-framing) + cycle 362 (1, eslint-disable
  recurring-carve-out-pattern; second instance establishes
  the across-packages pattern) + cycle 361 (1, ava-like
  claim resolved in source) + cycle 358 (1, first design-vs-
  implementation-arc instance; now one of four shapes) +
  cycle 322 (42, @endo/errors absent here for measurement-
  validity) + cycle 339 (49, lockdown's Date constructor
  absent; benchmark uses Date.now anyway via cross-engine-
  compatibility need) + cycle 326 (37, pure-naming-as-
  discipline reaches one more sibling). Pushes citation-arc-
  closures-in-pivot to TWO-HUNDRED-NINETEEN (212 + 7 net new).
---

39-line `src/benchmark.js` for @endo/benchmark, the hand-rolled "minimalistic ava-like interface". Chat-lane after cycle 363 designs-lane README. §the-named-substrate-non-use-in-substrate-benchmarking (single most structurally interesting move — file uses NONE of the @endo substrate; circular measurement avoidance). §the-named-four-shapes-of-design-vs-implementation-arc-from-README-to-source as REVISED tier-3 framing (ABSTRACTING + UNDERCOUNTING + WHAT-VS-HOW + ANALOGY-VS-LITERAL). §the-named-Date-now-times-million-for-nanoseconds (fake nanosecond precision for cross-engine compat). §the-named-typo-fossil-in-private-package (`expedtedTime`); §the-named-typo-as-evidence-of-missing-audience-effect. §the-named-eslint-disable-as-recurring-carve-out-pattern-across-packages (second instance). §the-named-await-null-as-microtask-yield. §the-named-ava-like-is-just-try-catch. §the-named-helper-injection-via-t-object. §the-named-two-function-API. §the-named-emoji-in-private-package-output. Seven citation arcs closed.
