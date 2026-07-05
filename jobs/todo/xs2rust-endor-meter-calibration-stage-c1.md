<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-05T21:34:33Z -->

# xs2rust-endor meter calibration — build (stage C1: firewall + histogram)

**Program:** `port-xs-to-rust-memory-safe-engine`, PR #600 `xs2rust-endor` branch.
**Design:** `designs/xs2rust-endor-meter-opcode-cost-instrumentation.md` (landed
2026-07-05, commit 80be8cf63) — read it first; it is the authoritative spec.
**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor`.

**Gate:** deferred — **promote only after the design is reviewed/accepted** by the
program supervisor (the parent engine design went through supervisor approval; this
sub-design changes the interpreter hot loop and should clear the same bar first).

## This job (stage C1 only — the thin slice)
Land the design's stage C1: the `cost-calibration` Cargo feature on `endor-vm` (off
by default), a zero-sized-when-off `CostRecorder`, the per-opcode + per-builtin
**histogram** wired at the existing `tick_code`/`n_dispatched` and `tick_builtin`
seams in `interp.rs`, and the `CostModel` work-function table (data only, from the
design's complexity-model table). No wall-clock timing yet.

**Acceptance bar (design § roadmap C1):** disassembly of `dispatch_at` in a default
build is instruction-identical to pre-change (firewall proof); the oracle corpus
produces identical computrons AND identical snapshots feature-on vs feature-off;
histogram totals reconcile with `n_dispatched`; `forbid(unsafe_code)` holds.

## Follow-ons (the rest of the roadmap — orchestrate when promoting for build)
The design decomposes into four ordered stages C1–C4 (C2 batched timing +
normalization, C3 corpus sampling, C4 press/benchmark-harness integration + the
recalibration-review artifact). Per the standing decomposition norm, promote them as
a **serial orchestration** (`post-orchestration.sh --serial`) over parked children
`xs2rust-endor-meter-calibration-stage-c2 … -c4`, each gated on the prior reaching
`tada/`. This C1 job is the head of that chain.

**Role:** builder (Rust engine work). Isolated project worktree per the gardener norm.
