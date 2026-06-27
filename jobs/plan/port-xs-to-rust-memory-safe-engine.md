---
gate: go-ahead
priority: normal
posted_by: liaison
posted_at: 2026-06-27T20:27:13Z
---

# PLAN (go-ahead): port XS to Rust — a memory-safe, meterable, no-JIT JS engine for Endor

Map: **research/design** → researcher then designer. Deliverable is a FEASIBILITY + ARCHITECTURE
design doc + a staged roadmap — NOT the port itself (that is a multi-quarter program the design
scopes). Design only; no engine code in this job. Go-ahead gated (strategic): promote with
"go ahead on port-xs-to-rust-memory-safe-engine".

## Goal
Investigate and design a port of **XS** (Moddable's interpreted JavaScript engine, as consumed by
Endo's xs-worker / agoric-sdk's `xsnap`) to **Rust**, to raise confidence in memory safety while
preserving everything that makes XS uniquely suited to Endo/agoric.

## Hard requirements (the design must carry ALL of these)
1. **Preserve the metering, debugger, and snapshot-persistence systems.**
   - **Metering:** deterministic CPU + memory metering (the agoric consensus requirement — every
     validator must meter identically). The Rust engine must reproduce XS's metering semantics
     EXACTLY, or the design must state how determinism-equivalence is proven against C-XS.
   - **Debugger:** the XS debugger protocol/inspection surface.
   - **Snapshot persistence:** heap snapshot save/restore (the xsnap snapshot lifecycle). Design the
     snapshot FORMAT question: read existing XS snapshots, or a new Rust-native format with a
     migration path.
2. **Minimize `unsafe`.** Quantify and contain it (an `unsafe` budget + justification per use; isolate
   it behind audited modules). The whole point is fewer foot-guns than the C engine.
3. **Increase confidence in memory safety** — the raison d'être; safety is the headline metric, weighed
   against perf (see daemon-rust-xs-performance.md for the perf framing).
4. **Eschew JIT — continue interpreter-only.** No JIT, ever: required for determinism, metering,
   security surface, and tiny footprint. Design the interpreter (bytecode/threaded) accordingly.
5. **Continue HardenedJS support, especially Compartment.** Native `Compartment`, `lockdown`/SES
   semantics, and the hardening primitives must be first-class (XS's native Compartment is a
   differentiator general Rust engines lack).
6. **High test262 coverage.** A conformance strategy: harness, the coverage bar, and how coverage is
   bootstrapped and tracked toward parity with C-XS.
7. **Fuzzability.** First-class fuzzing (cargo-fuzz / libFuzzer; structure-aware fuzzing of the
   parser + interpreter; differential fuzzing against C-XS). Rust makes this far cheaper than C.
8. **Better endor integration.** The engine as a Rust crate **endor** (the Rust Endo daemon) embeds
   directly, instead of the current C `xsnap` subprocess — reconcile with daemon-endor-architecture.md,
   daemon-rust-xs-performance.md, daemon-endo-rust-sqlite.md, and the daemon-xs-worker-{metering,
   debugger,snapshot}.md cluster.

## Investigation scope (the design must weigh)
- **Build approaches:** (a) re-implement XS's semantics in Rust from scratch; (b) extend an existing
  Rust JS engine (e.g. Boa) with Compartment + deterministic metering + snapshot + the no-JIT
  guarantee; (c) a hybrid (Rust front/interpreter over an XS-compatible core). Weigh each against the
  8 requirements — general Rust engines lack Compartment, deterministic metering, snapshotting, and
  the metering-determinism bar, which are the hard parts.
- **The determinism bar is the crux.** Metering must be bit-for-bit reproducible across the fleet;
  detail how the Rust engine's metering is validated equivalent to C-XS (differential testing on
  test262 + agoric contract corpora), since a metering divergence is a consensus fault upstream.
- **Snapshot compatibility + the debugger protocol** — keep or re-spec, with migration.
- **Footprint / perf envelope** vs C-XS, acknowledging safety is the priority, not raw speed.

## Deliverable
A feasibility verdict + architecture design (interpreter core, Compartment/SES integration, the
metering/debugger/snapshot subsystems, the unsafe budget, the test262 + fuzzing strategy, the endor
embedding) and a STAGED roadmap (a thin first slice that proves the metering-determinism + Compartment
bar and bootstraps test262 coverage, then iterate). Cross-link the existing endor/XS-worker design
cluster.

## Constraints / scope
- Design doc lands on `endojs/endo-but-for-bots` under `designs/` (where the endor/XS-worker direction
  is designed), referencing Moddable XS (upstream) and agoric-sdk's `xsnap` consumption. This is
  DESIGN/RESEARCH only — no autonomous action on agoric-sdk; any eventual port is a separately
  authorized, fork-scoped program. The metering-equivalence requirement exists precisely because XS
  feeds agoric consensus.
