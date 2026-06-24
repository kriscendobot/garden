---
title: ByteArray
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

An array of 8-bit bytes.

> - **Guile**: `#vu8()`
> - **JavaScript**: `new ArrayBuffer()`
> - **Python**: `b''`
>
> Tracking: https://github.com/ocapn/ocapn/issues/48
>
> At the [November 14, 2023]
> (https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2023-11-14.md)
> meeting, we agreed to settle on the prefix "byte" and agreed to decide at the
> next meeting based on a [reactji poll]
> (https://github.com/ocapn/ocapn/issues/48#issuecomment-1811097196).
>
> [January 2024 meeting
> notes](https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2024-01-09.md)
> record that we agreed on ByteArray because it was the winner of the poll, and
> we had already agreed to resolve this specific issue by poll among these
> three choices.
>
> The JavaScript representation of a ByteArray is an `ArrayBuffer` which may
> be made immutable with the proposed JavaScript [Immutable
> ArrayBuffer](https://github.com/tc39/proposal-immutable-arraybuffer) feature.

For purposes of [Pass Invariant Equality](#pass-invariant-equality), a pair of
ByteArrays are equal if they have the same quantity of bytes and have the same
respective bytes in order.

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
