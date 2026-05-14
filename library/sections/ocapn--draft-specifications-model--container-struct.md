---
title: Container: Struct
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
notes: Cross-reference: library/sections/endo--pkg-pass-style-doc-copyrecord-guarantees--overview.md. The symbol-vs-string key disagreement is worth flagging to the maintainer.
---

> Abstract: OCapN Struct: an unordered map from symbols to values. Maps to pass-style copyRecord with one important difference: OCapN Struct keys are Symbols (with restrictions); copyRecord keys are strings (also with restrictions). Both forbid arbitrary keys and require all values be passable.

## Struct

([JSON](#json-invariants))

> The name "struct" is tentative.
> https://github.com/ocapn/ocapn/pull/125

A collection of unordered (key, value) pairs.
Each key must be a [String](#string), and must be
non-[Equal](#pass-invariant-equality) to any other key within a Struct.
[Values](#value) within a Struct may be of heterogeneous type.

> - **Guile**: `make-tbd-hash` a hash of undecided type
> - **JavaScript**: `{}`
> - **Python**: `{}`
>
> For the purposes of surviving a round trip, the order of appearance of
> entries in the struct must not be important for determining equivalence.
> A struct representation concretely using one key order may validly
> round-trip into a struct representation using another key order.
> However, we encourage concrete representations to use some canonical key
> order, though this is not a concern of the abstract syntax and data model.
>
> A JavaScript object that owns any symbol-keyed properties or uses a prototype
> other than `Object.prototype` cannot be passed as an OCapN struct.
> The key `Symbol.for('passStyle')` is special and indicates the kind of OCapN
> value the object represents.

A pair of structs are Equal for purposes of [Pass Invariant
Equality](#pass-invariant-equality) if they mutually posses a value for every
key in the other struct and every respective value is equal to their own,
transitively.

> A pair of structs may be Equal regardless of the order of appearance of
> fields.


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
