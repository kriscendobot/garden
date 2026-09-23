---
title: Record
source: draft-specifications/Notation.md
source_repo: kriscendobot/ocapn
source_commit: e5e153554321895fc7e8c47d4b3741f82ad7adb2
source_date: 2025-06-19
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn]
status: current
notes: Possible terminology mismatch with ocapn--draft-specifications-model--container-list/struct/tagged. Model has Struct + List + Tagged; Notation has Struct + List + Record. Worth flagging to the maintainer.
parent: ocapn--draft-specifications-notation--containers
---

A tuple of any quantity of values.

> Examples:
> - `<foo 1 2 3>` corresponds to `<3'foo 1+ 2+ 3+>`
> - `<'foo 1 2 3>` corresponds to `<3'foo 1+ 2+ 3+>`
> - `<"foo 1 2 3>` corresponds to `<3"foo 1+ 2+ 3+>`

- _abstract-record_: `<` _abstract-value_ * `>`
- _concrete-record_: `<` _concrete-field_ * `>`
- _concrete-field_: _concrete-field-name_ / _concrete-value_
- _concrete-field-name_: _name_ :: Corresponding to a symbol.

> The first value is typically a symbol to multiplex the shapes and behaviors
> implied by the record, but may be any value.

The notation allows a shorthand where the first value of a record may be a bare
alphanumeric name without a prefix `'`, in which case he value is a
[Symbol](#symbol).

> Records do not correspond to a paricular type in the [Model](Model.md), but
> are instrumental in representing messages in the
> [protocol](CapTP%20Specification.md) and envelope many types in the concrete
> representation of the passable data model.
>
> The name "record" does not indicate a relationship to TypeScript records.
> They are more analogous to Python tuples.

Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
