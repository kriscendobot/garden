Panel round 1 on kriscendobot/minion.town PR #152 (head `8712a29`, base `dcc2d64`) came back **must-fix**, and the verdict is posted on the PR. Everything was finished last session; this report only fixes the order of the closing lines.

- **Panel run:** `panel.sh` ran in single-round mode on an isolated checkout of `chore/javascript-only-scripts-part-2a`. Its last line was `code-panel single-round — must-fix`. All 33 seats ran without error and the decider wrote nothing to its error log. I didn't capture the exit code directly because I launched it detached. The run is recorded as `panel-runs/kriscendobot-minion.town-152/500ca90e5b4c.md`.
- **Review posted:** it went up as a COMMENTED review at 2026-10-04T18:44:13Z. GitHub doesn't let the bot request changes on its own PR. The review leads with the must-fix verdict and holds the six request-changes seats.
- **Rest of the aggregate:** the full aggregate is about 88.5k characters, over GitHub's 65,536-character limit for a review. The other 27 seat blocks went into two PR comments, issuecomment-5983193665 and -5983193876.
- **Must-fix items for the fix stage:**
  - **Interrupts don't work:** the SIGINT/SIGTERM handlers set up by `onExit` in `lib/common.js` never get to run because the scripts block synchronously, so Ctrl-C and SIGTERM are swallowed during a deploy.
  - **Stale glob:** `DEPLOYMENT.md:1094` still says `deploy-cognito-*.sh`.
  - **British spellings:** `honour`, `behavioural` and `honoured`.
  - **Abbreviated name:** `storeDir` should be `storeDirectory`.
  - **Missing property test:** `accountKey` escaping needs one.
  - **Others:** further findings from the wire-watcher and pruner seats are in the review.
  - **Coverage unchecked:** the coverage seat had no c8 report, so it couldn't confirm the new lines are covered.
- **Follow-up:** nothing in the garden splits a panel aggregate that's too long for one review, so I split it by hand. `panel.sh` or a posting helper should do this.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1011362 cached reads)
- Output: 6387 tokens
- Cost: $1.614726
- Wall-clock: 1205s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
