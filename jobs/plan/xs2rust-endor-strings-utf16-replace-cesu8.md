---
gate: deferred
priority: normal
roadmap: xs2rust-endor
posted_by: producer
posted_at: 2026-07-03T05:51:58Z
---

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

## The crux to resolve in design (do NOT skip)
The port is an **oracle-locked transliteration of XS**, with C-XS as a permanent
**differential oracle** on `(result, computron)`. XS meters string chunk allocation
and concatenation (`fxNewChunk`, `fxConcatString`) **by CESU-8 byte length**.
Switching storage to UTF-16 therefore forces an explicit decision:
- **(a) Preserve meter parity** — keep the meter computed on a CESU-8-length basis
  (compute the CESU-8 byte length for metering even though bytes are stored as
  UTF-16), so computron counts stay identical to C-XS and the differential oracle
  keeps passing. (Preferred default unless there's a reason to diverge.)
- **(b) Formally diverge the meter** — re-base string metering on UTF-16 units and
  update the oracle's expected computrons + any Agoric meter-version implications.
  Heavier; only if (a) proves untenable.
Observable JS semantics stay identical either way (UTF-16 is the JS-native view);
the risk is entirely in metering determinism and the snapshot/FourCC string atoms.

## Scope / touch points
- `endor-vm` chunk-backed string values (the `228ee790b` surface): storage,
  literals, concat, comparison, `typeof`, rendering.
- Delete the O(1)-index hacks/fast-paths once UTF-16 makes them unnecessary.
- Snapshot grammar: ensure string atoms still round-trip under the new encoding.
- Differential/test262 harness: re-run to confirm result parity + the chosen
  meter-parity story; add index-heavy and supplementary-plane (surrogate-pair)
  cases (`charCodeAt`/`codePointAt`/slicing across a surrogate boundary).
- Any C-FFI / xsnap boundary where raw string bytes cross.

## Suggested shape when promoted
Designer revisits the string-representation section of
`designs/xs2rust-endor-engine.md` and picks (a)/(b) with rationale; then a build
stage swaps the representation and removes the hacks; then a test stage proves
parity. If it decomposes into ordered steps, run it as an orchestration.
