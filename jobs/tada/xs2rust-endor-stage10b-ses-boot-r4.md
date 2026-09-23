My commit `43de4567f6` is the origin tip of `xs2rust-endor`. Work is landed and verified. Writing the completion report.

---

## Completion report — stage-10b child 3/5: SES worker-bundle boot, gap round 4

**Branch/tip measured:** `endojs/endo-but-for-bots` PR #600, `xs2rust-endor`. Synced to the real remote tip **`0d1aef351f`** (the body's predicted `d197a95e34` had been superseded by the press + the cross-turn-functions job; I recorded the sha I measured). Pushed 1 commit; final tip **`43de4567f6`** (confirmed = `origin/xs2rust-endor`). PR kept DRAFT; no PR comments.

**r3 recovery:** stage-10b child 2 (`-ses-boot-r3`) **died leaving nothing recoverable** — not in the alive-doers list, no tada, its worktree clean at tip with no WIP, and no ses-boot commits on the branch past r2. I resumed from r2's reported halt and re-measured against the current tip (two engine commits had landed since r2: cross-turn functions + `native method objects chain to %Function.prototype%`), which had already **advanced the raw-bundle frontier** from r2's `Throw("call: not a function")` to `Unsupported("bind:non-user-function-receiver")`.

**Gap closed (1 commit, pushed): `bind`/`call`/`apply` on native & method receivers.**
The SES-boot bundle's `@endo/ses` `commons.js` builds `const uncurryThis = bind.bind(call)`. That drove endor's bound-function/`.call`/`.apply` machinery past its **user-function-only** floor on two fronts:
- `make_bound_function` rejected a native/method **target** (`bind:non-user-function-receiver`);
- `enter_call_dot_call`/`enter_call_dot_apply` rejected a native/method **receiver** (`call:non-user-function-receiver`).

Both now accept user, native, and native-prototype-method callees. All three trampolines reshape the frame to the direct form `[this, receiver, RESULT, FRAME, args…]` and hand off to one shared **`dispatch_reshaped_receiver`** seam: a value-producing native/method completes in place (resume at `ret_pc`), `.call`/`.apply` as the receiver recurse into their own trampoline, a native intrinsic produces its value in place, a user function enters a bytecode frame. This composes the `bind.bind(call)` chain (bound `FunctionBind`, then bound `FunctionCall`) **end to end**. Commit `43de4567f6`.

Along the way I caught and avoided a regression: over-tightening `make_bound_function` to reject *bound* targets broke a corpus case that binds an already-bound function at creation — restored to accept-at-creation / self-name-at-call (unchanged behavior), reverifying 1909/1909.

**Verification (all bars met, real-execution evidence):**
- Full workspace `cargo test --no-fail-fast` (after `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, c/moddable seeded at pin): **EXIT=0**, `acc_test2.log` — **48 `test result:` lines, every one `0 failed`; 703 passed** (was 695 at cut).
- `compile-diff` (no-arg = curated corpora + SYMB): **1909 identical / 0 divergent**, full accept/reject agreement; **SYMB 1909 identical / 0 divergent** (compiler untouched).
- Boot gate green: promoted **`boot_step_ses_bind_native_method_targets_agree`** (max.bind, hasOwnProperty.bind, the full `uncurryThis` idiom, apply-native) — all `assert_boots` result-agreement, oracle-validated in isolation. Boot-gate fn count now **24**.
- **Zero new Rust warnings** (endor crates; the moddable C-build warnings are pre-existing).
- `#![forbid(unsafe_code)]` intact at **8** engine crate roots.
- `c/moddable` clean at pin `23b4d6b0`, never staged. **No bundles committed** (`ses_boot.js` gitignored, 70009 bytes, sha `a90ccec`). **No new VM side table** — the existing `bound_functions` map is merely populated for more target kinds; GC/snapshot reach through the existing `BoundData`.
- **Doctrine:** result agreement gates; bound-creation/bound-call metering stays advisory (accuracy-over-parity). The metered single-shot path is untouched — the native-receiver arms are additive; the user-function path is byte-identical.

**Exact resume point for round 5 (precisely attributed):** the raw SES-boot bundle now advances two halts, to **`Unsupported("getOwnPropertyDescriptor:exotic-object")`**. I instrumented it: the receiver is an **error object** and the key is **`"stack"`** — i.e. `Object.getOwnPropertyDescriptor(errorObj, 'stack')`, SES's error-taming inspecting the `stack` own-property descriptor. This is a fresh subsystem (error-object own-property descriptors; error receivers are currently classified fully exotic for `getOwnPropertyDescriptor`). Round 5 resumes exactly there: teach `ObjectGetOwnPropertyDescriptor` (and likely `Reflect.getOwnPropertyDescriptor`, same guard) to read an error instance's `stack` (and other own) property descriptor, validated by an oracle-reaching `Object.getOwnPropertyDescriptor(new Error(), 'stack')` dual-run.

**Follow-ups (real gaps deferred, not blockers this round):**
- `getOwnPropertyDescriptor` on error/array/wrapper receivers (the immediate next halt above).
- Binding an already-bound function still self-names at *call* (`bind:bound-target-call`); the bundle does not need bound-of-bound calls.
- `.call`/`.apply` with a **primitive** `thisArg` still self-names (`call:primitive-this-boxing`) — the strict/sloppy receiver-boxing distinction, unneeded by the object-receiver uncurryThis chain.
- The composed prelude+bundle **single-eval** concatenation is malformed (`SyntaxError: invalid directive`); the daemon evaluates polyfills and boot as *separate* evals in one machine, so a faithful full-composition dual-run would need a multi-script harness. Not required for bundle-halt-order gap closure — each surface is validated by isolated oracle-reaching snippets (the r1/r2 method), which is what the boot-gate tests do.
