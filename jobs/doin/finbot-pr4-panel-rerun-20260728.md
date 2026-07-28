role: builder

# Run the required merge-governance panel for kriscendobot/finbot PR #4

PR: https://github.com/kriscendobot/finbot/pull/4 (DRAFT)
Head branch: `feat/harness-compartment-role-program` @ `a99c87b97a77` (a99c87b97a77...)
Base: `main` @ `877fa76769b4ff538916ac21afcac747409dc542` (origin/main == this base).
Diff: 5 commits ahead, 0 behind; 7 files (harness sandbox/permissive.js, spawn.js,
schemas/spawn.js, index.js, README, cap-attenuation design, spawn.test.js). CI: green (`test` pass).

Increment: "run role programs in SES compartments" — the foundational harness increment
(`designs/cap-attenuation.md`): a role program is spawned inside a hardened SES compartment
with an attenuated permissive endowment so a subagent gets only the capabilities its schema
grants. This is the deepest of the three open finbot PRs; #5 (pipeline OBSERVE-dispatch) and
#6 (forecast data-sufficiency) build in orthogonal packages.

This is the merge-governance panel gate (maintainer directive 2026-07-22): finbot lands only
after BOTH a passing panel AND a Fable-orchestrator sign-off — even on our own fork.

## Why this re-post

PR #4's prior panel jobs were **poisoned** — the most recent (`finbot-pr4-panel-20260728`)
hit `requeue-exhausted` (5 requeue cycles, 0 deadline overruns) on follower
`endolin-garden2-5bcdff64` at 2026-07-28T16:53Z, i.e. host churn / requeue-cap, not a
structural panel failure. The sibling panels for PR #5 (`finbot-pr5-panel-20260728`) and
PR #6 (`finbot-pr6-panel-20260728`) are running clean on the same fleet right now, so a
fresh, un-poisoned #4 panel should complete. The earlier PR #4 empty-seat-verdict failure
mode is covered by the deployed fixes `010abbe299` (empty-seat retry) + `6963e506db`
(CI-sized handler budgets).

## Do

1. Get an isolated project worktree for the PR head (key it to YOUR job base, never a
   hand-named per-PR checkout):
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/harness-compartment-role-program`
2. Run the scripted code panel over the PR against base `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 4 origin/main` with the project fixer/un-draft
   hooks wired per skills/panel. REQUIRE non-empty formal per-seat verdicts — do NOT treat an
   empty/absent seat block as a pass (the earlier PR #4 failure mode). Re-run any seat that
   produces no verdict.
3. On a PASSING panel: DO NOT MERGE and DO NOT UN-DRAFT. Post the Fable sign-off job
   `finbot-pr4-fable-signoff` with `role: orchestrator` and `model: claude-fable-5`, handing
   it the panel outcome + PR link; the merge is that orchestrator's authority (or a conductor
   it directs), never the panel-runner's.
4. On must-fix: run the fix-loop (fixer commits on the PR head) until the panel passes, then
   proceed to step 3. Keep the tree green.

Per merge governance (2026-07-22), finbot lands only after BOTH the panel and the
Fable-orchestrator sign-off. Never self-merge.

---
claim:
  host: ps23-garden-f65473ae
  gardener: 3
  worker_kind: gardener
  claimed_at: 2026-07-28T17:18:29Z
