---
role: fixer
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Fixer round 2 on kriscendobot/finbot PR #6 — clear the re-run panel's must-fix bundle

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head: `feat/forecast-data-sufficiency` @ `bdc96c1`. Base `main` @ `b06cdacf`.
Governance: this increment lands only after BOTH a passing panel AND an orchestrator
sign-off (2026-07-22, amended 2026-08-01). NEVER self-merge; leave DRAFT.

The re-run panel at `bdc96c1` (durable record `panel-runs/.../22ff2eb30ec1.md`,
disposition **must-fix**, 21/28 seats request-changes) did NOT pass. The prior
run `4fb530557978` was poisoned by a forced pass; do not repeat that — verdict
only the code, keep the tree green (CI `test` green, `mergeable`/`CLEAN`), and a
subsequent full panel re-run must PASS before any sign-off.

The primary provenance-binding must-fix from the previous round IS closed at the
JSON `audit_proposal` trust boundary (parsed-JSON input cannot carry Proxies /
accessors / `toJSON`, so `readOwn` and `projectionId` see identical values and the
binding is sound), and the disclosed residual is worded correctly (invariant-4's:
a wholly self-consistent, self-cited artifact is measured, not disproven). The
new must-fix bundle is adversarial-hardening-vs-the-code's-own-stated-contract
plus a doc/hygiene chorus. Deconflicted, actionable items:

## Substantive (correctness / contract-consistency)
1. **`auditor.js` `citedProjectionIds`: `cited.length` is read OUTSIDE the try.**
   The per-element read is guarded but `Math.min(cited.length, 4096)` is not, so a
   Proxy-array whose `length` trap throws propagates out of `audit()` — violating
   the docstring's "owes a verdict, not an exception." Guard the `length` read
   (fail-closed to `[]`). Seats: assessor, warden, breaker, engine-realist,
   corner-prober, prover, purist, wire-watcher.
2. **`ooda-cycle.js` gate-OFF window handling.** `requestedWindowTicks =
   config.windowTicks ?? 10` + `validTickCount` guarded only by `coverageGateOn`
   means a malformed explicit `windowTicks` (NaN / 0 / fractional) on the
   gate-OFF path now flows into `windowFromHistory` and `slice`, selecting the
   whole history (was `|| 10` → 10 pre-PR). Default path (undefined) is
   unaffected. Validate the window on the OFF path too, or restore the prior
   coercion, so "unchanged by default" holds for malformed inputs as well.
   Seats: assessor, migrator, saboteur, engine-realist, corner-prober.
3. **In-process split-view binding residual (Proxy `getOwnPropertyDescriptor`
   vs `[[Get]]`, or `toJSON`).** `readDataSufficiency` reads counts via
   `getOwnPropertyDescriptor().value` while `recomputeProjectionId` hashes via
   `projectionArtifact`/`JSON.stringify` plain access, so a forecast object that
   answers forged counts to one and honest values to the other can pass a forged
   coverage bound to a cited honest id. This is UNREACHABLE across the JSON tool
   boundary (its real threat surface) and requires an in-process hostile object,
   BUT the docstring claims to remove exactly "a forged descriptor borrowing the
   coverage of an artifact the proposal never committed to ... in flight before
   the executor's fire-time re-audit." Resolve the gap between claim and code:
   EITHER harden (recompute the id from the same own-data snapshot the gate
   judges, so a split-view cannot diverge the two reads) OR narrow the docstring
   to state the binding holds for plain-data forecasts (the JSON boundary) and
   name the in-process split-view as an out-of-threat-model residual. Seats:
   spec-keeper, wire-watcher, breaker.
4. **`audit()` config knobs fail OPEN for accessor/inherited configs.** The nine
   safety knobs now read via `readOwn`; an accessor-backed or inherited config
   value silently falls back to the built-in default, which can be LOOSER than
   the caller intended (a getter `tailFloorPct` → 0.80 default, not the operator's
   0.99). Low reachability, but a safety gate must not fail open. Either honor a
   readable accessor value or fail closed on an unreadable one. Seats: assessor,
   migrator, typist.

## Byte-identity claim accuracy
5. **Lexicographic persistence tie-break narrows "byte-identical when off."**
   `worstAssetPersistence` now tie-breaks lexicographically (was first-in-map
   order via strict `>`); on an exact GARCH-persistence tie the chosen
   `worstAsset` — and thus `horizonRegime`, the projection horizon, and the
   forecast p05/p50/p95 — can change with the data-sufficiency feature OFF. It is
   a deliberate determinism improvement, but call it out: qualify the "byte-
   identical when off" claim to "except an exact persistence tie now resolves
   deterministically-lexicographically rather than by map-construction order,"
   and keep the regime-horizon test that locks it. Seat: saboteur (+ changeset-auditor).

## Doc / prose / hygiene (the ~10-seat chorus — these are concrete request-changes too)
6. **Stale PR description.** The body's orthogonality claim is false (the diff
   touches `agent-tools.js`, `index.js`, CLAUDE.md), "passes vacuously" is the
   INVERSE of the shipped fail-closed behavior, the `scarce` field it names is
   gone, and "~10 new tests" is ~68. Rewrite the PR body to match the shipped
   fail-closed gate. Seats: packager, integrator, scribe, gateway, saboteur,
   migrator, pruner.
7. **Commit-message + changeset hygiene.** Five identical `fix(pipeline): address
   panel must-fix items on PR #6` messages; the CLAUDE.md governance rewrite is
   bundled into the feature PR. Give the fix commits distinct messages; consider
   whether the CLAUDE.md/governance edit belongs in this PR or a separate one.
   Seats: packager, integrator, gateway, releaser.
8. **Prose over-claim + comment density.** Correct any tool/skill/design prose
   that still overstates the binding beyond item 3's honest scope; the ~59%
   comment density / 233-line design note drew pruner/integrator/stylist/typist/
   archivist/curator flags (doc contradictions archivist F1–F3; unused
   `MAX_LABEL_CODE_POINTS` promotion per curator; JSDoc/type drift per typist/
   spec-keeper; the dead `slice(-0)` branch whose comment is false per assessor/
   migrator/saboteur/corner-prober/engine-realist). Trim/repair to the extent it
   sharpens correctness; do not merely add more prose.

## Test coverage (defense-in-depth; prover / corner-prober / coverage-auditor)
9. Add regressions that would fail if a fail-closed guard were deleted: the
   `ooda-cycle` invalid-window block, the frames×assets bound, the `worstAsset`
   sanitize, and — for items 1–3 — a Proxy-`length` proposal, a malformed-window
   gate-off case, and a split-view forecast (if hardened per 3).

Full per-seat verdicts are in the panel run dir (torn down with the panel job's
worktree); the compact durable record is on `journal2`. After a green head that
clears these, a full panel re-run is REQUIRED before the orchestrator sign-off.
