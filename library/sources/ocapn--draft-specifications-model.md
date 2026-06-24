---
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
section_count: 11
status: current
notes: First ingestion from the upstream protocol's spec (held at kriscendobot/ocapn). Per project rules, source_repo names the fork; abstracts and bodies are specific (internal journal usage), but outward-facing artifacts citing this material should prefer oblique references. Every section carries explicit notes: cross-references to the corresponding Endo pass-style or marshal sections, surfacing the value-model overlap the maintainer flagged when scheduling this ingest.
---

> Abstract: The upstream protocol's value-model spec. 11 sections cover the framing (Value/Atom), the 8 atom types (Undefined, Null, Boolean, Integer, Float64, String, Symbol, ByteArray), the 3 container types (List, Struct, Tagged), the 2 reference types (Target, Promise), Error, the round-trip Pass Invariant, and JSON Invariants. Each section's `notes:` field cross-references the Endo realization (pass-style README sections, marshal README sections, pass-style/doc guarantees, eventual-send HandledPromise) so an agent traversing the library can navigate from spec to implementation and back.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/ocapn--draft-specifications-model--overview.md) | ocapn, marshal, pass-style | current |
| [value-and-atom-frame](../sections/ocapn--draft-specifications-model--value-and-atom-frame.md) | ocapn, marshal, pass-style | current |
| [atom-types](../sections/ocapn--draft-specifications-model--atom-types.md) | ocapn, marshal, pass-style | current |
| [container-list](../sections/ocapn--draft-specifications-model--container-list.md) | ocapn, marshal, pass-style | current |
| [container-struct](../sections/ocapn--draft-specifications-model--container-struct.md) | ocapn, marshal, pass-style | current |
| [container-tagged](../sections/ocapn--draft-specifications-model--container-tagged.md) | ocapn, marshal, pass-style | current |
| [reference-target](../sections/ocapn--draft-specifications-model--reference-target.md) | ocapn, capability-security, captp | current |
| [reference-promise](../sections/ocapn--draft-specifications-model--reference-promise.md) | ocapn, capability-security, captp, eventual-send | current |
| [error](../sections/ocapn--draft-specifications-model--error.md) | ocapn, errors, marshal | current |
| [pass-invariant](../sections/ocapn--draft-specifications-model--pass-invariant.md) | ocapn, marshal, pass-style | current |
| [json-invariants](../sections/ocapn--draft-specifications-model--json-invariants.md) | ocapn, marshal, pass-style | current |

## Notable overlaps with the Endo realization

- **Integer/Float64 split**: the upstream protocol distinguishes Integer and Float64 atoms; Endo's pass-style merges them into JS `number` (with BigInt for safe-integer overflow). This is a real shape disagreement and worth a maintainer note.
- **Struct keys**: OCapN Struct uses Symbol keys; pass-style copyRecord uses string keys. Worth flagging as a wire-format consideration when interoperating.
- **Promise resolution**: OCapN's Promise atom describes wire-level resolution semantics that match HandledPromise in @endo/eventual-send.
- **Tagged**: OCapN Tagged is a near-exact match for pass-style tagged / makeTagged.
- **Error**: OCapN Error carries name+message; Endo's distributed-error plans (docs/errors.md) extend with identifier-correlation for source-side log lookup.

## Provenance

- File last modified 2025-06-23 by Mark S. Miller.
- Captured at upstream commit `971eadd1`.
- Held at `kriscendobot/ocapn` per the ocapn project's engagement rules.

Source: `draft-specifications/Model.md` at commit `971eadd1`.
