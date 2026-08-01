---
role: builder
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Run the required merge-governance panel for kriscendobot/finbot PR #6 (post-fix head)

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head branch: `feat/forecast-data-sufficiency` at `76bffd406768573dd322d8c000119cb3cbeb2e3a`.
Base: `main` at `b06cdacf932223c30456c6a69f18de8edf7b1961` (advanced by the PR #4 merge, 2026-08-01).
CI: GitHub Actions `test` is green at the head; PR is `MERGEABLE` / `mergeStateStatus: CLEAN`.

**Why this job exists.** PR #6's fixer round 2 (`finbot-pr6-fix-panel-r2`, completed)
cleared the must-fix bundle from the prior panel run at head `bdc96c1` and advanced the
head to `76bffd4` (four focused commits, tree green). Per merge governance the fixer
does NOT self-merge and a **full panel re-run is required** at the new green head before
an orchestrator sign-off can land the increment. No panel job currently exists on the
board for `76bffd4` — this posts it. Do NOT re-run against the stale `bdc96c1`/`b663b4f`
heads (already verdicted) and do NOT revive any earlier poisoned PR #6 panel job.

**Increment under review.** Names and gates forecast data-sufficiency: an armed
`forecast-data-sufficiency` gate that binds the caller-supplied `dataSufficiency`
descriptor to the cited forecast via a `projectionId` recompute (a forged/foreign
descriptor changes the id and fails CLOSED), reaching both `audit_proposal` and the
executor's fire-time re-audit. Round 2 additionally fail-closes on hostile inputs
(Proxy `cited_forecasts.length`, unreadable config knobs → `config-integrity`
invariant), fixes the malformed-window path on both gate-on and gate-off, and discloses
the residual (a wholly self-consistent, self-cited artifact is measured, not disproven).
Gate off → plain data → JSON-boundary verdict is byte-identical (with the disclosed
lexicographic tie-break caveat). Scope of the trust claim: the JSON tool boundary where
parsed input cannot carry Proxies/accessors/`toJSON`.

## Do

1. Get an isolated project worktree for the PR head (keyed by YOUR job base, not the PR):
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/forecast-data-sufficiency`
2. Run the scripted code panel against `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 6 origin/main`
   Require a non-empty, formal verdict from EVERY seat. Do not treat missing/empty seat
   output as a pass — retry the affected seat.
3. On must-fix findings, run the fixer loop on the PR head until the panel passes,
   keeping the tree green (CI `test` green, `mergeable`/`CLEAN`). Verify in particular
   that the round-2 fail-closed guards (projectionId binding, `config-integrity`,
   Proxy-length safety, both-path malformed window) genuinely hold, and that the
   disclosed residual is not over-claimed as closed.
4. On a passing panel, leave the PR DRAFT — do NOT merge or un-draft it. Post the
   sign-off job `finbot-pr6-signoff` with `role: orchestrator`, `tier: mentor`, and
   **NO model pin** (per the liaison's 2026-08-01 governance annotation removing the
   earlier `claude-fable-5` Fable pin; confirmed by the plain-orchestrator sign-off
   that landed PR #4). Include the panel outcome and PR URL in that job's body. The
   orchestrator owns sign-off and any merge it directs — the builder/press NEVER merges.

Per merge governance (2026-07-22, as amended 2026-08-01), this increment lands only
after BOTH a passing panel and an orchestrator sign-off. Never self-merge.

<!-- garden-reaped: 0 -->
