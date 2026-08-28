All verification complete and the worktree is clean. Here is my completion report.

---

## Completion report: async-instance OOM on endojs/endo-but-for-bots#1046

**Root cause (a frame leak, not a missing GC).** The 2-byte fuzz input `[193, 169]` = `START_ASYNC, RETURN`. The async body was terminated by `RETURN` — the *top-level-only* program terminator — instead of `END`. `RETURN` returns `Halt::Return` **without** the boundary `leave_call` that a real `END` performs. But `step_async`'s `Halt::Return` arm *assumed* the body's `END` had already popped the driver frame it pushed. So the driver frame was left on the call stack; `START_ASYNC` then popped that stray frame and resumed at its sentinel `ret_pc` (0), re-executing `START_ASYNC` and inserting a fresh, never-reclaimed `async_instances` entry every 2 dispatched opcodes → ~1,000,000 live instances (~1.4 KB each) → ~2.8 GB → libFuzzer OOM at `rss_limit_mb=2048`. Confirmed at `dispatch_depth=1`, orthogonal to the just-fixed stack overflow.

**Fix (shared invariant, all three resume drivers).** In `step_async`, `resume_generator`, and `step_async_generator` (`rust/engine/ironhorse-vm/src/interp.rs`), the `Halt::Return` arm now detects the un-popped driver (`call_stack.len() >= return_depth`, which only happens on a non-boundary `RETURN` — a real boundary `END` always leaves `call_stack.len() < return_depth`), pops the leaked frame(s), and degrades to a named `Halt::Unsupported`, symmetric with each arm's existing throw/`other` cleanup and the `start_async:frame-underflow` guard. The run now halts in a constant **2 dispatches** with `async_instances` bounded. The generator/async-generator mirrors are included per the job's "mirror for generators/async_generators."

**Regression.** Added `async_non_boundary_return_does_not_leak_instances` (VM unit test, since the fuzz corpus is gitignored) asserting the bounded halt, `dispatched < 1000`, and `async_instances.len() <= 1`.

**Verification.**
- New regression: passes (`Unsupported("async:non-boundary-return")`, 2 dispatched, 1 instance).
- `cargo test -p ironhorse-vm`: **106 passed, 0 failed.**
- Built the actual ASan fuzz binary (moddable submodule + `nightly-2026-08-15`) and ran the exact crash input `[0xc1, 0xa9]`: **2 ms, no OOM** (was ~2.8 GB before).
- 60s continuous `cargo fuzz run bytecode_decoder`: **55,425 runs, RSS steady at 399 Mb**, no OOM/crash.

**Committed & pushed:** `603597aca` → `feat/ironhorse-coverage-matrix` (interp.rs only). Did **not** merge, per instructions.

**CI note (separate, peer-owned).** `test-ironhorse` is red on a **pre-existing, unrelated** failure — the `metamorphic_determinism::golden_vector_pins_canonical_bytes_and_seal` snapshot pin. I bisected it: it **passes at `4f8f4fad3`** and breaks at **`b70aad6a9`** (`Symbol.toStringTag` on generator-family intrinsics — a legitimate machine-state change that omitted the documented conscious re-pin; the seven-way determinism tests still pass). This is owned by the **alive peer job `pr1046-snapshot-golden-regression-20260828`**, which has already edited `metamorphic_determinism.rs`. I did **not** touch that file (would collide), verified my change does **not** alter the golden bytes (hash `d34c62fc…` unchanged with/without my fix), and messaged the peer. `test-ironhorse` goes green once their re-pin rebases onto my commit — its resolution is outside this job's scope.

**Follow-up:** none for the async OOM itself. `test-ironhorse` green depends on the snapshot-golden peer's re-pin landing (coordinated via the message bus).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1046-fuzz-async-instance-oom-20260827.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 127 tokens (7063808 cached reads)
- Output: 57813 tokens
- Cost: $6.436600999999999 (1 engagement(s) unpriced)
- Wall-clock: 1171s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
