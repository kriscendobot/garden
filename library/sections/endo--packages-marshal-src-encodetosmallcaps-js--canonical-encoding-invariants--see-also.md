---
title: See also
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "138-187"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why encodeToSmallcaps must produce a canonical JSON encoding (equal passables must JSON.stringify-equal), the copyRecord key-sort that achieves it, and the canonical-JSON aspiration the current implementation falls short of"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants
---

- [`endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme`](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) — the prefix-scheme's contiguous-range design is what makes the property-name sort canonical across the special-character escape.
- [`endo--pkg-marshal-docs-smallcaps-cheatsheet--overview`](endo--pkg-marshal-docs-smallcaps-cheatsheet--overview.md) — documents the "keys sorted" rule for copyRecord without explaining its rationale; this section is the rationale.
- [`endo--pkg-pass-style-doc-copyrecord-guarantees--overview`](endo--pkg-pass-style-doc-copyrecord-guarantees--overview.md) — the upstream invariant on copyRecord (string-keyed-only, frozen, every value passable) that lets the sort-then-encode pattern work.
- [`endo--pkg-pass-style-doc-enumerating-properties--overview`](endo--pkg-pass-style-doc-enumerating-properties--overview.md) — the pass-style discipline on how properties are enumerated.
- [`ocapn--draft-specifications-model--json-invariants`](ocapn--draft-specifications-model--json-invariants.md) — the upstream protocol's canonicity expectation that smallcaps realizes.
- [[smallcaps-encoding]] — the concept page for smallcaps' wire format.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L138-L187) at commit `e56bf00f`.
