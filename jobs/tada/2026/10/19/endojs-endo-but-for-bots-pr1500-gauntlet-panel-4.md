## Panel round 4 for endojs/endo-but-for-bots PR #1500: panel error (the review could not be posted)

The style pre-pass passed and a verdict already exists, but `panel.sh` exited 1 because the review could not be posted from this host. Under the job rules that counts as a sensor failure, so the marker is `panel=panel-error`.

1. **Pinned pair.** I recorded both commit IDs from the PR:
   - base `ca5aaefb23c58a3bf11162cf78e7062d248371cc`
   - head `da4b8ac700fde140788d998aa6bd01a6767d851b`
   - head owner and branch: `endojs` / `build/endo-gateway-mcp-termination`

   The isolated checkout is `/Users/dom/garden/scratch/project-wt-endojs--6fa6a12c1d42-8345cc5a`. I checked out the head commit detached, and `git rev-parse HEAD` matched it.
2. **Style pre-pass.** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. It gave one non-blocking warning: a 22-line prose comment at `packages/agent-mcp-stdio/src/http.js:1` (the pruner seat flags it).
3. **Panel.** I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` and it exited with **rc=1**. It did not re-run the jurors. It reused the verdict from an earlier attempt of this round (durable record `302ea84461fa`), then failed when it tried to post the review:
   ```
   panel #1500: code-panel single-round — RESUMED from durable record 302ea84461fa (seats not re-run)
   failed to create review: GraphQL: Resource not accessible by personal access token (addPullRequestReview)
   panel #1500: FAILED at review submission (gh pr review failed)
   ```
   The newest review on the PR is still the earlier `COMMENTED` one by kriscendobot at 2026-10-19T16:51:24Z, so this round posted nothing. I posted no aggregate myself.

**Follow-up:** this will not clear on a retry from this host. The bot's token on `oros-studio-garden-ce242c49` gets a 403 on PR reviews, comments and reactions for `endojs` repos. A retried panel round needs to be pinned to `requires: host=endolin-garden-ece02cb4`. Otherwise it will rerun the panel from the saved verdict and fail at the same step. I made no changes to the project or the garden.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1500-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 64 tokens (1576235 cached reads)
- Output: 14761 tokens
- Cost: $1.7295710000000002
- Wall-clock: 960s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
