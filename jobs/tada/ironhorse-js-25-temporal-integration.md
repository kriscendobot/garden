All work is complete, committed, and pushed. Local HEAD matches remote at `b3c3ae93b8`.

## Completion report — Temporal integration (js-25)

**Repository:** `endojs/endo-but-for-bots` · **PR:** https://github.com/endojs/endo-but-for-bots/pull/970 (**OPEN, draft, not merged**) · **Head SHA:** `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b` · **Branch:** `feat/ironhorse-262-language-completion` (the shared Ironhorse completion branch; I fetched it, preserved children 12–24's commits, and stacked on `3c62d67`). **Pins unchanged:** test262 `be13516fb`, XS oracle `23b4d6b0`.

**What I did.** Closed the residual **Temporal-specific** opcode gaps in the pinned suite with ISO calendar-relative arithmetic under the engine's fixed-offset / constant-24-hour-day model (`rust/engine/ironhorse-vm/src/interp.rs`):
- `Temporal.Duration.compare` / `total` / `round` with a `relativeTo` reference (PlainDate, PlainDateTime, ZonedDateTime, property bag, or ISO string), plus the field-identical `compare` short-circuit that needs no reference.
- `Temporal.ZonedDateTime.prototype.until` / `since` with a calendar `largestUnit` (week/month/year) via `DifferenceISODateTime` on the local wall clock.
- ISO 8601 basic-format date parsing (`YYYYMMDD`, `YYYYMM`).
- Spec validation: calendar units require `relativeTo`; `largestUnit ≥ smallestUnit`; increments divide their unit maximum; endpoint bounded to the Temporal datetime limit.

New free helpers do ISO `dateAdd`/`dateUntil`, `DifferenceISODateTime`, the exact duration span, and the year/month total fraction.

**Commands run** (all release, XS oracle on):
- `full-run.sh --subtree built-ins/Temporal` (before + after) and `--subtree intl402/Temporal`, `--test262-dir` at the pin.
- `cargo test --workspace --release` on the final committed tree.
- Targeted: `regressions_dual_run`, `corpus_conversion_equivalence`, `temporal_{core,plain,zoned,integration}`.
- Real-case verification: 22 official target cases assembled with the harness → all reach `IronhorseOnlyComplete`.

**Totals before → after — `test/built-ins/Temporal` (4603 cases, real XS-oracle execution):**
| category | before | after |
|---|---|---|
| skipped (host-excluded `oracle-host-missing-temporal`) | 2876 | **2962** |
| unsupported | 1727 | **1641** |
| ironhorse-failure | 0 | **0** |
| infrastructure | 0 | **0** |

**86 cases** moved `unsupported-opcode:*` → the justified host-only skip: `Duration.{compare,total,round}:relativeTo` (78) and `ZonedDateTime:calendar-difference-unit` (8). **Zero `feature:Temporal` pre-skips** — already the case from prior children, still true.

**Changed skip reasons:** the five Temporal-specific `unsupported-opcode` reasons dropped to 0; the sole remaining Temporal-specific residual is `toLocaleString:needs-intl` (9 across both slices). Remaining `unsupported` is dominated by the shared `u/v` regexp-flag prerequisite (1477), owned elsewhere.

**Correctness gate (the oracle cannot compare Temporal, so the full-run masks it):** 8 new XS-differential regressions in `rust/engine/ironhorse-262/tests/temporal_integration.rs` pin exact rendered results / catchable errors; separately, all **22/22** official target cases reach `IronhorseOnlyComplete` (every assertion passes under Ironhorse). Do **not** rely on the report's skip-count movement alone for correctness.

**Regression invariant — verified.** `cargo test --workspace --release` green (56 suites, **0 failed**) on the committed tree; exact-metering corpus (`regressions_dual_run`, `corpus_conversion_equivalence`) passes with **computron expectations unchanged**; no covered case regressed; `intl402/Temporal` (2029 cases) shows **0 ironhorse-failure / 0 infrastructure**. One mid-work regression (4 hangs on adversarial out-of-range durations scored as `ironhorse-failure`) was found by the after-slice and fixed with an endpoint range-guard + O(1) loop seed before final push.

**Follow-ups (not blocking):** `Temporal.*.toLocaleString` remains an honest `needs-intl` residual requiring Temporal↔`Intl.DateTimeFormat` wiring; the `u/v` regexp-flag prerequisite gates the bulk of remaining Temporal `unsupported` cases and is a shared regexp-engine concern.

**Self-improvement:** updated the `ironhorse-temporal-host-exclusion` memory with the js-25 result, the relativeTo→date reduction, and the hang/range-guard gotcha.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-25-temporal-integration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 273 tokens (26698042 cached reads)
- Output: 168361 tokens
- Cost: $20.41128300000001
- Wall-clock: 4962s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
