Pushed to `origin/xs2rust-endor` at `57270f3060` (fast-forward, no race). All gates were run on this exact tree. Done.

## Completion report

**Job:** stage-10k child 0 — F1(s41) accessor→data method-redefine leaves a stale getter (PR #600, endojs/endo-but-for-bots, branch `xs2rust-endor`).

**Reproduced first (at the real remote tip `42e4fcdf8e`):** every accessor→data-method redefine wrong-completed exactly as the finding described — `Throw("call: not a function")` on the read (the stale getter ran → `1`, then `1()` threw), where the C-XS oracle returns the data method's value. Confirmed via dual-run for the literal, class-body, computed-key, set-only, get+set, and data→accessor→data shapes; `getOwnPropertyDescriptor` already reported the DATA shape (internally inconsistent slot).

**Root cause:** `instance_put`'s found-property branch (`interp.rs`) overwrote the slot's `kind`/`value` but left the `XS_GETTER_FLAG`/`XS_SETTER_FLAG` marker and holder linkage intact, so the read path treated the fresh data value as an accessor holder.

**Fix (5-line change + comment):** transliterated XS's `fxOrdinaryDefineOwnProperty` data-over-accessor transition — the reverse of `instance_define_accessor`. `instance_put` now masks off the accessor markers (`s.flag &= !(XS_GETTER_FLAG | XS_SETTER_FLAG)`) before writing the data value, leaving a coherent data slot. Verified the assignment/`[[Set]]`/Reflect.set/proxy.set paths all intercept accessors via `accessor_in_chain` and invoke the setter *before* reaching `instance_put`, so an accessor slot there is always a define-time redefine — the fix is scoped correctly and is metering-neutral (a flag mask ticks nothing).

**Redefine sweep answer — the stale-accessor-redefine (wrong-completion) set is now EMPTY.** All accessor→data defines that previously ran a stale getter/setter now agree bit-exact with the oracle: literal + class bodies, plain method + generator + async method values, string-computed (`NEW_PROPERTY_AT`) + symbol keys, set-only→data, get+set→data, three-way merge, sandwich, and data→accessor→data round trips. The only remaining accessor→data divergences are pre-existing, orthogonal **honest self-named skips** (not wrong completions): `Object.defineProperty` redefine → `Unsupported("defineProperty:redefine")` (a general defineProperty-redefine gap, not accessor-specific) and numeric-index accessor → `Unsupported("define-accessor-at-index")` (self-names even on a bare `get 5(){}` define). Neither is regressed. The redefine-reflection +1 advisory family was not chased and not regressed (gopd-after-redefine tests are result-only).

**Suite committed:** `rust/engine/endor-262/tests/accessor_data_redefine.rs` — 10 dual-run tests (both record shapes + fresh variants), all green.

**BINDING no-boot-regression gates at my tip (`57270f3060`), all run + observed:**
- Engine workspace `cargo test --workspace -- --test-threads=1`: **EXIT=0, 904/0, 71 result lines** (was 894/0/70; the delta is exactly my +10 tests / +1 result-line new file — no boot regression).
- compile-diff no-arg: **1909/1909 identical + SYMB 1909/1909**, EXIT=0.
- ROOT `cargo test -p endo --lib` with real bundles: **111/0**, EXIT=0, **both markers GREEN** (`boot_drives_the_real_chain_to_the_worker_bundle_frontier` + `real_handler_decodes_a_real_envelope_to_the_dispatch_path_frontier`).
- 0 non-oracle warnings; no new `unsafe`; no new side table (only a flag mask + test file); VARIANT_COUNT unchanged.

Ran `cargo clean -p endor-compile -p endor-vm -p endor-oracle` before the acceptance-grade runs. Seeded the build cache (`rust/engine/target`, `c/moddable` @ oracle pin `23b4d6b0a65f`, real bundles) via `cp -al` from the local exact-tip sibling `project-wt-xs2rust-endor-stage10j-live-captp-dispatch` (the named garden2 sibling was on a different host and unavailable here).

**Push:** single push-per-item to `origin/xs2rust-endor`, sha **`57270f3060`** (fast-forward from `42e4fcdf8e`, verified by git exit code + matching remote tip; no rebase-CAS race). PR #600 left DRAFT and untouched.

**Follow-ups:** none required for this finding. The two remaining accessor→data honest-skips (`defineProperty:redefine`, `define-accessor-at-index`) are pre-existing gaps in orthogonal features (reflective defineProperty redefine; numeric-index accessors) — candidates for future stages, not regressions.
