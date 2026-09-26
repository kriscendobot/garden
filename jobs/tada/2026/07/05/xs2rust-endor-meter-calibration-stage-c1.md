The push output already confirmed the update (`3ac7f7621..3904232b8 HEAD -> xs2rust-endor`, no rejection); the `ls-remote` timeout is transient sandbox network flakiness, not a push failure. The work is committed and pushed. Writing the completion report.

---

## Completion report — `xs2rust-endor-meter-calibration-stage-c1`

**Landed stage C1** of the opcode cost-calibration instrumentation (design `designs/xs2rust-endor-meter-opcode-cost-instrumentation.md` § roadmap C1) on `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600). Commit `3904232b8` pushed cleanly (fast-forward, after rebasing onto concurrent peer pushes).

### What I did
- **`cost-calibration` Cargo feature** on `endor-vm`, off by default; enabled by no default/release/snapshot/consensus build (the firewall).
- **New `src/cost.rs` module.**
  - *Feature-off:* `CostRecorder` is a zero-sized unit struct with `#[inline(always)]` empty `on_dispatch`/`on_builtin` — LLVM deletes the hot-loop calls.
  - *Feature-on:* per-opcode dense histogram (`Box<[u64; XS_CODE_COUNT]>`) + per-`NativeMethod` invocation map, with a self-describing `report()` keyed by the generated `CODE_NAMES` mnemonics and the `NativeMethod` variant names.
  - `CostModel` **work-function table (data only)**: the design's complexity families as a `WorkModel` enum (`Constant`/`StringLength`/`BigIntDigits`/`PropertyChain`/`AllocSize`/`CallArgs`/`IterCount`/`NLogN`/`ChunkBytes`) with `evaluate(&WorkInputs)`, and `opcode_work`/`builtin_work` mappings. Nothing consumes it yet (no timing until C2).
- **Wired at the existing seams in `interp.rs`:** opcode half at the `tick_code`/`n_dispatched += 1` seam in `dispatch_at`; builtin half at the `call_native_method` dispatch seam. Added the `cost` field, its init, and feature-gated `cost_recorder()`/`n_dispatched()` accessors. Added `Hash` to `MathId`/`NativeMethod` (the enum has 3 data-carrying variants, so a discriminant-indexed array is impossible; a map is the clean equivalent).

### Acceptance bar (design § roadmap C1)
- **Firewall / instruction-identical `dispatch_at`:** landed the structural proof — `size_of::<CostRecorder>() == 0` in the default build (tested) + inlined no-op methods. The objdump/disassembly diff is the CI gate the design assigns; not runnable in this environment.
- **Identical computrons/snapshots feature-on vs off:** the recorder only observes (holds no `&mut Meter`; `meter.rs` names no cost type — grep-invariant test). The existing bit-exact metering tests pass **unchanged in both configs**, which is the on/off metering-equality proof. The full oracle-corpus cross-run is CI-only here (needs the `c/moddable` submodule, absent in this worktree).
- **Histogram reconciles with `n_dispatched`:** tested (`opcode_total() == out.dispatched`).
- **`#![forbid(unsafe_code)]` holds:** builds both configs, no `unsafe` added.

Tests: `cargo test -p endor-vm` → 46 pass; `--features cost-calibration` → 50 pass. New code is clippy-clean (baseline interp.rs clippy/fmt noise is pre-existing and untouched).

### Deferred / follow-ups
- **Step-granular (k-weighted) builtin attribution** and the in-loop property-step seams are deferred to **C2**, where the timing normalization that consumes step counts lands; C1's builtin histogram is per-`NativeMethod` invocation counts.
- **C2–C4 orchestration not set up.** This is the C1 head, but the parked children `…-c2 … -c4` + the serial orchestration (`post-orchestration.sh --serial`) are a producer/liaison action at build-promotion (and need per-stage bodies from the design). Recommend the liaison park+orchestrate C2–C4 gated on this C1 reaching `tada/`.
