from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-29T18:03:14Z
doom_base: endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-29T18:03:14Z
last_seen: 2026-08-29T18:03:14Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
The handler returned rc=124 at its applied 7200s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3) or removes it.
Original job base: endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3

--- original job body ---
---
role: gardener
handler-budget-role: panel
handler-timeout: 7200
gauntlet: endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet
gauntlet_stage: panel
gauntlet_iteration: 3
pr: https://github.com/endojs/endo-but-for-bots/pull/1085
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1085

You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet). Run EXACTLY ONE panel round, post the
verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3 <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1085 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
2. Run the panel in SINGLE-ROUND mode against that worktree:
   `GARDEN_PANEL_SINGLE_ROUND=1 \
     scripts/jobs/gardening/panel.sh <worktree> 1085 <base-ref>`
   It fans the seats, aggregates, and prints its disposition as the terminal line's
   last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on https://github.com/endojs/endo-but-for-bots/pull/1085 — the
   panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
   review on must-fix, a comment/approve on pass).
4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
   report with `orchestration-failed: true` and do NOT emit a panel marker.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: panel=pass -->
  <!-- gauntlet-stage-result: panel=must-fix -->
