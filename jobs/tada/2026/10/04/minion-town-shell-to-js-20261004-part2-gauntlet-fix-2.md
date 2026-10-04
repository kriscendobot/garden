I applied all of panel round 2's must-fix items on PR #152 (kriscendobot/minion.town) and pushed them as follow-up commit `478f9bd` with `safe-push-pr-head.sh`. CI is green on `478f9bd` (3 of 3 checks; `ci-wait-merge` returned rc 0).

**Changes**
- **Ctrl-C cleanup (breaker, engine-realist):**
  - The problem was real. A terminal Ctrl-C signals the whole process group, so the parent died before its cleanup hooks ran. Staged S3 secret objects could be left in the bucket.
  - `onExit` now installs a SIGINT listener. It keeps the parent alive until the interrupted child returns, and then `run` exits through the cleanup hooks.
  - `sleep` now pauses in a separate `sleep` child process, so a Ctrl-C during an SSM poll ends the poll.
  - SIGTERM keeps Node's default. Holding it until a long poll finishes would be worse than exiting without cleanup.
- **Misplaced doc comment (typist, stylist):** the comment describing `exitForSignal` is back above `exitForSignal` instead of `parseJson`.
- **Stale base (integrator):** I copied two fixes from #151's current head (`11fc6bb`) into `lib/common.js`:
  - `SSM_POLL_TRIES` is now validated before `send-command` runs.
  - `AWS_REGION` is passed in the AWS CLI's environment instead of being written into `process.env` at import.
  - A full weave onto #151's final head is still a separate step.
- **`nextGrantId`:** grant ids now keep their zero padding (`-01` becomes `-02`).
- **Tests:**
  - The AWS-override test now sets up a temporary `HOME` with an executable `~/.local/bin/aws`, so it bites on CI. It also covers `AWS=""`, which counts as unset.
  - New test that sends SIGINT to a whole process group.
  - New tests for:
    - zip ordering with mixed-case names
    - empty archives and zero-byte files
    - `formatSize` around the 1023/1024 boundary
    - `parsePollTries`
    - token uniqueness
    - zero-padded grant ids
  - I reverted each fix in turn, and the process-group, zip-order and AWS-override tests failed every time.
- **PR body (pruner):** shortened, with the `garden-job` marker kept.
- **Round summary (scribe):** posted at https://github.com/kriscendobot/minion.town/pull/152#issuecomment-5983558683, including what changed per finding, what was checked, and the loop status.

**Checks:** the deploy-provisioning test file passes 27 of 27 and `npm run typecheck` is clean. The full `vitest` run has one failure, `test/git-remote/capability.test.ts` "propagates a git failure". It also fails with this round's changes removed and is unrelated to this PR, probably because of the `GIT_CEILING_DIRECTORIES` setting on the garden worker.

**Not fixed:** breaker's comment-only note about the two different EnvironmentFile renderers (one blocks bad characters, the other allows only listed ones). One shared allowlist would not fit the Stripe values, so I left them separate; merging them could be a follow-up.

**Follow-ups**
- Weave #152 onto #151's final head once #151 settles.
- Panel round 3 is next; the gauntlet driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1917778 cached reads)
- Output: 21011 tokens
- Cost: $1.5562556
- Wall-clock: 537s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
