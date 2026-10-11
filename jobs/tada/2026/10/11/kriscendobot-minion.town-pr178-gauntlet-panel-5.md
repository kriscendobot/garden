## Panel round 5 for kriscendobot/minion.town PR #178: must-fix

Round 5 is complete. The panel ran (exit 0) and decided **must-fix**. The verdict is posted as a comment review because the bot opened this PR and GitHub won't let it request changes on its own PR. My previous report put the completion signal before the stage marker, so it wasn't the last line; that's why the job came back. I checked that the review is still on the PR and posted nothing new.

- **Run:** I used an isolated checkout of `kriscendobot/minion.town@git-remote-push-caps`, head `c5294c5`, against base `main-c7bdf20`, with `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh`. It ended with `code-panel single-round — must-fix`.
- **Seats (34 total):** 2 request changes (assessor, breaker), 20 comment-only, 12 approve.
- **Main blocker (assessor):** if a client hangs up while the push size is being measured, `git http-backend` can be left running forever. That stalls the queue of later pushes to the same storage area.
- **Should-fix items:** the per-partition push hold has no time limit, and an exception thrown before the backend starts can leave the hold taken.
- **Probes:** the "same mechanism keeps failing" probe fired on `git-http.ts` / `limits.ts`, which also came up as must-fix in rounds at heads ec1fb1d4 and 3de6adcb. That forced the decomplector seat to ask whether the mechanism is needed at all. The PR-description concision probe also fired.
- **Review posted:** review [5483967704](https://github.com/kriscendobot/minion.town/pull/178#pullrequestreview-5483967704), state COMMENTED, on commit `c5294c5`. Its body starts with `<!-- garden-panel-verdict: must-fix round=5 … -->`.
- **Trimmed body:** the full combined review was 87KB, over GitHub's body-size limit. The posted body (about 60KB) has full write-ups for both request-changes seats, the decomplector and most comment-only seats. The 14 non-blocking write-ups that didn't fit are listed by name.

**Follow-ups:**
- Panel verdicts on PRs the bot opened can only be posted as comments. If the next-stage heuristic only recognizes request-changes reviews as must-fix, it will need the body marker or the stage-result line instead.
- Nothing in the panel tooling handles combined reviews over GitHub's size limit. A shared trimming step in `panel.sh` would make this consistent across rounds.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2110569 cached reads)
- Output: 9631 tokens
- Cost: $2.4349038
- Wall-clock: 3858s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
