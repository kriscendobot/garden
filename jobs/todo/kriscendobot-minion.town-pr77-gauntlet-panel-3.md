---
role: gardener
handler-budget-role: panel
handler-timeout: 10800
gauntlet: kriscendobot-minion.town-pr77-gauntlet
gauntlet_stage: panel
gauntlet_iteration: 3
pr: https://github.com/kriscendobot/minion.town/pull/77
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Gauntlet stage: PANEL round 3 — kriscendobot/minion.town PR #77

You are ONE stage of a staged gauntlet (kriscendobot-minion.town-pr77-gauntlet). Run EXACTLY ONE panel round, post the
verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh kriscendobot-minion.town-pr77-gauntlet-panel-3 <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/kriscendobot/minion.town/pull/77 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
2. Run the panel in SINGLE-ROUND mode against that worktree:
   `GARDEN_PANEL_SINGLE_ROUND=1 \
     scripts/jobs/gardening/panel.sh <worktree> 77 <base-ref>`
   It fans the seats, aggregates, and prints its disposition as the terminal line's
   last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on https://github.com/kriscendobot/minion.town/pull/77 — the
   panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
   review on must-fix, a comment/approve on pass).
4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
   report with `orchestration-failed: true` and do NOT emit a panel marker.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: panel=pass -->
  <!-- gauntlet-stage-result: panel=must-fix -->



<!-- garden-transient-elapsed: kind=exit0 through=1 values=184,42 -->

<!-- garden-reaped: 2 -->
