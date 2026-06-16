---
title: copyArray Guarantees
source: packages/pass-style/doc/copyArray-guarantees.md
source_repo: endojs/endo
source_commit: be51fb10b6f4
source_date: 2023-11-30
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
kind: index
section_count: 4
---

> Abstract: Invariants guaranteed for copyArray values: dense numbered indices 0..length-1, no holes, no negative or non-integer keys, no extra properties beyond length, frozen. Why each invariant matters for safe cross-realm transport. Distinct from JS Array (which permits sparse and exotic properties); copyArray is the marshal-disciplined subset.

Sections:

- [Why validate that an object is a CopyArray?](endo--pkg-pass-style-doc-copyarray-guarantees--overview--why-validate-that-an-object-is-a-copyarray.md)
- [How do I enumerate thee, let me list the ways](endo--pkg-pass-style-doc-copyarray-guarantees--overview--how-do-i-enumerate-thee-let-me-list-the-ways.md)
- [Like Tuples from Records & Tuples.](endo--pkg-pass-style-doc-copyarray-guarantees--overview--like-tuples-from-records-tuples.md)
- [Like CopyRecord](endo--pkg-pass-style-doc-copyarray-guarantees--overview--like-copyrecord.md)

Source: [packages/pass-style/doc/copyArray-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyArray-guarantees.md) at commit `be51fb10`.
