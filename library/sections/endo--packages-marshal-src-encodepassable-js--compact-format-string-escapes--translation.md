---
title: Translation
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "249-330"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "The compactOrdered encoding moves array element-terminator escaping from per-element to per-string: control characters and the array-element terminator are escaped at the string level via a contiguous-range mapping that preserves lexicographic order"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes
---

| encodePassable idiom | Adjacent vocabulary |
|---|---|
| "compactOrdered" | the v2 string-escaped format introduced in PR #1260; contrasts with legacyOrdered's array-escaped form |
| "stringEscapes" | the module-scope sparse array indexed by code point; the canonical escape table |
| "element terminator" | space (0x20) in compactOrdered; U+0000 NULL in legacyOrdered |
| "escape prefix" | `!` (0x21) in compactOrdered string escapes; U+0001 in legacyOrdered array escapes |
| "format discriminator" | the leading `~` byte in compactOrdered encoded output |

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L249-L330) at commit `e6192056`.
