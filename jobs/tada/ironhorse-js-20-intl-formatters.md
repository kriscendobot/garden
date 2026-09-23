---
orchestration-failed: true
---
All commits are pushed (`af3f563fea` is the branch tip; nothing unpushed).

---

## Completion report — `ironhorse-js-20-intl-formatters`

**Repository:** endojs/endo-but-for-bots · **PR:** https://github.com/endojs/endo-but-for-bots/pull/970 (open, draft, not merged) · **Head:** `af3f563feab7683da09cb78950990d9ad0451f52`

### What I did
Built on child 19's deterministic Intl core (present on the branch as `bd88685f0c`) and implemented **2 of the 6** required formatter families to real-execution correctness:

- **`Intl.ListFormat`** — constructor with `GetOptionsObject` + `GetOption` validation in spec read order (localeMatcher → type → style, RangeError on bad enum, TypeError without `new`); `format`/`formatToParts` driving the full iterator protocol (dense arrays, array-iterators handed in directly, guest `@@iterator` objects via native→JS re-entry, and primitive strings by code point) with `StringListFromIterable`'s string-only TypeError; `resolvedOptions` (exact `{locale,type,style}` order/descriptors); `supportedLocalesOf`; `Symbol.toStringTag`. Encoded English (every type×style) and Spanish `unit` CLDR list patterns.
- **`Intl.PluralRules`** — constructor with a faithful `SetNumberFormatDigitOptions` (fraction/significant defaulting, roundingIncrement/mode/priority validation); `select`/`selectRange` (English cardinal + ordinal rules with fraction-digit operands); `resolvedOptions` emitting fraction vs significant keys by rounding type in spec order; per-locale `pluralCategories` in canonical CLDR order; `Symbol.toStringTag`. Correct method `.name`/`.length`.
- **Core fix (suite-wide):** `arguments.length` returned `(actual − declared)` because the `ARGUMENTS_SLOPPY/STRICT` opcode used the formal-param-count operand as a skip offset; the arguments object now carries all passed args. This unblocks test262's `propertyHelper.verifyProperty` (rejects <3 args) everywhere.

### Commands run
- `cargo test -p ironhorse-262 --test intl_formatters` / `intl_core` — pass (new + existing oracle regressions).
- `cargo test --release --workspace` (rust/engine) — **all pass, 0 failures.**
- `corpus_conversion_equivalence` (gate_meter_exact) — **total=1711 covered=1711 failed=0** (computron-exact unchanged).
- `full-run.sh --subtree intl402/<family> --oracle on` for all six families (test262 pin `be13516`, XS `23b4d6b`).

### Totals before → after (official slice)
For Intl, `covered` is unreachable (the pinned XS oracle has no ECMA-402 host), so the acceptance target is the justified host-only exclusion `oracle-host-missing-intl`:

| Family | unsupported → | skipped (host-only) → |
|---|---|---|
| ListFormat | 80 → **47** | 1 → **34** |
| PluralRules | 50 → **29** | 3 → **24** |
| NumberFormat | 245 → 245 | 4 → 4 (unchanged) |
| RelativeTimeFormat | 80 → 80 | 0 → 0 (unchanged) |
| DisplayNames | 52 → 52 | 5 → 5 (unchanged) |
| DurationFormat | 103 → 103 | 7 → 7 (unchanged) |

**+54 cases** flipped from `unsupported` to host-only `oracle-host-missing-intl`. Changed skip reason: `abort-value-differs` → `oracle-host-missing-intl`.

### Regression invariant — held
`covered`, `ironhorse-failure`, and `infrastructure` are **0 across all six families** (no case regressed, no new failure/infrastructure result); metering corpus **1711/1711 computron-exact, unchanged**; full workspace green. Pins unchanged (test262 `be13516`, XS `23b4d6b`); branch base advanced by a peer's `chore: Update Cargo.lock` (`00fc377422`), onto which I rebased.

### Not done (why the gate is unmet)
4 of 6 families remain (NumberFormat, RelativeTimeFormat, DisplayNames, DurationFormat), and the two implemented families are not fully covered. Ceiling is two **core, non-Intl** engine gaps I judged too risky to change under the strict metering invariant (they belong in their own jobs): (1) native method `.length`/`.name` aren't reflectable/deletable descriptors (computed in GET, not stored), blocking all `length`/`name`/`prop-desc` `verifyProperty` tests suite-wide; (2) `Array.prototype[Symbol.iterator]` isn't a real property (for-of special-cases arrays), blocking ListFormat format-value tests and unsafe to install (for-of prioritizes custom `@@iterator`, changing metering everywhere). NumberFormat is foundational for RelativeTime/Duration and is the largest remaining piece (needs CLDR currency/unit/compact data). These findings were relayed to the maintainer via the message bus.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-20-intl-formatters.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 314 tokens (32388697 cached reads)
- Output: 181246 tokens
- Cost: $23.896511500000003
- Wall-clock: 2586s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
