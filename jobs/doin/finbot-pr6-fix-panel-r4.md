---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---

# Fixer round 4 — clear the round-4 panel's must-fix bundle on kriscendobot/finbot PR #6

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head branch: `feat/forecast-data-sufficiency` (base `origin/main`). Current head `3725880` —
review-verified at that tip; **rebase onto `origin/main` first**, then fix.

**Context.** The round-4 merge-governance panel (`finbot-pr6-panel-r4`, 28-seat code panel at
head `3725880`) returned **MUST-FIX**: 22 of 28 seats requested changes; `benchmarker`,
`archivist`, `scribe`, `coverage-auditor`, `releaser`, `transplanter` were approve/comment-only.
The round-3 fixes genuinely HELD (verified: `dataSufficiencyMinCoverage` now arms fail-closed
via `readConfigKnob`; `steps`/`proposal_hash`/`portfolio` snapshotted; the off-gate
`windowTicks || 10` path is byte-identical to `origin/main`; `selection`/`model` are string-
typed before the frozen fit; the `cited_forecasts`-outside-`proposal_hash` residual is now
correctly disclosed — wire-watcher: "no further ask this round"). These are NEW fail-open holes
where the round-2/3 own-data discipline **stopped short**, each empirically reproduced by
multiple seats executing the code at head `3725880` (not prose nits).

## Must-fix bundle (each cross-corroborated; reproduced against head `3725880`)

