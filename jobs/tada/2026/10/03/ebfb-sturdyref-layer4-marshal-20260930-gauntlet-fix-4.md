# Fix round 4 for endojs/endo-but-for-bots PR #1393: fixes pushed, CI green

I applied the round-4 panel's must-fix items as five follow-up commits on `build/sturdyref-marshal-representation`. The push went through `safe-push-pr-head.sh`: head moved from `4b4842c464` to `0e1d90053f`. `ci-wait-merge --no-merge` returned rc 0, with all 33 checks done and none failed.

## What changed
- **`7b6de9e795` refactor(marshal), stylist and purist:**
  - Renamed the `ref` parameters to `sturdyRef` in `encodePassable.js`, `encodeToCapData.js` and `encodeToSmallcaps.js`.
  - Did the same in both `sturdyref.test.js` files (`makeRef` became `makeSturdyRef`).
  - Renamed the local `isSturdyRef` check to `isPassableSturdyRef`, so it no longer shares a name with the `@endo/sturdyref` brand check.
- **`27f418bffa` fix(patterns), purist:** the `Key` and `Pattern` types now exclude `SturdyRef`. This caused one type error in `compareKeys.js`, so I added a `Key` cast there with a comment. It follows an existing cast in the same file.
- **`90ec319faf` fix(marshal), spec-keeper and purist:** the smallcaps `'` decoder now accepts only a canonical decimal index and gives an error that names the SturdyRef. New tests check that `'`, `' 0`, `'0x0`, `'0e0`, `'00` and `'3.Foo` are rejected, and that a plain string `"'0"` is still escaped as `#"!'0"`.
- **`f8075a530e` fix(marshal), spec-keeper and corner-prober:** in `dot-membrane.js`:
  - The realm's `SturdyRef` and its `enliven` are now captured once, and the membrane checks that the ref it creates is a SturdyRef.
  - `enliven` is now called inside `E.when`, so a synchronous throw also crosses the membrane through `pass()`. A new test covers this.
- **`0e1d90053f` docs(marshal), packager and spec-keeper:** added `@endo/spaces-util: patch` to the changeset. The smallcaps cheatsheet now labels the sturdyRef row as an Endo extension, not part of OCapN.
- **PR body, pruner:** cut the Documentation Considerations section that repeated the diff, shortened the XS note to one sentence, and removed the ava snapshot workaround sentence. I also added the new test coverage and type changes to the body.

## Local checks
- **Passed:**
  - The full `@endo/marshal` ava suite.
  - `tsc` for marshal, patterns, pass-style, sturdyref, spaces-util and exo.
  - prettier.
  - eslint, with warnings only.
- **Not checked locally:**
  - The `@endo/patterns` ava tests did not run here: every test file fails at startup with `assert is not defined` in `eventual-send`, including files this PR doesn't touch. CI ran them and passed.
  - The repo-root `tsc` ran out of memory, so the cross-package type check was covered only by the per-package runs above.

## Not addressed
- **procurer** asked to import `isSturdyRef` from `@endo/sturdyref`. I left the local check as it is, only renamed, because `@endo/marshal` keeps `@endo/sturdyref` as a devDependency only; the code comment documents that choice.
- **corner-prober, minor:** there is no test for revoking the membrane while an enlivening is in flight.
- Comment-only findings from other seats were not acted on.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3867905 cached reads)
- Output: 18642 tokens
- Cost: $1.9773329999999991
- Wall-clock: 2347s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
