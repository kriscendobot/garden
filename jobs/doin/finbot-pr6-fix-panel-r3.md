---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---

# Fix the round-3 panel must-fix findings on kriscendobot/finbot PR #6

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT — keep it draft; never merge/un-draft/self-merge)
Head branch: `feat/forecast-data-sufficiency`, reviewed head `76bffd406768573dd322d8c000119cb3cbeb2e3a`.
Base: `origin/main` at `b06cdacf932223c30456c6a69f18de8edf7b1961`.

The round-3 merge-governance panel (`finbot-pr6-panel-r3`) ran the full 28-seat code
panel at head `76bffd4` and returned **must-fix**. The findings below are cross-
corroborated and, for the fail-open items, empirically verified by multiple seats
executing the code (saboteur, breaker, prover, locksmith, migrator, assessor, warden,
spec-keeper, wire-watcher, engine-realist). Address them, keep the suite green, keep the
PR mergeable, push to the PR head branch. Do NOT merge or un-draft.

## Working tree

Get YOUR isolated project worktree (keyed by your own job base, not the PR):
`scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/forecast-data-sufficiency`
cd there; run git ONLY there. Test runner is bare `node --test` (no devDependencies, no
fast-check); Node v22. Confirm baseline green BEFORE changing anything.

## STEP 0 — Rebase onto origin/main first (packager must-fix)

`origin/main` is 8 commits ahead of the branch merge-base (PR #4 merged; it rewrote
`packages/harness/sandbox/*`). File sets are disjoint. `git fetch origin main` then
`git rebase origin/main`; run `npm test` green against the harness it will merge onto.
If a real conflict appears you cannot resolve cleanly, STOP and report.

## STEP 1 — Correctness must-fix (fail-open holes). Each needs a code fix AND a regression test that reddens if the fix is reverted.

M1 (FLAGSHIP — 6 seats verified). `packages/pipeline/auditor.js` ~:107-118:
`dataSufficiencyMinCoverage` is the ONE config knob read by an inline
`getOwnPropertyDescriptor` snapshot instead of `readConfigKnob` (~:433-468). An
INHERITED value reads as `undefined` → `coverageGateArmed(undefined) === false` → the
whole data-sufficiency gate is SILENTLY OFF: no `forecast-data-sufficiency` invariant, no
`config-integrity` failure. Verified: `audit(base, Object.create({ dataSufficiencyMinCoverage: 1 }))`
→ `approved`, gate absent; same value as an OWN property arms-and-fails-closed; an
inherited `tailFloorPct` correctly trips `config-integrity`. FIX: read
`dataSufficiencyMinCoverage` through `readConfigKnob` so a present-but-unreadable/inherited
value yields `UNREADABLE_KNOB` → arms-and-fails-closed (`coverageGateArmed(UNREADABLE_KNOB)`
already true; `coverageThresholdUsable` already false). Confirm `ooda-cycle.js` (~:92,:204)
reads the same knob so the forecaster-measurement arming cannot diverge from the auditor's.
TEST: extend the round-2 inherited-knob regression (which covers `maxStepPct`) to
`dataSufficiencyMinCoverage` — inherited value arms-and-fails-closed and emits the invariant.

M2 (saboteur/breaker/prover/engine-realist/purist). `packages/pipeline/auditor.js`: the
item-1 guard added `safeArrayLength(readOwn(proposal,'steps'))` at ~:145 but RAW reads of
the same untrusted field remain and throw OUT of `audit()`: `:163`
`for (const s of proposal.steps)`, `:220` `hashProposal(proposal.steps)`, `:248`
`proposal.steps.filter`, plus `input.portfolio.balances`/`.cash` (~:159-160) and
`proposal.proposal_hash` (~:221). Verified: `steps` absent/`42`/`'nope'`/throwing accessor
→ TypeError (or caller error) escapes `audit()`. Lands on the executor's UNWRAPPED
fire-time re-audit (`executor.js` ~:79). Stated contract (auditor.js ~:140-144): "owes the
gate a fail-closed verdict … not an exception out of `audit()`". FIX: snapshot `steps` ONCE
via `readOwn`, coerce to a safe array (default `[]`), use that snapshot at every downstream
read so hostile/absent/throwing `steps` yields fail-closed `rejected`, never an exception;
same for the balances/cash and proposal_hash reads flagged. TEST: hostile `steps` shapes
(absent, non-array, throwing own accessor, Proxy length trap) each return `rejected`.

