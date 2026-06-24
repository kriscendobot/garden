---
ts: 2026-05-21T05:36:26Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--7583e2/project
refs:
  - entries/2026/05/21/052128Z-dispatch-liaison-70fb1e.md
---

# Result: fixer 70fb1e — turadg-review fixes on endojs/endo-but-for-bots#244

1. **`hexadecimal.groupLength: 4` configurable at `eslint-plugin-unicorn@56.0.1`?** Yes. The rule's schema (`node_modules/.store/eslint-plugin-unicorn-virtual-*/package/rules/numeric-separators-style.js` lines 135-153, 155-167) declares `groupLength` as a `{ type: 'integer', minimum: 1 }` property under each of `binary`/`octal`/`hexadecimal`/`number`, with per-type defaults `{ hexadecimal: { groupLength: 2 }, binary: { groupLength: 4 }, octal: { groupLength: 4 }, number: { groupLength: 3 } }`. The lockfile pins `eslint-plugin-unicorn@npm:56.0.1`.

2. **Commits landed** (pushed to `chore/eslint-numeric-separators-style-master`, final head `292322fac`):
   - `4b23bb2b1` chore(eslint-plugin): group hex digits by two bytes (25 files; preset option flipped to `groupLength: 4`, ESLint+Prettier autofix on every hex literal across the tree, plus the wiring test updated)
   - `bd2b040b1` chore(hex): exempt mnemonic seed literals from numeric-separators rule
   - `292322fac` chore(marshal,cli): exempt comparison literals from numeric-separators rule

3. **Selective-override sites** (all line-scope `eslint-disable-next-line unicorn/numeric-separators-style`):
   - `packages/hex/test/decode.bench.js` line 191: `defaultSeed = [0xb0b5c0ff, 0xeefacade, 0xb0b5c0ff, 0xeefacade]` (BOBSCOFF/EEFACADE mnemonic).
   - `packages/hex/test/encode.bench.js` line 166: same `defaultSeed` literal.
   - `packages/cli/test/number-parse.test.js` lines 7-11: the two `parseBigint` cases comparing a bigint literal to its decimal-string argument. The disable comments precede each affected bigint on its own line.
   - `packages/marshal/tools/marshal-test-data.js` line 118: the `[9007199254740993n, { digits: '9007199254740993' }]` pair.

4. **`yarn lint` from repo root**: 0 errors, 0 warnings (only the unrelated `[DEP0128]` Node warning about `packages/ses/package.json`'s `main` field, pre-existing). Phase 1 autofix produced 26 files of hex-regrouping; subsequent Prettier surfaced 5 files needing reflow (`cjs-module-analyzer/index.js`, both hex bench files, two ocapn fuzz tests). The eslint-plugin's own integration test (`internal-numeric-separators.test.js`, added on `0739b4f8c`) was failing under the new `groupLength: 4` until updated; the option-shape `deepStrictEqual` and the hex `RuleTester` fixtures were both refreshed (66+1 = 67 passing). The `0xAB_CD` "already canonical at groupLength 2" valid case was retired in favor of `0xABCD` (single 4-digit group, no separator needed) and `0xAB_CDEF` (the new canonical-at-4 boundary).

5. **Surprises in the autofix re-run**: (a) The integration test that the cleaner had pinned to `groupLength: 2` made the rebase a real edit, not just a stack-on-top. The dispatch entry described project head `0739b4f8c`, but the prepared worktree was sitting at `b583f9259` (one commit behind); a fetch+rebase onto origin's tip was required before pushing. (b) Prettier reflowed 5 files after the ESLint autofix: the line widths shifted because `0xff_ff_ff_ff` (12 chars) becomes `0xffff_ffff` (11 chars), and several lines hovered around the 80-column boundary in a way the original PR's prettier pass had already settled at the 2-byte groupings. (c) Some `0x1_00_00` literals became `0x1_0000` and `0xfc_00` became `0xfc00` (4-or-fewer-digit hex now no longer warrants a separator at all under `groupLength: 4`); the autofix handled this correctly.

Self-improvement: nothing this time.
