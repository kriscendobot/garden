The job is complete for the coherent prefix that converts the boot-gate skip. Here is my honest completion report.

---

## Completion report — Stage-9b child 2/5: HandledPromise / eventual-send surface

**Repo/PR:** `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` — kept DRAFT, no PR comment. Pushed commit `1cfaa93a5a` (verified: remote tip == my HEAD, push exit 0).

### What I did

**Honest scoping first (read the actual consumer).** Traced the boot bundle: `bus-worker-xs-ses-boot.js` → `@endo/eventual-send/shim.js`, whose install condition is `if (typeof globalThis.HandledPromise === 'undefined') globalThis.HandledPromise = makeHandledPromise()`. The oracle (`mxLockdown`, no shim bundle — a `.gitignore`d `makeBundle` artifact) never runs the shim body, so the only dual-runnable fact this boot gate measures is the shim's **guard expression**: the pre-shim `typeof HandledPromise === 'undefined'`.

Probing the engine, I found the real gap the skip named: **`typeof <unresolvable reference>` threw a ReferenceError** ("get N: undefined variable") instead of yielding `"undefined"` — the one reference-resolution path ES exempts from throwing.

**Slice landed (engine correctness fix + boot-gate conversion):**
- `endor-vm/src/interp.rs`: `XS_CODE_GET_VARIABLE`/`GET_THIS_VARIABLE` now mirror `xsRun.c`'s next-opcode peek — an unresolved name suppresses the throw and leaves the stack top `undefined` when the following opcode is `XS_CODE_TYPEOF` (peeking `code[pc+ilen]`, reproducing the `EVAL_REFERENCE GET_VARIABLE TYPEOF` shape the compiler emits). Annotated against the exact XS source (`if (byte != XS_CODE_TYPEOF)`).
- `endor-262/tests/boot_bundle_gate.rs`: converted `skip_ses_boot_handled_promise_shim_absent` → green `boot_step_pre_shim_handled_promise_absence_agrees` (`typeof HandledPromise` and `=== 'undefined'` now BothComplete + agree). Removed the now-unused `assert_named_skip_throws` helper (kept warnings at zero). Doc comment states the precise residual.
- New `endor-262/tests/typeof_unresolvable.rs`: dedicated regression gate — unresolvable-global yields `"undefined"` (agrees), resolvable names unchanged, and a plain (non-`typeof`) unresolvable read **still** throws (BothAbort).

### Verification bar (all met)
- Fresh `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, then `cargo test --workspace`: **TEST_EXIT=0**, 36 `test result: ok` lines, **0 failed total**.
- Curated compile-diff all-identical + **SYMB**: `corpora_byte_identity_no_undocumented_divergence`, `module_corpora_byte_identity_no_divergence`, `corpora_symbols_atom_byte_identity` all green (my change is VM-only; compiler bytecode untouched).
- Boot gate green (conversion included).
- **Zero new Rust warnings** (clean build; only pre-existing endor-oracle C `cc` warnings remain).
- `forbid(unsafe_code)` intact at all **7** roots; my edit adds no unsafe.
- Diff scope: only `rust/`; `c/moddable` untouched/unstaged.

### Precise remainder (for re-dispatch — the async/eventual-send stage)
The HandledPromise **shim body** — `makeHandledPromise()` installing the constructor + `resolve`/`applyFunction`/`applyMethod`/`get` static methods + WeakMap-backed handler side table + the four eventual-send ops — is a self-contained subsystem that is **not oracle-observable through this boot gate** (the oracle never runs the shim), so its surface is shim-defined and must be verified by endor-side unit tests in the eventual-send stage, not by dual-run here. Probing surfaced the concrete engine prerequisites it will need, none yet present:
- `Object.is` — unbound ("call: not a function"); `handled-promise.js` uses it (`objectIs`).
- `Reflect.apply` / `Reflect.construct` — halt `Unsupported("Reflect.apply:reentrant-trampoline")` (re-entrant host trampoline).
- `String.prototype.replace` `$1` dollar-substitution — `Unsupported("String.replace:dollar-substitution")`; `SEND_ONLY_RE` uses it.
- Proxy get-trap dispatch — `new Proxy({},{}).x` still halts.
- (Separately noticed, not shim-related) `typeof Proxy` returns `"undefined"` on endor vs `"function"` on oracle — the `Proxy` intrinsic isn't bound as a readable global value; pre-existing gap, no test asserts agreement on it, so not a regression from this change.

These are the coherent next slices; I did not rush an unsound partial shim.
