The design deliverable is complete. Final summary:

## Completion report

**Job:** `xs2rust-endor-meter-opcode-cost-instrumentation` — designer-first spec for optional opcode cost-calibration instrumentation on the endor-vm metering path.

**Nature confirmed:** This is a **project** job on `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, the XS→Rust "endor" engine port). The parent design `designs/xs2rust-endor-engine.md` § Metering (revised 2026-07-04, accuracy-over-parity doctrine) explicitly names this as the sibling plan that supplies the release-versioned meter cost table's weights. Worked in an isolated project worktree keyed to my job base.

**What I did (designer deliverable):**
- Authored `designs/xs2rust-endor-meter-opcode-cost-instrumentation.md` (493 lines), specifying all six things the job asked for:
  1. **Complexity model** — a per-opcode/builtin-family table of expected work functions `w(args)`, polynomial in operand *size* (code-unit/byte/element lengths, chain depth, slots/bytes allocated) or *magnitude* (argument count, BigInt digits, iteration count), with explicit guidance on picking size-vs-magnitude per family; normalized time = `t / w(args)`, and non-flat normalized time is itself surfaced as a model finding.
  2. **Instrumentation** — an opcode/builtin histogram (deterministic-safe, keyed on the generated `Opcode`/`NativeMethod` tables) plus normalized mean wall-clock time whose outliers are the mis-priced fixed costs.
  3. **Determinism firewall** — a compile-time `cost-calibration` Cargo feature, off by default, zero-sized-when-off (instruction-identical hot loop as an acceptance bar), one-directional data flow, and no timing type in `RunOutcome`/snapshots/`OracleOutcome` (compile-checked), so timing can never leak into a metered or reproducible result.
  4. **Measurement robustness** — no per-dispatch clock reads; batched homogeneous microbenchmarks over swept operand sizes + deterministic-stride in-run sampling, monotonic clock, distributional stats (mean/CV/p50/p90/p99), ratios-not-absolutes on a named reference platform.
  5. **Report + recalibration loop** — a JSON report the press/benchmark harness aggregates across the corpus, feeding a human-gated re-derivation of the frozen integer cost table shipped as the next `endor-meter-N`.
  6. **Staged roadmap** — four ordered build stages (C1 firewall+histogram, C2 batched timing+normalization, C3 corpus sampling, C4 harness integration), to run as a serial orchestration when promoted.
- Grounded every hook site in the actual code seams (`interp.rs::dispatch_at`'s existing `tick_code`/`n_dispatched`, `tick_builtin`, `tick_slot_alloc`/`tick_chunk_new`; `opcode.rs` name/size tables; `interp.rs` `NativeMethod::display_name`).
- Added the README index entry (narrative + status-table row) and linked the parent engine design's mention of this plan to the new doc. Noted no milestone re-projection (sub-plan of the already-counted M11 engine port).

**What changed / verification:**
- Commit `80be8cf63` on `xs2rust-endor`, **pushed to origin** — verified via `git ls-remote origin xs2rust-endor` → `80be8cf6332ce3b5200f477373c2411dfd5a93d2`. Working tree clean.
- This is a **design document, not code** — no Rust build/test was run because nothing executable changed; there is no runtime to exercise. The design's acceptance bars (instruction-identical hot loop, feature-on/off computron+snapshot equality) are specified for the build stages to verify, not this job.

**Follow-ups:**
- Parked a deferred plan job `xs2rust-endor-meter-calibration-stage-c1` (role: builder) as the head of the build chain, gated to promote **only after the design is reviewed/accepted** by the program supervisor (same bar the parent engine design cleared, since the build touches the interpreter hot loop). Its body records the full C1–C4 serial-orchestration plan so the follow-ons aren't forgotten.
- Five open questions in the design (reference-platform selection, timing source, builtin-step granularity, percentile sketch, corpus choice) are flagged for the supervisor to resolve, each with a leaning proposal.
