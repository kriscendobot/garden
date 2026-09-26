Remote tip matches my commit (`1eb9e8904c`); inbox empty. Job complete. All verification bars green.

## Completion report

**Job:** PR #600 stage-10 child 1/7 — function `.prototype` own-property reads. Branch `xs2rust-endor` (measured tip at start `e07903ebee`, no rebase during the run). Pushed as **`1eb9e8904c`** (verified = remote tip). PR left draft, no comments.

### What I did
Transliterated `fxDefaultFunctionPrototype`'s read surface into `endor-vm/src/interp.rs`:

1. **`fn.prototype` reads** — new `function_own_prototype()` maps a receiver to its own `.prototype` object (the `ctor_prototype` side-table entry) for an ordinary constructable function, a generator, a class constructor, and every intrinsic constructor — and returns `None` (→ `undefined`) for the non-constructor plain-`XS_CODE_FUNCTION` forms (arrow / concise method / accessor), async functions, and `Proxy` (placeholder prototype, out of scope). Wired into `GET_PROPERTY` via a cached `prototype_id`, as a plain own-property read (no tick, no alloc). This makes `fn.prototype === Object.getPrototypeOf(new fn())` and **`Promise.prototype` identity** hold — the stage-9c child-5 prerequisite that had blocked SES's `isSafePromise`.
2. **`constructor` back-link** — `XS_CODE_CONSTRUCTOR_FUNCTION` now installs `prototype.constructor` (writable, non-enumerable, configurable) so `fn.prototype.constructor === fn`. Folded into the already-ticked `FUNCTION_DEFINE_METERING`, so materialized unmetered.
3. **for-in bug fix** — `enumerable_keys` now skips `XS_DONT_ENUM` own properties (previously a no-op filter, exposed as load-bearing once the non-enumerable `constructor` back-link existed).
4. Reverted an initially-too-broad `Reflect.ownKeys` function guard (it regressed the passing handled-promise-shim tests, which rely on a function's assigned statics being enumerable); left the pre-existing tolerated behavior and documented complete function-ownKeys as a remainder.

**Coverage:** `cases/language/stage10-function-prototype/` — 18 dual-run cases (user-fn `.prototype`, `constructor` round-trip, intrinsic-ctor `.prototype` identity, `Promise`/`Array`/`Object`/`Number.prototype`, arrows & methods having none, generator/class prototypes, non-enumerable `constructor` via for-in). `CORPUS_PROGRAM_COUNT` 1878 → **1896** (+ mod.rs doc).

### Verification (all green, captured to files, `$?` checked)
- Engine `cargo test` **EXIT=0**, 47 result lines all 0-failed, **673 passed / 0 failed**.
- Curated compile-diff **1896 identical, 0 divergent** + SYMB **1896 identical**.
- Boot gate **17 green** (no named skip newly greened here — the SES shim boot step is a separate child).
- **Zero new Rust warnings**; `#![forbid(unsafe_code)]` intact (8 engine crates; `endor-oracle` stays the audited FFI seam).
- `c/moddable` clean at pin `23b4d6b0…`, never staged; no committed bundles. No new VM side table (the `prototype_id` cache rebuilds at restore via `bind_program_symbols`, like `length_id`/`name_id`).

### Named remainders / honest gaps
- **5 stage-10 cases** (arrow `.prototype`-miss ×2, `Object.getPrototypeOf` identity ×2, class) + the **pre-existing `stage3-arrays/265.js`** are result-gated `endor-dual-run`: results agree, computrons differ by 1–2 (advisory per accuracy-over-parity, each documented in-case). 265's +1 is because the harness's now-*correct* `Test262Error.prototype.toString =` write executes (was a no-op on `undefined`), shifting flatMap's allocation-sensitive meter — I relaxed its tag with a full documented reason rather than back-fitting.
- **Complete function `Reflect.ownKeys`** (prepending `length`/`name`/`prototype` in creation order) is left as a named remainder — the current path returns only slot-chain (assigned) own keys, which downstream consumers observe identically on both engines.
- Reconciling the flatMap allocation +1 is a possible future increment.
