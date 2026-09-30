# Fix round 1 — endojs/endo-but-for-bots#1393 (SturdyRef layer 4, marshal)

All six must-fix items from the panel-1 review (5371698026) are fixed and pushed to `build/sturdyref-marshal-representation` (`36c4f40bcd` → `3e93fbbe66`). CI is green: 33 checks, 0 failed. I did not re-run the panel.

**Commits (follow-ups, no history rewritten):**
1. `85e3cd77e7` **fix(marshal): reject a SturdyRef decoded from a capdata slot** (item 1).
   - The capdata `'slot'` case now rejects a value that is a SturdyRef. It uses a `passStyleOf` check that returns false instead of throwing, so capdata still accepts whatever else `convertSlotToVal` returns.
   - The comment that claimed the decoder "can and does check" is corrected, and the `TODO SECURITY HAZARD` in `marshal.js` now names SturdyRefs.
   - New capdata regression tests cover sturdyRef-then-slot reuse (the reproduced attack), slot-then-sturdyRef reuse, and a SturdyRef in a fresh plain slot.
2. `58d3ffecf4` **fix(marshal): pass a SturdyRef enliven rejection across the dot-membrane** (item 2).
   - Both settlement paths now go through `pass()`, plus the two `.catch` layers for when `pass()` itself fails, as in the `'promise'` case.
   - A new test checks that a rejected enlivening arrives as a membraned proxy, not the original object.
3. `b40038e095` **test(pass-style): generate SturdyRefs in the passable arbitraries** (item 4).
   - `arbPassable` now includes SturdyRef leaves when the realm has a `SturdyRef`, with an opt-out `excludePassStyles: ['sturdyRef']`. They are not keys, so `arbKey` is unchanged.
   - The marshal rankOrder and encodePassable property tests now install the shim, and the encodePassable test kit gained a `t` encoder and decoder. A sample check found 77 SturdyRefs in 2000 generated values, and 0 with the opt-out.
   - The commit message also states that `b9b3777f1b` silently dropped the already-failing `passStyleOf rejects a SturdyRef` assertion (item 3).
4. `3e93fbbe66` **docs(changeset)** (item 5): one sentence per line, describes the capdata slot check and the arbitraries, and adds `'@endo/patterns': patch` for the shifted rank-cover indices.

**PR body** (items 3 and 6):
- Removed the "Stack index" heading and folded it into one clause in Description.
- Removed the inline test tally.
- Added the disclosure about the removed assertion.
- Updated Security, Testing, the membrane row of the table, and Upgrade to match the fixes.

**Local verification:**
- marshal: 113 passed, 1 pre-existing skip.
- pass-style: 86 passed.
- patterns: 699 passed.
- `yarn lint` (types and eslint) has 0 errors for marshal and pass-style.
- Repo-root `tsc -p tsconfig.json` reported no errors.
- prettier is clean.

**Follow-ups, not done here** (non-blocking panel comments):
- `deeplyFulfilled` has no `'sturdyRef'` case (it throws).
- `marshal-justin` doesn't reject an `iface` on a sturdyRef.
- There is no eval-based Justin binding for `sturdyRefToVal`.
- The smallcaps cheatsheet's OCapN mapping for SturdyRef needs a source.
- The fast-checker's optional generalization of the hand-written round-trip tests.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4093240 cached reads)
- Output: 22944 tokens
- Cost: $2.1967359999999996
- Wall-clock: 2496s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
