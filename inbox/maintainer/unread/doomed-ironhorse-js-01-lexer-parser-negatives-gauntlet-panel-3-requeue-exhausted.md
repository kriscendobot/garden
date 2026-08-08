from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-08T10:33:08Z
doom_base: ironhorse-js-01-lexer-parser-negatives-gauntlet-panel-3
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-08T10:33:08Z
last_seen: 2026-08-08T10:33:08Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/ironhorse-js-01-lexer-parser-negatives-gauntlet-panel-3; it stays HELD until a human promotes it
(promote-plan.sh ironhorse-js-01-lexer-parser-negatives-gauntlet-panel-3) or removes it, so nothing is lost.
Original job base: ironhorse-js-01-lexer-parser-negatives-gauntlet-panel-3

--- original job body ---
---
role: gardener
gauntlet: ironhorse-js-01-lexer-parser-negatives-gauntlet
gauntlet_stage: panel
gauntlet_iteration: 3
pr: https://github.com/endojs/endo-but-for-bots/pull/970
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #970

You are ONE stage of a staged gauntlet (ironhorse-js-01-lexer-parser-negatives-gauntlet). Run EXACTLY ONE panel round, post the
verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.

1. Get an ISOLATED project checkout of the PR head:
   `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh ironhorse-js-01-lexer-parser-negatives-gauntlet-panel-3 endojs/endo-but-for-bots <pr-head-branch>`.
2. Run the panel in SINGLE-ROUND mode against that worktree:
   `GARDEN_PANEL_SINGLE_ROUND=1 \
     /home/kris/garden2/scripts/jobs/gardening/panel.sh <worktree> 970 <base-ref>`
   It fans the seats, aggregates, and prints its disposition as the terminal line's
   last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on https://github.com/endojs/endo-but-for-bots/pull/970 — the
   panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
   review on must-fix, a comment/approve on pass).
4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
   report with `orchestration-failed: true` and do NOT emit a panel marker.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: panel=pass -->
  <!-- gauntlet-stage-result: panel=must-fix -->
