---
ts: 2026-06-18T09:18:07Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/claimed/20260618T091445Z--endolinbot--fixer--3231--af8356--summary-fix-468-r2.md
---

Summary-fix bundle for PR #468 R2 applied and pushed.

Commit: 8541aaf8b on feat/freezable-typedarray-emulation.

Items addressed:

1. Removed `// eslint-disable-next-line guard-for-in` before a `for...of`
   loop in `test/shim-typedarray.test.js` line 160.
   The rule applies only to `for...in`; the comment was a no-op that
   misled readers.

2. Added `t.is(sub.byteOffset, 1)` to the existing subarray test,
   pinning the amplifier-delegate offset-forwarding path.

3. Added chained-subarray buffer assertion
   `t.is(view.subarray(0, 2).subarray(0, 1).buffer, iab)`,
   covering the double-nesting reverseBuffers path.

4. Removed `[...]` optional-parameter brackets from JSDoc on ten
   spec-required parameters across `every`, `some`, `find`,
   `findIndex`, `findLast`, `findLastIndex`, `forEach`, `map`,
   `reduce`, `reduceRight` in `src/lib.js`.

All 217 tests pass.
Pre-push gates pass (yarn format and lint auto-fixed 2 paths each;
all 8 probes green; typecheck skipped, no script).

Recommended next stage: conductor (CI green, no must-fix items remaining).

Self-improvement: nothing this time.
