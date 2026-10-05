I applied all three of the round-6 panel's must-fix items to endojs/endo-but-for-bots#1391 and pushed them. CI is green: all 33 checks passed, 0 failed (`ci-wait-merge` rc 0).

**Changes (pushed with `safe-push-pr-head.sh`, head moved `68f2ff05a1` → `19e56526ff`):**
1. **Lost lock after a reentrant swap (engine-realist), commit `3ee1ad2416`.** If user code re-points `globalThis.SturdyRef` while lockdown is checking it, `setGlobalObjectMutableProperties` used to put the right value back but leave it writable and configurable. It now puts it back locked (non-writable, non-configurable).
   - The lock only applies when the global's value is no longer the one lockdown checked. A configurable binding that still holds that value is still redefined as an ordinary global, so `sturdyref-configurable.test.js` still passes unchanged. Child compartments are not affected.
   - `sturdyref-reentrant.test.js` now checks that the restored binding is locked and that assigning to it throws. I confirmed this new test fails against the old `global-object.js`.
2. **Test fixture out of step with the shim (breaker), commit `19e56526ff`.** `_sturdyref-shim-first.js` now captures `Promise`, `TypeError` and `WeakMap` when the module loads, the same way the real shim does.
3. **PR body too long (pruner).** I cut it from 403 to about 245 words. The #695/#1392 scope narrative, the documentation meta-commentary and the file-by-file test inventory are gone, and the Security section now mentions the re-lock.

**Local checks before pushing:** the `packages/ses` tests (417 passed), `test:xs` under `xst` after a fresh build, `lint:types`, and eslint on the changed files (no errors) all passed. The `packages/sturdyref` tests passed too (23). I also posted a comment on the PR summarizing the fixes (issuecomment-5999733871), which covers scribe's point about posting one right after each push.

**Follow-ups:**
- The CI wait ran into the GitHub GraphQL rate limit for about 10 minutes. It retried without assuming success and recovered on its own.
- Some comment-only suggestions were not acted on in this round: property-based tests with fast-check, regression tests for capturing `TypeError` and `WeakMap`, a test for the two-read `prototype` swap, and an XS test for `@endo/sturdyref` itself.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2017242 cached reads)
- Output: 11034 tokens
- Cost: $1.2446004
- Wall-clock: 2345s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
