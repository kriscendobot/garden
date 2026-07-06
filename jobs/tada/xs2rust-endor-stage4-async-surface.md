Everything is landed and pushed. The `M c/moddable` and `?? rust/engine/c/` entries are just the local oracle-build submodule populations (build artifacts, correctly left uncommitted). All four commits are on `origin/xs2rust-endor`, with HEAD matching.

## Completion report

**Job:** stage-4b child 2/5 — the async-function surface (from `ASYNC-AWAIT-HANDOFF.md`). **Status: LANDED**, bit-exact, pushed to `origin/xs2rust-endor` (PR #600, kept DRAFT).

### What I did
Implemented the folded async-function surface over the promise keystone, executing directly from the handoff map, bit-exact (result **and** computron) against the C-XS oracle pin `48ee02d8cfe0`:

- **`XS_CODE_ASYNC_FUNCTION`** — `new_async_function` re-chains the instance `[[Prototype]]` to a new `%AsyncFunction.prototype%` intrinsic (no own `.prototype`; calibrated `ASYNC_FUNCTION_DEFINE_DELTA` backs out the constructor-prototype allocation).
- **`XS_CODE_START_ASYNC`** — `new_async_instance` clones the frame like `new_generator_instance`, builds the result promise via `new_promise_instance` + `make_resolving_functions`, runs `step_async` synchronously to the first await/completion, returns the result promise (START_GENERATOR boundary split).
- **`XS_CODE_AWAIT`** — YIELD-shaped suspend reading a new `async_run_stack` → `Halt::Await`; per-suspend metering reuses `GENERATOR_YIELD_METERING`.
- **`BRANCH_STATUS`** — extended to honor a threaded `resume_status` (fulfilled → branch by offset; rejected → `THROW_STATUS` unwind). Generators unchanged (they only resume `NoStatus`).
- **`step_async`** modeled on `resume_generator`; **`await_schedule`** native-promise fast path + general path, both bit-exact.
- **The 5-slot native-reaction path** (`PromiseReaction.kind = AsyncAwait(inst)`, `promise_then_native`, `run_promise_job` dispatch → `step_async`) — the shared prerequisite is built.

### Evidence (all divergent=0, every skip named)
- `language/statements/async-function` **6/60** (was 0), `language/expressions/await` **6/21** (was 0), `built-ins/AsyncFunction` **1/16**, `built-ins/Promise` **9/474** (held).
- Corpus bar `stage4_async_await_corpus_is_bit_exact_against_oracle` (14 programs) locked.
- Miri `async_await_suspend_resume_is_miri_clean` (clean, 11s).
- `cargo test --workspace` green; `#![forbid(unsafe_code)]` intact.
- GC-roots: `async_instances` + `async_run_stack` join the root set; `AsyncAwait` edge roots the suspended instance (noted in README + code).

### Scope folds (honest named skips, not half-implemented)
- **`Promise.prototype.finally` + `all`/`race`/`allSettled`/`any` combinators** — now rest on the landed 5-slot native-reaction path, but each is its own surface (`finally` chains a `Promise.resolve().then(finallyReturn/finallyThrow)` native-reaction family; combinators need iterator protocol + a shared-count native reaction). Folded cleanly per "never half-implement"; this is the highest-value next child on the now-built substrate.
- **`await`-inside-live-`try`** (`await:await-in-try`) — per the handoff v1 note.
- **async generators / `for-await-of`** — designated fold.

`ASYNC-AWAIT-HANDOFF.md` marked LANDED, its C-XS map retained as reference for the finally/combinator follow-up. Reported to supervisor `port-xs-to-rust-memory-safe-engine-s10` (inbox gone → dead-lettered and promoted to a fresh job, intent preserved).

### Follow-up
The finally + combinators child is fully unblocked and scoped — recommend posting it next.
