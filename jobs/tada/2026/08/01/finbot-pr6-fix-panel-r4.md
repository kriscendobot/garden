Everything is committed, pushed, and CI-green. The job is complete.

## Completion report

**Job:** Fixer round 4 — clear the round-4 merge-governance panel's must-fix bundle on kriscendobot/finbot PR #6.

**Rebase:** `feat/forecast-data-sufficiency` was already current with `origin/main` (rebase was a no-op; head stayed `3725880`). New head after fixes: **`f43b20e`**.

**All 8 must-fixes resolved** (commit `af19c6d` for the auditor bundle unless noted):
- **M1** — `knob()` usability test made **type-scoped** (`typeof !== 'number' || !isFinite`), so a non-number knob (`'25%'`, `{}`, `true`, throwing `valueOf`) fails `config-integrity` closed instead of letting `maxStepPct * nav` go `NaN` and audit `approved`. Widened `config-integrity` message + `SKILL.md §8` to three failure modes (commit `6e466c7`).
- **M2** — Portfolio snapshotted **own-data-first** (null-proto `balances`, finite `cash`); nav computed from the snapshot, so a throwing accessor owes a verdict and an inherited `balances` no longer splits nav from the risk loop.
- **M3** — Invariant 6 reads `route`/`proposal.substrate` via `readOwn` and hands `stepHasRealRoute` a plain snapshot (containment kept in `auditor.js`; `substrates.js` untouched).
- **M4** — Pricing-freshness materializes readings via `safeSteps`, reads `currentTick`/`observedAtTick` as own finite numbers; a non-array no longer throws and a non-numeric tick / absent clock fails closed instead of recording a false `pass: true`.
- **M5** — `asset` type-checked to a string before keying a **null-prototype** balances map, defusing throwing-`toString` and `'__proto__'` → `Object.prototype`.
- **M6** — `Array.isArray` guarded by a total `isArraySafe` in `auditor.js` (safeArrayLength/safeSteps/citedProjectionIds) and `forecaster.js` (namedAssets/measureHistoryCoverage), so a revoked Proxy fails closed instead of throwing (commit `40b8cca` for the forecaster half).
- **M7** — Closed by M1: `stalenessWindowTicks` is now guaranteed numeric before it reaches the freshness detail, so a forged knob can't splice an invariant line.
- **M8** — Restated the export-promotion criterion in `index.js` + `packages/pipeline/README.md` to the co-recorder-sizes-the-field ground and stopped claiming `bin/finbot-ooda` consumes `MAX_LABEL_CODE_POINTS` (commit `ad604b9`).

**One should-fix addressed** (commit `f43b20e`): prover's pin — `readOwnDataProperty` is now pinned against `Object.prototype.value` pollution via `worstAssetPersistence`.

**Tests:** 12 new round-4 regressions (`panel-r4-auditor.test.js`, `panel-r4-forecaster.test.js`) plus a non-number `config-integrity` case in `panel-r3-auditor.test.js` and two ownness pins. Verified genuine: all 12 fail against HEAD sources and pass against the fix; M1 and the ownness pin each confirmed to redden when their guard is reverted. **Full suite: 727 pass / 0 fail.** CI `test` **green** on `f43b20e`. PR **DRAFT / MERGEABLE / CLEAN**; never merged, never un-drafted.

**Deferred should-fixes** (non-gating; disclosed for the round-5 loop, each carries behavior-change or cross-module refactor risk I kept out of this focused diff): purist/saboteur coverage asset-set enumerable-only read (`forecaster.js:~806–848`); purist consolidation of the duplicate `readOwn`/`readOwnDataProperty`; spec-keeper provenance-binding primordial capture (`includes`/`toFixed`); locksmith `agent-tools.js args.config || {}`; prover `bin/finbot-ooda --warmup/--fit-window` now validating on the gate-off path; gateway one-sentence PR-body note that the safety-bound doc numbers are reconciled (not relaxed).

The parked `finbot-pr6-panel-r5` re-run promotes automatically now that this lands.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/finbot-pr6-fix-panel-r4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (8756518 cached reads)
- Output: 84261 tokens
- Cost: $8.130226
- Wall-clock: 1322s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
