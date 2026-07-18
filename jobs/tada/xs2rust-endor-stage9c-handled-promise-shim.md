Working tree clean, commit pushed, `c/moddable` clean at pin and never staged. The job is complete for its scoped bar.

---

## Completion report — stage-9c child 5/9: the HandledPromise / eventual-send shim body boots on endor

**Repo/PR:** `endojs/endo-but-for-bots` PR #600, branch `xs2rust-endor` (kept draft, no comment). Synced to the real remote tip `85504f5297` (child 4 already landed; ahead of the sha in the job body). Pushed one commit **`85131468b1`**; local HEAD == `origin/xs2rust-endor`.

### Probe first (work-list, in dependency order)
Booting the inlined `@endo/eventual-send/shim.js` → `makeHandledPromise()` bundle on endor, it halted successively at:
1. `Throw("call: not a function")` — four unbound `Object.*` statics the shim's constructor plumbing calls.
2. `Unsupported("reset_local")` — the `for (const key of ownKeys(HandledPromise))` hardening loop's per-iteration binding opcode.

Both closed; the shim now installs `globalThis.HandledPromise`.

### What landed (all in `rust/engine/endor-vm/src/interp.rs`, safe code)
- **Four `Object.*` prototype/shape statics** (oracle-observable → dual-run gate): `getPrototypeOf`, `setPrototypeOf` (returns the object, throws-on-reject unlike the `Reflect` twin's boolean), `create` (the `create(null)`/1-arg shape), `defineProperties` (each own enumerable string-keyed data descriptor via the same new-own-data-property path as `defineProperty`). Transliterated from `xsObject.c`, reusing existing helpers.
- **`XS_CODE_RESET_LOCAL_1`/`_2`** (`fxResetLocal`/`fxScopeCodeReset`): the `let`/`const` per-iteration binding reset in `for (… of …)`; sets the slot to endor's existing `Kind::Uninitialized` TDZ marker. C body calls no `mxMeter`.

### Tests (30 new, all green)
- `object_prototype_statics.rs` (13, dual-run result-agreement)
- `for_of_iteration_binding.rs` (9, dual-run, incl. per-iteration closure capture)
- `handled_promise_shim.rs` (8, endor-side over an inlined bundle fixture): install under guard + idempotent; the four statics + send-only siblings exist as frozen functions with arity 2/2/3/1; constructor inherits from Promise.

### Verification (all observed, captured to files, `$?` checked)
- `cargo test -p endor-vm` (88) + `-p endor-262` (all files) **EXIT=0**, every `test result:` line **0 failed**.
- Curated compile-diff **1878 identical**, 0 divergent + SYMB **1878 identical**, 0 divergent (compiler untouched).
- Boot gate **green** (17 passed); module_corpora **47 identical**.
- **Zero new Rust warnings** (346 warnings are all pre-existing `endor-oracle@` C warnings).
- `#![forbid(unsafe_code)]` intact at all **8** engine crate roots (`endor-oracle` is the audited FFI seam); my only source change is safe code in `interp.rs`.
- `c/moddable` clean at pin `23b4d6b0a65f`, unstaged, never `git add`ed; no committed bundles.

### Honest remainder (named for child 8/9 — worker-surface / live delivery)
- **Message delivery round-trip.** *Invoking* a static drives the full eventual-send machinery: `new HandledPromise(executor)` bottoms into `Reflect.construct(Promise, [superExecutor], new.target)` — a **Promise-subclass construct with a retargeted `new.target`** (a documented deferred trampoline: `Reflect.construct:non-constructor`/`newtarget-retarget`) — plus `harden` over the internal argument arrays (`harden:exotic-object`) and a **drained microtask queue**. Out of this child's scope.
- **New finding — `.prototype` reads return `undefined` on endor.** Reading a function's `.prototype` own property (intrinsic or user) yields `undefined` — a pre-existing function-object modeling gap (same family as `ownKeys(fn)` missing `length`/`name`/`prototype`). The shim install tolerates it (`baseHandledPromise.prototype = Promise.prototype` sets the slot, just not property-readable). **This is a prerequisite for child 8's `isSafePromise`** (`getPrototypeOf(p) === Promise.prototype`), which is currently vacuously false because `Promise.prototype` reads `undefined`; likely worth its own small child before/with child 8. My gates anchor prototype identity on real objects rather than `.prototype` reads.

No new VM side table introduced (the WeakMap handler tables the shim uses were already implemented; the shim install exercises them only structurally).
