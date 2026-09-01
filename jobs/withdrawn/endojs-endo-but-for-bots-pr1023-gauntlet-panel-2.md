---
withdrawn: true
withdrawn_reason: orphaned gauntlet STAGE fragment: its parent gauntlet already halted, so promoting a lone stage cannot advance anything — the remedy for the underlying PR is a fresh gauntlet, not this stage (2026-09-01 muster, maintainer-authorized)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:08:23Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: gardener
tier: minion
handler-budget-role: panel
handler-timeout: 7200
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-23T04:13:09Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-23T04:13:09Z
---

---
role: gardener
tier: minion
handler-budget-role: panel
handler-timeout: 7200
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:56:16Z cleared=none -->

---
role: gardener
handler-budget-role: panel
handler-timeout: 7200
gauntlet: endojs-endo-but-for-bots-pr1023-gauntlet
gauntlet_stage: panel
gauntlet_iteration: 2
pr: https://github.com/endojs/endo-but-for-bots/pull/1023
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1023

You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr1023-gauntlet). Run EXACTLY ONE panel round, post the
verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.

Garden script names below are repo-relative. Resolve them against THIS claiming
worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
posting host's garden root.

1. Get an ISOLATED project checkout of the PR head:
   `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1023-gauntlet-panel-2 <pr-head-owner>/<repo-name> <pr-head-branch>`.
   Resolve the head owner and branch with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1023 --json headRepositoryOwner,headRefName`;
   do not pass the base repo when the PR head belongs to a fork.
2. Run the panel in SINGLE-ROUND mode against that worktree:
   `GARDEN_PANEL_SINGLE_ROUND=1 \
     scripts/jobs/gardening/panel.sh <worktree> 1023 <base-ref>`
   It fans the seats, aggregates, and prints its disposition as the terminal line's
   last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on https://github.com/endojs/endo-but-for-bots/pull/1023 — the
   panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
   review on must-fix, a comment/approve on pass).
4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
   report with `orchestration-failed: true` and do NOT emit a panel marker.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: panel=pass -->
  <!-- gauntlet-stage-result: panel=must-fix -->
