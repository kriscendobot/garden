---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 2
deadline_overruns: 1
doomed_at: 2026-07-27T08:53:17Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-07-27T08:53:17Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200
<!-- liaison 2026-08-06: this job was DOOMED by the reaper after a
     deterministic deadline overrun at the 2400s default. It carried no
     handler-timeout: header and its role does not qualify for the 7200s
     builder default (landed 2026-08-01), so it was SIGTERM-killed at the
     wall on every requeue. The budget is the fix; the work is wanted.
     If it overruns 7200s too, that is a REAL overrun -- diagnose it, do
     not raise the budget again. -->

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
