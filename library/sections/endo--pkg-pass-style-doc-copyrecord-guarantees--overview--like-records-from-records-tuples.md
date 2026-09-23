---
title: Like Records from Records & Tuples.
source: packages/pass-style/doc/copyRecord-guarantees.md
source_repo: endojs/endo
source_commit: be51fb10b6f4
source_date: 2023-11-30
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
parent: endo--pkg-pass-style-doc-copyrecord-guarantees--overview
---

Taken together, the security, robustness, and simplicity guarantees of `assertRecord(r)` are similar to that provided by the "records" of the TC39 "Records and Tuples" proposal. (TODO need link) These are close enough that, for many purposes, we can take CopyRecord as a shim for that portion of the Records and Tuples proposal. We can equally well take [CopyArray](./copyArray-guarantees.md) as a shim for the "tuples" of the "Records and Tuples" proposal.

Source: [packages/pass-style/doc/copyRecord-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyRecord-guarantees.md) at commit `be51fb10`.
