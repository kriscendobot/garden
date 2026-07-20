Remote tip confirmed at my commit `8b9c050825`; no inbox messages. The job is complete.

## Completion report

**Job:** stage-10m child 0 — land the `XS_CODE_SET_PROPERTY_AT` runtime-opcode frontier (computed integer-key assignment on plain objects), PR #600, branch `xs2rust-endor`.

**What I did**
- **Reproduce-first:** confirmed at the real tip (`1481757f7f`) that the only remaining `set_property_at` skip was integer-index on a non-array ordinary object — string-key, array-index, accessor, proxy, and array-length computed writes were already landed at s43. The oracle certified `o[2]='x'`→`"x"` and key order `{b:1,2:'x',a:2,1:'y'}`→`"1,2,b,a"`.
- Transliterated XS's `fxOrdinarySetProperty` id-0 branch: an ordinary object's integer-index own properties live in a hidden internal `XS_ARRAY_KIND` index chunk (`fxSetIndexProperty`), enumerated ascending **before** the string keys (`fxOrdinaryOwnKeys`). Carried as a new `object_indices` side table (BTreeMap per instance).
- **Write** (`o[2]=v`, `{2:'x'}` literal) and **read** paths now store/read that chunk; a non-extensible/frozen receiver rejects a new index (sloppy no-op / strict self-name) and honest-skips an ambiguous existing-index overwrite.
- **BINDING integer-key order** landed for `Object.keys`, `Object.getOwnPropertyNames`, `for-in`, `JSON.stringify` (indices first ascending, then string keys in creation order). The non-required consumers (`Object.entries`/`values`, `Reflect.ownKeys`, object spread, `Object.assign`, `defineProperties` descs) honest-skip index-keyed receivers rather than drop keys. Verified every index-key query path (`in`, `hasOwnProperty`, `getOwnPropertyDescriptor`, `delete o[k]`) already honest-skips — no wrong completion possible.
- **New side table ledgered same-day:** `SideTable::ObjectIndices` (`Coverage::Pending`), `VARIANT_COUNT` 35 → 36.

**What changed** (commit `8b9c050825`, pushed to `origin/xs2rust-endor`, exit 0 verified)
- `rust/engine/endor-vm/src/interp.rs` — storage, write/read, enumeration weaving, safety guards, helpers.
- `rust/engine/endor-snapshot/src/sidetable.rs` — new ledger variant + count.
- `rust/engine/endor-262/tests/object_integer_key_assignment.rs` — 7 new dual-run gates.

**Bars at final tip** (clean rebuild `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, oracle from sha-verified pin `23b4d6b0`): engine workspace **930/0** (74 result lines, up from s43 anchor 923/0/73), compile-diff **1909/1909** + SYMB **1909/1909**, boot gate **30/0**, ROOT `cargo test -p endo --lib` **111/0** with all three markers green. 0 non-oracle warnings, no new unsafe, `forbid(unsafe_code)` intact, forbid roots intact.

**Honest skips added:** `set_property_at:non-extensible-existing-index`, `strict-set:not-extensible`, and `*:integer-index-key` guards on entries/values/Reflect.ownKeys/copy-object/assign/defineProperties. **Removed:** the `set_property_at` and `get_property_at` skips for ordinary-object integer indices.

**Follow-ups:** `XS_CODE_DELETE_PROPERTY_AT`, integer-index `in`/`hasOwnProperty`/`getOwnPropertyDescriptor`, integer-index accessors, and weaving index keys into entries/values/Reflect.ownKeys/spread remain separate ledger frontiers (all currently honest-skip).
