CI has kicked off for the new head (`c6944f583`). The specific fuzz trophy is verified fixed via the actual release fuzz binary locally; the full `fuzz-ironhorse` lane is queued in CI. Inbox is empty. The deliverable is complete.

---

## Completion report

**Job:** Fix the `bytecode_decoder` fuzz panic `leave_call with empty call stack` (endojs/endo-but-for-bots#1046).

**Root cause.** The four return-family boundary handlers in `ironhorse-vm/src/interp.rs` — `END`, `START_GENERATOR`, `START_ASYNC_GENERATOR`, `START_ASYNC` — guarded only `call_stack.len() == return_depth` (the boundary/return case) and then unconditionally called `leave_call()` in the else branch, implicitly assuming `len > return_depth`. Crafted bytecode can reach these opcodes with `call_stack.len() < return_depth`, so the frame `leave_call` pops belongs to an **outer** dispatch context. Cascaded through nested async re-entry (the backtrace showed repeated `step_async → dispatch → START_ASYNC`), this empties the call stack and hits the explicit `panic!("leave_call with empty call stack")` at `interp.rs:30797`. I reproduced it locally and confirmed via `RUST_BACKTRACE` that the abort fired at the `START_ASYNC` non-boundary `leave_call` (line 12181).

**Fix.** Added an underflow guard at all four sites: when `call_stack.len() < return_depth` the control flow is malformed, so degrade to a host-facing `Halt::Unsupported("<op>:frame-underflow")` (`end:` / `start_generator:` / `start_async_generator:` / `start_async:`), mirroring the existing sibling `yield:`/`await:`/`add:stack-underflow` refusals — never `panic!`. Valid bytecode always maintains `len >= return_depth`, so behavior changes only for crafted/corrupt input and the oracle-differential paths are untouched.

**Regression.** Added `leave_call_underflow_fails_closed_on_main_thread_stack` in `ironhorse-vm`, embedding the 20-byte minimized crash unit directly (corpus is gitignored) and asserting it returns `Halt::Unsupported("start_async:frame-underflow")` — run on a spawned 8 MiB (main-thread/libFuzzer-sized) stack.

**Evidence (commands + output).**
- `cargo test -p ironhorse-vm leave_call_underflow_fails_closed_on_main_thread_stack` → `test result: ok. 1 passed`
- `cargo test -p ironhorse-vm -p ironhorse-snapshot` → all green (vm lib 105 passed incl. the new test; snapshot suites 0 failed)
- `cargo test -p ironhorse-fuzz` → `33 passed; 0 failed`
- `cargo +nightly-2026-08-15 fuzz run bytecode_decoder /tmp/leave_call_crash_input` (release) → `Executed … in 2 ms`, exit 0 — previously a `libFuzzer: deadly signal`.

**Delivered.** Committed `c6944f583` (single file `rust/engine/ironhorse-vm/src/interp.rs`, +66 lines), pushed to `feat/ironhorse-coverage-matrix` via rebase-CAS. Did not stage the gitignored Moddable submodule. Posted a completion-summary comment: https://github.com/endojs/endo-but-for-bots/pull/1046#issuecomment-5446621809. Did not merge.

**Status / follow-up.** CI re-triggered on the new head (run 33128030212, queued/in-progress at report time). The specific trophy is verified fixed against the actual release fuzz binary; the full `fuzz-ironhorse` lane's green is pending CI completion. Distinct from and did not touch the async-instance OOM on `[193,169]` (owned by `endojs-endo-but-for-bots-pr1046-fuzz-async-instance-oom-20260827`) or the already-landed native-dispatch re-entry depth cap.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1046-fuzz-leave-call-underflow-20260827.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3543321 cached reads)
- Output: 32772 tokens
- Cost: $3.5249094999999993
- Wall-clock: 590s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
