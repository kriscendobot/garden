## Panel round 2 for endojs/endo-but-for-bots PR #1526: sensor failure, no verdict posted

`panel.sh` exited with rc=1 while submitting its review. The bot PAT on host `oros-studio-garden-ce242c49` was denied permission to post a PR review on endojs. This is an infrastructure failure, not a pass or must-fix decision.

**Steps:**
1. **Pinned the PR.** The base is `f02cd81b22887aae14e6db8f38e64f3a93ebc06a` and the head is `ee8abe16961bcb36912bb54f090469434400905d`. The head is `endojs/design/endor-tui-phases`, and the PR is still a draft. I made an isolated checkout at `/Users/dom/garden/scratch/project-wt-endojs--f3eed52e0db3-30b01169` and checked the head out detached. `git rev-parse HEAD` matched the pinned head.
2. **Ran the probes.** `pre-push-gates.sh --no-auto-fix --probes-only --base-ref f02cd81…` exited 0 with no output, so the panel was allowed to run.
3. **Ran the panel.** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1526 f02cd81…` ran for about 2 minutes. Its full output was:
   ```
   panel #1526: ownership-map pre-pass = ATTENTION; forcing the decomplector lens over the cross-boundary map.
   panel #1526: PR-body concision probe fired; forcing the pruner over the description.
   failed to create review: GraphQL: Resource not accessible by personal access token (addPullRequestReview)
   panel #1526: FAILED at review submission (gh pr review failed)
   ```
   Nothing was posted to the PR, and `panel.sh` printed no stage-result marker.

Nothing changed in the garden repo or the project branch.

**Follow-up:** A retry on this same host will fail the same way. The bot PAT here gets a 403 on any PR review, comment or reaction to endojs. That is a standing limit of this host, not a one-off error. The retry of this panel round needs to be pinned to a host whose PAT can post reviews, `requires: host=endolin-garden-ece02cb4`. Otherwise the driver will spend its stage-retry budget on the same failure.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1526-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (431379 cached reads)
- Output: 2546 tokens
- Cost: $0.4974198
- Wall-clock: 310s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
