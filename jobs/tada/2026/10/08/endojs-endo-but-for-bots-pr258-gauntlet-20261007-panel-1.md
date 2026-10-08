## Panel round 1 on endojs/endo-but-for-bots #258: must-fix

This stage was already finished in my previous session. I'm re-sending the report because that session put the stage-result marker after the completion signal, and the signal has to be the very last line.

- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` ran against an isolated checkout of head `ci/ocapn-guile-interop-resilience-iii` @ `ace90ab0af`. The base was the PR's frozen base commit `46d4edf317` (`master-46d4edf`). It exited 0 with disposition **must-fix**.
- **Seats not re-run:** an earlier claimant had already run all 33 seats for this exact head. `panel.sh` reused that durable record (`panel-runs/endojs-endo-but-for-bots-258/d5313d3f405c.md`): 10 must-fix, 12 comment-only and 11 pass seats, with 20 must-fix items.
- **Review already on the PR, so I didn't post it again:**
  - Review 5453912310 (2026-10-08T08:37:02Z, on `ace90ab0`) holds the request-changes verdict. It shows as COMMENTED because GitHub refuses request-changes on the bot's own PR.
  - Follow-up comment 6056041682 holds the comment-only and approve seats, because the full write-up exceeds GitHub's size limit for a review.
- **Main must-fix problems the review names:**
  1. The restore step never runs. It checks a `cache-matched-key` output that the combined `actions/cache` action does not produce.
  2. The cache key ignores the workflow file. The checkout uses `path: endo`, so the workflow-file hash comes back empty.
  3. The restore extracts into `/gnu/store` while it is still mounted read-only.
  4. The snapshot copies a live SQLite database.
  5. The PR description overclaims.
  6. There is no forced cache-hit run as evidence.

No garden or project files changed and nothing was committed. Next is the gauntlet's fix-loop stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 72 tokens (1989938 cached reads)
- Output: 12999 tokens
- Cost: $2.3368764
- Wall-clock: 516s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
