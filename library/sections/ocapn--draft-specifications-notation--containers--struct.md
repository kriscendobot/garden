---
title: Struct
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

> The name "struct" is tentative.
> https://github.com/ocapn/ocapn/pull/125

A collection of unordered (key, value) pairs.

> Examples:
> - `{ a: 10, b: 2 }` corresponds to `{ 1"a 10+ 1"b 2+ }`.
> - `{ "a": 10, "b": 2 }` corresponds to `{ 1"a 10+ 1"b 2+ }`.
> - `{ 'a: 10, 'b: 2 }` corresponds to `{ 1'a 10+ 1'b 2+ }`.

- _abstract-struct_: `{` ( _abstract-field_ ( `,` _abstract-field_ )* )? `}`
- _abstract-field_: _abstract-key_ `:` _abstract-value_
- _abstract-key_: _abstract-field-name_ / _abstract-value_
- _abstract-field-name_: _name_ :: Corresponding to a string.
- _concrete-struct_: `{` _concrete-field_* `}`
- _concrete-field_: _concrete-key_ _concrete-value_
- _concrete-key_: _concrete-value_ :: The concrete representation lacks an analog for the abstraction notation’s string key shorthand.

> The [Model](Model.md) limits field names in structs to strings, but for
> purposes of [CapTP](CapTP%20Specification.md) surrounding data, the notation
> and representation allow any value.

The abstract notation allows a shorthand where a field name may be an alphanumeric ASCII
name without a prefix `"`, in which case the field name is a [String](#string).

Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
