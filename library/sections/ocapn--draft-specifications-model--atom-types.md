---
title: Atom types (Undefined, Null, Boolean, Integer, Float64, String, Symbol, ByteArray)
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
kind: index
section_count: 8
---

> Abstract: All 8 atom types in the upstream protocol's value model. Maps to pass-style as follows: OCapN Undefined ↔ pass-style undefined; OCapN Null ↔ pass-style null; OCapN Boolean ↔ pass-style boolean; OCapN Integer + Float64 (split into two atoms in OCapN, with Float64 carrying NaN/Infinity semantics) ↔ pass-style number + bigint (Endo merges integers into the JS number atom unless they exceed safe-integer range, in which case bigint applies); OCapN String ↔ pass-style string; OCapN Symbol ↔ pass-style symbol (with well-known + registered restrictions); OCapN ByteArray ↔ no pass-style equivalent (Endo conveys ByteArrays via tagged values wrapping Uint8Array). The integer/float split is the most notable disagreement: OCapN keeps them distinct at the wire level; Endo's smallcaps wire format encodes JS numbers and BigInts but does not separately tag float-vs-integer.

Sections:

- [Undefined](ocapn--draft-specifications-model--atom-types--undefined.md)
- [Null](ocapn--draft-specifications-model--atom-types--null.md)
- [Boolean](ocapn--draft-specifications-model--atom-types--boolean.md)
- [Integer](ocapn--draft-specifications-model--atom-types--integer.md)
- [Float64](ocapn--draft-specifications-model--atom-types--float64.md)
- [String](ocapn--draft-specifications-model--atom-types--string.md)
- [Symbol](ocapn--draft-specifications-model--atom-types--symbol.md)
- [ByteArray](ocapn--draft-specifications-model--atom-types--bytearray.md)

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
