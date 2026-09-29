I opened draft PR [endojs/endo-but-for-bots#1374](https://github.com/endojs/endo-but-for-bots/pull/1374) for this leg, and every CI check is now green. One leg (`test (22.x, ubuntu-latest)`) failed once and passed on rerun. The PR is based on the frozen snapshot `llm-1706e63`, has head `95adf7f398`, and carries `Refs: #1018`. No stacking was needed: no earlier leg left a PR this depends on.

**What changed**
- **One outcome from the live C-XS worker.** The worker now names which abort ended a run. Before this, a stack overflow was reported as a metering death, and a caught Rust panic came back through a separate error.
  - The run loop returns a new `XsnapError::Aborted` error instead of success.
  - A new `WorkerOutcome` type classifies each run once, with three arms: `Quiesced`, `Uncaught` and `Panicked`.
  - Stack overflow, native stack overflow, meter abort, out-of-memory, key-table exhaustion and the caught Rust panic all land in `Panicked`, and each keeps its source.
  - Unhandled exceptions and rejections are `Uncaught`. Startup failures and unknown exit statuses also land in `Panicked` but are not counted as panics, so the crank is discarded without a retry.
  - Each outcome maps to a crank decision: commit, discard and terminate, or discard and recover.
- **Consumed on the delivery path.** The supervisor now retires a worker with its outcome at both exit points (in-process workers and resumed workers). It unregisters the worker and keeps the last 64 outcomes. Nothing is discarded yet because no outbound effect is staged; the outbound-embargo leg will act on the crank decision.
- **Ironhorse joins the same arms.** With the `ironhorse-engine` feature, the existing Ironhorse outcome converts into the same three arms and keeps its full payload. It only calls `halt.is_panic()`, so it doesn't conflict with the classification lint in #1373.
- **CI.** The `build-xsnap` lane previously ran only the Ironhorse engine tests from the endo crate, so the new tests would never have run. I added them, and the CI log shows them passing.

**Tests**
- Unit tests cover every panic source reaching one `Panicked` arm, the source being kept, `Uncaught` for unhandled errors, failing closed for refusals, the Ironhorse conversion, and every C-XS exit status.
- Live tests drive a real worker through the run loop and supervisor: a stack overflow now retires as `Panicked` rather than a meter death, a meter abort retires as `Panicked`, and a run-entry panic retires as an engine fault.
- Locally, all 376 endo tests passed, and the `ffi_wiring` tests passed. In the xsnap tests, two tests that need the generated JS bundles failed locally only because I had stubbed those bundles; CI builds the real ones.

**Open-question decisions**, following the mentat answers (#1018 comment 5886418488, design amendment #1370), all listed in the PR body as review items:
- **Decode/StepLimit:** they stay in the panic set, through the Ironhorse `is_panic()` check. C-XS has no equivalent exit, so nothing here changes that set.
- **Unhandled rejection:** I classified this abort as `Uncaught`. That was my call; the answers didn't settle it.
- **Payload-preserving `Halt` migration:** deferred to the halt-shape-unification leg. The conversion carries the whole `Halt` in the meantime, so nothing is lost.
- **Integration dependency:** already filed in `ironhorse-engine.md` by #1370. The Ironhorse outcome's doc comment now says the C-XS adapter is the only live consumer.
- **Remaining C-XS exits:** I mapped out-of-memory, key-table exhaustion and native stack overflow to panics; any other status fails closed.

**Behavior change to review:** a subprocess `endor worker xs` that aborts now exits with status 1 instead of 0.

**Follow-ups**
- Evaluating guest code that throws when no error handler is set up crashes the process with a segfault. CI's own comments already record this. I hit it because my first test bundle didn't define `__shouldTerminate`, which the live loop evaluates after every crank. It isn't caused by this PR, but it is a real hazard.
- Probe gap 1 is still open and outside this leg: after a Rust panic in a callback, the guest keeps running until the next checkpoint.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-cxs-panicked-adapter.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 6 tokens (596664 cached reads)
- Output: 1954 tokens
- Cost: $5.986908399999998 (1 engagement(s) unpriced)
- Wall-clock: 7479s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
