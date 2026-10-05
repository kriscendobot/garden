# Fix round 5 report: endojs/endo-but-for-bots#1391

I applied the round-5 panel's must-fix items, force-pushed the PR head, and CI is green on the new head (`ci-wait-merge` rc 0, 33/33, 0 failed).

**What changed** (PR head `673167cf5a` → `68f2ff05a1`, pushed with `safe-push-pr-head.sh --mode rewrite`):
- **Integrator item 1, commit history:** I reset to base `ef4662f` and rebuilt the history as four commits:
  - `feat(ses)`: the source changes.
  - `test(ses)`: the tests.
  - `fix(sturdyref)`: the fix plus its test.
  - `chore`: the changesets.

  The three daemon test commits and their `revert(daemon)` are gone, and the review fix-ups are folded into the commits they amend. The final tree differs from the old head only by the comment edits below.
- **Integrator item 2:** the `SturdyRef` permit comment in `packages/ses/src/permits.js` now says instances are "not yet passable; see layer 3 (#1392)".
- **Integrator item 3 (comment-only):** `packages/ses/test/_sturdyref-shim-first.js` now has a header pointing at the real-shim test in `@endo/sturdyref`.
- **Breaker (should-fix):** I rewrote the `isFirstWinsDescriptor` comment in `global-object.js`. It no longer claims the value comparison "always holds"; it now says that comparison catches a reentrant shape check re-pointing the binding.
- **Copyeditor (should-fix):** fixed the `interinsicsCollector` → `intrinsicsCollector` typo in `intrinsics.js`.
- **Scribe:** posted a completion summary covering the pushes for rounds 4 and 5 (issuecomment-5998657504).

**Checks:** Locally, the SES `sturdyref-*` and `global-locked-universal` tests passed (17), the `@endo/sturdyref` tests passed (23), and Prettier is clean. ESLint gave 2 warnings and no errors.

**Follow-ups:**
- Breaker also suggested a `_sturdyref-reentrant-locked.js` test that expects a `TypeError`. I fixed the comment only and did not add the test.
- Other comment-only items from the non-blocking seats are not addressed: drift between the XS stand-in shim and the real one, Hermes and the locked-prototype requirement, and the first-wins generalization being half-built.

The driver will post panel round 6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1035348 cached reads)
- Output: 7780 tokens
- Cost: $0.8573816000000001
- Wall-clock: 2303s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
