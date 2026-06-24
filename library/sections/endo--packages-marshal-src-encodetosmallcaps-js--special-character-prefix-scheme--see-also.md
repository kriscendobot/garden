---
title: See also
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "34-77"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Smallcaps' reserved special-character range (BANG `!` 33 to DASH `-` 45) and the prefix assignments that turn JSON strings into a tagged representation"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme
---

- [`endo--pkg-marshal-docs-smallcaps-cheatsheet--overview`](endo--pkg-marshal-docs-smallcaps-cheatsheet--overview.md) — the reference table that pairs JS values to their smallcaps encodings; this comment-fragment section explains *why* the prefix scheme has the shape that table records.
- [`endo--pkg-marshal-readme--beyond-json`](endo--pkg-marshal-readme--beyond-json.md) — the marshal README's framing of the smallcaps-vs-capdata wire choice.
- [`ocapn--draft-specifications-model--json-invariants`](ocapn--draft-specifications-model--json-invariants.md) — the upstream protocol's specification of the JSON round-trip invariant that smallcaps must preserve.
- [`endo--pkg-pass-style-readme--passable-values`](endo--pkg-pass-style-readme--passable-values.md) — the list of passable values smallcaps encodes; each non-JSON-native pass style maps to one of the seven assigned sigils.
- [[smallcaps-encoding]] — the concept page for smallcaps' wire format.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L34-L77) at commit `e56bf00f`.
