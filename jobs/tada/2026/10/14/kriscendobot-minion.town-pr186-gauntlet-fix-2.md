I fixed both must-fix items from panel round 2 on kriscendobot/minion.town#186, pushed the fix, and CI is green on the new head `db483f6`.

**Fixes** (one follow-up commit, pushed with `safe-push-pr-head.sh`, advancing the head from `8c80972` to `db483f6`):
1. **Silent pass on a symlinked path (engine-realist):** `deploy/probe/root-canary.mjs` now decides whether it is the main script with a new `isMainModule`. It compares the resolved real path of the module with that of `process.argv[1]`. Before, a symlinked release directory or a path with a space made the canary skip its run and exit 0. A new test starts the script through a symlink in a directory whose name has a space, and checks that the run actually starts.
2. **Swallowed cleanup errors (saboteur):** cleanup now runs in a new `cleanUpRootCanary`.
   - If dismissing the child or ending the session fails, the error goes to stderr with where it came from.
   - A dismiss that the server answers with an error result counts as a failure.
   - An otherwise passing run now fails instead of reporting pass. A run that already failed keeps its original error.
   - The dismiss is skipped when no child was ever requested.
   - Five new unit tests cover these cases.

**Declined:** the suggestion that `root-canary-exec.sh` should require an explicit `"status":"pass"` line. That script is the general `-- <command>` runner from design §2.6. It passes the child's exit code through, and an existing test checks that. With the entry-point fix, the canary can no longer exit 0 without running.

**Verification:** the two root-canary test files pass (24 tests) and `npm run typecheck` is clean. `ci-wait-merge.sh --no-merge` returned 0 (3 of 3 checks green).

**PR comment:** I posted a fix-round summary on the PR, which the scribe had flagged as missing. It lists what this round and the round-1 commits closed, the declined item, and the four should-fix themes I left untaken: the exit code for a bad session name, the mint listener that accepts only one request, revoking `AWSPREVIOUS`, and the token-bearing `AuthInfo` passed to the audit hook. They remain possible follow-ups.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1293151 cached reads)
- Output: 10573 tokens
- Cost: $1.0282102
- Wall-clock: 909s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
