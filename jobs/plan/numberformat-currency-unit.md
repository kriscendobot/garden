---
gate: orchestrated
orchestrated_by: numberformat-residual-orch
priority: normal
posted_by: producer
posted_at: 2026-08-15T03:44:37Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
issue_spine: issue-kriscendobot-garden-51
---

# NumberFormat: currency + unit formatting (CLDR affixes, per-locale)

**Scope (~34 cases):** style `currency` and style `unit` formatting across en-US/de-DE/ja-JP/ko-KR/zh-TW, currently `abort-value-differs` (the number body is correct; the affixes are unimplemented).

**Currency:** implement symbol resolution (`currencyDisplay`: symbol / narrowSymbol / code / name), per-locale **symbol placement** (prefix vs suffix, spacing), and `currencySign: accounting` **negative parenthesization** (`(87.00)`). E.g. en-US USD → `$987.00`, accounting negative → `($987.00)`, signDisplay:always positive → `+$987.00`. Currencies in the corpus: USD, EUR, JPY, KRW, CNY, GBP, and code-only IQD/KMF/CLF/XDR. Default fraction digits already come from `currency_digits()`. Cases: `prototype/format/signDisplay-currency-{en-US,de-DE,ja-JP,ko-KR,zh-TW}.js`, `signDisplay-negative-currency-*.js`, `prototype/formatToParts/signDisplay-currency-*.js`, `test-option-currency.js`, `test-option-currencyDisplay.js` (also hits `unsupported-opcode:at`), `currency-digits-nonstandard-notation.js`, `currencyDisplay-unit.js`.

**Unit:** implement CLDR unit patterns (`unitDisplay`: short/narrow/long), **compound units** (`kilometer-per-hour` → `km/h` short, `kilometers per hour` long) with **plural selection** (reuse the plural machinery), per-locale placement (ko `시속 …킬로미터` prefix). Cases: `prototype/format/unit-{en-US,de-DE,ja-JP,ko-KR,zh-TW}.js`, `units.js`, `prototype/formatToParts/unit-*.js`, `style-unit.js`, `constructor-unit.js`, `constructor-unitDisplay.js`.

Add `currency`/`unit` part types to `intl_number::partition_number` (currency/unit affix layering, already scaffolded with `Style::Currency`/`Style::Unit`, `CurrencyDisplay`, `UnitDisplay`).

**Pins (unchanged):** shared branch `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN/draft, keep OPEN, do NOT merge); test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; `TMPDIR` off noexec. Fetch+rebase the shared branch before every push (rebase CAS loop); preserve prior commits; stack bounded commits.

**Landed foundation (child `ironhorse-intl-numberformat`, commits through `d49790f5f` on the shared branch):** `Intl.NumberFormat` is registered in `create_intl` with the constructor, full ECMA-402 option processing (style/currency/unit/notation/signDisplay/useGrouping/digit options in spec read order), `resolvedOptions` (correct key order), `supportedLocalesOf`, and the `format`/`formatToParts`/`resolvedOptions` prototype methods. The value engine is the new module `rust/engine/ironhorse-vm/src/intl_number.rs` (exact-decimal rounding). WORKING: style decimal + percent; notation standard/scientific/engineering; grouping (en-US/de-DE/ja/ko/zh + en-IN Indian sizes); all 9 rounding modes; significant/fraction digits; roundingIncrement; trailingZeroDisplay; signDisplay (rounded-zero + NaN/Infinity); non-finite; numbering-system digit maps (latn/arab/thai/hanidec/etc.); formatToParts for the above. Regression tests: `rust/engine/ironhorse-262/tests/intl_numberformat.rs`. At head, the intl402/NumberFormat slice is 89 `oracle-host-missing-intl` (accepted) of 249; this orchestration closes the rest.

**Acceptance bar (non-negotiable, per parent):** convert via REAL execution to the accepted terminal — genuine `covered` (BothComplete, values agree) or the standards-grounded `oracle-host-missing-intl` (Ironhorse runs to `IronhorseOnlyComplete` with the correct CLDR value while the oracle reports `ReferenceError: get Intl: undefined variable`). Do NOT weaken the classifier, relabel, suppress, skip-list, or add expectation files. Lock exact values with focused Rust regressions in `rust/engine/ironhorse-262/tests/` (mirror `intl_numberformat.rs` / `intl_formatters.rs`). **Regression invariant:** no `covered` case in `baseline/baseline.json` regresses; no new `ironhorse-failure`/`infrastructure`; the `--gate-meter-exact` corpus (`cases/**`) and `cargo test --workspace --release` stay green. Measure the slice with `rust/engine/ironhorse-262/scripts/full-run.sh --subtree intl402/NumberFormat --output <dir> --jobs 4` (clean tree required — commit first). Triage single cases with `ironhorse_262::dual_run(src)`.

**Report:** commands, before/after slice totals, changed reasons, head SHA, PR URL. Keep PR OPEN; do not merge. If over budget, sub-decompose further under a nested halt-on-failure orchestration and hand off — do NOT partially relabel.
