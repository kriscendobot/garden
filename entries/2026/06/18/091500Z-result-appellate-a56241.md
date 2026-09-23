---
ts: 2026-06-18T09:15:00Z
kind: result
role: appellate
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/090950Z-result-justice-aaa2a8.md
  - jobs/open/20260618T090855Z--af8356--summary-fix-468-r2.md
  - projects/endo-but-for-bots/followups/endo-but-for-bots--468.md
---

## Appellate result: endojs/endo-but-for-bots#468 post-justice-r2

PR title: feat(immutable-arraybuffer): freezable TypedArray emulation per #449 design
PR head reviewed: f7715659e
Originating verdict: justice r2 (entries/2026/06/18/090950Z-result-justice-aaa2a8.md)
Items considered: 3 follow-up (round-2) + 5 acknowledge = 8 total
Promotions proposed: 3

### Items not appealed

All 5 acknowledge items stand without challenge. Each is a deliberate
design decision confirmed correct by the panel:
- Symbol.toStringTag omission: intentional per design spec.
- species-constructor deviation in subarray: intentional, no promotion warranted.
- WeakMap capture pattern: verified correct.
- PseudoTypedArray constructor mutation: required for SES, intentional.
- detect-then-skip policy: confirmed correct.

The round-1 follow-up items (5 items in the ledger tagged Round: 1) are
out of scope for this appellate pass; justice r2 appended the round-2
items only. The round-1 items were deferred at barrister r1 and are
considered by this appellate below only insofar as items originate from
round 2.

### Proposed promotions

- **finding**: No test for chained subarray buffer contract.
  `view.subarray(a,b).subarray(c,d).buffer === iab` is correct by
  mechanism (reverseBuffers maps the genuine backing buffer regardless of
  nesting depth) but no explicit regression test covers the double-subarray
  path.
  **judge's disposition**: follow-up (round 2, corner-prober)
  **appellate's proposal**: summary-fix
  **rationale**: Small (one `t.is(...)` assertion in the existing subarray
  test block). In-context (`test/shim-typedarray.test.js` is already
  heavily modified by this PR and the subarray test is present). Loss-
  tracking risk is medium: the mechanism is correct today but a future
  refactor of reverseBuffers could silently break the double-nesting path
  with no test to catch it. Adding the assertion now costs one line and
  locks in the invariant while the code is in active review.
  [proposed-rule: view-returning delegate methods need regression tests for
  chained calls]

- **finding**: JSDoc `[predicate]` / `[callback]` marks spec-required
  parameters as optional on `every`, `some`, `find`, `findIndex`,
  `findLast`, `findLastIndex`, `forEach`, `map`, `reduce`, `reduceRight`
  in `src/lib.js` (introduced by the cleaner commit `a04fbe7af`).
  **judge's disposition**: follow-up (round 2, typist)
  **appellate's proposal**: summary-fix
  **rationale**: Small (bracket removal on approximately ten JSDoc
  parameter annotations in one file). In-context (`src/lib.js` is the
  central implementation file this PR introduces). Loss-tracking risk is
  marginal: the ledger is durable, but the mistake was introduced by the
  cleaner in the same pipeline run and the summary-fix fixer is already
  being dispatched to fix the eslint-disable comment in the same file's
  test. Bundling this correction into that fixer dispatch costs nothing
  extra and eliminates a separate follow-up claim cycle.

- **finding**: `test/shim-typedarray.test.js` subarray test does not
  assert `sub.byteOffset`. `view.subarray(1,3).byteOffset` should be `1`;
  no assertion currently pins this value.
  **judge's disposition**: follow-up (round 2, prover)
  **appellate's proposal**: summary-fix
  **rationale**: Small (literally one line: `t.is(sub.byteOffset, 1)` in
  the existing subarray test). In-context (the subarray test already
  exists in `test/shim-typedarray.test.js`; the test block is present in
  the current diff). Loss-tracking risk is medium: the byteOffset
  amplifier-delegate path is new in this PR; without an assertion, a
  regression in offset forwarding would be invisible. All three small +
  in-context + loss-tracking criteria are satisfied.
  [proposed-rule: amplifier-delegate path assertions: each accessor
  forwarded via the delegate must have at least one test pinning its value]

### Summary-fix job amendment

The three promoted items should be appended to the existing summary-fix
job at jobs/open/20260618T090855Z--af8356--summary-fix-468-r2.md so the
fixer addresses all four items in one dispatch:
1. (existing) Remove `// eslint-disable-next-line guard-for-in` from
   `test/shim-typedarray.test.js` line 160.
2. (promoted) Add `t.is(view.subarray(a,b).subarray(c,d).buffer, iab)`
   to the double-subarray path in `test/shim-typedarray.test.js`.
3. (promoted) Add `t.is(sub.byteOffset, 1)` to the subarray test in
   `test/shim-typedarray.test.js`.
4. (promoted) Remove brackets from mandatory parameter names in `src/lib.js`
   JSDoc for `every`, `some`, `find`, `findIndex`, `findLast`,
   `findLastIndex`, `forEach`, `map`, `reduce`, `reduceRight`.

Follow-up ledger: the three promoted items should be removed (or not
re-written on final ledger append) from
`projects/endo-but-for-bots/followups/endo-but-for-bots--468.md` once
the fixer lands.

### Next stage recommendation

next: fixer (claim summary-fix job af8356 with the four-item bundle above)

PR #468 is substantive implementation; leave DRAFT until the summary-fix
bundle lands and CI is green, then un-draft via conductor.

Self-improvement: nothing this time.
