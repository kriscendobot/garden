---
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
handler-timeout: 7200
dispatch: automatic
---

# Fix the round-5 merge-governance panel must-fix findings for kriscendobot/finbot PR #6

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head branch: `feat/forecast-data-sufficiency` (base `origin/main`). Rebase before you start
(`skills/rebase-before-followup`) and keep the tree green (CI `test` green, mergeable/CLEAN).

The round-5 panel (`finbot-pr6-panel-r5`) returned **must-fix**. The findings below are
empirically reproduced at head `f43b20e`. The through-line, again: round 4 hardened ONE member
of each fail-open family and left the siblings — so the auditor still has value-boundary holes.
Fix each, and add the regression that reddens if the guard is removed
(`skills/regression-evidence`). One concern per commit with a specific subject/body — do NOT
reuse the empty-bodied `fix(pipeline): address panel must-fix items on PR #6` subject.

## Fail-open / fail-closed correctness (the core)

1. **`prices` reaches `navOf` unsnapshotted by plain `[[Get]]`** — `packages/pipeline/auditor.js:143,165`.
   M2 hardened `portfolio` but left `prices`, the OTHER argument to the SAME `navOf` call;
   `navOf` plain-gets `prices[asset]` (`rebalance.js:26-32`) with no type check. Reproduced from
   plain JSON: a step 100× over the per-step cap with `prices:{BTC:'1e9'}` returns
   `approved, failed_invariants:[]`; `{BTC:100}` rejects. A throwing own `prices` accessor throws
   out of `audit()`. Fix: snapshot `prices` with the `snapshotBalances` discipline (own-data,
   finite-number-only) and read `input.prices` via `readOwn`.

2. **`hashProposal(steps)` plain-`[[Get]]`s untrusted step fields → `audit()` throws** —
   `packages/pipeline/auditor.js:304`. `safeSteps` bounds the array but keeps raw elements;
   `hashProposal` then reads `source/dest/side/asset/qty/price/notional` and `JSON.stringify`s
   them. A step with `get source(){throw}`, `qty:{valueOf(){throw}}`, or `asset:{toJSON(){throw}}`
   makes `audit()` throw instead of returning a verdict (falsifies the `:145-150` and `:562-570`
   claims). Sibling of M2. The remedy already exists at `recomputeProjectionId` (`:742`), which
   try-wraps for exactly this reason. Fix: wrap the recompute the same way (a null hash fails
   `reproducibility` closed), or scope both claims to plain data.

3. **The M5 null-prototype defense is contingent on a `lockdown()` this module never calls** —
   `packages/pipeline/auditor.js:606,610,538,577`. Only `getOwnPropertyDescriptor`/`hasOwn` are
   captured; `Object.create`, `Object.getOwnPropertyNames`, `Array.isArray`, `Math.min`,
   `Number.prototype.toFixed` (`:251`) are read live at call time. `readOwn` invokes caller code
   (a `getOwnPropertyDescriptor` trap), so a hostile `portfolio` Proxy swaps `Object.create` at
   `:163` before `snapshotBalances` at `:606`, yielding an ordinary-prototype `balances`;
   `asset:'__proto__'` then resolves to `Object.prototype`, `weight` is `NaN`, the concentration
   cap never trips. Reproduced `approved` while the baseline rejects in the same process. Masked
   TODAY only because the import chain happens to `lockdown()` — and that mask LIFTS in any
   process where `Object.prototype` is already frozen (`ensureLockdown()` short-circuits and
   `lockdown()` never runs). Fix locally by capturing the primordials, as the sibling
   `forecaster.js:22-30` already does.

4. **`safeArrayLength` returns an unchecked `length`** — `packages/pipeline/auditor.js:552`.
   `Array.isArray` is true of a Proxy-over-array; a `length` trap may answer `'5'`, a Symbol, a
   BigInt, or `{valueOf(){throw}}`. Reproduced: a Proxy with `length→'5'` over a genuinely empty
   array yields `citation-completeness: pass, approved` with zero citations; a throwing trap
   escapes `audit()` with `TypeError`. The sibling `forecaster.js:463 safeLength` already
   type-checks. Fix: `const raw = value.length; return Number.isSafeInteger(raw) && raw >= 0 ? raw : 0;`
   plus a regression.

5. **`route` read conflates unreadable with absent → vacuous `routePass=true`** —
   `packages/pipeline/auditor.js:362-377` (and `snapshotRoute` `:637-655`). `readOwn(s,'route')`
   returns `undefined` for unreadable AND absent alike, so a throwing/inherited `route` drops from
   `realRouteSteps`; an empty `realRouteSteps` falls through to `routePass=true`. Reproduced: a
   route with `needs_internal_detail:['venue-mapping']` REJECTS when plain and APPROVES behind a
   throwing getter or on the prototype, recorded as a false attestation on a `substrate:'agoric'`
   proposal. `origin/main` rejected the inherited case — this is a **regression**. Mixed plans
   yield a false undercount. Fix: when `readOwn(proposal,'substrate')` is present and non-`sim`,
   require `realRouteSteps.length === steps.length`, and count a present-but-unreadable
   `route`/`needs_internal_detail` as unreachable, not absent.

