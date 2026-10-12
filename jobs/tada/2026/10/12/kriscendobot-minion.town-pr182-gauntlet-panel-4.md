I ran panel round 4 on PR #182 again and it returned **must-fix**, the same verdict a previous attempt at this job had already posted. I did not post a second review.

**What I did**
- Checked out the PR head (`kriscendobot/minion.town` @ `fix/prod-probe-ci-runs-on`, head `94f3ae2`) in this job's own isolated worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 182 main-4bd13c8`. It exited 0 with `code-panel single-round — must-fix`.
- 34 seats ran. Six requested changes: prover, curator, saboteur, breaker, spec-keeper and decomplector. The rest approved or left comments only.
- The repeated-mechanism pre-pass fired: the two previous heads (`a5376f12`, `88934af3`) both drew must-fix findings on the same mechanism, choosing the runner through `CI_RUNS_ON` in `prod-probe.yml`. That made the decomplector ask whether the extra switch is needed at all.
- The main must-fix findings:
  - **decomplector:** two runner-selection variables for one workflow. `probe` reads the new `PROBE_RUNS_ON` and defaults to hosted, while `report` reads `CI_RUNS_ON` and defaults to self-hosted. It should be one switch.
  - **spec-keeper:** `fromJSON(vars.PROBE_RUNS_ON || '"ubuntu-latest"')` relies on `runs-on` behaving in a way nobody has checked.
  - **assessor (comment only):** if the self-hosted runner is down while a hosted probe fails, the `report` job waits in the queue forever and no tracking issue gets opened.

**Review posting**
- A previous attempt at this job had already posted the round-4 verdict on this same head `94f3ae2`: review 5486755120 at 05:16Z, "Panel round 4 — must-fix". That attempt died before it finished.
- My rerun reached the same disposition on the same head, so I did not post a second review. The existing one already serves as the panel verdict for this round.
- It was posted as COMMENTED, like rounds 1–3, not as a request-changes review.

**Follow-ups**
- This is the fourth must-fix in a row on the same mechanism. The next fix should collapse `probe` and `report` onto one runner switch rather than keep patching around two.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 76 tokens (2171879 cached reads)
- Output: 10340 tokens
- Cost: $1.6251918
- Wall-clock: 712s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
