from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-07-27T08:53:21Z
poison_base: finbot-pr5-panel-20260727
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-27T08:53:21Z
last_seen: 2026-07-27T08:53:21Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden-ece02cb4.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/finbot-pr5-panel-20260727; it stays HELD until a human promotes it
(promote-plan.sh finbot-pr5-panel-20260727) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: finbot-pr5-panel-20260727

--- original job body ---
role: builder

# Run the required panel for kriscendobot/finbot PR #5

PR: https://github.com/kriscendobot/finbot/pull/5 (DRAFT)
Head branch: `feat/observe-inference-dispatch`; base `main` (single commit `503f6c9`).

This is the merge-governance panel gate for the finbot increment "inference-driven
OBSERVE stage dispatch" (adds `dispatchObserver` + observe-phase tool subset so the
OODA loop's first stage runs by inference like every other stage; determinism
preserved, `npm test` 614/614 green, `finbot-dispatch --seed=7` walletTouched:false).

## Do

1. Get an isolated project worktree for the PR head:
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/observe-inference-dispatch`
2. Run the scripted code panel over the PR (base `main`, i.e. `HEAD~1`):
   `scripts/jobs/gardening/panel.sh <worktree> 5 origin/main` with the project
   un-draft/fixer hooks wired (see skills/panel). Require NON-EMPTY formal
   per-seat verdicts — do NOT treat an empty/absent seat block as a pass
   (the PR #4 failure mode). Re-run any seat that produces no verdict.
3. On a passing panel: DO NOT MERGE. Post the Fable sign-off job
   `finbot-pr5-fable-signoff` with `role: orchestrator` and `model: claude-fable-5`,
   handing it the panel outcome + PR link; the merge is that orchestrator's
   authority (or a conductor it directs), never the panel-runner's.
4. On must-fix: run the fix-loop (fixer commits on the PR head) until the panel
   passes, then proceed to step 3. Keep the tree green.

Per merge governance (2026-07-22), finbot lands only after BOTH the panel and the
Fable-orchestrator sign-off. Never self-merge.


<!-- garden-deadline-overrun: 1 -->