6. **M4's `currentTick` fail-closed is unpinned and reversible** —
   `packages/pipeline/auditor.js:326`. Reverting `readOwnFiniteNumber(input,'currentTick')` to a
   plain `input.currentTick` leaves the whole suite green (the M4 test exercises only
   `currentTick: undefined`). Unpinned: a non-numeric clock (`'now'`) flips a 1000-tick-stale
   reading from `rejected` to `approved` with `all 1 cited readings within 5 ticks`; an inherited
   clock; and a throwing clock accessor that throws out of `audit()`. Add the non-numeric,
   inherited, and throwing cases.

7. **The observed-window `windowTicks` half is unpinned** — `packages/pipeline/ooda-cycle.js:120`.
   Only `fitWindowTicks` is pinned (`test/panel-r3-ooda-window.test.js:65,78`). Under an armed
   gate `windowTicks:15.5` yields a 16-frame window and `dry-run-complete` instead of the
   fail-closed `no-opportunity`; `windowTicks: NaN` or `2**53` slices ALL frames (the whole
   history), inflating the very coverage ratio the gate rejects on. Add the `windowTicks`
   counterparts of the two existing `fitWindowTicks` tests.

8. **Coverage counts array-adjacency, not tick-adjacency (fail-OPEN)** —
   `packages/pipeline/forecaster.js:96,489`. `priceFramesForCoverage` discards each reading's `t`,
   so `countObservedFramesAndReturns` treats any two consecutive array slots as a return.
   Reproduced: 21 readings spanning 10,000 ticks report `coverageRatio:1.0` over a 20-tick
   horizon — identical to a dense 21-tick window. A live oracle outage drops entries, not `prices`
   keys, so the gate's numerator inflates exactly when coverage is worst. Fix: count the numerator
   over tick-adjacent observations, not array-adjacent ones.

9. **`bin/finbot-ooda:212-218` narrows the CLI contract on the gate-OFF path** — the
   `--fit-window`/`--warmup` validation loop is unconditional while the siblings validated for the
   same reason (`--horizon` `:180`, `--regime-horizon-stretch` `:192`) are correctly scoped on
   `coverageGateArmed(...)`. Reproduced with no `--data-sufficiency-min`: `--warmup=2.5` →
   `origin/main` exit 0, head exit 2 (same for `--fit-window`, `--warmup=abc`, bare `--warmup`).
   Round-4 prover's should-fix, still unaddressed. Fix: scope the loop on `coverageGateArmed`, or
   pin the off-gate narrowing deliberately with an off-gate test plus a PR-body line.

## Naming (stylist — must-fix)

10. Divergent spellings for one concept in one package/round: `readOwnDataProperty`
    (`forecaster.js:58`) vs `readOwn` (`auditor.js:503`); `safeLength` (`forecaster.js:456`) vs
    `safeArrayLength` (`auditor.js:552`). Pick one spelling per concept (`readOwnDataProperty`,
    which `test/ownness-prototype-independence.test.js` already names; `safeArrayLength`).
11. `safeSteps` lies — `auditor.js:575` is a generic bounded array snapshotter, called on
    `oracleReadings` at `:325`. Rename `safeArraySnapshot`.
12. `sanitizeLabel` (`:871`, exported, returns `string`) vs `sanitizedLabel` (`:807`, private,
    returns `string|null`) differ only by an inflectional suffix with different return contracts.
    Rename (e.g. `sanitizeLabel` / `labelOrNull`).
13. Freshly-authored abbreviations, each with a spelled-out sibling already in this diff:
    `const st`→`assetFit` (`forecaster.js:287`); `const r`→`reading` (`:81`); `let i`→`index`
    (`:493,532,600`); `(k)=>`→`knobName` (`auditor.js:176,181`).

## Docs / provenance (must-fix)

14. `config-integrity` is documented as two-way after M1 widened it to three — `roles/auditor/AGENT.md:26`
    ("either … a non-finite number") and one sibling doc. `audit()` emits a distinct third-case
    detail ("not a usable finite number (a non-number, NaN, or ±Infinity)"). Fix the enumeration.
15. `MAX_LABEL_CODE_POINTS` is promoted/documented on a ground no code satisfies (the
    export-promotion criterion in `skills/pre-execution-audit` / `index.js`). Restate the criterion
    so it holds for the promoted name, or drop the promotion (surfacer S1 / integrator / packager).
