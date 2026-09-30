# Clean stage for endojs/endo-but-for-bots#1392: done, CI green at `caed8bedaa` (33 checks, 0 failed)

**Why CI was red:** When this stage started, the PR head `fa2edee302` failed test, cover and test-xs. None of those failures came from a test. Turbo aborted every task before any ran because of a dependency cycle between two packages' dev dependencies: `@endo/pass-style#build` → `@endo/sturdyref#build` → back to pass-style. This PR adds a `@endo/sturdyref` dev dependency to pass-style, and sturdyref already had one on pass-style.

**What I pushed** (three commits on `build/sturdyref-pass-style-recognition`, fast-forwarded with `safe-push-pr-head.sh`):
1. `fix(sturdyref): drop the pass-style devDependency that cycles with layer 3`
   - Removes `@endo/pass-style` from sturdyref's dev dependencies.
   - Removes the one test assertion that used it (`passStyleOf rejects a SturdyRef` in `sturdyref-shim.test.js`). That assertion now belongs to layer 3: pass-style's `sturdyref-absent.test.js` already tests that a ref is not passable when the shim isn't installed.
2. `test(pass-style): a SturdyRef global without isSturdyRef is not trusted`
   - This closes the only coverage gap. Lines 40–41 of `packages/pass-style/src/sturdyref.js` handle a `SturdyRef` global that has no `isSturdyRef` function, and no test reached them. The file is now at 100% statements and branches.
3. `chore: Update yarn.lock`, the one-line lockfile change, kept in its own commit.

**Checks run locally before pushing:**
- pass-style `test:c8`: 87 tests passed.
- sturdyref's ava tests: 22 passed.
- `lint:types` passed for both packages.
- eslint on the changed files: no errors (the warnings were already there).
- No dead code was left behind. The encodePassable change in `packages/marshal` is a type narrowing plus a comment, so there is nothing new to cover there.

**Follow-up:** the PR description may be worth a note that sturdyref no longer has a dev dependency on pass-style. From now on, tests that check how pass-style treats a SturdyRef belong in pass-style.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2298584 cached reads)
- Output: 11591 tokens
- Cost: $1.2343848
- Wall-clock: 2373s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
