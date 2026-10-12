Panel round 5 on kriscendobot/minion.town PR #182 finished with a **must-fix** verdict, and I posted it as a review on the PR.

- **Panel run:** I checked out the PR head (`fix/prod-probe-ci-runs-on` at `53fad66`) and ran `panel.sh` in single-round mode against base `main-4bd13c8`. It exited 0 with disposition `must-fix`. All seats were run fresh; nothing was reused from an earlier record.
- **Restarts:** I stopped the first run about 10 minutes in because its background time limit might have killed it partway, and restarted it with a longer limit. My next relaunch then killed itself before the panel started: the `pkill` meant to clear leftover processes from the first run matched its own shell. The third launch is the one that produced this verdict.
- **Posted review:** https://github.com/kriscendobot/minion.town/pull/182#pullrequestreview-5487853120. It contains the full panel output (about 78 KB) and is tied to commit `53fad66`. It went up as a COMMENTED review because GitHub won't let the bot request changes on its own PR, which is also how rounds 1–4 were posted. The bot's `gh` wrapper first refused it over a bare `#166`, so I changed that to `kriscendobot/minion.town#166`.
- **Main must-fix items:**
  - The new `PROBE_RUNS_ON` switch duplicates the existing `CI_RUNS_ON`. The decomplector seat was made to ask whether it is needed because the same mechanism has failed several rounds in a row.
  - The `fromJSON(vars.PROBE_RUNS_ON || ...)` expression has edge cases nothing covers.
  - A docs sentence says a down runner "cannot silence a failure". That is wrong: both jobs now run on the same runner, so if it is offline the alert issue is never created either.
  - Nothing on the PR summarizes rounds 1–4 yet. The fix is one top-level comment naming head `53fad66` and saying how each earlier must-fix item was resolved or declined.

I made no fixes and did not un-draft the PR; the next fix-loop stage owns that.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1363654 cached reads)
- Output: 5467 tokens
- Cost: $0.9404868
- Wall-clock: 774s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
