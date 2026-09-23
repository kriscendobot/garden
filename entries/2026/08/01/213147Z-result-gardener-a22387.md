---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-01T21:31:48Z
---
project: finbot
repo: kriscendobot/finbot
pr: 6
panel_round: 5
seat: assessor

# Panel round 5, seat: assessor -- kriscendobot/finbot#6

Diff base `origin/main`, worktree `scratch/project-wt-finbot-pr6-panel-r5-55da45b5`, head f43b20e.
All `packages/pipeline/test/*.test.js` pass locally (`node --test`, 23 files, no failures).

### assessor

**Verdict:** request-changes

**Findings:**

- **must-fix** `packages/pipeline/auditor.js:164` -- `const cash0 = readOwnFiniteNumber(input.portfolio, 'cash') ?? 0` silently defaults an unreadable `cash` (own accessor, inherited value, hostile trap) to 0, on the very surface where an unreadable *config* knob is made to fail closed through `config-integrity`. Understating NAV shrinks the tail floor (`regime.floorPct * nav`), which is the fail-OPEN direction. Verified: one step buying 1 ATOM, portfolio `balances {ATOM:50, OSMO:50}` at price 1, `tailFloorPct: 0.8`, `forecast.p05Equity: 100`. With own `cash: 900` the audit rejects on `tail-risk-floor` (floor 800.00); with the same 900 reachable only through the prototype it **approves** (floor 80.00). Fold the portfolio into the config-integrity family (a present-but-unreadable `cash`/`balances` rejects) rather than defaulting it. [rule: skills/pre-execution-audit/SKILL.md § 8]

- **must-fix** `packages/pipeline/auditor.js:577` -- `safeSteps` truncates at 4096 and its docstring claims "a truncated plan can only fail the reproducibility hash, never pass spuriously". The body falsifies that: `proposal_hash` is caller-supplied, so a hash over the truncated prefix matches. Verified: a 5000-step proposal whose `proposal_hash` is `hashProposal(steps.slice(0, 4096))` audits **approved**, `failed_invariants: []`, while `executor.js:104` applies `input.proposal.steps` (all 5000). 904 steps never reach the risk loop, and `cumulative` (the per-day cap at :267) sums the prefix only. A bound on untrusted input must reject, not measure a prefix: over-length `steps` should fail the invariant closed. [rule: skills/pre-execution-audit/SKILL.md § 2, § 4]

- **should-fix** `packages/pipeline/forecaster.js:175` -- the comment at :162 drops a non-string `model`/`selection` "rather than alias it", and the return at :191 claims the freeze reaches "each record's `oosQlike`". `oosQlike` values pass through `round12`, which returns a non-number **by reference**, so a caller-supplied mutable object is aliased into the frozen fit and into the hashed `projectionArtifact`. Verified: `makeVolSurface` returns a `nextVariance`-carrying descriptor untouched (`packages/simulator/world.js:133`), so a surface whose `stats()` yields `{ oosQlike: { garch: leak } }` gives `fit.assets.ATOM.oosQlike.garch === leak`, unfrozen and mutable after the id is hashed. Drop or coerce each value as `model`/`selection` already do. [proposed-rule: a value copied into a hash-bearing record must be a primitive or a fresh frozen copy; a total quantizer that passes non-numbers through unchanged is not a copy]

**Notes (out of scope but worth flagging):**

- `bin/finbot-ooda` validates `--warmup` / `--fit-window` as safe integers **unconditionally**, outside the `coverageGateArmed` guards `--horizon` and `--regime-horizon-stretch` sit behind, so `--warmup=10.5` now exits 2 with the gate off. The header doc scopes that rejection to the coverage gate. Gate the loop or restate the doc. [rule: skills/pre-execution-audit/SKILL.md § 7]
- `executor.js` re-reads `input.proposal.steps` after the fire-time audit approved a materialized snapshot. Auditing a snapshot and executing the original is a standing time-of-check/time-of-use shape, independent of finding 2. [proposed-rule: a fire-time gate and the action it authorizes read the same materialized snapshot]

Self-improvement: nothing this time.
