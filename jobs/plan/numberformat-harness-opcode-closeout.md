---
gate: orchestrated
orchestrated_by: numberformat-residual-orch
priority: normal
posted_by: producer
posted_at: 2026-08-15T03:44:51Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
issue_spine: issue-kriscendobot-garden-51
---

# NumberFormat: engine-opcode gaps exposed by Intl test harnesses + misc closeout + zero-generic verification

**Scope (~46 cases + final verification):** cases blocked NOT by NumberFormat but by engine-opcode honest-skips that the Intl test harnesses (testIntl.js, compareArray.js, propertyBagObserver, Test262Error paths) newly reach now that NumberFormat runs to completion. These are engine-completion tasks; the NumberFormat VALUES the foundation computes are already correct — the harness helper hits an unmodeled opcode metering before the case can complete.

**Cases by blocking opcode:**
- `unsupported-opcode:indexOf/lastIndexOf:scan-metering` (**34**): all `prototype/format/format-rounding-*.js` (increment/mode/priority), `format-{fraction,significant}-digits*.js`, `format-max-min-fraction-significant-digits.js`, `percent-formatter.js`, `test-option-roundingPriority-mixed-options.js`. These use `testIntl.js` helpers calling String/Array `indexOf`/`lastIndexOf` in a metering path Ironhorse honest-skips. Model the metering.
- `unsupported-opcode:callback:non-user-function` (3): `constructor-option-read-order.js`, `format-function-property-order.js`, `subclassing.js` (compareArray / propertyBagObserver Proxy).
- `to_primitive:no-primitive-result` (2), `native-call:Object` (2), `to_numeric:type-error` (2), `String.split:non-regexp-separator` (2), `at` (2), `JSON.stringify:interned-key` (1), `plus` (1), `propertyIsEnumerable:non-string-key` (1), `getOwnPropertyDescriptor:non-object` (2 — may close with the getter child).

**Misc closeout (NumberFormat-side):** `prototype/format/{numbering-systems,value-decimal-string,engineering-scientific-zh-TW,value-arg-coerced-to-number,value-tonumber}.js`, `prototype/formatToParts/{percent-en-US,engineering-scientific-zh-TW,value-tonumber}.js`, `prototype/resolvedOptions/{basic,return-keys-order-default,resolved-numbering-system-unicode-extensions-and-options}.js`, `constructor-{locales-arraylike,locales-get-tostring,locales-hasproperty,locales-toobject,options-toobject,options-throwing-getters,options-roundingMode-invalid,roundingIncrement-invalid}.js`, `ignore-invalid-unicode-ext-values.js`, `taint-Object-prototype.js`, `this-value-ignored.js`.

**Definition of done:** the ENTIRE intl402/NumberFormat slice reports ZERO generic reasons (no `abort-value-differs`, `ironhorse-aborted`, `unsupported-opcode:*`, `parse-or-decode`, `non-primitive-completion`) — every case at `oracle-host-missing-intl` or `covered`. Run the full slice as the final gate. Some engine-opcode work benefits other Intl families too; that is expected.

**Pins (unchanged):** shared branch `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN/draft, keep OPEN, do NOT merge); test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; `TMPDIR` off noexec. Fetch+rebase the shared branch before every push (rebase CAS loop); preserve prior commits; stack bounded commits.

**Landed foundation (child `ironhorse-intl-numberformat`, commits through `d49790f5f` on the shared branch):** `Intl.NumberFormat` is registered in `create_intl` with the constructor, full ECMA-402 option processing (style/currency/unit/notation/signDisplay/useGrouping/digit options in spec read order), `resolvedOptions` (correct key order), `supportedLocalesOf`, and the `format`/`formatToParts`/`resolvedOptions` prototype methods. The value engine is the new module `rust/engine/ironhorse-vm/src/intl_number.rs` (exact-decimal rounding). WORKING: style decimal + percent; notation standard/scientific/engineering; grouping (en-US/de-DE/ja/ko/zh + en-IN Indian sizes); all 9 rounding modes; significant/fraction digits; roundingIncrement; trailingZeroDisplay; signDisplay (rounded-zero + NaN/Infinity); non-finite; numbering-system digit maps (latn/arab/thai/hanidec/etc.); formatToParts for the above. Regression tests: `rust/engine/ironhorse-262/tests/intl_numberformat.rs`. At head, the intl402/NumberFormat slice is 89 `oracle-host-missing-intl` (accepted) of 249; this orchestration closes the rest.

**Acceptance bar (non-negotiable, per parent):** convert via REAL execution to the accepted terminal — genuine `covered` (BothComplete, values agree) or the standards-grounded `oracle-host-missing-intl` (Ironhorse runs to `IronhorseOnlyComplete` with the correct CLDR value while the oracle reports `ReferenceError: get Intl: undefined variable`). Do NOT weaken the classifier, relabel, suppress, skip-list, or add expectation files. Lock exact values with focused Rust regressions in `rust/engine/ironhorse-262/tests/` (mirror `intl_numberformat.rs` / `intl_formatters.rs`). **Regression invariant:** no `covered` case in `baseline/baseline.json` regresses; no new `ironhorse-failure`/`infrastructure`; the `--gate-meter-exact` corpus (`cases/**`) and `cargo test --workspace --release` stay green. Measure the slice with `rust/engine/ironhorse-262/scripts/full-run.sh --subtree intl402/NumberFormat --output <dir> --jobs 4` (clean tree required — commit first). Triage single cases with `ironhorse_262::dual_run(src)`.

**Report:** commands, before/after slice totals, changed reasons, head SHA, PR URL. Keep PR OPEN; do not merge. If over budget, sub-decompose further under a nested halt-on-failure orchestration and hand off — do NOT partially relabel.

<!-- garden-annotation: key=67344d1d5edd by=producer at=2026-08-16T06:50:21Z -->

DEFERRED INDEFINITELY by maintainer decision 2026-08-16 (liaison session): the re-scope proposal recommended promoting the 9 rebudgeted Intl/ECMA-402 formatter families as the best-scoped landable work, and the maintainer instead deferred the Intl feature families indefinitely to conserve campaign budget (spend was 3,307,979 against 2,080,000 approved). Do NOT promote this without a fresh maintainer go-ahead. The host-only-exclusion pattern proven by child-20 and js-25 still applies whenever it is revived.
