---
role: gardener
handler-budget-role: panel
handler-timeout: 7200
gauntlet: endojs-endo-but-for-bots-pr992-gauntlet
gauntlet_stage: panel
gauntlet_iteration: 2
pr: https://github.com/endojs/endo-but-for-bots/pull/992
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #992

You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr992-gauntlet). Run EXACTLY ONE panel round, post the
verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr992-gauntlet-panel-2 endojs/endo-but-for-bots <pr-head-branch>`.
2. Run the panel in SINGLE-ROUND mode against that worktree:
   `GARDEN_PANEL_SINGLE_ROUND=1 \
     scripts/jobs/gardening/panel.sh <worktree> 992 <base-ref>`
   It fans the seats, aggregates, and prints its disposition as the terminal line's
   last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on https://github.com/endojs/endo-but-for-bots/pull/992 — the
   panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
   review on must-fix, a comment/approve on pass).
4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
   report with `orchestration-failed: true` and do NOT emit a panel marker.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: panel=pass -->
  <!-- gauntlet-stage-result: panel=must-fix -->

<!-- garden-reaped: 0 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-15T11:53:08Z
