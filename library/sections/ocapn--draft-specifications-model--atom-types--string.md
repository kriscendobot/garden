---
title: String
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
notes: Cross-reference: library/sections/endo--pkg-pass-style-readme--pass-styles.md enumerates the pass-style side; library/sections/endo--pkg-marshal-readme--beyond-json.md describes smallcaps's wire-format choices.
parent: ocapn--draft-specifications-model--atom-types
---

([JSON](#json-invariants)†)

A sequence of Unicode code points excluding surrogates (U+D800-U+DFFF).
Strings are distinguished from [Symbols](#symbol) by type, not content.

> - **Guile**: `""`
> - **JavaScript**: `''`
> - **Python**: `''`
>
> †Strings participate in the [JSON subset](#json-invariants) of OCapN except
> any strings that contain surrogate code points.
>
> A string's content must be expressible in UTF-8.
> Some two-byte Unicode encodings, as in JavaScript strings, can contain
> 16-bit surrogate code _units_ in the range from 0xD800-0xDFFF.
> Pairs of surrogate code units correspond to a single Unicode code _point_
> greater than or equal to U+10000 and can be expressed in UTF-8.
> However unpaired or lone surrogates have no valid expression in any UTF
> and so cannot be carried by OCapN.
>
> Notes: [January 2024 meeting
> notes](https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2024-01-09.md)
> record that we agreed that strings can only be well-formed Unicode, that is,
> cannot contain unpaired surrogate code points.
> For JavaScript, if a string does not pass [the `isWellFormed`
> predicate](https://github.com/tc39/proposal-is-usv-string), then it is not a
> Passable string.

For purposes of [Pass Invariant Equality](#pass-invariant-equality), a pair of
Strings are equal if they have the same quantity of Unicode code points and
have the same respective Unicode code points in order.

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
