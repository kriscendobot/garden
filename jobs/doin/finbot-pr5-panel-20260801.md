---
role: builder
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Run the required merge-governance panel for kriscendobot/finbot PR #5 (current head)

PR: https://github.com/kriscendobot/finbot/pull/5 (DRAFT)
Head branch: `feat/observe-inference-dispatch` at `c1427a66b0e5194464a3857964439ec1d94d5dee`.
Base: `main` at `b06cdacf932223c30456c6a69f18de8edf7b1961` (advanced by the PR #4 merge, 2026-08-01).
CI: GitHub Actions `test` is green at the head; PR is `MERGEABLE` / `mergeStateStatus: CLEAN`.

**Why this job exists.** The prior panel job `finbot-pr5-panel-20260730` was parked
(`jobs/plan/`) as HELD: it targeted the STALE head `468b774b`, and a governance panel
against a stale head verdicts code that is not under review. This job re-issues the
panel at the CURRENT head `c1427a66`. Do NOT revive the parked/held job or the earlier
poisoned `finbot-pr5-panel-20260729-195004` (all seats returned empty and it was
poisoned).

**Increment under review.** Makes the OODA loop's OBSERVE stage inference-driven while
preserving the trusted input boundary: the observer receives a frozen, *required*
reading-window binding (`observerToolRegistry`); the subagent chooses whether to
observe but cannot select detector inputs (bound tool publishes an empty schema);
downstream uses a deterministic `canonical` recompute and `guardedObservation` refuses
an incomplete/uncalled/unreconciled dispatch. Scope of the trust claim: the loop's
*input set* carries no LLM-chosen value; it does not extend past OBSERVE.

## Do

1. Get an isolated project worktree for the PR head (keyed by YOUR job base, not the PR):
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/observe-inference-dispatch`
2. Run the scripted code panel against `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 5 origin/main`
   Require a non-empty, formal verdict from EVERY seat. Do not treat missing/empty seat
   output as a pass — retry the affected seat.
3. On must-fix findings, run the fixer loop on the PR head until the panel passes,
   keeping the tree green (CI `test` green, `mergeable`/`CLEAN`).
4. On a passing panel, leave the PR DRAFT — do NOT merge or un-draft it. Post the
   sign-off job `finbot-pr5-signoff` with `role: orchestrator`, `tier: mentor`, and
   **NO model pin** (per the liaison's 2026-08-01 governance annotation removing the
   earlier `claude-fable-5` Fable pin; confirmed by the plain-orchestrator sign-off
   that landed PR #4). Include the panel outcome and PR URL in that job's body. The
   orchestrator owns sign-off and any merge it directs — the builder/press NEVER merges.

Per merge governance (2026-07-22, as amended 2026-08-01), this increment lands only
after BOTH a passing panel and an orchestrator sign-off. Never self-merge.

<!-- garden-reaped: 4 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T11:23:33Z
