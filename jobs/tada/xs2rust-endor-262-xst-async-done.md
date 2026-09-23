Work complete. Inbox is empty. Here's my completion report.

---

## Completion report: endor-xst async/$DONE + job-drain wiring (PR #600 convergence 3/5)

**What I did.** Wired `flags: [async]` handling into the `endor-xst` test262 runner so async cases graduate from the wholesale `structural:async-or-can-block` pre-skip to real dual-run verdicts, playing `xst262.c`'s async protocol over the already-landed stage-3b/4b promise pump.

**Design choice.** The dual-run compiles on the C-XS oracle and runs that exact bytecode on endor, so `$DONE`/`print` are defined **once in a pure-JS async prelude** rather than as host functions on each engine — the two engines stay byte-identical (no host-function metering to calibrate, no C-shim change) and the oracle can't ReferenceError on `$DONE`. `$DONE`'s outcome is recorded into a sentinel global read off endor after the drain, gated by the completion/computron agreement (which already proves endor reproduced the oracle's whole execution including the microtask drain).

**Changes (5 files, project repo `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR #600 — kept DRAFT):**
- `endor-262/src/xst.rs`: split `CanBlockIsFalse` into its own `structural:can-block` skip; added the async prelude + `ASYNC_SIGNAL_NAME`; extracted `verdict_for`; added `run_async_case` (prelude → `dual_run_async` → base verdict refined by the completion latch) and `refine_async` (only a clean `Test262:AsyncTestComplete` on a `Covered` base is covered; failure/did-not-run/unhandled-rejection are honest `async:*` named skips, never a `Fail`). Three new bar tests.
- `endor-262/src/lib.rs`: `dual_run_async` + `AsyncDualRun` (retains endor's interpreter to read the latches); extracted `build_dual_run` shared with `dual_run_with`.
- `endor-vm/src/interp.rs`: unmetered post-run inspection — `Interp::global_string` (reads a top-level binding via the interpreter's own read path) and `Interp::has_unhandled_rejection` + a `PromiseData.ever_handled` flag mirroring XS's `the->rejection`.
- `README.md`, `ASYNC-AWAIT-HANDOFF.md`: documented the harness wiring and graduated numbers.

**Results.** All async sections `divergent=0`, zero `Fail` across 571 async files. Graduated `endor-xst` covered counts: `language/expressions/await` 10, `language/statements/async-function` 22, `built-ins/AsyncFunction` 1, `built-ins/Promise` 68. Full `endor-vm` suite (82) and the 9 `xst` tests pass.

**Notes / follow-ups.**
- The one failing lib test, `compile_diff::module_corpora_byte_identity_no_divergence` (a `top-level-await.js` module-bytecode 1-byte divergence), is **pre-existing** — confirmed failing on the pristine checkout before my changes; it's `endor-compile` module-goal work, unrelated to this harness wiring (it's in the "still folded" set per the handoff).
- The `ever_handled`-based unhandled-rejection latch is a coarse mirror of `the->rejection` (a promise never `.then`/`.catch`/`await`-ed) rather than a full XS handled-list; sufficient for the async did-not-run cases and folds naturally into the honest `async:*` skips.
- Async cases inside a live `try` and async-generator/`for-await-of` remain the designated engine-side folds (per the handoff), so they surface as honest run-skips, not failures.
