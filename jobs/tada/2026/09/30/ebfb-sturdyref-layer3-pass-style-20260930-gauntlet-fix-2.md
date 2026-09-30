## Gauntlet fix round 2: endojs/endo-but-for-bots PR #1392

I fixed both round-2 must-fix items and pushed them to the PR head (`b8c830e71b..2e92bd7790`). CI is green: `ci-wait-merge` returned rc 0, with 33 checks and 0 failures.

**Commits pushed with `safe-push-pr-head.sh` in advance mode:**

- **`737f039eb7` fix(pass-style)** — covers the prover's must-fix plus the warden's and corner-prober's should-fix items.
  - **Warden:** `sturdyref.js` now trusts a `SturdyRef` global only if its prototype has the same shape as the shim's. It must inherit from `Object.prototype` and hold only a data `constructor` equal to the global and a data `Symbol.toStringTag` of `'SturdyRef'`. Before this, an impostor could give its refs inherited methods.
  - **Prover:** the new `sturdyref-gated-global.test.js` tests each condition on the trusted global. It has a control case that is trusted and 8 cases that each break one condition. The prover's complaint was that shared cases hide each other, so each case imports a fresh instance of `sturdyref.js`. I checked this by deleting the validation block: all 8 negative cases then failed.
  - `sturdyref-malformed-global` now freezes its constructor, so it actually reaches the `isSturdyRef` check its title names.
  - **Corner-prober:** the lying-global test adds a candidate with the right prototype and an own key.
  - I updated the pass-style changeset to match.
- **`18ffa390a6` fix(patterns)** — covers the saboteur, breaker and migrator must-fix.
  - `'sturdyRef'` is now rejected alongside `promise`/`error` in `confirmKeyInternal`, `confirmPattern` and `confirmMatchesInternal`.
  - `isKey`, `isPattern` and `matches` now return false for a SturdyRef. `assertKey`, `keyEQ` and `mustMatch` now say it "cannot be a key/pattern" instead of throwing an internal error.
  - Added `packages/patterns/test/sturdyref.test.js`, which fails on the old source. Also added `@endo/sturdyref` as a devDependency and a patch changeset for `@endo/patterns`.
- **`2e92bd7790` chore: Update yarn.lock**

**Local checks:** the full pass-style and patterns test suites pass under every ses-ava config (patterns 702, pass-style 99–100 per config). eslint reports no errors on the touched files, and I ran prettier on them.

**Summary comment:** I posted one on the PR (issuecomment-5916856347). It covers this push and also the round-1 response push, which never got one (the scribe's item).

**Left for follow-up (should-fix or comment-only items I did not address):**
- The marshal encoders and `dot-membrane` still report a SturdyRef as `internal: Unrecognized passStyle`.
- Comparing two SturdyRefs by rank gives a different error message than comparing a SturdyRef with another style (purist).
- `SturdyRefObject` is not yet part of `PassableCap`.
- The pass-style switches in daemon and spaces-util still need an audit.
- The fast-checker suggested property-based versions of the gate tests.
- The pruner asked to trim the PR body and the module comment.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3446522 cached reads)
- Output: 20280 tokens
- Cost: $1.8919044
- Wall-clock: 3681s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
