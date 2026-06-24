---
title: Like Tuples from Records & Tuples.
source: packages/pass-style/doc/copyArray-guarantees.md
source_repo: endojs/endo
source_commit: be51fb10b6f4
source_date: 2023-11-30
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
parent: endo--pkg-pass-style-doc-copyarray-guarantees--overview
---

Taken together, the security, robustness, and simplicity guarantees of `assertCopyArray(arr)` are similar to that provided by the "tuples" of the TC39 "Arrays and Tuples" proposal. (TODO need link) These are close enough that, for many purposes, we can take CopyArray as a shim for that portion of the Arrays and Tuples proposal. We can equally well take CopyRecord as a shim for the "records" of the "Records and Tuples" proposal.

Source: [packages/pass-style/doc/copyArray-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyArray-guarantees.md) at commit `be51fb10`.
