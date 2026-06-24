---
title: copyRecord Guarantees
source: packages/pass-style/doc/copyRecord-guarantees.md
source_repo: endojs/endo
source_commit: be51fb10b6f4
source_date: 2023-11-30
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
kind: index
section_count: 5
---

> Abstract: Invariants guaranteed for copyRecord values: own-property-only (no prototype-chain reads), string-keyed (no symbol keys), enumerable, frozen, every value is itself passable. Why each invariant matters for safe cross-realm transport. Distinct from JS Object (which permits non-enumerable, symbol-keyed, prototype-chain inheritance); copyRecord is the marshal-disciplined subset.

Sections:

- [Why validate that an object is a CopyRecord?](endo--pkg-pass-style-doc-copyrecord-guarantees--overview--why-validate-that-an-object-is-a-copyrecord.md)
- [How do I enumerate thee, let me list the ways](endo--pkg-pass-style-doc-copyrecord-guarantees--overview--how-do-i-enumerate-thee-let-me-list-the-ways.md)
- [Like Records from Records & Tuples.](endo--pkg-pass-style-doc-copyrecord-guarantees--overview--like-records-from-records-tuples.md)
- [Where CopyRecord fits in the Passable taxonomy](endo--pkg-pass-style-doc-copyrecord-guarantees--overview--where-copyrecord-fits-in-the-passable-taxonomy.md)
- [Hazards](endo--pkg-pass-style-doc-copyrecord-guarantees--overview--hazards.md)

Source: [packages/pass-style/doc/copyRecord-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyRecord-guarantees.md) at commit `be51fb10`.
