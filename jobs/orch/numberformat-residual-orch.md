---
order: serial
children: numberformat-getter-structural numberformat-currency-unit numberformat-compact-formatrange numberformat-harness-opcode-closeout
on-child-failure: halt
state: running
created_by: builder
created_at: 2026-08-15T03:45:24Z
---

# NumberFormat residual closure — nested halt-on-failure orchestration

Nested under the parent `ironhorse-intl-value-parity-orch` (js-26 residual arc, issue kriskowal/garden#51). The foundational child `ironhorse-intl-numberformat` landed `Intl.NumberFormat` — the constructor, full option processing, resolvedOptions, supportedLocalesOf, and the format/formatToParts methods, with the exact-decimal value engine `rust/engine/ironhorse-vm/src/intl_number.rs` covering decimal/percent/scientific/engineering, grouping, all rounding modes, signDisplay, numbering systems, and formatToParts (89/249 of the slice at `oracle-host-missing-intl`, 0 regressions, on the shared branch through commit `d49790f5f`).

The NumberFormat family was too large for one handler AND ~46 of its cases are blocked on engine-opcode honest-skips exposed by Intl test harnesses (indexOf scan-metering ×34, callback, to_primitive, String.split, …) that are outside the NumberFormat feature surface. This orchestration closes the residual in **serial, halt-on-failure** order so the shared branch `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970, kept OPEN/draft) never suffers concurrent-CAS collisions:

1. `numberformat-getter-structural` — the `format` accessor-getter (real accessor property + cached bound function) + constructor/prototype structural conformance + legacy-constructed-symbol (~30 cases).
2. `numberformat-currency-unit` — currency (symbols/placement/accounting) + unit (compound/plural, per-locale) CLDR formatting (~34 cases).
3. `numberformat-compact-formatrange` — compact notation CLDR patterns + formatRange/formatRangeToParts (~30 cases).
4. `numberformat-harness-opcode-closeout` — engine-opcode gaps the Intl harnesses reach + misc closeout + final ZERO-generic-reasons verification of the whole slice (~46 cases).

Each child carries the full pins, acceptance bar, regression invariant, shared-branch rebase-CAS rules, and its measured case list. Definition of done: the entire intl402/NumberFormat slice at `oracle-host-missing-intl` or `covered` with zero generic reasons, plus the Number/BigInt.prototype.toLocaleString bridges (owned by the sibling `ironhorse-intl-core-tolocalestring` child of the parent orchestration).
