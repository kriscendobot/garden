role: builder

# Run the required merge-governance panel for kriscendobot/finbot PR #6

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head branch: `feat/forecast-data-sufficiency` @ `ffe7df67f47b50391973f44052a083d7d402a337`
Base: `main` @ `877fa76769b4ff538916ac21afcac747409dc542` (origin/main == this base).
Diff: 1 commit ahead, 0 behind; 7 files (pipeline forecaster/auditor/ooda + bin + design + 2 new tests). CI: green (`test` pass).

Increment: "name and gate forecast data-sufficiency" — closes the ensemble-forecasting
design's open question (a forecast whose horizon outruns its historical window is thin).
The forecaster attaches an opt-in `dataSufficiency` descriptor (observed returns /
projected horizon -> coverageRatio, scarce); the auditor gains an opt-in invariant #7
`forecast-data-sufficiency` gated by `dataSufficiencyMinCoverage` (default 0 -> OFF,
invariant not even emitted, verdict byte-identical). Both off-by-default so the default
path is byte-identical. Orthogonal to PR #4 (harness) and PR #5 (pipeline OBSERVE-dispatch):
touches forecaster.js / auditor.js / ooda-cycle.js / bin/finbot-ooda / design + tests only.

This is the merge-governance panel gate (maintainer directive 2026-07-22): finbot lands
only after BOTH a passing panel AND a Fable-orchestrator sign-off — even on our own fork.

## Do

1. Get an isolated project worktree for the PR head:
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/forecast-data-sufficiency`
2. Run the scripted code panel over the PR against base `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 6 origin/main` with the project
   fixer/un-draft hooks wired per skills/panel. REQUIRE non-empty formal per-seat
   verdicts — do NOT treat an empty/absent seat block as a pass. Re-run any seat that
   produces no verdict.
3. On a PASSING panel: DO NOT MERGE and DO NOT UN-DRAFT. Post the Fable sign-off job
   `finbot-pr6-fable-signoff` with `role: orchestrator` and `model: claude-fable-5`,
   handing it the panel outcome + PR link; the merge is that orchestrator's authority
   (or a conductor it directs), never the panel-runner's.
4. On must-fix: run the fix-loop (fixer commits on the PR head) until the panel passes,
   then proceed to step 3. Keep the tree green.

Per merge governance (2026-07-22), finbot lands only after BOTH the panel and the
Fable-orchestrator sign-off. Never self-merge.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-28T16:53:21Z
