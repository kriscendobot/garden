The job is complete. Let me write the completion report.

---

## Completion report — build-ironhorse-panic

Built the "Required First Step" live-code slice of the merged `designs/ironhorse-panic.md`, opened as **draft PR [endojs/endo-but-for-bots#1150](https://github.com/endojs/endo-but-for-bots/pull/1150)** against `llm` (head `kriscendobot:build/ironhorse-panic`).

### What I did

**Item 1 — Formal `Panic` category (interpreter-side, no behavior change):**
- `rust/engine/ironhorse-vm/src/interp.rs`: added `Halt::Panic(PanicKind)` with `PanicKind::EngineFault { message, location }`; marked `Halt` `#[non_exhaustive]` with a steering doc comment on the type ("match a panic via `is_panic()`, never on variant shape").
- Added `Halt::is_panic()` — the single definition of the "terminate, do not commit" set (`StackOverflow | MeterAbort | Panic(_)`, provisionally `Decode | StepLimit`), documented as the design's Open Question.
- `rust/endo/src/ironhorse_engine.rs`: added `ExecutionOutcome` (`Quiesced | Uncaught | Panicked`) at the `Machine` seam, whose `classify()` defines its `Panicked` arm **by delegation** to `is_panic()`. Classifier only — deliberately not wired to a delivery path (that surfacing rides the gated `-e ironhorse` integration).

**Item 2 — Net-new FFI-abort guard (real live safety fix):**
- `rust/endo/xsnap/src/worker_io.rs`: wrapped all 18 `extern "C"` callback bodies in a new `guard_ffi` (`catch_unwind` + a location-capturing panic hook), recording a **thread-local poison marker** instead of unwinding past the C frame (which since Rust 1.71 aborts the whole daemon).
- `rust/endo/xsnap/src/lib.rs`: new `XsnapError::Panicked`; the crank loop drains the poison at the crank boundary and returns it, so only the one worker dies.
- `rust/endo/src/inproc.rs`: wrapped the machine-thread run entry in `catch_unwind` as the outer net for panics that never crossed an `extern "C"` frame.

### Tests / verification (all local, green)
- New FFI-guard regressions incl. the **confined-to-one-worker** isolation invariant (one thread panics and dies; a sibling keeps serving — unit analogue of the design's two-co-resident-workers case) and the named `with_transport().expect` example.
- New `is_panic()`/`ExecutionOutcome::classify` tests incl. "Panicked fires exactly when `is_panic()`".
- Suites: `xsnap` 125, `endo` lib 344, `ironhorse-vm` lib 121 — 0 failures. `endor` binary + all endo/engine test targets build clean.

### Notes / follow-ups
- The draft PR auto-runs the gauntlet under its supervising gardener.
- Deliberately deferred (noted in PR body): the message embargo + per-crank commit + write-ahead transcript (→ a to-be-filed `message-embargo-and-crank-commit` design); the Coda's `panic-on-reference-error`; the `-e ironhorse` delivery-path surfacing; and a **clippy/dylint lint** for the "never match a `Halt` variant directly" convention (no built-in clippy lint bans a match arm — needs a custom driver; today enforced via `#[non_exhaustive]` + steering doc). No design citations had drifted.
- Recorded a reusable memory: the fresh-worktree ebfb Rust build prereqs (moddable submodule via local-ref clone + 3 generated JS bundles).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-panic.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 274 tokens (22866773 cached reads)
- Output: 104591 tokens
- Cost: $15.532631249999996
- Wall-clock: 1770s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
