---
title: Container: List
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
notes: Cross-reference: library/sections/endo--pkg-pass-style-doc-copyarray-guarantees--overview.md is the matching Endo-side guarantees doc.
---

> Abstract: OCapN List: an ordered sequence of values. Maps directly to pass-style copyArray. Wire-level invariants for List (dense, no holes, all elements passable) match copyArray-guarantees.md verbatim.

# Container

A container is a value that contains other values.

## List

([JSON](#json-invariants))

A list of any quantity of values.

> - **Guile**: `'()`
> - **JavaScript** and **JSON**: `[]`
> - **Python**: `()` (We have not discussed whether to use tuple or list. Tuple
>   is less mutable, though enforcing immutability in Python is not likely to be
>   a goal the way it is in hardened JavaScript.)
>
> Lists participate in the JSON subset of OCapN.
>
> We achieved consensus to name the type "List" at the [November 14, 2023]
> (https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2023-11-14.md)
> meeting.

A pair of lists are equal or Equal for purposes of [Pass Invariant
Equality](#pass-invariant-equality) if they are the same length and every
respective value is equal, transitively.


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
