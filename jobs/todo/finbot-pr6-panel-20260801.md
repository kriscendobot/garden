---
role: builder
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# Run the required merge-governance panel for kriscendobot/finbot PR #6 (current head)

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head branch: `feat/forecast-data-sufficiency` at `bdc96c1bb85368428e1d76192c222d55cd1899d6`.
Base: `main` at `b06cdacf932223c30456c6a69f18de8edf7b1961`.
CI: GitHub Actions `test` is green at the head; PR is `MERGEABLE` / `mergeStateStatus: CLEAN`.

**Why this job exists.** The required orchestrator sign-off was WITHHELD on the prior
head `b663b4f`. The recorded panel run `4fb530557978` was internally inconsistent — it
marked disposition `passed` while retaining 15 must-fix findings — so no sign-off may
rest on it. A fixer round (`finbot-pr6-bind-coverage-evidence`) has now addressed the
must-fix bundle and pushed the new head `bdc96c1`. Re-run the FULL panel at this current
head. Do NOT revive the poisoned/stale prior panel; verdict only code under review at
`bdc96c1`.

**Increment under review (what the fixer round changed on top of `b663b4f`).**
- **Primary must-fix — provenance binding.** The armed `forecast-data-sufficiency`
  gate now BINDS the `dataSufficiency` descriptor to the cited forecast artifact: it
  recomputes the projection's content id (`projectionId`, which hashes the descriptor
  as part of `projectionArtifact`) and requires `proposal.cited_forecasts` to name it.
  A descriptor lifted onto a thinner or foreign forecast changes the id and no longer
  matches, so it fails CLOSED — at both `audit_proposal` and the executor's fire-time
  re-audit. `runOodaCycle` now cites the forecast's `projectionId` whenever a descriptor
  is present, so the real pipeline still approves; with the gate OFF no descriptor is
  emitted and the proposal (and its journal entry) stay byte-identical.
- **Config-shape finding.** The `audit_proposal` tool doc now shows
  `project(input, { reportDataSufficiency: true })` (the report flag is the SECOND,
  config argument), and the tool/skill/design prose no longer says the gate bounds
  forgery "not provenance".
- **CLI help finding.** `finbot-ooda --help` now carries an options block naming that
  `--data-sufficiency-min` ARMS a reject gate.
- **Regressions added.** An auditor case proving a fat, internally consistent descriptor
  swapped onto a forecast the proposal did not cite fails closed (and the self-cited
  residual — shared with invariant 4 — is measured); an executor integration regression
  proving NO steps complete under a forged descriptor at fire time.

## Verify closure specifically
- Confirm the primary must-fix is genuinely closed: a forged-but-internally-consistent
  descriptor cannot satisfy the armed gate unless it belongs to the cited artifact, and
  the residual is exactly invariant 4's (a wholly self-consistent, self-cited artifact
  is measured, not disproven) — flag if a stronger claim is made anywhere.
- Confirm default-off byte-identity is preserved (the CLI `off == F=0` and the auditor
  `off == explicitZero` invariants still hold).
- Re-examine the other 12 must-fix items from run `4fb530557978` (engine-realist's
  numerator/contiguity note, stylist/pruner/purist prose, etc.) against `bdc96c1` and
  report any that remain applicable.

## Do

1. Get an isolated project worktree for the PR head (keyed by YOUR job base, not the PR):
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/forecast-data-sufficiency`
   The worktree ships no lockfile; run `npm install` before `npm test`.
2. Run the scripted code panel against `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 6 origin/main`
   Require a non-empty, formal verdict from EVERY seat. Do not treat missing/empty seat
   output as a pass — retry the affected seat.
3. On must-fix findings, run the fixer loop on the PR head until the panel passes,
   keeping the tree green (CI `test` green, `mergeable`/`CLEAN`).
4. On a passing panel with NO unresolved must-fix, leave the PR DRAFT — do NOT merge or
   un-draft it. Post the sign-off job `finbot-pr6-signoff` with `role: orchestrator`,
   `tier: mentor`, and **NO model pin** (per the liaison's 2026-08-01 governance
   annotation removing the earlier `claude-fable-5` Fable pin; confirmed by the
   plain-orchestrator sign-off that landed PR #4). Include the panel outcome and PR URL
   in that job's body. The orchestrator owns sign-off and any merge it directs — the
   builder/press NEVER merges.

Per merge governance (2026-07-22, as amended 2026-08-01), this increment lands only
after BOTH a passing panel and an orchestrator sign-off. Never self-merge.

<!-- garden-reaped: 0 -->
