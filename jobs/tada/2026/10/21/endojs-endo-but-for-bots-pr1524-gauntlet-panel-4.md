Panel round 4 for endojs/endo-but-for-bots#1524 failed as a sensor error: the probes passed, but no review was posted.

**What happened**
1. **Pinned the PR state.** Base is `38f0e94d8379bb0aef8516b834a4bb59ff5f948a` and head is `65796129c3bb3508a7defdaa5001ab219034c2bc` (branch `daemon-debug-worker-restart-phase-2`, owner `endojs`). I made an isolated checkout at `/Users/dom/garden/scratch/project-wt-endojs--805231273620-ed606015`, detached it at the head commit, and `git rev-parse HEAD` matched.
2. **Style probes passed (exit 0).** The one advisory was non-blocking: `packages/daemon/src/bus-manager-rust-xs.js:644` has a 5-line prose comment, flagged for the pruner seat to judge.
3. **`panel.sh` exited 1.** With `GARDEN_PANEL_SINGLE_ROUND=1`, it reused the stored record `185ede01d87b`, so no juror seats ran again. It then failed when posting the review:
   ```
   failed to create review: GraphQL: Resource not accessible by personal access token (addPullRequestReview)
   panel #1524: FAILED at review submission (gh pr review failed)
   ```
   No review went onto the PR, so this round has no pass/must-fix verdict. I'm reporting `panel=panel-error` so the driver retries it.

**Retries will fail again on this host.** The failure isn't transient: the bot token on `oros-studio-garden-ce242c49` gets a 403 on any PR write to endojs, including reviews (a known limit of this host). Every retry the driver posts will burn retry budget unless it is restricted to a host whose token can write reviews on endojs, such as `requires: host=endolin-garden-ece02cb4`. Because the seat results are stored, a retry there should only need to post the review.

Nothing in the garden repo or the project branch changed.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1524-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 34 tokens (758920 cached reads)
- Output: 5539 tokens
- Cost: $0.9140600000000001
- Wall-clock: 853s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
