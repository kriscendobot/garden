## Layer 3 done: `passStyleOf` now recognizes a SturdyRef (draft PR #1392)

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1392. It is a draft, opened through `ensure-pr.sh`, and carries this job's marker.
- Head: `build/sturdyref-pass-style-recognition`, at fa2edee302.
- Base: `build/sturdyref-ses-accommodation-a0ef0c4`. `ensure-pr.sh` would not open a PR against layer 2's moving branch, so I pushed that frozen copy of layer 2's head (a0ef0c4). This is the same pattern layer 2 used on layer 1.

I verified locally only. I did not wait for GitHub CI.

**What changed** (commit ca9619d651, plus a separate `chore: Update yarn.lock` commit fa2edee302):
- **New `packages/pass-style/src/sturdyref.js`:** it recognizes a SturdyRef using only the realm's `SturdyRef.isSturdyRef` brand check, as the layer-1 design (#1389) requires.
  - It never uses `instanceof` and never reads anything from the ref.
  - Pass-style does not depend on `@endo/sturdyref`. It reads the global `SturdyRef` the shim installs and keeps its brand check once found, so a value's pass style never changes later.
- **`passStyleOf.js`:** the brand check runs on frozen objects that are not promises or thenables, before the `PASS_STYLE` check. A match returns `'sturdyRef'`. There is no `sturdyRef` entry in the helper table, so a forged `{ [PASS_STYLE]: 'sturdyRef' }` is still rejected.
- **`types.d.ts`:** adds `'sturdyRef'` to `PassStyle`, a `SturdyRef` interface, and a `passStyleOf` overload. I left `SturdyRef` out of `PassableCap` on purpose: whether marshal carries it as a slot is layer 4's decision.
- **`deeplyFulfilled.js`:** a SturdyRef passes through unchanged.
- **`@endo/marshal` `encodePassable.js` (type annotation only):** the prefix table now excludes `sturdyRef`. Without this, marshal and patterns failed to type-check. At runtime, trying to encode a SturdyRef still throws until layer 4.
- **Tests:** `test/sturdyref.test.js` (9 tests, using the real `@endo/sturdyref/shim.js`) and `test/sturdyref-absent.test.js` (2 tests). `@endo/sturdyref` is a new devDependency of pass-style.
- **Changeset:** `.changeset/pass-style-sturdyref.md`, a minor bump for `@endo/pass-style`.

**From #737 (not rebased):** I reused its test ideas (identity, nesting in containers, rejecting forgeries) and its style name `'sturdyRef'`. I dropped its `makeSturdyRef` constructor and its tag-record shape, which the layer-1 design replaced. `@endo/ocapn`'s existing `ocapn-sturdyref` is untouched.

**Local checks:**
- The full `@endo/pass-style` test suite passes in every config, with 1 test skipped that was skipped before this change.
- The type check (`lint:types`) is clean for pass-style, marshal and patterns.
- eslint shows 0 errors and prettier is clean on the touched files.

**Follow-ups:**
- Layer 4 (marshal) must give `sturdyRef` an encoding prefix and a slot kind, and decide whether it joins `PassableCap`.
- The pass-style README's list of styles should gain a SturdyRef entry once marshal can encode one.
- The stack-index comment on arc kriscendobot/garden#47 still needs #1392 added. I did not edit it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3264067 cached reads)
- Output: 20485 tokens
- Cost: $1.9006334000000003
- Wall-clock: 316s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
