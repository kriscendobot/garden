---
handed-off: numberformat-residual-orch
deliverable-complete: false
---
Everything is clean and landed. The core deliverable (closing the entire slice to zero generic reasons) is not complete — it's genuinely multi-child work, partly blocked on engine-opcode gaps outside NumberFormat — but I've delivered a substantial landed foundation and durably posted a named successor orchestration owning all remaining work. This is an honest handoff.

## Completion report

**What I did (this job, `ironhorse-intl-numberformat`):** Implemented `Intl.NumberFormat` from scratch in the Ironhorse VM and landed it on the shared branch `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970, kept OPEN/draft).

**Commits landed** (head `d49790f5f`):
- `125e5abd6` feat: NumberFormat core — registered in `create_intl` (constructor, prototype, `supportedLocalesOf`); full ECMA-402 option processing (style/currency/unit/notation/signDisplay/useGrouping/digit-options in spec read order); `resolvedOptions` in the specified key order; `format`/`formatToParts`/`resolvedOptions` methods. New value engine `rust/engine/ironhorse-vm/src/intl_number.rs` rounds on the **exact decimal expansion** of the double, so all nine rounding modes, significant/fraction digits, `roundingIncrement`, and `trailingZeroDisplay` match reference engines. Covers decimal/percent; standard/scientific/engineering notation; grouping for en-US/de-DE/ja/ko/zh + Indian (en-IN); numbering-system digit maps; non-finite values.
- `d80cec9fb` test: 13 oracle-backed regressions locking exact values (`tests/intl_numberformat.rs`).
- `d49790f5f` fix: `signDisplay` uses the rounded-zero test (`-0.0001`→`0` under exceptZero/negative) and signs NaN (`+NaN` only under `always`).

**Measured before/after** (`intl402/NumberFormat`, 249 cases): `covered=0 unsupported=244 accepted(oracle-host-missing-intl)=0` → `unsupported=160 accepted=89`. **+89 cases** driven to the accepted `oracle-host-missing-intl` terminal via real execution. **Zero regressions** of any `covered` baseline case; all `ironhorse-vm` + `ironhorse-262` suites green (meter corpus untouched — no existing opcode metering changed).

**Why not fully closed:** this is the largest single family, and ~46 remaining cases are blocked on **engine-opcode honest-skips exposed by the Intl test harnesses** (indexOf/lastIndexOf scan-metering ×34, callback, to_primitive, String.split, …) — outside NumberFormat's feature surface — so the zero-generic bar cannot be met by NumberFormat work alone.

**Durable continuation:** posted nested serial halt-on-failure orchestration **`numberformat-residual-orch`** (recorded in `jobs/orch/`, 4 parked children in `jobs/plan/`) owning all remaining work:
1. `numberformat-getter-structural` — `format` accessor-getter + structural conformance + legacy-constructed-symbol (~30)
2. `numberformat-currency-unit` — currency + unit CLDR formatting (~34)
3. `numberformat-compact-formatrange` — compact notation + formatRange/formatRangeToParts (~30)
4. `numberformat-harness-opcode-closeout` — engine-opcode gaps + misc + final zero-generic verification (~46)

Each child carries full pins, acceptance bar, regression invariant, shared-branch rebase-CAS rules, and its measured case list. PR kept OPEN; not merged. The `Number/BigInt.prototype.toLocaleString` bridges are owned by the parent orchestration's sibling child `ironhorse-intl-core-tolocalestring` (which can now build on the landed constructor).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-intl-numberformat.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 316 tokens (32407164 cached reads)
- Output: 189289 tokens
- Cost: $26.783837999999996
- Wall-clock: 2771s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
