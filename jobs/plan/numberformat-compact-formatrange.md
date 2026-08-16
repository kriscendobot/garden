---
gate: orchestrated
orchestrated_by: numberformat-residual-orch
priority: normal
posted_by: producer
posted_at: 2026-08-15T03:44:45Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
issue_spine: issue-kriscendobot-garden-51
---

# NumberFormat: compact notation + formatRange/formatRangeToParts

**Scope (~30 cases):** compact notation (`abort-value-differs`) and formatRange/formatRangeToParts (`unsupported-opcode:Intl.NumberFormat:formatRange`, honest-skipped by the foundation).

**Compact notation:** implement CLDR compact patterns (short/long) per locale (en/de/ja/ko/zh). The `Compact` struct and `Notation::Compact` path are scaffolded in `intl_number.rs`; the compact default rounding is `morePrecision` min1/max2 significant (the `_compact` hook in `set_number_digit_options` is unimplemented). E.g. en short: 987654321 → `988M`, 9876 → `9.9K`; long: → `988 million`, `9.9 thousand`. ja: `万`/`億`; ko: `천`/`만`/`억`; zh-TW: `萬`/`億`. Cases: `prototype/format/notation-compact-{en-US,de-DE,ja-JP,ko-KR,zh-TW}.js`, `prototype/formatToParts/notation-compact-*.js`, `constructor-compactDisplay-*.js`, and the compact assertions inside `useGrouping-extended-*.js` / `test-option-useGrouping-extended.js`.

**formatRange/formatRangeToParts:** implement `FormatNumericRange` — ToIntlMathematicalValue coercion of both args (throws TypeError on undefined, RangeError on NaN), the CLDR range pattern (en-US `1–5`), and the `x>y` no-throw rule. Cases: `prototype/formatRange/{en-US,pt-PT,nan-arguments-throws,undefined-arguments-throws,x-greater-than-y-not-throws,argument-to-Intlmathematicalvalue-throws,builtin,invoked-as-func,length,name}.js` and the parallel `formatRangeToParts/*.js`. Replace the `Halt::Unsupported("Intl.NumberFormat:formatRange")` stub in the method dispatch.

**Pins (unchanged):** shared branch `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN/draft, keep OPEN, do NOT merge); test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; `TMPDIR` off noexec. Fetch+rebase the shared branch before every push (rebase CAS loop); preserve prior commits; stack bounded commits.

**Landed foundation (child `ironhorse-intl-numberformat`, commits through `d49790f5f` on the shared branch):** `Intl.NumberFormat` is registered in `create_intl` with the constructor, full ECMA-402 option processing (style/currency/unit/notation/signDisplay/useGrouping/digit options in spec read order), `resolvedOptions` (correct key order), `supportedLocalesOf`, and the `format`/`formatToParts`/`resolvedOptions` prototype methods. The value engine is the new module `rust/engine/ironhorse-vm/src/intl_number.rs` (exact-decimal rounding). WORKING: style decimal + percent; notation standard/scientific/engineering; grouping (en-US/de-DE/ja/ko/zh + en-IN Indian sizes); all 9 rounding modes; significant/fraction digits; roundingIncrement; trailingZeroDisplay; signDisplay (rounded-zero + NaN/Infinity); non-finite; numbering-system digit maps (latn/arab/thai/hanidec/etc.); formatToParts for the above. Regression tests: `rust/engine/ironhorse-262/tests/intl_numberformat.rs`. At head, the intl402/NumberFormat slice is 89 `oracle-host-missing-intl` (accepted) of 249; this orchestration closes the rest.

**Acceptance bar (non-negotiable, per parent):** convert via REAL execution to the accepted terminal — genuine `covered` (BothComplete, values agree) or the standards-grounded `oracle-host-missing-intl` (Ironhorse runs to `IronhorseOnlyComplete` with the correct CLDR value while the oracle reports `ReferenceError: get Intl: undefined variable`). Do NOT weaken the classifier, relabel, suppress, skip-list, or add expectation files. Lock exact values with focused Rust regressions in `rust/engine/ironhorse-262/tests/` (mirror `intl_numberformat.rs` / `intl_formatters.rs`). **Regression invariant:** no `covered` case in `baseline/baseline.json` regresses; no new `ironhorse-failure`/`infrastructure`; the `--gate-meter-exact` corpus (`cases/**`) and `cargo test --workspace --release` stay green. Measure the slice with `rust/engine/ironhorse-262/scripts/full-run.sh --subtree intl402/NumberFormat --output <dir> --jobs 4` (clean tree required — commit first). Triage single cases with `ironhorse_262::dual_run(src)`.

**Report:** commands, before/after slice totals, changed reasons, head SHA, PR URL. Keep PR OPEN; do not merge. If over budget, sub-decompose further under a nested halt-on-failure orchestration and hand off — do NOT partially relabel.

<!-- garden-annotation: key=67344d1d5edd by=producer at=2026-08-16T06:50:07Z -->

DEFERRED INDEFINITELY by maintainer decision 2026-08-16 (liaison session): the re-scope proposal recommended promoting the 9 rebudgeted Intl/ECMA-402 formatter families as the best-scoped landable work, and the maintainer instead deferred the Intl feature families indefinitely to conserve campaign budget (spend was 3,307,979 against 2,080,000 approved). Do NOT promote this without a fresh maintainer go-ahead. The host-only-exclusion pattern proven by child-20 and js-25 still applies whenever it is revived.
