---
title: The legacyOrdered and compactOrdered array encodings, the wire-byte tradeoffs, and the embeddability-verifying double-decode check on user-supplied remotable / promise / error encodings
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "332-475, 770-822"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "Two array encodings (legacyOrdered with NUL-terminator and SOH-escape, compactOrdered with space-terminator and pre-escaped strings); the embeddability-verifying double-decode applied to user-provided remotable / promise / error encoders to keep them within the C0-control-free invariant"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify--abstract.md)
- [Body](endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify--body.md)
- [Translation](endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify--translation.md)
- [See also](endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify--see-also.md)

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L332-L475) at commit `e6192056`.