M3 (assessor/migrator — both ran differentials). `packages/pipeline/ooda-cycle.js` ~:93-102:
the `||`→`??` + `validTickCount` change silently altered the GATE-OFF path for
`config.windowTicks === 0`. On `origin/main`, `windowTicks: 0` was falsy → default 10; now
`0` is a valid explicit window → `[]`. Verified differential (10 ticks history, gate off,
stock config): main → `dry-run-complete/opportunities:1`; head → `no-opportunity/opportunities:0`.
Breaks the "both knobs off → byte-identical" claim (the in-code comment covers only
MALFORMED values; `0` is the value that flipped). FIX: off the gate (coverage gate NOT
armed) reproduce ORIGINAL `|| 10` semantics EXACTLY (so `0`/malformed → default window,
byte-identical to `origin/main`); honor an explicit `0` (empty window) ONLY when the gate is
armed. Same for `fitWindowTicks`. TEST: `windowTicks: 0` gate-OFF → same observed window as
`origin/main` (default 10); gate-ON → honors the explicit value; add the same for `fitWindowTicks`.

M4 (prover). `packages/pipeline/test/panel-r2-hardening.test.js` ~:180 "a malformed
fitWindowTicks off the gate is ignored" is NOT load-bearing: it picks `NaN`, already caught
by the pre-existing truthiness check, so deleting `fitWindowTicksValid` leaves the suite
green while production regresses (`fitWindowTicks: 15.5` → 16 frames; `MAX_SAFE_INTEGER + 2`
→ whole history). FIX: add truthy-but-invalid cases (fractional 15.5, unsafe-integer) so the
test reddens when the guard is removed. (Overlaps M3 — ensure the guard bounds these on the
ARMED path and the test pins it.)

M5 (warden). `packages/pipeline/forecaster.js` ~:144-145: `assets[asset].model = st.model`
/ `.selection = st.selection` copy BY REFERENCE into a record whose freeze at ~:156 is
SHALLOW. `selection` traces to caller-supplied `adaptiveVol.selection` (spread at ~:120,
honored unvalidated in `packages/simulator/garch.js`). An object-valued `selection` is a
mutable leaf inside the hashed `projectionArtifact`, so "frozen at every depth a consumer
reads" is false. FIX: type-check `model`/`selection` to strings before copying (coerce/drop
non-strings) — preferred, matches the descriptor's string contract — or deep-freeze the
record. TEST: an object-valued `adaptiveVol.selection` cannot leave a mutable leaf in the
frozen fit record.

## STEP 2 — Provenance residual: fix the OVER-CLAIM, do not over-fix (locksmith/wire-watcher/breaker/archivist)

The binding recomputes `projectionId(forecast)` and requires it ∈ `proposal.cited_forecasts`.
But `hashProposal` (`planner.js` ~:30) commits to `steps` ONLY — `cited_forecasts` is
outside the hash and `proposal_hash` is a bare checksum. So a payload tamperer swaps the
descriptor AND appends the recomputed id; `reproducibility` still passes and the gate
approves. The binding buys DESCRIPTOR-SWAP resistance (a forged/foreign descriptor whose id
≠ any honest cited id fails closed), NOT full at-rest/in-flight proposal-tamper resistance.

