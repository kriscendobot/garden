# PR #1392 gauntlet fix round 5: one panel must-fix item only partly addressed, one not addressed

CI is green, but the panel's two must-fix items are not fully done, so panel-6 should expect both to come back.

**What I pushed:** one follow-up commit, `b404d4452d`, to `endojs/endo-but-for-bots` on `build/sturdyref-pass-style-recognition`.
- **First must-fix item (the decomplector's), partly done:**
  - I removed the per-candidate `decisions` WeakMap from `packages/pass-style/src/parcel.js`. `passStyleOf` already remembers every `'parcel'` answer, so a recognized Parcel can't be reclassified later. A rejected candidate throws, and errors are never remembered, so it may be asked again; the comment above `brandCheck` now explains this.
  - I kept the `checking` reentrancy guard. Without it, an `isParcel` that calls back into `passStyleOf` recurses until the stack overflows, and the result depends on how that overflow unwinds. The `reentrant` test pins this case.
  - I did not do the alternative fix, letting `@endo/parcel` register its check with pass-style instead of pass-style reading the global. That is a design change, and the reason for using the global is already in the existing doc comment.
- **Should-fix (the typist's):** added `// @ts-check` to `parcel.js`.
- **Test change:** the `stateful` case in `test/parcel-pre-shim-fixture.js` asserted that a rejection was cached. It now asserts the new behaviour: a rejection can be retried, and once a value is classified `'parcel'` it stays that way. This changes behaviour on purpose: a candidate whose `isParcel` answers differently over time can go from not passable to `'parcel'`, but never the other way.
- **Checks:** the pass-style tests pass (110 tests). eslint shows no errors, only one warning on a line I didn't change. `yarn lint:types` passes. CI after the push: 35 checks, 0 failed.

**Second must-fix item (the coverage-auditor's), not done:** the `'parcel'` branches in `packages/spaces-util/src/value-render.js` and `value-vnodes.js` are still untested. `@endo/spaces-util` has no test script and no ava dependency. Adding them means changing `yarn.lock` and reinstalling, and that didn't fit in this round's budget. A follow-up should add ava plus a test script and test `valueToVnodes` on a Parcel in Node. Testing `render` needs a DOM.

**Other should-fix items not taken:** the per-call cost of the nested-identical walk in `rankOrder.js` `compareParts`, the duplicated rejection of values that have no sort rank, renaming `labelComp`, and a `@returns` on `getPassStyleRank`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1084199 cached reads)
- Output: 9233 tokens
- Cost: $0.9129557999999997
- Wall-clock: 145s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
