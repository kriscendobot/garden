---
withdrawn: true
withdrawn_reason: orphaned gauntlet STAGE fragment: its parent gauntlet already halted, so promoting a lone stage cannot advance anything — the remedy for the underlying PR is a fresh gauntlet, not this stage (2026-09-01 muster, maintainer-authorized)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:08:46Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: low
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
doomed_at: 2026-08-01T11:13:05Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-01T11:13:05Z
---
handler-timeout: 7200
<!-- liaison 2026-08-06: this job was DOOMED by the reaper after a
     deterministic deadline overrun at the 2400s default. It carried no
     handler-timeout: header and its role does not qualify for the 7200s
     builder default (landed 2026-08-01), so it was SIGTERM-killed at the
     wall on every requeue. The budget is the fix; the work is wanted.
     If it overruns 7200s too, that is a REAL overrun -- diagnose it, do
     not raise the budget again. -->

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

<!-- garden-annotation: key=f37f1176c596 by=producer at=2026-08-22T06:24:21Z fields=priority=low -->

Shelved 2026-08-22 (maintainer directive, during the parked-job roadmap session): not resuming now, may return to finbot someday but not soon. Left parked go-ahead, not pruned -- this is deliberate deprioritization, not moot/superseded work.
