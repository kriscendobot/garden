I made the one must-fix change and pushed it, but CI didn't finish within the hour and five checks have already failed. My guess is that the failures are unrelated to my change, which is a one-word rename, but I haven't confirmed it.

**The fix.** In `packages/ocapn-noise/src/network.js`, the session writer's `throw` handler (about lines 1360–1370) now names its parameter `error` instead of `err`. That is the only occurrence the PR adds; the other `err` uses in the file were already there, so I left them alone. The edit is commit `4df3d965f` ("refactor(ocapn-noise): spell out the error parameter in the session writer's throw"). `safe-push-pr-head.sh` pushed it on top of `750929d3b` as a plain follow-up commit, with no history rewrite.

**The comment warning (non-blocking).** I kept the 6-line comment at line 196 above `OUTBOUND_HIGH_WATER_FRAMES`. It explains things the code doesn't show: the queue limit still holds with concurrent writers because each one checks for room before adding a frame, and merged heartbeats mean the queue never holds more than the limit plus two.

**Checks.** `node --check` passes on the file. I couldn't run eslint because the checkout has no `node_modules`.

**CI.** `ci-wait-merge.sh --no-merge` hit its 3600s deadline with rc=4 and one of 35 checks still pending. Five checks have already failed:
- `test (22.x)`
- `test (24.x)`
- `cover (22.x)`
- `cover (24.x)`
- `sandbox-drivers`

In the test log I read, the failing test is `bwrap › bwrap parent death leaves no owned process group` ("Test finished without running any assertions"). That is the sandbox/bwrap failure seen on the ubuntu-26.04 runners. The previous head, `750929d3b`, was fully green (17 passed, 18 skipped). I didn't read the logs for `sandbox-drivers` or the `cover` jobs, so it's unconfirmed that they fail the same way. I also couldn't re-run the failed jobs because the run was still in progress.

**Next step.** I reported this as still-pending, as the rc=4 rule says. If the last check finishes and the run turns red, the next attempt should re-run the failed jobs before treating this as a real failure. Tests in this sandbox suite seem to depend on the runner.

**Setup note.** The first `ensure-project-worktree.sh` attempt was killed at the 120s git limit. It worked with `GARDEN_REPO_GIT_TIMEOUT=900`.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-20261101-750929d3-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1620248 cached reads)
- Output: 7111 tokens
- Cost: $0.9149496000000001
- Wall-clock: 4838s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
