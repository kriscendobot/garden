---
title: Value and Atom (frame)
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
---

> Abstract: The Value top-level definition and Atom sub-category framing. Distinguishes Atom (primitives + ByteArray) from Container, Reference, Error. The Endo equivalent splits primitives across pass-style's primitive pass-styles (undefined, null, boolean, number, bigint, string, symbol).

# Value

A value is any [Atom](#atom), [Container](#container),
[Reference](#reference-capability), or [Error](#error).

Atoms:

- [Undefined](#undefined)
- [Null](#null)
- [Boolean](#boolean)
- [Integer](#integer)
- [Float64](#float64)
- [String](#string)
- [ByteArray](#bytearray)
- [Symbol](#symbol)

Containers:

- [List](#list)
- [Struct](#struct)
- [Tagged](#tagged)

References:

- [Target](#target)
- [Promise](#promise)

# Atom

Atoms are values that cannot contain or refer to other values.


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
