---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 3
deadline_overruns: 1
doomed_at: 2026-08-01T11:53:04Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-01T11:53:04Z
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
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-30T16:18:15Z cleared=none -->

---
role: gardener
gauntlet: registry-immutable-byte-array-followup-gauntlet
gauntlet_stage: panel
gauntlet_iteration: 1
pr: https://github.com/endojs/endo-but-for-bots/pull/888
---

# Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #888

You are ONE stage of a staged gauntlet (registry-immutable-byte-array-followup-gauntlet). Run EXACTLY ONE panel round, post the
verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.

1. Get an ISOLATED project checkout of the PR head:
   `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh registry-immutable-byte-array-followup-gauntlet-panel-1 endojs/endo-but-for-bots <pr-head-branch>`.
2. Run the panel in SINGLE-ROUND mode against that worktree:
   `GARDEN_PANEL_SINGLE_ROUND=1 \
     /home/kris/garden2/scripts/jobs/gardening/panel.sh <worktree> 888 <base-ref>`
   It fans the seats, aggregates, and prints its disposition as the terminal line's
   last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on https://github.com/endojs/endo-but-for-bots/pull/888 — the
   panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
   review on must-fix, a comment/approve on pass).
4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
   report with `orchestration-failed: true` and do NOT emit a panel marker.

END your completion report with EXACTLY ONE of these marker lines (last line):
  <!-- gauntlet-stage-result: panel=pass -->
  <!-- gauntlet-stage-result: panel=must-fix -->


<!-- garden-deadline-overrun: 1 -->
