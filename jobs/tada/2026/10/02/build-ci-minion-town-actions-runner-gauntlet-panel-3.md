Panel round 3 on kriscendobot/minion.town PR #145 came back **must-fix**. I posted the verdict as a review on the PR.

**What I did**
- Checked out the PR head (`kriscendobot/minion.town@ci-minion-town-runner`, commit `aa3ef2d`) into its own worktree, at `scratch/project-wt-build-c-8b640f921183-adde1f80`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 145 origin/main-c54f507`. It exited 0 with disposition `must-fix`. The first launch was a backgrounded command that could have been killed at 10 minutes. I stopped it and its seats a few seconds in and reran it detached; only that second run produced the verdict.
- 33 seats ran: 6 request-changes (stylist, locksmith, saboteur, breaker, engine-realist, integrator), 13 comment-only and 14 approve.
- Posted the verdict as review https://github.com/kriscendobot/minion.town/pull/145#pullrequestreview-5388503073. GitHub refuses request-changes on a self-authored PR, so it went up as a COMMENT review and its body says to treat it as REQUEST CHANGES, the same as rounds 1 and 2. The review leads with the request-changes and comment-only seats. The full aggregate is 85 KB, over GitHub's review-body limit, so the 14 approve seats are in a separate comment: https://github.com/kriscendobot/minion.town/pull/145#issuecomment-5945981622

**Main findings for the fix stage**
- **stylist (must-fix):** new shell variables are still abbreviated:
  - `temporary_dir`, `rel` and `ver` in `bootstrap.sh`
  - `tok` in `ci-runner-controller.sh`
  - should-fix: `res`, `out` and `op` in the Lambda, and the `gh` test helper.
- **integrator (must-fix):**
  - `DEPLOYMENT.md` still cites #144 for the billing block, but #144 is an unrelated guest-coupon design PR.
  - should-fix: fold the "address panel round N" commits into the commits they fix and use `type(scope):` subjects; add `[skip deploy]`; explain why the Lambda lives in `deploy/aws/ci-runner/` rather than `deploy/aws/lambda/`.
- **locksmith / breaker:**
  - The minter should check that the repo is still private each time it mints, not only when the runner is provisioned.
  - The trust note's "at worst mint more runners" understates the risk: a job can run a root container on the host network and reach the instance metadata service. Suggested fixes are to cap live runners or add an `aws:SourceIp` condition.
- **saboteur / breaker:** the scrub between jobs misses `ghrunner`'s crontab and any `/tmp/systemd-private-*` directory a job creates, and a single `pkill` can miss processes from a fork loop.
- **saboteur / engine-realist / assessor:** the 10-minute offline-runner sweep can delete a runner that was just minted and hasn't connected yet. Separately, there is no back-off when `run.sh` exits quickly.
- **breaker:** the teardown script hard-codes resource names that the provision script lets environment variables override.
- **engine-realist:** the emulated arm64 build on a `t3.large` with standard CPU credits is likely to hit the 20-minute timeout.

No garden files changed. I didn't fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-minion-town-actions-runner-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1093203 cached reads)
- Output: 6672 tokens
- Cost: $0.8575366
- Wall-clock: 356s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
