## Gauntlet fix round 3: endojs/endo-but-for-bots#1396

I applied all four must-fix items and most of the should-fix items from the round-3 panel. The fixes are pushed, but CI hadn't finished at the 3600s deadline: `ci-wait-merge` returned rc 4, with 31/33 checks passed, 0 failed, and 2 still pending. The two pending checks are `test (22.x, macos-15)` and `test (24.x, macos-15)`, both still queued on macOS runners.

**Pushed to `build/sturdyref-captp-construct`** (`c951573936` → `13f96a7d89`, with `safe-push-pr-head.sh` in advance mode):
- `88c9a9743d` fix(captp,ocapn):
  - **Must-fix 3:** `SturdyRef` now comes from the top-level `@import` block in `captp.js`, replacing the two inline `import()` types.
  - **Must-fix 4:** added fast-check property tests in both packages. They generate many object ids, run them through every validation-failure path, and check that no error message contains the id. `fast-check` (`^4.10.2`) is now a devDependency of `@endo/captp` and `@endo/ocapn`.
  - **Should-fix:**
    - Data that isn't an object (such as `null`) now gets the module's own error instead of a raw engine `TypeError`.
    - Extra properties are now checked with `Reflect.ownKeys`, so symbol-keyed extras are rejected.
    - The `l-0` locator is now typed as a `RemoteKit` with a `locate` method instead of `any`.
    - A `Uint8Array` objectId is copied in `sturdyRefDataToDetails`, so the caller's buffer is no longer shared or frozen. A test covers this.
    - The `peerId` option doc now says it is not a security boundary.
- `13f96a7d89` chore: Update yarn.lock (separate commit, 2 lines).

**PR body edited:**
- **Must-fix 1:** `designator` is now `network` throughout, and the OCapN mapping reads `network` → `location.transport`.
- **Must-fix 2:** the invented `## Stack index` heading is folded into Description.
- The Documentation Considerations sentence that only restated the diff is replaced. The Security section now mentions the property tests.

**Checks I ran locally:**
- `yarn test test/sturdyref.test.js` passes in both packages (captp: 14 tests, ocapn: 17).
- `yarn lint` (eslint and tsc) passes for both packages.
- The repo-root `tsc -p tsconfig.json --noEmit` reports no errors.

**Not done:**
- **Squashing the fixup commits** (`4330ae6f00` and `14e9810335`): I skipped this should-fix because it needs a history rewrite and force-push, and this stage only adds follow-up commits. It can be done before the PR is un-drafted.
- **Comment-only items:** left for later. These are the round-trip property tests, the `network` field on the location, the duplicated validator, forwarding `SturdyRef` from `packages/ocapn/index.js` with a README entry, and the scribe mapping comment.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2727598 cached reads)
- Output: 14363 tokens
- Cost: $1.5238356000000002
- Wall-clock: 3858s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
