---
title: Translation
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

| Smallcaps idiom | Adjacent vocabulary |
|---|---|
| "manifest constant" | a string-position singleton (e.g., `#undefined`); the older capdata vocabulary calls these "qclass values" |
| "special prefix" | "sigil" in some adjacent docs; "tag character" in capdata's vocabulary |
| "reserved for future use" | the five undriven sigil chars; not the same as "reserved property names" (those start with `#`) |

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L34-L77) at commit `e56bf00f`.
