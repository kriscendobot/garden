Job complete at a green checkpoint. All acceptance bars pass and the fix is pushed to the real remote tip.

## Completion report — F1(s43) native-method `length`/`name` reflection (PR #600, branch `xs2rust-endor`)

**Reproduced first.** Built a dual-run probe against the sha-verified oracle pin (`23b4d6b0…`): confirmed every native method read `.length`/`.name` as `undefined` where the oracle reads the spec arity/name (`Object.keys.length` oracle `1`/endor `undefined`, `[].push.name` oracle `"push"`/endor `undefined`, etc.) — a silent wrong completion, plus the descriptor and own-keys divergences the ledger row names.

**Fix (one commit, `d268092d7b`, pushed to `origin/xs2rust-endor`):**
- `NativeMethod::spec_arity` / `Native::spec_arity` — per-method/ctor arity transliterated from the pinned moddable's host-function builder tables (`fxNextHostFunctionProperty`/`fxBuildHostConstructor` arity arguments, keyed by the exact `fx_...` callback; collisions like `keys`/`apply`/`get` disambiguated by variant, not name).
- Stamped `name`/`arity`/`name_chunk` on native ctors (at alloc), every prototype method+static (boot install loop), and the global functions registered straight into `intrinsics` (`parseInt`/`parseFloat`/`isNaN`/`isFinite`/`harden`/`petrify`/`lockdown`/`mutabilities`) — unmetered at boot.
- `GET_PROPERTY` + `getOwnPropertyDescriptor` synthesize the `length`/`name` own property lazily (no arena slot; descriptor carries XS's `{writable:false, enumerable:false, configurable:true}`).
- **Graduated** the ledger's "complete function `Reflect.ownKeys` (length/name/prototype prepend)" row: `getOwnPropertyNames`/`Reflect.ownKeys` now prepend `length,name(,prototype)` in XS creation order. Bound functions read the target's real reflection (`Object.keys.bind(null)` → `.length 0`, `.name "bound keys"`); user functions unchanged.
- Symbol-keyed/exotic accessors stay unreflected (sound `undefined` miss — gated on the stamped `name_chunk`), so the deliberate anonymous-name ledger row is not regressed.

**New test** `endor-262/tests/native_fn_reflection.rs` (6 dual-run tests, all result-agreeing): length across all bound families + constructors, `.name`, descriptor flags, own-keys order, bound/user non-regression.

**Measured bars at my tip (`d268092d7b`):**
- engine workspace `cargo test`: EXIT=0, all green (grew only by my 6 tests)
- compile byte-identity: **1909/1909 identical, 0 divergent**; SYMB: **1909/1909**
- boot gate: **30 passed / 0 failed**
- ROOT `cargo test -p endo --lib`: **111 passed / 0 failed** (the three deliver-path markers green)
- 0 rustc/build warnings; no new `unsafe`; `#![forbid(unsafe_code)]` roots intact; no new side table (reused `FuncInfo` fields); VARIANT_COUNT untouched. PR kept DRAFT.

**Skips added/removed:** none added; `Reflect.ownKeys` length/name/prototype-prepend remainder **removed** (graduated). Out-of-scope gaps observed but not touched (separate unbound-method/static findings, not reflection): `''.padStart` unbound; `Map.groupBy`/`RegExp.escape` statics unbound (constructor own-keys therefore agree only on the reflection prefix — tested via `.slice(0,3)`).

Synced past child 0 (`set_property_at`) before starting; caches seeded from the s42 pin cache (no s43 cache existed on this host — used the newest available, pin sha verified identical). No press was live to defer to.
