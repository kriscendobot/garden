**Gauntlet FIX round 3 — endojs/endo-but-for-bots PR #1061 — complete.**

**Panel must-fix applied (prover, request-changes):** the round-2 tuple/object pins in `packages/marshal/src/types.test-d.ts` used tsd's `expectType<T>(x)` — a one-directional *assignability* check — so dropping a pinned member left the pin green. I introduced a bidirectional `Equal<A,B>` type-equality helper (`(<T>() => T extends A ? 1 : 2) extends <T>() => T extends B ? 1 : 2`) and converted every identity pin (`EncodingElement`, `CapData`, `Marshal`, `MakeMarshalOptions`, `RankComparison`, `RankCover`, `PartialComparison`, the `ConvertValToSlot`/`ConvertSlotToVal` signatures, their `Parameters` tuples, `ToCapData`/`FromCapData`/`RankCompare`/`FullCompare`/`PartialCompare`) to `expectType<true>(null as unknown as Equal<Actual, Expected>)`, which reddens under the plain `tsc` check this package's CI runs (`yarn lint:types`, no `tsd` CLI).

**Verified by mutation** (the round-2 fix's exact failure mode): dropping `iface` from `ConvertSlotToVal`, dropping `marshalName` from `MakeMarshalOptions`, dropping `errorId` from the error arm, **widening** `MakeMarshalOptions` with a sneaky option, and making the slot arm's `index` optional each now produce `tsc` errors; the clean tree passes.

**Should-fix items also addressed:**
- *breaker* — header comment corrected to "drops, widens, or malforms" (bidirectional now genuinely catches widening).
- *corner-prober* — added negative `@ts-expect-error` union pins (`bogus`/`slot`/`bigint`/`symbol` discriminants), positive exercise of the error arm's `errorId`/`cause`/`errors`, and one-arg instantiations pinning the `= any` generic defaults.
- *spec-keeper* — replaced the vacuous `Exclude<PartialComparison, NaN>` cast in `rankOrder.js:333` with a sound `RankComparison` assertion; dropped the now-unused `PartialComparison` import.
- *typist* — moved the "TS has no NaN literal type" rationale into the `PartialComparison` doc comment in `types.d.ts`.

**Checks:** `tsc`, `eslint`, `prettier` all clean locally. Pushed as follow-up commit `923b23fd6` via `safe-push-pr-head.sh --mode advance` (`37200386..923b23fd6`). CI watched to terminal: **all 14 checks SUCCESS**, mergeStateStatus `CLEAN`.

**Follow-ups:** none blocking. The panel noted a proposed-rule (grep same-package consumers for casts naming a migrated type) and coverage-auditor's non-issue (type-only diff, no runtime surface); both are informational.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 75 tokens (2957825 cached reads)
- Output: 25718 tokens
- Cost: $3.0286975000000007
- Wall-clock: 992s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
