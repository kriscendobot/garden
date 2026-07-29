role: builder

# Run the required merge-governance panel for kriscendobot/finbot PR #5

PR: https://github.com/kriscendobot/finbot/pull/5 (DRAFT)
Head branch: `feat/observe-inference-dispatch` @ `57e397c9558ed0468f75fca0a25e5724aa02dae5`
Base: `main` @ `877fa76769b4ff538916ac21afcac747409dc542` (origin/main == this base).
CI: green (`test` pass). Mergeable.

Increment: "inference-driven OBSERVE stage dispatch" — adds `dispatchObserver` +
an observe-phase tool subset so the OODA loop's first stage runs by inference like
every other stage; determinism preserved. This is the merge-governance panel gate
(maintainer directive 2026-07-22): finbot lands only after BOTH a passing panel AND
a Fable-orchestrator sign-off — even on our own fork.

The earlier panel jobs for this PR were poisoned (deadline-overrun) on a fleet root
that predated the panel parallelization fixes (`GARDEN_PANEL_CONCURRENCY` bounded
seat fan-out + claim-sized staged gauntlet + single-round mode). The deployed root is
now current at `7d041aa1` WITH those fixes (deployed 2026-07-29T16:03Z), and PR #4's
panel is running productively under it. This is a fresh, un-poisoned post.

## Do

1. Get an isolated project worktree for the PR head:
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/observe-inference-dispatch`
2. Run the scripted code panel over the PR against base `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 5 origin/main` with the project
   fixer/un-draft hooks wired per skills/panel. REQUIRE non-empty formal per-seat
   verdicts — do NOT treat an empty/absent seat block as a pass. Re-run any seat
   that produces no verdict.
3. On a PASSING panel: DO NOT MERGE and DO NOT UN-DRAFT. Post the Fable sign-off job
   `finbot-pr5-fable-signoff` with `role: orchestrator` and `model: claude-fable-5`,
   handing it the panel outcome + PR link; the merge is that orchestrator's authority
   (or a conductor it directs), never the panel-runner's.
4. On must-fix: run the fix-loop (fixer commits on the PR head) until the panel
   passes, then proceed to step 3. Keep the tree green.

Per merge governance (2026-07-22), finbot lands only after BOTH the panel and the
Fable-orchestrator sign-off. Never self-merge.

<!-- garden-reaped: 3 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-29T17:25:13Z