- **M1 — Non-numeric config knob fails OPEN (the `config-integrity` guard is value-scoped, not
  type-scoped).** `packages/pipeline/auditor.js:~102` `knob()` usability test is
  `typeof value === 'number' && !Number.isFinite(value)` → it rejects only a non-finite
  *number*. A knob that is not a number at all — `'25%'`, `'unbounded'`, `{}`, `true`, `'none'`
  — passes through untouched; `maxStepPct * nav` is then `NaN` and `notional > NaN` is always
  false, so a step 100× over the per-step cap audits **`approved`** with `failed_invariants: []`
  and **no `config-integrity` invariant emitted**. Reproduced by assessor, wire-watcher, purist,
  saboteur. Reachable on the real threat surface (`audit_proposal`'s `config` is
  `type:'object', additionalProperties:true`, knob types unschema'd, JSON from an LLM that
  writes `"25%"`; the executor's fire-time re-audit passes it through). Family-inconsistent:
  `coverageThresholdUsable`/`coverageGateArmed` already lead with `typeof === 'number'`.
  **Fix:** in `knob()`, `if (typeof value !== 'number' || !Number.isFinite(value)) { unusableKnobs.push(key); return fallback; }`.
  Widen `skills/pre-execution-audit/SKILL.md § 8` from "two ways" to three, and extend the
  config-integrity family test (currently `test/panel-r3-auditor.test.js:~101` covers only
  NaN/±Infinity) with the non-number type case. Note `knob({ valueOf(){ throw } })` (a readable
  own data property whose coercion throws) must also fail closed, not throw at `maxStepPct * nav`.

- **M2 — `navOf(input.portfolio, prices)` reads the portfolio via plain `[[Get]]` BEFORE the
  fail-closed snapshot, so the round-3 `readOwn` portfolio guard is dead.** `auditor.js:~147`
  calls `navOf` (via `rebalance.js:26-33`, plain-getting `.cash`/`.balances`) ~48 lines before
  the `readOwn`/`readOwnFiniteNumber` guards at `:~190-200`. A portfolio with a throwing
  `cash`/`balances` accessor throws **out of `audit()`**, falsifying the invariant the PR
  publishes at `:~194-196` ("a hostile portfolio whose accessor throws owes the gate a verdict,
  not an exception") — the guards added for exactly that case are unreachable. An *inherited*
  `balances` also splits the view (`navOf` counts it; the risk loop's `readOwn` does not), so a
  step that should `reject` goes **`approved`**. Reproduced by assessor, prover, saboteur.
  **Fix:** take the own-data portfolio snapshot FIRST and compute nav from it, so the fail-closed
  guards are reachable for the case they cite. `{ ...balancesSource }` at `:~198` likewise
  invokes own accessors — snapshot with the own-read discipline.

- **M3 — Invariant 6 (`s.route`, `proposal.substrate`) read via plain `[[Get]]`.**
  `auditor.js:~305` (`s.route`, inside the `filter`), `:~312` (`proposal.substrate`); `s` is
  handed to `stepHasRealRoute` (`substrates.js:344`), which plain-gets `route`/`place`/
  `substrate`/`needs_internal_detail` and calls `.includes`. A throwing own `route`/`substrate`
  accessor throws **out of `audit()`**; `executor.js:78` calls this unwrapped and *before* the
  attenuated compartment, so the fire-time drift guard yields no verdict and no `fire_time_audit`
  record. A polluted `Object.prototype.substrate` (or an inherited `route`) is read as the
  proposal's own claim. Line `:~312` is a line the PR rewrote (it added `sanitizedLabelOr`) — the
  sanitizer was added, the own-read was not. Reproduced by locksmith AND spec-keeper.
  **Fix:** `readOwn(proposal, 'substrate')`, and snapshot `route` via `readOwn` before invariant
  6 (containment belongs in `auditor.js`; `substrates.js` is outside this diff).

- **M4 — Invariant 5 (`oracleReadings` staleness) is the one untrusted surface the round-2/3
  own-data pass skipped, and it fails three ways.** `auditor.js:~283-296`: (a) a non-array
  `oracleReadings: { length: 2 }` (or `[null]`, a throwing element getter, a Proxy `length` trap)
  throws `readings.filter is not a function` / a `TypeError` **out of `audit()`**; (b) a reading
  whose `observedAtTick` is non-numeric, or an absent `currentTick` (not in the tool schema's
  `required` list), records **`pass: true`** "all N cited readings within 5 ticks" via a
  `NaN`-comparison fail-open — an affirmative false attestation; the same fail-open the PR closed
  for `notional`/`qty`/`price` at `:~211-220`. Reproduced by assessor, wire-watcher, locksmith.
  **Fix:** read `currentTick` and each `observedAtTick` through `readOwnFiniteNumber`, and the
  count/array through the `safeArrayLength`/`safeSteps` guard — the discipline already applied to
  steps/citations/portfolio/forecast.

- **M5 — `asset` used as a computed property key re-invokes untrusted code / prototype
  confusion.** `auditor.js:~228-229`: `asset` is read via `readOwn` (avoiding an accessor) but
  then used as a computed property key `balances[asset]`, which re-invokes untrusted code through
  `ToPropertyKey`. `{ asset: { toString(){ throw } }, … }` throws **out of `audit()`**;
  `asset: '__proto__'` (plain JSON) makes `balances['__proto__']` resolve to `Object.prototype`,
  so `weight` is `NaN` and the concentration cap never trips — reproduced **`approved`** under
  `concentrationCapPct: 0.5`. Reproduced by saboteur. **Fix:** type-check `asset` to a string
  first; key a null-prototype object or a `Map`.

- **M6 — `Array.isArray` is not total: it throws on a revoked Proxy.** Called unguarded at
  `auditor.js:~471` (`safeArrayLength`), `:~494` (`safeSteps`), `:~613` (`citedProjectionIds`),
  and `forecaster.js:505,560`. `audit({ proposal: { steps: revokedProxy, … } })` →
  `TypeError: Cannot perform 'IsArray' on a proxy that has been revoked`, escaping `audit()` with
  no verdict (ECMA-262 §7.2.2 IsArray step 3.a; reproduced on Node 22). `Object.getOwnPropertyDescriptor`
  is already `try`-wrapped for the same reason; this call is the gap. Reproduced by spec-keeper.
  **Fix:** guard the `Array.isArray` calls (treat a throwing check as fail-closed / non-array).

- **M7 — `stalenessWindowTicks` reaches the recorded detail unsanitized (journal/CLI forgery).**
  `auditor.js:~294`: a knob `"5\n- pricing-freshness: FORGED PASS"` yields the recorded detail
  `all 1 cited readings within 5\n- pricing-freshness: FORGED PASS ticks`, forging an invariant
  line in the journal record and the CLI report — the exact hazard `sanitizeLabel` exists for,
  applied to the asset name but not to the config value landing on the same line. Reproduced by
  wire-watcher. **Fix:** `sanitizeLabel` (or numeric-coerce) the config value before it lands in
  the detail string.

- **M8 — The stated export-promotion criterion does not hold for one of the six promoted names.**
  `packages/pipeline/index.js:~26-33` (and `README.md:~39`) justify the auditor promotions as
  "each has the same out-of-package consumer — `bin/finbot-ooda`", under a rule the comment states
  absolutely ("the criterion has to hold for every name it covers"). But `bin/finbot-ooda:~82-84`
  imports `runOodaCycle, round12, sanitizeLabel, formatCoverage, coverageThresholdUsable,
  coverageGateArmed` — **not** `MAX_LABEL_CODE_POINTS`; that constant's only consumers are
  `auditor.js`, `index.js`, and `test/auditor-data-sufficiency.test.js` (which imports it from
  `../auditor.js`) — the exact profile the same comment gives for *not* promoting
  `computeDataSufficiency`. Flagged as a `must-fix-loop` by surfacer. **Fix:** either demote
  `MAX_LABEL_CODE_POINTS` to the `./auditor` subpath, or restate the promotion criterion to the
  grounds that actually apply (a co-recorder must be able to size the field — the README row and
  `designs/ensemble-forecasting.md` already argue this) and stop claiming `bin/finbot-ooda`
  consumes it.

## Should-fix — address to converge the round-5 panel (not strictly gating, but reproduced)

- **prover:** `forecaster.js:43 readOwnDataProperty` is unpinned (`ownness-prototype-independence.test.js`
  pins only `hasOwnPositivePrice`); a `'value' in descriptor` mutation on the sibling survives the
  suite and moves the regime tail floor — add one case to the existing file. Also: off the gate,
  `bin/finbot-ooda:~212` `--warmup`/`--fit-window` now validate *unconditionally* (`--warmup=2.5`
  used to run, now exits 2) — a behavior change on the gate-off path; either scope the validation
  on `coverageGateArmed` or pin the off-gate behavior deliberately.
- **purist / saboteur:** the coverage asset set is named by an enumerable-only, accessor-executing
  read — `forecaster.js:~806-820,844-848` uses `Object.entries(input.targetWeights)` /
  `...portfolio.balances`, inconsistent with `worstAssetPersistence`'s own `getOwnPropertyNames`
  discipline (`forecaster.js:252-257`); a hidden non-enumerable thin constituent *raises* the
  reported coverage ratio → fail-open. Walk own property names.
- **purist:** the ownness read is defined twice (`forecaster.js:39 readOwnDataProperty` and
  `auditor.js:440 readOwn` are the same function), the one discipline NOT promoted through
  `index.js` while `round12`/`sanitizeLabel`/`formatCoverage` were, under `index.js`'s own stated
  criterion — two copies drift silently. Consolidate/promote.
- **spec-keeper:** the provenance binding *decision itself* is a prototype `[[Get]]` —
  `auditor.js:~950 citedForecasts.includes(provenanceId)` and `:~983-984` `.toFixed`/`.toExponential`;
  a pre-lockdown `Array.prototype.includes`/`Number.prototype.toFixed` replacement passes/rewrites
  the binding. Capture or `reflectApply`, as the module already does for `numberToFixed`.
- **locksmith:** `agent-tools.js:~266` (and `:194`) `args.config || {}` — the audited party
  decides whether the gate is armed, and plain omission degrades to no gate. Consider taking the
  bound from an operator config closed over at tool construction and treating model-supplied knobs
  as tightening-only (structural; disclose if deferred).
- **gateway (summary-fix):** the safety-bound doc numbers in `skills/pre-execution-audit/SKILL.md:~244-249`
  (per-step 5→25, per-day 20→50, concentration 40→80, staleness 300s→5 ticks) were verified to
  *match* the shipped `auditor.js` defaults on `origin/main` — a doc reconciliation, **not** an
  effective relaxation — but nothing on the PR body or the carrying commit says so (it rides a
  commit whose subject is a forecaster change). Add one sentence to the PR body stating the
  numbers are reconciled to the shipped defaults; ideally add a doc↔code lock test.

## Do

- **Rebase onto `origin/main` first** (force-with-lease expected on push).
- Commit **per concern** with conventional-commit subjects that NAME the fix and carry `(#6)` —
  e.g. `fix(auditor): fail a non-numeric safety knob closed via a type-scoped config-integrity guard (#6)`.
  Squash each fail-closed guard WITH its regression test into one commit. Do NOT reuse an
  empty-bodied subject.
- Add regressions that FAIL if each guard is removed (the round-2/3 `panel-r*-*.test.js` cadence):
  non-number knob → `config-integrity` + not-approved; throwing/inherited portfolio accessor →
  fail-closed verdict; throwing/inherited `route`/`substrate` → verdict not exception; non-array /
  bad-tick `oracleReadings` → fail-closed; `asset:'__proto__'`/throwing-toString → fail-closed;
  revoked-Proxy `steps` → verdict not exception; forged `stalenessWindowTicks` detail sanitized.
- Run the FULL suite green (`npm test`, CI-equivalent). Push:
  `git push --force-with-lease origin HEAD:feat/forecast-data-sufficiency`; print the new head SHA.
- Verify CI `test` goes green and the PR stays MERGEABLE/CLEAN and **DRAFT** before completing.

## Guardrails

- The fleet pins git identity to the bot; don't override it. Keep the diff focused on the findings
  above; no unrelated refactors. If ANY step blocks (unresolvable rebase conflict, a fix that
  can't keep the suite green, a fix genuinely out of scope), STOP and report exactly what blocked
  and what you completed — never force a red push. This fixer **NEVER merges** and never un-drafts.

A fresh panel re-run job (`finbot-pr6-panel-r5`) is parked blocked on this job and promotes
automatically once this lands in `tada/`, continuing the panel→fixer loop until a clean panel; on
a clean panel the orchestrator sign-off is posted. Per merge governance (2026-07-22, amended
2026-08-01) this increment lands only after BOTH a passing panel and an orchestrator sign-off.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T20:37:02Z
