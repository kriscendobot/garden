---
title: OCapN Notation (overview)
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
notes: Companion to ocapn--draft-specifications-model--*. Model.md defines the value types; this Notation.md defines how those types are written in spec text.
---

> Abstract: The notation used throughout the upstream protocol's spec documents. Defines a meta-notation, then walks through how each Value type is written in that notation. Companion document to Model.md (the data model itself).


# Notation

The OCapN specification uses an Abstract Notation for the corresponding
Concrete Representation of messages.
This document describes both the notation and representation.
The [CapTP Specification](CapTP%20Specification.md) and [Model](Model.md) documents
employ the abstract notation to imply the conrete representation.

The concrete representation is a binary encoding that is occasionally and
incidentally human-readable.

The abstract notation is human-readable and human-writable and is not intended
for machine processing.
The abstract notation does not attempt to comprehensively cover all expressible
concrete messages, but is suitable for expressing all the specification and
examples.

> The abstract notation comes from
> [Preserves](https://preserves.gitlab.io/preserves/TUTORIAL.html).
> The concrete representation is a subset of
> [Syrup](https://github.com/ocapn/syrup).


Source: `draft-specifications/Notation.md` at commit `e5e15355` (held at kriscendobot/ocapn).