CORRECT FIX: NARROW THE PROSE to exactly what the binding buys; do NOT expand `hashProposal`
(out of scope, changes the proposal commitment). Reconcile every over-claiming surface:
- `designs/ensemble-forecasting.md` ~:1005-1012 and ~:1110: line ~:1110's "Still
  outstanding: the descriptor is not bound to the projection the proposal cites …"
  contradicts the shipped binding and the ~:998/~:1012 "closed" statements. CUT the stale
  first clause (through "into provenance."); KEEP the genuinely-open planner-downweight
  sentence. Scope "tampered at rest or in flight … fails closed" to descriptor SUBSTITUTION,
  and disclose that a payload-level tamperer who ALSO rewrites `cited_forecasts` is not
  caught by this binding alone (the disclosed residual — measured, not disproven). Remove
  process/review-history commentary ("the pre-merge review flagged", the "Reconciled in this
  change:" file manifest, "further than it first did") from the durable design note.
- `skills/pre-execution-audit/SKILL.md` § 7 and `packages/pipeline/agent-tools.js` (the
  "BINDS the descriptor to provenance" / "rebuilt by hand no longer matches" prose): scope
  to descriptor-substitution, not proposal tamper.
Ensure design note, SKILL, agent-tools prose, and code comments are mutually consistent and
none claims the forgery path is fully closed.

## STEP 3 — Documentation-contradiction must-fix

M7 (archivist/scribe). `roles/auditor/AGENT.md` ~:25 reads "it bounds forgery rather than
provenance" — the INVERSE of canon (`skills/pre-execution-audit/SKILL.md` § 7,
`agent-tools.js`: the gate BINDS the descriptor to provenance). Swap the terms to match canon.

M8 (archivist). The emitted invariant name `config-integrity` (`auditor.js` ~:131) is
documented NOWHERE: not in `packages/pipeline/README.md` (~:29 invariant row),
`roles/auditor/AGENT.md` (the numbered invariant set), `skills/pre-execution-audit/SKILL.md`,
or `packages/pipeline/agent-tools.js` (~:231-236 enumeration). Add `config-integrity` to all
four surfaces (the design note names those exact four as where a new invariant must land).

## STEP 3b — Strong should-fix fail-opens worth folding in (cheap correctness; only if the tree stays green — else note as follow-up)

- spec-keeper (fail-OPEN): `forecaster.js` ~:243 `worstAssetPersistence` walks keys via
  `Object.keys(assets)` (enumerable-only) but reads `persistence` descriptor-based
  (enumerability-blind). A non-enumerable worst asset hides from the key walk → the regime
  tail-floor is NOT tightened. FIX: `Object.getOwnPropertyNames` (or filter descriptors) so
  the key walk matches the value read; add a test.
- saboteur#4 / spec-keeper: `config-integrity` checks READABILITY not USABILITY:
  `{maxStepPct: NaN, maxDayPct: NaN, concentrationCapPct: NaN}` → `approved`, while
  `tailFloorPct: NaN` fails closed. FIX: fold a NaN/non-finite usability check into the
  config-integrity family for the bound knobs; add a test.
- saboteur#3 / engine-realist: NaN/string step fields walk through invariant 2 (a `>` bound
  is not a check when `NaN` makes it false; a string `notional` throws `toFixed`). Narrow
  each compared step field to a finite number first (reuse `readOwnFiniteNumber`, already
  used for `p05Equity`); add a test.

## STEP 4 — Commit discipline & push

- Commit per concern with conventional-commit subjects that NAME the fix and carry `(#6)` —
  e.g. `fix(auditor): route dataSufficiencyMinCoverage through readConfigKnob so an inherited knob fails closed (#6)`.
  Do NOT reuse the empty-bodied `address panel must-fix items on PR #6` subject the packager
  flagged. Squash each fail-closed guard WITH its regression test into one commit.
- Run `npm test` once more — the FULL suite must be green.
- Push: `git push --force-with-lease origin HEAD:feat/forecast-data-sufficiency` (force-with-lease
  expected because you rebased onto main). Print the new head SHA.
- Verify CI `test` goes green and the PR stays MERGEABLE/CLEAN before completing.

## Guardrails

- The fleet pins git identity to the bot; don't override it. Keep the diff focused on the
  findings above; no unrelated refactors. If ANY step blocks (unresolvable rebase conflict, a
  fix that can't keep the suite green, a fix genuinely out of scope), STOP and report exactly
  what blocked and what you completed — never force a red push.

A fresh panel re-run job (`finbot-pr6-panel-r4`) is parked blocked on this job and will
promote automatically once this lands in `tada/`, continuing the panel→fixer loop until a
clean panel; on a clean panel the orchestrator sign-off is posted. This fixer NEVER merges.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T19:17:37Z
