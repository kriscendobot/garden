All gates green, both items pushed, inbox empty. The job is complete.

## Completion report

**Job:** stage-10l child 0 — fix the two s42 reflection findings on `endojs/endo-but-for-bots` PR #600, branch `xs2rust-endor`.

**Setup:** Isolated worktree keyed by job base; verified the real remote tip was `c34ffd9012` (s42 acceptance) via a real fetch. The old `/home/kris/garden` cache path is gone, so I seeded from the garden2 sibling `stage10k-live-captp-dispatch` — `cp -al` of `c/moddable` (pin `23b4d6b0…`, verified), the engine `target/`, and copied the 3 built bundle JS files. Reproduced BOTH findings at the real tip before touching code.

**Item (0) — F1: `Object.getOwnPropertyNames` was UNBOUND** (commit `37b6eeb33`, pushed).
- Repro: `typeof Object.getOwnPropertyNames` → endor `"undefined"` vs oracle `"function"`; any call self-threw `"call: not a function"`.
- Fix: added the `ObjectGetOwnPropertyNames` `NativeMethod`, registered it on the `Object` constructor, and implemented it reusing the own-keys machinery. New helper `own_all_string_name_ids` (the accessor-tolerant sibling of `own_all_string_ids` — lists an accessor property's NAME without invoking the getter); exotic arrays route through `get_own_property_names_array` (indices + `length` + named). Enumerable AND non-enumerable, symbols excluded, oracle-exact order.
- Coverage (new test file `object_get_own_property_names.rs`, 7 tests): plain/method/accessor objects, non-enumerables included (vs `Object.keys` dropping them), symbols excluded, exotic arrays, key order — all `BothComplete + result_agrees`.

**Item (1) — F2: `Reflect.get` over an accessor leaked the internal HOLDER** (commit `1481757f7`, pushed).
- Repro: `var t={get a(){return 7;}};typeof Reflect.get(t,'a')` → endor `"object"` (holder leak) vs oracle `"number"` (7) — a wrong completion + encapsulation leak.
- Fix: routed `Reflect.get` through the same accessor-dispatching read as ordinary `o.a` (`accessor_in_chain` → `accessor_getter` → `run_reentrant_call`), including proto-chain accessors. Getter runs with `this = receiver` (2-arg defaults to target; **3-arg receiver form implemented** since the read path threads the `this`). Set-only → `undefined`; data path unchanged via `instance_get`. A throwing getter escapes behind the jump barrier — added `ReflectGet` to the native-call dispatch's scoped throw-reroute (alongside `ReflectApply`/`ReflectConstruct`) so a surrounding `try`/`catch` catches it.
- **Holder-leak sweep (tada answer): the set is now EMPTY for `Reflect.get`.** `Reflect.getOwnPropertyDescriptor` still self-names on an accessor (honest skip, per ledger); `Object.getOwnPropertyDescriptor` returns the getter FUNCTION (not the holder); `Object.values`/`entries`/`assign` and object spread all honest-skip an accessor. No other reflective read hands the holder to the guest.
- Coverage (+6 tests in `reflect_intrinsic.rs`): getter→primitive, getter reading `this`, set-only→undefined, data path unregressed, proto-chain accessor, 3-arg receiver, throwing getter caught/uncaught.

**No-boot-regression bars at final tip `1481757f7` (all by exit code):**
- Engine workspace `cargo test --workspace -- --test-threads=1` — **EXIT=0, 0 failed, 923 passed** (grew only by my 13 new tests: 7 gOPN + 6 Reflect.get; `reflect_intrinsic` 29→35).
- compile-diff no-arg **1909/1909** + SYMB **1909/1909** (both BAR MET, EXIT=0).
- boot gate **30/0**.
- ROOT `cargo test -p endo --lib` **111/0**, both markers GREEN (`boot_drives_the_real_chain_to_the_worker_bundle_frontier`, `real_handler_decodes_a_real_envelope_to_the_dispatch_path_frontier`).
- **0 non-oracle warnings** in the changed crates; **no new `unsafe`**; **no new side table** (reused existing machinery). Acceptance-grade: ran `cargo clean -p endor-compile -p endor-vm -p endor-oracle` first, oracle at pin `23b4d6b0…`.

**Follow-ups (named honest skips, not regressions):** `Object.getOwnPropertySymbols` (the symbol half of gOPN); `Reflect.getOwnPropertyDescriptor` over an accessor remains an honest self-name per ledger; `Object.values`/`entries`/`assign`/spread over accessors remain honest skips (getter-invoking copy paths are a separate increment).
