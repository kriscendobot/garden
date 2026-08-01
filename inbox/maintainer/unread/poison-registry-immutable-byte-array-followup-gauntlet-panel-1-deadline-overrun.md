from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-01T11:53:48Z
poison_base: registry-immutable-byte-array-followup-gauntlet-panel-1
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-01T11:53:48Z
last_seen: 2026-08-01T11:53:48Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/registry-immutable-byte-array-followup-gauntlet-panel-1; it stays HELD until a human promotes it
(promote-plan.sh registry-immutable-byte-array-followup-gauntlet-panel-1) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: registry-immutable-byte-array-followup-gauntlet-panel-1

--- original job body ---
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
