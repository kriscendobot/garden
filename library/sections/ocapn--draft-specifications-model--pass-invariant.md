---
title: Pass Invariant
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, marshal, pass-style]
status: current
notes: Cross-reference: library/sections/endo--pkg-pass-style-doc-copyarray-guarantees--overview.md, library/sections/endo--pkg-pass-style-doc-copyrecord-guarantees--overview.md, library/sections/endo--pkg-marshal-readme--frozen-objects-only.md.
kind: index
section_count: 3
---

> Abstract: OCapN Pass Invariant: the round-trip-stability requirement for the wire format. A value serialized and then deserialized must yield an equivalent value. Two sub-sections cover Pass Type Invariant (the type is preserved) and Pass Invariant Equality (the equality predicate is preserved). The Endo equivalent invariants are scattered across pass-style/doc/copyArray-guarantees, copyRecord-guarantees, and the marshal README's frozen-objects-only and beyond-json sections.

Sections:

- [Pass Invariant](ocapn--draft-specifications-model--pass-invariant--pass-invariant.md)
- [Pass Type Invariant](ocapn--draft-specifications-model--pass-invariant--pass-type-invariant.md)
- [Pass Invariant Equality](ocapn--draft-specifications-model--pass-invariant--pass-invariant-equality.md)

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
