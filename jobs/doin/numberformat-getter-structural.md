---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T03:46:08Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
issue_spine: issue-kriscendobot-garden-51
---

# NumberFormat: format accessor-getter + constructor/prototype structural surface + legacy-constructed-symbol

**Scope (~30 cases of the intl402/NumberFormat slice):** the `format` **accessor getter** and the structural conformance tests that currently land `abort-value-differs` / `unsupported-opcode:getOwnPropertyDescriptor:non-object`.

**Measured diagnosis:** the foundation models `Intl.NumberFormat.prototype.format` as a plain own **method**, but the spec requires an **accessor property** whose getter returns a cached bound function (`[[BoundFormat]]`). `Object.getOwnPropertyDescriptor(Intl.NumberFormat.prototype,'format')` must report `{get:function, set:undefined, enumerable:false, configurable:true}`. The engine currently has NO boot-time real accessor property (its native getters — RegExp `flags`, Map `size` — are special-cased in GET_PROPERTY and do NOT appear in `getOwnPropertyDescriptor`; verified). This child must add the machinery to install a real native accessor getter on a prototype (revealed by `getOwnPropertyDescriptor`, invoked on read with the instance as `this`, returning the same cached bound function each read; the `NumberFormatData.bound_format` slot is already reserved). 

**Cases:** `prototype/format/{prop-desc,builtin,length,name,bound-to-numberformat-instance,format-function-builtin,format-function-length,format-function-name,format-function-property-order,no-instanceof}.js`; top-level `{builtin,length,name,prop-desc,proto-from-ctor-realm}.js`; `prototype/{prop-desc}`; and the **legacy-constructed-symbol** trio `intl-legacy-constructed-symbol{,-on-unwrap,-property}.js` (the ECMA-402 fallback-symbol behavior where a NumberFormat is installed on a `this` that inherits from NumberFormat.prototype). `format-function-property-order.js` and `subclassing.js` additionally hit `unsupported-opcode:callback:non-user-function` — verify whether the getter closes them.

**Pins (unchanged):** shared branch `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN/draft, keep OPEN, do NOT merge); test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; `TMPDIR` off noexec. Fetch+rebase the shared branch before every push (rebase CAS loop); preserve prior commits; stack bounded commits.

**Landed foundation (child `ironhorse-intl-numberformat`, commits through `d49790f5f` on the shared branch):** `Intl.NumberFormat` is registered in `create_intl` with the constructor, full ECMA-402 option processing (style/currency/unit/notation/signDisplay/useGrouping/digit options in spec read order), `resolvedOptions` (correct key order), `supportedLocalesOf`, and the `format`/`formatToParts`/`resolvedOptions` prototype methods. The value engine is the new module `rust/engine/ironhorse-vm/src/intl_number.rs` (exact-decimal rounding). WORKING: style decimal + percent; notation standard/scientific/engineering; grouping (en-US/de-DE/ja/ko/zh + en-IN Indian sizes); all 9 rounding modes; significant/fraction digits; roundingIncrement; trailingZeroDisplay; signDisplay (rounded-zero + NaN/Infinity); non-finite; numbering-system digit maps (latn/arab/thai/hanidec/etc.); formatToParts for the above. Regression tests: `rust/engine/ironhorse-262/tests/intl_numberformat.rs`. At head, the intl402/NumberFormat slice is 89 `oracle-host-missing-intl` (accepted) of 249; this orchestration closes the rest.

**Acceptance bar (non-negotiable, per parent):** convert via REAL execution to the accepted terminal — genuine `covered` (BothComplete, values agree) or the standards-grounded `oracle-host-missing-intl` (Ironhorse runs to `IronhorseOnlyComplete` with the correct CLDR value while the oracle reports `ReferenceError: get Intl: undefined variable`). Do NOT weaken the classifier, relabel, suppress, skip-list, or add expectation files. Lock exact values with focused Rust regressions in `rust/engine/ironhorse-262/tests/` (mirror `intl_numberformat.rs` / `intl_formatters.rs`). **Regression invariant:** no `covered` case in `baseline/baseline.json` regresses; no new `ironhorse-failure`/`infrastructure`; the `--gate-meter-exact` corpus (`cases/**`) and `cargo test --workspace --release` stay green. Measure the slice with `rust/engine/ironhorse-262/scripts/full-run.sh --subtree intl402/NumberFormat --output <dir> --jobs 4` (clean tree required — commit first). Triage single cases with `ironhorse_262::dual_run(src)`.

**Report:** commands, before/after slice totals, changed reasons, head SHA, PR URL. Keep PR OPEN; do not merge. If over budget, sub-decompose further under a nested halt-on-failure orchestration and hand off — do NOT partially relabel.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-15T04:14:54Z
