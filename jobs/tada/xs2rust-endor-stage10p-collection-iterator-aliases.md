All three alias fixes are pushed to `xs2rust-endor` (tip `3028c313f5`), local matches remote, working tree clean (no bundles/moddable staged), inbox empty, PR #600 untouched (stays DRAFT).

## Completion report — s10p child 0: collection `@@iterator` alias completion (F1(s46), PR #600)

**Reproduced first (dual-run at tip 139b8561f1):** endor bound `@@iterator` on **no** collection/array prototype — the read was `undefined` (for-of drives the dedicated `XS_CODE_FOR_OF` opcode, not a property read), so `Set/Map/Array.prototype[Symbol.iterator] === …values/entries` all silently WRONG-completed (`typeof` `undefined` vs oracle `function`). The finding's "distinct function object" was in fact *no* binding at all.

**Audited every `fxNextSlotProperty` `@@iterator` alias** in the pinned tables (`grep 'mxID(_Symbol_iterator)' c/moddable/xs/sources/*.c`) and fixed each genuine identity divergence by sharing the ONE aliased function slot (matching XS), the shared `.name` being the aliased target's:

| Case | Oracle | Fix | Commit |
|---|---|---|---|
| **Set** → `values` (=== `keys`), name `"values"` | true | aliased | `66f16b015d` |
| **Map** → `entries` (NOT `keys`), name `"entries"` | true | aliased | `e314ccc855` |
| **Array** → `values`, name `"values"` | true | aliased | `3028c313f5` |

Mechanism: a boot-time `iterator_alias_targets` vec captures each shared method slot; after `proto_methods` stamps `.name`, a single loop registers it under the interned `Symbol.iterator` key as a non-enumerable (`XS_DONT_ENUM_FLAG`) own data property, gated on the program naming `Symbol.iterator`, unmetered. `Map.prototype.keys` stays its own `"keys"` function (no collateral aliasing — gated).

**Verified-already-correct / honest-skip (recorded, not fixed, per accuracy-over-parity):**
- **TypedArray** (`Uint8Array.prototype.values`) is itself unbound in endor, so `@@iterator === values` *spuriously agrees* (both `undefined`) — no identity divergence to alias; needs a TypedArray values iterator (separate increment).
- **arguments object** `@@iterator` honest-SKIPs (`Unsupported("arguments_sloppy")`) — arguments-object property reads are unmodeled; a skip, not a wrong completion.
- **String** `@@iterator` verified as XS's OWN host function `fx_String_prototype_iterator` (name `"[Symbol.iterator]"`), **not an alias** — a fresh native method, out of scope for alias completion.

**Gate:** new `collection_iterator_alias.rs` (3 tests) graduating the s46 probe `Set.prototype[Symbol.iterator] === Set.prototype.values` to an `agree` assertion, plus Map/Array siblings (identity, non-alias, name, enumerable, functional for-of).

**Full bars at each pushed tip** (final, `3028c313f5`): workspace `cargo test --workspace --release` **946/0** (943 → +3 gates), compile-diff no-arg **1909/1909 + SYMB 1909/1909**, boot_bundle_gate **30/0**, ROOT `endo --lib` **111/0**, 0 non-oracle warnings, no new `unsafe`, no new per-instance side table (a boot-construction vec, `mem::take`'d like `proto_methods`).

**Follow-ups:** TypedArray `values`/`keys`/`entries` iterator methods (would then let TypedArray `@@iterator` alias truthfully); arguments-object property-read modeling; String `@@iterator` own-method binding. PR #600 kept DRAFT.
