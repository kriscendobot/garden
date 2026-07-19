Both findings are fixed, verified bit-exact against the C-XS oracle, and pushed as two separate gated commits. Inbox is empty. Here is my completion report.

---

## Completion report — F1(s40) + F2(s40), PR #600 (stage 10j)

**Both findings fixed, bit-exact vs the C-XS oracle, landed as two separate pushes to `origin/xs2rust-endor` (PR #600 stays DRAFT — only branch pushes, PR state untouched).**

### Setup
- Isolated worktree keyed by this base; synced to remote tip `afff3aaf6` (== FETCH_HEAD).
- Seeded `rust/engine/target/` (`cp -al`) and `c/moddable` (pin `23b4d6b0…`, clean) from sibling `…stage10i-accessor-fixer`; `cargo clean -p endor-compile -p endor-vm -p endor-oracle`.
- Real bundles seeded into `rust/endo/xsnap/src/` from the same sibling after verifying bundle-input identity (only `rust/endo/src/rust_worker.rs` differs between the two commits — not a bundle input; `polyfills.js`/`host_aliases.js` byte-identical). Bundles gitignored, never committed. (The spec's `/home/kris/garden/tmp/s9r/…` seed path did not exist on this instance.)

### Reproduce-first finding
Dual-run probes showed **metering already agreed for every shape** — the divergence was purely semantic (enumerability / `.name`). So the fix stamps flags and names functions **without touching the meter**; only the pre-existing generator-method rename keeps its metered `+2`.

### F1 — `XS_DONT_ENUM` dropped on class DATA methods (push `6d7ee44a8`)
Transliterated `fxOrdinaryDefineOwnProperty`'s `XS_GET_ONLY` handling: after the data `instance_put`, `define_apply_attributes` stamps `define_byte & (XS_DONT_DELETE|XS_DONT_ENUM|XS_DONT_SET)` onto the fresh property. Wired into both `NEW_PROPERTY` and `NEW_PROPERTY_AT`. Class methods (prototype + `static`) become non-enumerable; object-literal members carry none and stay enumerable; writable/configurable unchanged. Test `endor-262/tests/class_method_dont_enum.rs` (8 tests).

### F2 — inferred `.name` dropped (push `9f299a6c0`)
Transliterated `fxRenameFunction`/`fxNewFunctionName`: the data-path tail names an anonymous function value/concise method to the bare key; the accessor path (`instance_define_accessor`) names get/set to `"get "`/`"set "` + key (xsType.c). Key resolves via the shared `key_id_name` (program symbol OR runtime-interned computed key). Named function expressions and Symbol keys are left untouched. Generators keep their existing dedicated (metered) rename; F2 skips them to avoid a double rename. Test `endor-262/tests/define_inferred_name.rs` (8 tests).

### No-boot-regression gate — run at BOTH pushes, all EXIT=0
- Engine workspace `cargo test --workspace -- --test-threads=1`: **EXIT=0**, all `test result: ok`.
- `compile-diff`: **1909/1909 identical, divergent=0**; **SYMB 1909/1909 identical**, EXIT=0.
- ROOT `cargo test -p endo --lib` with real bundles: **110 passed / 0 failed** (the "30/0" boot subset has grown to 110).
- Full-boot marker `boot_drives_the_real_chain_to_the_worker_bundle_frontier`: **GREEN** (`halted_at==None && handle_command_registered==true`) — SES lockdown unaffected by the enumerability change.
- Zero new warnings; no new `unsafe` (`#![forbid(unsafe_code)]` intact); no new side table (VARIANT_COUNT unchanged at 35).

### Sweep (define-flag-byte consumer re-enumeration)
The **dropped-flag-consumer set is now empty** for result semantics: DONT_ENUM on prototype/`static`/generator/async/computed methods, and inferred `.name` on data values / concise methods / accessors / computed keys / class+static methods, all agree with the oracle (result **and** computrons). **One orthogonal pre-existing metering nuance remains** (advisory, NOT a dropped flag): `getOwnPropertyDescriptor` reflecting a **runtime-interned (computed) key** off a **class prototype/constructor** carries **+1 computron** — the *result* is correct and the define + `Object.keys` are bit-exact, so this is a pre-existing gopd-reflection metering issue *exposed* (not caused) by the now-correct enumerable result. Handled honestly via result-agreement in the F1 test (the stage-10i precedent for `C.prototype` descriptor reflection); worth a future increment if a stage targets computed-key gopd metering.

### Follow-ups
- Optional: close the computed-key-gopd-off-class-prototype +1-computron metering nuance noted above.
- Symbol-keyed method/accessor names (`{[Symbol.iterator](){}}` → `"[Symbol.iterator]"`) remain anonymous (endor does not yet model the `[desc]` adornment) — a deliberate honest skip, pre-existing, out of the s40 findings.
