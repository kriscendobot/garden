All work verified and pushed; working tree clean, bundle uncommitted, `c/moddable` at pin, inbox empty.

## Completion report — stage-10b child 2/5: SES worker-bundle boot, composed-boot gap round 3

**Branch/tip measured:** `endojs/endo-but-for-bots` PR #600, `xs2rust-endor`. Synced to the real remote tip **`e8db14a179`** (past r2's `d197a95e34` — the press had advanced the branch). Pushed 1 commit; final tip **`0d1aef351f`**. PR kept DRAFT; no PR comments.

**1. Composed the boot environment.** The r2 raw bundle halted the C-XS oracle at `ReferenceError: get assert: undefined variable` (host-provided globals absent). I established that the daemon's `run_xs_program` evaluates `polyfills.js` → SES-boot as **separate programs in one realm**, and that a naïve single-source concatenation of the real `polyfills.js` + bundle is rejected by BOTH the oracle and `endor-compile` with `SyntaxError: invalid directive` — XS's `mxNotSimpleParametersFlag` (from the shim's `...subs` rest params) leaks across sibling functions in one script, an XS-family parser quirk the daemon sidesteps with separate evals. I therefore composed a **parse-clean assert prelude** (rest-param-free, functionally the `polyfills.js` assert shim) prepended to the bundle, which boots the oracle past its assert ceiling and drives the composed program symmetrically through the `dual_run` harness.

**2. Attributed the `call: not a function` throw.** Under the composed environment endor still halted at `Throw("call: not a function")`. Temporary VM instrumentation (callee/receiver dump + a property-name ring, all removed before commit) pinned it to `@endo/ses` `commons.js` line 379: `const uncurryThis = bind.bind(bind.call)`. The callee resolved to **`undefined`**, and the exact defect is `Object.getPrototypeOf(Function.prototype.bind)` returning a NULL-proto placeholder on endor where the oracle returns `%Function.prototype%` — endor's `alloc_method` minted every native prototype-method instance with a NULL prototype (the retired "only ever dispatched, never re-inspected" assumption), so reading `.bind`/`.call` **as values** off a native method read `undefined`.

**3. Gap closed (1 commit, pushed).**

| Halt signature | Fix | Commit |
|---|---|---|
| `Throw("call: not a function")` @ `bind.bind(bind.call)` | Native prototype-method instances now chain to `%Function.prototype%` (`alloc_method`), exactly as user functions do, so `.call`/`.bind`/`.apply`/`.toString` resolve up the chain on the method *value* and the `Object.getPrototypeOf` identity agrees. No new side table — an ordinary `Slot::instance` prototype `Reference` edge GC/snapshot already traverse; `function_proto` is set before every `alloc_method` call. | `0d1aef351f` |

**Exact resume point for round 4:** the composed bundle now halts at **`Unsupported("bind:non-user-function-receiver")`** (`interp.rs:12572`, `make_bound_function`) — still on `bind.bind(bind.call)`, now one step deeper: SES's `uncurryThis` **binds `Function.prototype.bind` itself** (a native method) with `this = Function.prototype.call`. Closing it needs `make_bound_function` to accept a native/method/bound target AND the `enter_call_bound` trampoline to route native targets through native dispatch (`call_native`/`call_native_method`) — a re-entrant native-bind chain (`uncurryThis(fn)` ⇒ `Function.prototype.call.bind(fn)`), the flagged splittable subsystem. Ground truth is available in isolation without full composition: `dual_run("var {bind}=Function.prototype; typeof bind.bind(bind.call)")` completes on the oracle (`"function"`). Completion was not expected this round; four+ native-bind steps stand between here and `lockdown()`.

**Verification (all bars met):**
- Full engine-workspace `cargo test --workspace --no-fail-fast` after `cargo clean -p endor-compile -p endor-vm -p endor-oracle`: **EXIT=0**, captured to `/tmp/acc_test.log` — **48 `test result:` lines, every one `0 failed`; 701 passed** (≥ 695 baseline).
- `compile-diff` (no-arg): **1909 identical / 0 divergent**, full accept/reject agreement; **SYMB 1909 identical / 0 divergent** (compiler untouched).
- Boot gate: **22 → 23** (`boot_step_ses_native_method_function_prototype_agrees`, 11 `assert_boots` result-agreement forms: the `getPrototypeOf` identities + reading `call`/`bind`/`apply`/`toString` as values off native method objects, incl. the `commons.js` destructure shape).
- **Zero new Rust warnings** (the 346 are pre-existing moddable C-build warnings from the endor-oracle FFI seam).
- `#![forbid(unsafe_code)]` intact at **8** engine crate roots.
- `c/moddable` clean at pin `23b4d6b0`, never staged. **No bundles committed** (`ses_boot.js` gitignored). No new VM side table.

**Doctrine note:** result agreement gates every promoted form (accuracy-over-parity); the metered single-shot path was untouched (compile-diff + SYMB byte-identity and full-suite computron agreement confirm it). The change is a prototype-edge correction, invisible to the compiler.

**Follow-ups:** round 4 lands the native-bind subsystem (`bind:non-user-function-receiver` → native target support in `make_bound_function`/`enter_call_bound`), then re-drives. A more faithful composed prelude (or a separate-program shared-realm harness on the oracle FFI seam) will be needed once endor boots past the oracle's simplified-prelude `TypeError: cannot coerce object to string` artifact, but is not required for the isolated native-bind forms, which dual-run with ground truth today.
