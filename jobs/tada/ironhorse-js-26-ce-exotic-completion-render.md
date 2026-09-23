Done. All work committed, verified against the real XS oracle, and pushed. PR #970 stays open/draft.

## Completion report

**Job:** Close the residual `non-primitive-completion` gap for exotic-builtin program completions in the ironhorse VM's `Interp::render` (display-only, zero metering), the child of the js-26 residual-closure arc following the parent function-completion fix (`3f24768032`).

**What I did**
- Extended `Interp::render` (`rust/engine/ironhorse-vm/src/interp.rs`) to stringify exotic-builtin completions the way the pinned Moddable XS oracle does, via the internal type maps:
  - `ArrayBuffer`/`SharedArrayBuffer` → `[object ArrayBuffer]` / `[object SharedArrayBuffer]` (from `array_buffers`/`shared_buffers`).
  - `DataView` → `[object DataView]` (from `data_views`).
  - TypedArray → the `Array.prototype.join(",")` of its elements (`new Int8Array(3)` → `0,0,0`), NOT its tag; added a `&self` `typed_array_element_bigint_decimal` helper for BigInt64/BigUint64 element decimals.
  - `arguments` → `[object Arguments]`. Added an `arguments_objects` marker set (populated by `XS_CODE_ARGUMENTS_SLOPPY`/`_STRICT`) so render distinguishes it from a plain array **without changing element storage** — fixing the wrong `1,2` join. Marker arm precedes the array arm.
  - Any object with a string `Symbol.toStringTag` (own/inherited) → `[object <Tag>]`, via a new read-only `string_tag_of` (never interns; render-boundary sibling of `string_to_string_tag`).
- Date/WeakRef completions (a separate constructor-gap `ReferenceError`) left untouched, per scope.
- Added `rust/engine/ironhorse-262/tests/exotic_completion_tostring.rs` — 8 dual-run regression tests (real oracle), mirroring `function_completion_tostring.rs`, covering all five cases plus unchanged-`[object Object]` guards.

**Verification (real XS oracle)**
- Affected slice, `ironhorse-xst` before/after over `built-ins/{ArrayBuffer,SharedArrayBuffer,DataView,TypedArray,TypedArrayConstructors,Symbol}` (3168 cases): **covered 205 → 219**; **14** `non-primitive-completion` skips flipped to `covered` (ArrayBuffer, SharedArrayBuffer, DataView, and all 12 TypedArray-constructor `is-a-constructor.js`); **zero regressions, zero new divergences/failures**.
- `cargo test -p ironhorse-vm` (CI-equivalent, debug): 90 passed. `cargo test --workspace --release`: all pass (incl. exact-metering corpus). New regression test: 8/8 pass. Re-verified clean post-rebase.

**Result**
- Branch `feat/ironhorse-262-language-completion`, head **`a5779bf7dd2b2e62c766b6877167f70ded0e9361`**. PR **https://github.com/endojs/endo-but-for-bots/pull/970** — OPEN, draft, kept open (not merged).
- Pins unchanged (engine `b3c3ae93b8` lineage, test262 `be13516fb6`, Moddable `23b4d6b0a6`).

**Follow-ups (out of scope, noted):** the arguments/`Symbol.toStringTag` render paths have no corpus flips in the measured built-ins slice (test262 tests rarely end with a bare `arguments`/toStringTag completion), so those two are carried by the regression tests, not the slice delta; `TypedArray.of(...)` completions still abort on an unrelated builtin gap; Date/WeakRef completions remain a separate constructor gap.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ce-exotic-completion-render.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 148 tokens (7545220 cached reads)
- Output: 45313 tokens
- Cost: $6.1709070000000015
- Wall-clock: 811s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
