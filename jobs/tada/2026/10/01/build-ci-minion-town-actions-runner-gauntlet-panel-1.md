Panel round 1 on kriscendobot/minion.town PR #145 came back **must-fix**. The work was already done last session, and the review is still on the PR at head `352719f`. Last time the completion line wasn't the final line, so the job wasn't recorded; nothing new was run this time.

**What ran**
- I checked out the PR head (`kriscendobot/minion.town` @ `ci-minion-town-runner`, `352719f`) in an isolated project worktree.
- `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` ran one round against `origin/main-c54f507` and exited 0 with disposition **must-fix**. All 33 seats finished: 5 request changes, 15 comment-only, 13 approve.

**Where the verdict is**
- **Review:** https://github.com/kriscendobot/minion.town/pull/145#pullrequestreview-5373827457. It is a COMMENTED review, not request-changes, because GitHub won't let the bot request changes on its own PR. The body says at the top to treat it as REQUEST CHANGES.
- **Approve seats:** the full aggregate was 74 KB, over GitHub's 65,536-character review-body limit. The review holds the must-fix seats first, then the comment-only seats. The 13 approve seats are in a follow-up comment: https://github.com/kriscendobot/minion.town/pull/145#issuecomment-5922759650

**Findings the fix stage needs**
- **stylist:** spell out abbreviated names: `FUNC*`→`FUNCTION*`, `DIST`→`DISTRIBUTION`, `tmp`→`temporary`, `*_B64`→`*_BASE64`.
- **breaker:** `scrub()` only deletes `/tmp` leftovers owned by the runner user. A job can use docker to change a file's owner, and that file then survives into the next job.
- **wire-watcher:** `guard_imds` is applied once at controller start instead of on every job loop. That is the iptables rule that keeps the job user away from the instance metadata service.
- **integrator:** the provision, deploy and teardown scripts sit inside the component directory, unlike how the other `deploy/aws` components lay theirs out.
- **corner-prober:** the Lambda's `handler()`/`prune()` have no tests for the allowlist and op-dispatch boundaries, and there is a gap in how the runner list is paged.
- **should-fix:** breaker and wire-watcher both flag that nothing checks the repo stays private.

**Follow-ups**
- The panel-stage prompt asks for a request-changes review, which GitHub refuses on a PR the bot opened. It should say to fall back to `--comment`.
- `panel.sh` should split an aggregate that is over the review-body limit, instead of each stage doing it by hand.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1481984 cached reads)
- Output: 7112 tokens
- Cost: $1.9529045999999999
- Wall-clock: 477s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
