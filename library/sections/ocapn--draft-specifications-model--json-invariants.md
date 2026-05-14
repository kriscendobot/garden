---
title: JSON Invariants
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
notes: Cross-reference: library/sections/endo--pkg-marshal-readme--beyond-json.md, library/sections/endo--pkg-marshal-docs-smallcaps-cheatsheet--overview.md.
---

> Abstract: OCapN's spec for how Model values relate to JSON. Describes which OCapN values are JSON-representable directly and which need extension. The Endo smallcaps wire format extends JSON with the prefix-character-encoded extensions per packages/marshal/README's beyond-json section; this OCapN section is the wire-level spec the Endo extension realizes.

# JSON Invariants

OCapN holds invariant that:

- Any JSON text that a JavaScript peer can produce using
  `JSON.stringify`,
- excluding those in which the Unicode representation of any object member name
  or string includes a surrogate code point,
- can then be read back with `JSON.parse`,
- sent to any other OCapN peer,
- returned from any OCapN peer,
- then saved back to an equivalent JSON text with `JSON.stringify`.

> For this reason, OCapN supports a distinct [Undefined](#undefined)
> and [Null](#null).
> If OCapN coerced `null` to `undefined`, a JSON text like `{"key": null}`
> would become `{"key": undefined}` passing through an OCapN network, and
> consequently reduce to `{}` when returned to JSON format with
> `JSON.stringify`.
> If OCapn coerced `undefined` to `null`, an idiomatic JavaScript options
> object like `{"key": undefined}` would return through the OCapN network as
> `{"key": null}` and would `key` would no longer pass `key === undefined`
> checks.
> If OcapN refused to pass documents with either `null` or `undefined`, OCapN
> would have too great an impedence mismatch with either idiomatic JSON
> documents or idiomatic use of JavaScript objects.
>
> OCapN maintains that -0 and 0 are distinct [Pass Invariant](#pass-invariant)
> values, whereas JavaScript's `JSON.stringify` renders -0 as `0`.
> This is consistent with OCapN's JSON Invariants because all pass-invariant
> JSON texts are in the range of `JSON.parse(JSON.stringify(x))`, which
> cannot express -0.
> This holds without regard for -0 being in the range of `JSON.parse`,
> including `JSON.parse('-0')`, because of the narrowing behavior of
> `JSON.stringify`.
>
> OCapN does not hold invariant the preservation of arbitrary JSON texts
> through arbitrary JSON implementations in arbitrary languages.

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