16. The PR body contradicts a design doc shipped in the same diff and overclaims closure —
    `designs/ensemble-forecasting.md:423` says the tie-break is NOT byte-identical even with the
    gate off, while the body asserts unconditional off-by-default byte-identity three times; the
    body says "Closes the standing open question" while the doc says "Partially resolved". Align
    the body to the shipped docs (integrator).

## Commit / test hygiene (packager / integrator / changeset-auditor)

17. Five commits share the identical subject `fix(pipeline): address panel must-fix items on PR #6`
    with empty bodies (`fb09118,3603cdf,684a0f8,ba2af8b,36fece8`); 21 of 37 commits have empty
    bodies; 37 commits for one increment. Reword during a final rebase / redistribute to ~six
    concern-scoped commits with specific bodies.
18. Conflated commit: `2c8000b` restates four safety bounds while carrying a forecaster-coverage
    change. Split the doc reconciliation, or add one PR-body sentence stating the numbers are
    reconciled to the shipped defaults.
19. Methodology leak in durable artifacts: six test files named for the review round
    (`panel-r2-hardening`, `panel-r3-{auditor,forecaster,ooda-window}`, `panel-r4-{auditor,forecaster}`)
    and ~29 titles keyed to `M#`/`item #`/`saboteur#4`; a mislabel already exists
    (`panel-r3-auditor` carries an `r4 M1:` title). Rename files to their subject
    (`auditor-own-data-guards`, `ooda-observed-window`, …), fold the r3/r4 auditor files together,
    and strip the panel-bookkeeping prefixes, keeping the spec sentence already in each title.

## More fail-open / test-quality findings (re-run adversarial seats)

20. **Unreadable `cash` silently defaults to 0 → understates NAV → shrinks the tail floor
    (fail-OPEN)** — `packages/pipeline/auditor.js:164`. `readOwnFiniteNumber(input.portfolio,'cash') ?? 0`
    defaults an unreadable `cash` (own accessor, inherited value, hostile trap) to 0 on the very
    surface where an unreadable config knob is made to fail closed. Reproduced: one step buying
    1 ATOM, `balances {ATOM:50,OSMO:50}` @1, `tailFloorPct:0.8`, `p05Equity:100` — own `cash:900`
    rejects on `tail-risk-floor` (floor 800); the same 900 reachable only through the prototype
    APPROVES (floor 80). Fix: fold the portfolio into the `config-integrity` family — a
    present-but-unreadable `cash`/`balances` rejects, not defaults.

21. **`safeSteps` truncates untrusted steps at 4096 and measures the prefix instead of rejecting**
    — `packages/pipeline/auditor.js:577`. `proposal_hash` is caller-supplied, so a hash over the
    truncated prefix matches. Reproduced: a 5000-step proposal whose `proposal_hash` is
    `hashProposal(steps.slice(0,4096))` audits `approved, failed_invariants:[]`, while
    `executor.js:104` applies all 5000 — 904 steps never reach the risk loop and the per-day
    `cumulative` cap (`:267`) sums the prefix only. A bound on untrusted input must reject a
    length over the cap, not measure a prefix. (corner-prober corroborates a related class: a
    non-finite balance is measured as a projected constituent — count it fail-closed.)

22. **A benchmark is used as the sole correctness gate for the untrusted-length bound** —
    `packages/pipeline/test/forecaster-data-sufficiency.test.js:546`. `assert.ok(elapsedMs < 30_000)`
    is the only assertion pinning `MAX_UNTRUSTED_LENGTH`; the count assertions above it hold
    whether the walk truncates at 1e6 or 1e9, and the measured `elapsedMs` is discarded on
    success, so the boundary branch's magnitude is never demonstrated. Fix deterministically:
    count element reads through the proxy's `get` trap and assert `reads <= MAX_UNTRUSTED_LENGTH`
    (exportable, as `MAX_LABEL_CODE_POINTS` is) — not a wall-clock threshold.

23. **Non-opt-in behavior changes lack a user-facing migration note** (releaser F1/F2). The
    lexicographic `worstAssetPersistence` tie-break changes `horizonRegime`/horizon/p05-p50-p95
    (hence `projectionId`/`proposal_hash`) **with the gate off**, recorded only in `designs/`; the
    `--warmup`/`--fit-window` fractional-value rejection and the `NaN`-risk-bound fail-closed are
    recorded only as invariant definitions. Add operator-perspective migration lines to the
    user-facing surfaces (`packages/pipeline/README.md`, `bin/finbot-ooda --help`), e.g. the
    fixture-rebaseline note for the tie-break and "whole tick count; a fractional or unparseable
    value exits 2" on both CLI `--help` lines.

## Definition of done
- Every must-fix above addressed with a reddening regression where it is a correctness finding.
- CI `test` green; PR mergeable/CLEAN; PR left DRAFT (never self-merge).
- The panel re-run `finbot-pr6-panel-r6` (blocked on this job) will re-verify at your new head.

<!-- garden-reaped: 2 -->
