My commit `c0bf422ed1` is preserved in the shared branch history (a peer built on top of it). The foundational with model is landed. Everything within scope is done. Let me write the honest completion report.

I've completed the foundational `with`-statement environment-chain model and pushed it, but the strict acceptance bar (subtree *fully* covered with exact metering, zero aborts/gaps) is **not** met — blocked by pre-existing, out-of-scope general-engine metering bugs and deeper edges. Per the job's instruction to signal orchestration failure honestly rather than paper over, I'll report both.

<<<GARDEN-ORCHESTRATION-FAILED>>>

---

## Completion report: `ironhorse-js-26-cb-with-env-core` (with-cluster child A, FOUNDATIONAL)

### What I delivered (committed + pushed, preserved in the shared branch)

Implemented the XS **environment-chain model** and **real `with (expression) statement` execution** in `ironhorse-vm/src/interp.rs`:

- **Per-frame `mxEnvironment` register + chain.** Each `XS_CODE_WITH` allocates a real 2-slot environment instance (`new_environment_instance`, mirroring `fxNewEnvironmentInstance`): an exotic instance head chaining (prototype) to the prior head + a behavior slot holding the `with` value. It leaves the env-instance reference on the stack (for the compiled `POP` / a later child-B `STORE`) and sets the head. `XS_CODE_WITHOUT` pops to the prototype. The head is **saved/restored across every frame boundary** (enter/leave_call, generator suspend/resume, throw-unwind via `CatchJump`) exactly as XS resets `mxEnvironment` at frame setup.
- **Object-environment walk** in `EVAL_REFERENCE`/`PROGRAM_REFERENCE` via `fxIsScopableSlot` (HasProperty + `@@unscopables` blocklist). `GET_VARIABLE`/`GET_THIS_VARIABLE`/`SET_VARIABLE` resolve against the object the reference op selected, falling through to `resolve_get`/`resolve_set` when the chain doesn't bind the name.
- **Function-capture-of-`with`**: a function defined inside a `with` chains its closure environment to the active head; `enter_call` reinstalls it so free names resolve through the enclosing `with`. `resolve_get`/`resolve_set` now dereference a `Kind::Closure` local reached by name through the with/eval path.
- **Empty-chain path is byte-identical** (metering + behavior) to the pre-`with` engine — the chain is consulted only when a with/eval environment is active.
- **Metering calibrated exactly** against the pinned XS oracle: WITH env-setup (`2×BUILTIN`), the EVAL_REFERENCE scopable HasProperty walk (`1<<16` + per-prototype recursion), and the `@@unscopables` gets (`1<<16`, blocklist `1<<15`).
- **Tests**: `rust/engine/ironhorse-262/tests/with_statement.rs` — 12 **bit-exact** (value+computron) differential regressions (read/write, `@@unscopables` truthy/falsey/non-object, shadowing, outer-scope fallthrough, nested with, function-in-with capture, env-instance metering). All pass.

### Slice results (`language/statements/with`, 181 files)

| | baseline | after |
|---|---|---|
| value-covered | 20 | **141** |
| fully covered (value **+** computron) | 20 | **~53** |
| computron-gap (value-correct, meter off) | — | 88 |
| ironhorse-aborted | — | 10 |
| out-of-scope skips (eval 17, Function 3, primitive-box 3, callback 5, abort-value-differs 2) | | 30 |

The entire `unsupported-opcode:with` cluster (140 cases) is gone; every one now executes for real and agrees on **value**.

### Gates run before push

- `cargo test --workspace --release`: **green** (57 test binaries, incl. `corpus_conversion_equivalence` = `--gate-meter-exact` over `cases/**` — no `cases/**` regression, no baseline-covered regression).
- Focused `with_statement` tests: **12/12** bit-exact.
- Affected official slice run against the pinned XS oracle (numbers above).
- Pins: engine `b3c3ae93b8`, test262 `be13516fb6`, Moddable XS `23b4d6b0a6`.
- Head SHA: `c0bf422ed1` (now an ancestor of the shared head `3afd793924`). PR: https://github.com/endojs/endo-but-for-bots/pull/970 (kept OPEN + DRAFT).

### Why the acceptance bar is NOT fully met (honest)

Full computron-coverage is blocked by **pre-existing, general-engine metering bugs that are not part of the `with` feature** (each verified on the pristine baseline, reproducing with no `with`):

1. **Anonymous function-expression object-literal property value** (`{f:function(){}}`) under-meters by exactly `1<<15`. The clean-looking fix (charge the `NEW_PROPERTY` name-inference rename) **regresses** the `stage4-async-promises` `cases/**` fixtures (`Promise.resolve({then:function(){}})`), so I **reverted it** to honor the regression invariant — the elaborate `S12.10_A1.*` fixtures (objects full of `name:function(){}` methods) inherit this gap.
2. **`TO_INSTANCE`-throws-`TypeError`** (`with(undefined)`/`with(null)`) over-meters by `+97704` — identical gap in `var {x}=undefined` destructuring.
3. **Intrinsic-named property creation** (`{parseInt:1}`) over-meters ~`+280` each.

The 10 aborts are deeper / child-B edges: `@@unscopables` **getter** (needs getter-running through the scopable walk with recalibration), **proxy-in-`with`** (has-trap), and **closure-var-through-`with`-in-a-function** (the eval-prelude declarative/closure environments — the `mxBehaviorHasProperty` on the env instance branch, which the job scopes to child B's STORE/closure-env work).

Fixing these to reach "fully covered, zero gaps, zero aborts" requires fixing multiple pre-existing engine metering bugs (broad blast radius; one proven to regress) plus child-B closure-env resolution — beyond this child's clean scope. I reverted rather than paper over, delivered the foundational model correct and regression-free (which every sibling depends on and can build on), and am flagging the coverage gate as unmet.

### Follow-ups for the orchestrator/siblings

- Child B (STORE targeting the env / closure-env resolution) will complete the function-scoped / closure-var withs.
- A separate metering-calibration pass on the pre-existing bugs (#1–#3 above) is needed to close the `S12.10_A1.*`/`A3.*` computron gaps — should be its own job with full-suite regression coverage (the `#1` fix regressed async-promises).
- `@@unscopables` getter + proxy-in-`with` support for the 10 aborts.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-cb-with-env-core.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 526 tokens (77821356 cached reads)
- Output: 295098 tokens
- Cost: $51.314326
- Wall-clock: 4359s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
