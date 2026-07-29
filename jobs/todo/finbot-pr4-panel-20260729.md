role: builder

# Run the required merge-governance panel for kriscendobot/finbot PR #4

PR: https://github.com/kriscendobot/finbot/pull/4 (DRAFT)
Head branch: `feat/harness-compartment-role-program` @ `b58b125fe5d6162831706ee9574bc90ea5ce51bc`
Base: `main` @ `877fa76769b4ff538916ac21afcac747409dc542`. CI: green (`test` pass on current head).

Increment: "run role programs in SES compartments" — the harness increment. This is
the merge-governance panel gate (maintainer directive 2026-07-22): finbot lands only
after BOTH a passing panel AND a Fable-orchestrator sign-off, even on our own fork.
This PR is the one the maintainer's rationale specifically flagged (a prior review
found the "real SES attenuator" overstated what it did) — give the SES/compartment
attenuation claims adversarial scrutiny (locksmith / warden / skeptic / prover seats
especially): confirm the compartment boundary actually attenuates what the PR/commit
messages claim, with no ambient authority leaking into role programs.

The earlier panel jobs for this PR were poisoned (deadline-overrun / requeue-exhausted)
on a fleet root that PRE-DATED the panel fixes: bounded-parallel seat fan-out
(`GARDEN_PANEL_CONCURRENCY`, default 8) + claim-sized single-round staging +
empty-seat retry. The deploy that carried those fixes has since LANDED (root now at
`origin/main2` tip, 0 behind), so a fresh panel fits a claim budget and runs clean.
This is that fresh post, pinned to the CURRENT head `b58b125f` (the stale poisoned
copies in `jobs/plan/` reference an older head `a99c87b9` and should be reaped).

## Do

1. Get an isolated project worktree for the PR head:
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/harness-compartment-role-program`
2. Run the scripted code panel over the PR against base `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 4 origin/main` with the project
   fixer/un-draft hooks wired per skills/panel. REQUIRE non-empty formal per-seat
   verdicts — do NOT treat an empty/absent seat block as a pass (the earlier PR #4
   failure mode). Re-run any seat that produces no verdict.
3. On a PASSING panel: DO NOT MERGE and DO NOT UN-DRAFT. Post the Fable sign-off job
   `finbot-pr4-fable-signoff` with `role: orchestrator` and `model: claude-fable-5`,
   handing it the panel outcome + PR link; the merge is that orchestrator's authority
   (or a conductor it directs), never the panel-runner's.
4. On must-fix: run the fix-loop (fixer commits on the PR head) until the panel
   passes, then proceed to step 3. Keep the tree green.

Per merge governance (2026-07-22), finbot lands only after BOTH the panel and the
Fable-orchestrator sign-off. Never self-merge; the press (progress driver) and the
panel-runner never run `gh pr merge`.
