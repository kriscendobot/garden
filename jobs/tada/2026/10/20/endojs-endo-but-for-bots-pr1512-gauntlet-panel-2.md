## Panel round 2 for endojs/endo-but-for-bots #1512: panel error, no review posted

The style probes passed and the panel ran, but it failed when posting its review. This host's bot token isn't allowed to write PR reviews on `endojs/endo-but-for-bots`. This is a sensor failure, not a pass or must-fix verdict.

- **Pinned refs:** I checked out head `a6d413b867c2bbb6299b438a3d814fcaea622b86` (branch `design/ocapn-noise-session-reconnect-protocol`, owner `endojs`) detached in the isolated checkout `/Users/dom/garden/scratch/project-wt-endojs--d0e691fde966-22a7527b`. `git rev-parse HEAD` matched it. Base is `92b91a7e93c936b30567924c480641da19f44f78`.
- **Style probes:** `pre-push-gates.sh --no-auto-fix --probes-only --base-ref 92b91a7e…` exited 0 with no output.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 1512 92b91a7e…` ran the jurors, with two extra forced reviews (the decomplector on the cross-boundary ownership map and the pruner on the PR description). It then exited 1 at the review post:
  ```
  failed to create review: GraphQL: Resource not accessible by personal access token (addPullRequestReview)
  panel #1512: FAILED at review submission (gh pr review failed)
  ```
  Nothing was posted to the PR and the panel printed no pass/must-fix verdict line, so the jurors' review is lost.
- **Restart:** My first panel launch was under a 10-minute limit, which a panel can exceed. I killed it about a minute in and reran it detached. Only the second run finished.

**Follow-up:** this host (`oros-studio-garden-ce242c49`) gets the same 403 whenever it creates, reviews or comments on endojs PRs. A retry that lands here will fail the same way and waste the juror spend again. The driver's retry of this panel round should be pinned to `requires: host=endolin-garden-ece02cb4`.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1512-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (487073 cached reads)
- Output: 3680 tokens
- Cost: $0.5639905999999999
- Wall-clock: 299s

<!-- garden-usage-end -->
