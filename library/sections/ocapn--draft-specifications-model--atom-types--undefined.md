---
title: Undefined
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

A value representing the absence of a value.

> - **Guile**: `*unspecified*`
> - **JavaScript**: `undefined`
> - **Python**: `None`

If a JavaScript implementation of OCapN receives a [Struct](#struct) with an
Undefined value for some key, the struct must be represented as an object
that owns a property with the value `undefined` for that key.

> Consequently, `JSON.stringify` for the same OCapN struct will omit the
> property from the generated JSON object.

For purposes of [Pass Invariant Equality](#pass-invariant-equality),
there is only one Undefined value and it is equal to itself.

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
