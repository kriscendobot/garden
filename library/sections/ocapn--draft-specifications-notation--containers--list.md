---
title: List
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

A list of any quantity of values.

> Example: `[ 1 2 3 ]` corresponds to `[ 1+ 2+ 3+ ]`.

- _abstract-list_: `[` _abstract-value_ * `]`
- _concrete-list_: `[` _concrete-value_ * `]` :: The respective concrete
  representations of the abstract values.

Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
