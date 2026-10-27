## Completion report: endojs-endo-but-for-bots-pr1566-fix-ci-failures

**Outcome:** CI on endojs/endo-but-for-bots#1566 is all green at head `6c8a0ba3a5`. The fix is a commit I cherry-picked from #1567, which is open, not merged, and also green.

**What was failing:** Only `test (24.x, ubuntu-latest)` and `test (24.x, macos-15)` were red. All 28 tests in `@endo/floot`'s `test/factory-system-prompt.test.js` passed, but the file then exited 1 on an unhandled rejection: `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'`.
- **Not caused by #1566's diff.** The PR's sandbox change put floot in CI's affected set, which is why the test ran here.
- **Cause:** the test `createSession never infers a hosted backend from a colon in modelId` sent a real provider request. On Node 24 under SES, the rejection undici raises when it destroys that request's connection is fatal. `endo-fs-asset-server` hit and worked around the same failure earlier.

**What I did:**
- **Found an existing fix.** PR #1567 (`fix/floot-client-destroyed-error-node24`, commit `e8294ede88`, "test(floot): keep model routing check offline") already makes that test offline: it stubs `lookupProvider` and `fetch` and asserts no fetch happens. It targets the same base, `llm-d5ac419`.
- **Cherry-picked it** with `-x` onto the #1566 head branch as `6c8a0ba3a5`.
- **Checked locally on Node 24.19.0:** the file passes (28/28), eslint shows 0 errors (the 11 warnings were already there and none touch the changed lines), and prettier is clean. I could not reproduce the failure locally (the file passed 3/3 runs before the fix), so the CI run is the real evidence.
- **Pushed and waited for CI** in the foreground. Every check passed, including both Node 24 legs, `sandbox-drivers`, `lint` and the cover runs.
- **Left a comment on #1566** explaining the change: https://github.com/endojs/endo-but-for-bots/pull/1566#issuecomment-6449042971

**Follow-ups:**
- #1566 and #1567 now carry the same patch. Whichever merges first, the other rebases cleanly; if #1566 lands first, #1567 can just be closed.
- #1566 is still a draft. Moving it through the gauntlet and un-drafting it is outside this fixer job; after that it should unblock #1575 and the M3 Claude API sequence.
- No garden (main2) changes were made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1566-fix-ci-failures.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2011422 cached reads)
- Output: 9177 tokens
- Cost: $1.1616163999999998
- Wall-clock: 841s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
