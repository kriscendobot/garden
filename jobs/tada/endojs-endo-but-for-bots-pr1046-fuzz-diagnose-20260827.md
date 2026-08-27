No failing checks. Only an unrelated `lint` leg (JS eslint — my change is Rust-only) is still running; every substantive check including the assigned `fuzz-ironhorse` passes. The job is genuinely complete.

## Completion report

**Structural diagnosis (why the prior r2 handler failed every cycle):** Not a crashing tool or short timeout. The r2 `fuzz-shepherd` job was specced `tier: minion` with an empty `fallback-tier`; its usage log shows `source: none` on all 5 cycles plus a failed `kimi-k3 → opus` fallback — a **tier-routing failure** (the job routed to a worker source that could not serve it). This diagnose job at `tier: mentor` claimed cleanly on an anthropic worker, confirming the fix was already baked into its spec.

**Root cause of the crash:** The `bytecode_decoder` ASan stack overflow on `[193,193,37,253,45,93]` (`START_ASYNC` leading an async body that itself leads with `START_ASYNC`) was **unbounded native recursion**. Ordinary bytecode `CALL` loops within one `dispatch_at`, but callbacks/async/async-generator/generator resumes drive the callee by *recursively* calling `dispatch_at` on the native Rust stack. `run_program_bounded`'s step limit bounds dispatch *count* (a hang), not native *recursion depth*, so a degenerate nest overflowed the real thread stack instead of degrading to a `Halt`.

**Fix (pushed, PR head `e66cf4d5f`):** A thin `dispatch_at` wrapper caps native re-entry depth (`DISPATCH_REENTRY_LIMIT = 64`), aborting with the same host-facing `Halt::StackOverflow` the value-stack `fxOverflow` guard emits. All re-entry sites call through it, so the ceiling is enforced uniformly. Conservative on purpose — the `dispatch_at` activation is tens of KiB, so even a few hundred levels exhaust a main-thread stack.

**Verification (real execution):**
- Reproduced the exact overflow (SIGABRT, even on 8 MiB) before the fix.
- After: crash input returns `Halt::StackOverflow`; added regression test `nested_start_async_degrades_to_stack_overflow` (runs on a main-thread-sized 8 MiB stack).
- `cargo test -p ironhorse-vm -p ironhorse-snapshot` → all pass (104 VM tests + snapshot).
- Real ASan fuzz build (CI's pinned `nightly-2026-08-15`, release): crash input `Executed … in 2 ms`, exit 0, no overflow.
- **CI on `e66cf4d5f`: `fuzz-ironhorse` = pass (3m54s), `test-ironhorse` = pass**, no failing checks.

**Note on regression form:** `fuzz/corpus/` is gitignored, so a corpus seed can't be committed — the Rust unit test is the permanent regression (and runs in the normal test job, not just the time-boxed fuzz job).

**Separate finding (documented, not fixed here):** The 30 s fuzz run surfaced an unrelated pre-existing OOM on `[193,169]` (`START_ASYNC, RETURN`): a bounded non-terminating dispatch cycle that re-executes `START_ASYNC` and accumulates ~2M never-reclaimed `async_instances` (~2.8 GB). It occurs at recursion depth 1 — orthogonal to and unaffected by this fix — and needs its own async-instance lifecycle/GC decision. Posted follow-up job `endojs-endo-but-for-bots-pr1046-fuzz-async-instance-oom-20260827`, messaged the maintainer, and documented it in the PR summary.

**Follow-ups:** the OOM job above; PR not merged (as instructed). PR completion summary comment posted with head SHA and evidence.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1046-fuzz-diagnose-20260827.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 254 tokens (22064074 cached reads)
- Output: 129998 tokens
- Cost: $19.34784699999999
- Wall-clock: 2127s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
