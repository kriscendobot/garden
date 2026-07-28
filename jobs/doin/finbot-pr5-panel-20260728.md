role: builder

# Run the required merge-governance panel for kriscendobot/finbot PR #5

PR: https://github.com/kriscendobot/finbot/pull/5 (DRAFT)
Head branch: `feat/observe-inference-dispatch` @ `e889a899c1a5967354436aab2abf58ea9b5dc27b`
Base: `main` @ `877fa76769b4ff538916ac21afcac747409dc542` (origin/main == this base).
Diff: 8 commits ahead, 0 behind; 6 files, pipeline-focused. CI: green (`test` pass).

Increment: "inference-driven OBSERVE stage dispatch" — adds `dispatchObserver` +
an observe-phase tool subset so the OODA loop's first stage runs by inference like
every other stage; determinism preserved. This is the merge-governance panel gate
(maintainer directive 2026-07-22): finbot lands only after BOTH a passing panel AND
a Fable-orchestrator sign-off — even on our own fork. The pre-deploy panel jobs for
this PR were poisoned (deadline-overrun) on a fleet root that lacked the panel fixes
`010abbe299` (empty-seat retry) + `6963e506db` (CI-sized handler budgets); the fleet
is now deployed WITH both fixes, so a fresh panel runs clean. This is that fresh post.

## Do

1. Get an isolated project worktree for the PR head:
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/observe-inference-dispatch`
2. Run the scripted code panel over the PR against base `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 5 origin/main` with the project
   fixer/un-draft hooks wired per skills/panel. REQUIRE non-empty formal per-seat
   verdicts — do NOT treat an empty/absent seat block as a pass (the earlier PR #4
   failure mode). Re-run any seat that produces no verdict.
3. On a PASSING panel: DO NOT MERGE and DO NOT UN-DRAFT. Post the Fable sign-off job
   `finbot-pr5-fable-signoff` with `role: orchestrator` and `model: claude-fable-5`,
   handing it the panel outcome + PR link; the merge is that orchestrator's authority
   (or a conductor it directs), never the panel-runner's.
4. On must-fix: run the fix-loop (fixer commits on the PR head) until the panel
   passes, then proceed to step 3. Keep the tree green.

Per merge governance (2026-07-22), finbot lands only after BOTH the panel and the
Fable-orchestrator sign-off. Never self-merge.

<!-- garden-reaped: 1 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  claimed_at: 2026-07-28T16:53:16Z
