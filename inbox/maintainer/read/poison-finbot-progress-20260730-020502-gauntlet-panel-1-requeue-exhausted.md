from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-01T11:13:09Z
poison_base: finbot-progress-20260730-020502-gauntlet-panel-1
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-01T11:13:09Z
last_seen: 2026-08-01T11:13:09Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/finbot-progress-20260730-020502-gauntlet-panel-1; it stays HELD until a human promotes it
(promote-plan.sh finbot-progress-20260730-020502-gauntlet-panel-1) or removes it, so nothing is lost.
Original job base: finbot-progress-20260730-020502-gauntlet-panel-1

--- original job body ---
---
role: gardener
gauntlet: finbot-progress-20260730-020502-gauntlet
gauntlet_stage: panel
gauntlet_iteration: 1
pr: https://github.com/kriscendobot/finbot/pull/5
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Gauntlet stage: PANEL round 1 — kriscendobot/finbot PR #5

You are ONE stage of a staged gauntlet (finbot-progress-20260730-020502-gauntlet). Run EXACTLY ONE panel round, post the
verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.

1. Get an ISOLATED project checkout of the PR head:
   `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh finbot-progress-20260730-020502-gauntlet-panel-1 kriscendobot/finbot <pr-head-branch>`.
2. Run the panel in SINGLE-ROUND mode against that worktree:
   `GARDEN_PANEL_SINGLE_ROUND=1 \
     /home/kris/garden2/scripts/jobs/gardening/panel.sh <worktree> 5 <base-ref>`
   It fans the seats, aggregates, and prints its disposition as the terminal line's
   last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on https://github.com/kriscendobot/finbot/pull/5 — the
   panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
   review on must-fix, a comment/approve on pass).
4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
   report with `orchestration-failed: true` and do NOT emit a panel marker.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: panel=pass -->
  <!-- gauntlet-stage-result: panel=must-fix -->
