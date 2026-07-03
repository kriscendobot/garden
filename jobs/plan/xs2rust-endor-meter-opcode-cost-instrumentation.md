---
gate: deferred
priority: normal
roadmap: xs2rust-endor
posted_by: producer
posted_at: 2026-07-03T05:53:17Z
---

# xs2rust-endor: optional opcode cost-calibration instrumentation

**Program:** the `xs2rust-endor` XS→Rust port (design: `designs/xs2rust-endor-engine.md`).
**Nature:** new dev/analysis tooling on the metering path; **designer-first** (define the
complexity model + gating), then staged build.
**Gate:** parked/deferred — an analysis capability to sequence with the build, not urgent.

## Intent
Add **optional** instrumentation to the `endor-vm` metering path that, when enabled,
records:
1. **An opcode histogram** — execution counts per `XS_CODE_*` opcode (and per builtin
   step), over a run or corpus.
2. **Normalized average wall-clock time per opcode** — measured real time per opcode,
   **normalized by the operation's expected polynomial complexity** expressed as a
   function of its arguments' **sizes** (string/collection lengths, byte counts) or
   **magnitudes** (numeric values, iteration/allocation counts). The normalized mean
   approximates a per-unit-work constant; opcodes whose normalized time is an outlier
   are the ones whose fixed computron cost is mis-calibrated against real cost.

Off by default with zero overhead when disabled.

## Rationale
The deterministic meter assigns *fixed* costs (16.16 fixed-point: `1<<16`/dispatch,
`1<<14`/builtin, checks at loop-closing points) per opcode/builtin, ported to match
the C-XS oracle's computron counts. That gives *parity*, not *fidelity to real cost*.
This instrumentation empirically measures the real per-opcode cost relative to its
theoretical complexity, surfacing systematically over-/under-charged opcodes — data
that informs future meter tuning and validates the cost model against wall-clock
reality. It complements, and must not perturb, the C-XS differential oracle.

## Design crux (resolve before building)
- **Determinism firewall.** Wall-clock time is nondeterministic; the deterministic
  computron meter, snapshots, and the differential oracle must be entirely unaffected.
  Gate the instrumentation behind a compile-time feature flag (preferably) or an
  explicit runtime toggle that is provably off on any metered/reproducible/oracle path,
  so timing data can never leak into a metered result or a snapshot.
- **Complexity model.** Define, per opcode/builtin family, the expected complexity as a
  polynomial in argument size or magnitude — e.g. string concat/compare/index O(n) in
  code-unit/byte length; array & collection ops O(n) in element count; property access
  per its lookup model; arithmetic O(1) (O(digits) on any wide path); allocation O(n) in
  bytes. Normalize measured time by this expected work; pick *size* vs *magnitude* per
  op by what actually drives its cost.
- **Measurement robustness.** Per-dispatch timing has ruinous overhead/noise. Consider
  sampling, batched aggregate timing per opcode class using a high-resolution monotonic
  clock, and keeping distributional stats (count, mean, variance/percentiles) rather than
  a bare mean, so a few scheduler stalls don't dominate.
- **Output.** Emit a consumable report (histogram + normalized mean/percentile time per
  opcode) at run end or on demand, in a format the hourly **press driver** / benchmark
  harness can aggregate across the corpus for calibration trend data.

## Scope / touch points
- Hooks in the `endor-vm` `match`-dispatch interpreter loop and builtin steps, behind
  the feature/flag; reuse the meter's opcode enum + size/name tables generated from
  `xsCommon.h`/`xsCommon.c`.
- A reporting/serialization surface + optional integration into the press/benchmark run.

## Suggested shape when promoted
Designer specifies the complexity model, the instrumentation API, and the
off-by-default determinism gating; a build stage adds the hooks + report; a follow-on
wires it into the press/benchmark harness for corpus-wide calibration data. Orchestrate
if it decomposes into ordered steps.
