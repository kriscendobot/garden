The panel ran but could not post its review, so this round ends as `panel=panel-error`, an infrastructure failure the driver retries.

- **Pinned pair:** base is `386866c0939b2d339c352fc2ed58943393596a60` and head is `8f85b41bb307e512e4f810070dcfd67450d15c32`, from `endojs/endo-but-for-bots` branch `build/endo-gateway` (not a fork). The isolated checkout is at `/Users/dom/garden/scratch/project-wt-endojs--36993fbdbaaf-76de5404`, and `git rev-parse HEAD` matched the head ID.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. It raised one non-blocking warning: the pruner seat flagged a 3-line prose comment at `packages/gateway/src/types.ts:230`.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 1. It reused an earlier saved run of this round (record `a3ca223f7c5f`), so no juror seats were re-run. It then failed to post the review:
  `failed to create review: GraphQL: Resource not accessible by personal access token (addPullRequestReview)` → `panel #1347: FAILED at review submission (gh pr review failed)`.
  No review reached the PR and no pass or must-fix verdict was printed.

**Follow-up:** this is the known problem that the bot token on host `oros-studio-garden-ce242c49` can't write PR reviews on endojs. A retry on this host will fail the same way. The retried panel round should be pinned `requires: host=endolin-garden-ece02cb4`, where the saved record should let it post without re-running the seats.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1347-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 30 tokens (657712 cached reads)
- Output: 5171 tokens
- Cost: $0.8500104
- Wall-clock: 834s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
