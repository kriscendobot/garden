CI is confirmed GREEN (rc 0, 27/27 checks pass). The job is complete.

## Completion report

**FIX round 2 for endojs/endo-but-for-bots PR #1150** (Ironhorse formal Panic category + FFI-abort guard). Applied the round-2 review panel's must-fix items in one pass, pushed as a follow-up commit (`ccb34be66`) to the PR head `kriscendobot:build/ironhorse-panic`, and watched CI to terminal — **GREEN, 27/27 checks pass** (including `build-xsnap`, `test-ironhorse`, `test-ironhorse-oracle`).

Must-fixes applied:
- **assessor / spec-keeper** — `ExecutionOutcome::classify` claimed 100% delegation to `Halt::is_panic`, contradicted by its hand-coded `Unsupported` arm + fail-closed catch-all. Corrected the docs on both `classify` and `is_panic` to state `Panicked` is a strict **superset** of `is_panic()` (adds `Unsupported` and the catch-all, which terminate-without-commit but aren't panics); `is_panic` remains the sole definition of the panic set. Added tests pinning the superset, the catch-all's fail-closed contract (debug-assert vs. release), and the no-location render.
- **breaker** — snapshot-stream `extern "C"` callbacks (`mem_read`/`mem_write`/`file_read`/`file_write`) and `metering_callback` were unguarded (a corrupted snapshot could overflow/panic → whole-daemon abort). Added a value-returning `guard_ffi_ret` and routed each through it (fail-closed sentinel on panic); hardened `mem_read`'s length math with `checked_add`.
- **integrator** — the FFI guard covered only `worker_io.rs`. Extended it to **every** XS-invoked `extern "C"` callback: the 48 `host_*` powers callbacks (fs/crypto/sqlite/modules/process) and the 6 debug transport hooks. The live abort hazard is now closed crate-wide.
- **saboteur** — the reactive pump observed poison only at crank boundaries, letting a mid-pump-poisoned worker still process a `suspend`/`debug` envelope (un-guarded supervisor effects). Added `ffi_panicked()` checks after the promise-job drain and before every envelope dispatch inside the pump.

Also applied (should-fix / coverage): `#[non_exhaustive]` on `XsnapError` (curator/migrator); non-string `panic_payload_message` + `guard_ffi_ret` tests (corner-prober); ASCII `...`/`->` glyph fixes (typist).

Verified locally: xsnap `cargo check` clean (1 pre-existing warning); ironhorse-vm tests pass; endo `ironhorse_engine` unit tests 14/14 pass; xsnap worker_io tests 17/17 pass; endo integration test compiles. Did **not** re-run the panel (driver re-posts panel-3).

Follow-ups (non-blocking, panel comment-only/should-fix left for the next round): integrator's suggestion to factor the repeated poison-drain sequence into a `drain_ffi_death` helper; prover's request for end-to-end `run_xs_program`/`inproc` catch_unwind tests.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-panic-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 172 tokens (13510915 cached reads)
- Output: 83210 tokens
- Cost: $13.364290500000005
- Wall-clock: 2045s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
