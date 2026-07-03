# xs2rust-endor: replace CESU-8 string storage with UTF-16 (drop the constant-time-index hacks)

**Program:** the `xs2rust-endor` XS→Rust port (design: `designs/xs2rust-endor-engine.md`).
**Nature:** revisit an already-landed representation decision; **designer-first**, then staged build.
**Gate:** parked/deferred — a revisit to sequence against the in-flight Stage 3 build, not an emergency.

## Intent
Change the port's internal JS string representation from **chunk-backed CESU-8**
(introduced in Stage 3 language, commit `228ee790b`: `STRING_1/2/4` literals,
`fxConcatString` concat, byte-content comparison, `typeof`, `from_utf8_lossy`
rendering) to **UTF-16**, and **remove the performance hacks** that CESU-8 needs to
give constant-time (O(1)) random access by string index.

## Rationale
ECMAScript strings are semantically sequences of UTF-16 code units; `length`,
`[i]`, `charCodeAt`, `codePointAt`, iteration, and comparison are all defined over
UTF-16 code units and demand O(1) random access. CESU-8 (XS's native storage) is
variable-length, so O(1) code-unit indexing requires auxiliary machinery —
cached last-access cursors, ASCII/BMP fast paths, or index side-tables. Storing as
UTF-16 makes code-unit indexing intrinsically O(1) and lets that machinery be
**deleted**, trading a modest memory increase (2 bytes/unit vs ~1 for ASCII under
CESU-8) for simpler, obviously-correct indexing.

## Metering stance (IMPORTANT — parity is a non-goal)
Meter **parity with C-XS is explicitly NOT a goal.** The deterministic meter is free
to diverge from XS's computron counts. The goal is **meter accuracy as a proxy for
real (wall-clock) cost, while remaining deterministic for a given release version.**
Therefore:
- Re-base the string-op meter costs to reflect the real cost of the **UTF-16**
  representation (informed by the opcode cost-calibration instrumentation — see the
  sibling plan `xs2rust-endor-meter-opcode-cost-instrumentation`), **not** CESU-8 byte
  length chosen to match the oracle.
- Determinism is preserved by **freezing** the chosen costs per release version;
  accuracy improves across releases as the model is recalibrated.
- The C-XS differential oracle governs **result** correctness only; do not treat its
  computron counts as an authority the string meter must match. (This diverges from
  the design's current "oracle-locked on (result, computron)" language — flag that the
  design's metering section needs updating to the accuracy-over-parity stance.)

## Scope / touch points
- `endor-vm` chunk-backed string values (the `228ee790b` surface): storage,
  literals, concat, comparison, `typeof`, rendering.
- Delete the O(1)-index hacks/fast-paths once UTF-16 makes them unnecessary.
- Snapshot grammar: ensure string atoms still round-trip under the new encoding.
- test262 / differential harness: confirm **result** parity; add index-heavy and
  supplementary-plane (surrogate-pair) cases (`charCodeAt`/`codePointAt`/slicing across
  a surrogate boundary). Meter numbers may legitimately change — update expectations to
  the recalibrated, more-accurate costs rather than back-fitting to CESU-8.
- Any C-FFI / xsnap boundary where raw string bytes cross.

## Suggested shape when promoted
Designer revisits the string-representation section of
`designs/xs2rust-endor-engine.md`, adopts UTF-16, and re-bases string metering for
accuracy (deterministic-per-release); then a build stage swaps the representation and
removes the hacks; then a test stage proves result parity + the recalibrated meter.
Orchestrate if it decomposes into ordered steps.
