CI is GREEN (rc 0): all 27 checks pass on head `9ef61dcd9`. The job is complete.

## Completion report

Applied the round-4 review-panel must-fix items to endojs/endo-but-for-bots PR #1150, pushed as follow-up commit `9ef61dcd9` to the PR head (`kriscendobot:build/ironhorse-panic`), and drove CI to green.

**What changed (commit `9ef61dcd9`)**
- **engine-realist #1** — `guard_ffi_ret`'s `CAPTURING` thread-local restore is skipped when XS's `fxAbort`→`longjmp` unwinds past the `catch_unwind` frame, stranding the flag `true` and permanently suppressing this thread's panic diagnostics. Added `worker_io::reset_capturing()` (worker_io.rs) and call it at the run loop's pure-Rust, longjmp-proof crank boundaries — crank start, crank end, post-bootstrap, and post-`run_loop` (lib.rs) — healing a stranded flag before the next guarded callback runs.
- **assessor #1** — `flush_debug_outbound()` shipped a raw `debug` envelope after the drain loop with no `ffi_panicked()` re-check. Added a sixth poison checkpoint immediately before the flush and renumbered the five-checkpoint contract comment to six.
- **archivist #1** — `designs/ironhorse-panic.md` (269, 281) named a nonexistent `PanicLocation` Rust type; landed code uses `Option<String>`. Reconciled the prose to `Option<String>` (a `file:line:col` string) while keeping the optional-physical vs categorical-`RaiseSite` contrast.
- **scribe** — posted the missing top-level completion-summary comment (issue-comment 5550673199); bumped the design's `Updated` row to 2026-09-05 and reconciled the stale `designs/README.md` roadmap date row.

**Advisory / not this round** — the shared power-table caveat and the panic-injection harness remain tracked follow-ons per the panel (advisory-only; not blocking).

**Verification** — `cargo test -p xsnap --lib worker_io` green locally (21 passed, incl. `nested_guard_preserves_outer_capture`); clean compile, no new warnings. Full CI on `9ef61dcd9`: all 27 checks pass (rc 0, GREEN).

No further action for this stage; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-panic-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 116 tokens (4508876 cached reads)
- Output: 29314 tokens
- Cost: $3.9596470000000004
- Wall-clock: 677s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
