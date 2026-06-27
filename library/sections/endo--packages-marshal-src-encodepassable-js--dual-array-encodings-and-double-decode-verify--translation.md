---
title: Translation
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "332-475, 770-822"
source_commit: c423ed37b4c574aaccd778fc72acb2ff8910d586
comment_subject: "Two array encodings (legacyOrdered with NUL-terminator and SOH-escape, compactOrdered with space-terminator and pre-escaped strings); the embeddability-verifying double-decode applied to user-provided remotable / promise / error encoders to keep them within the C0-control-free invariant"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify
---

| encodePassable idiom | Adjacent vocabulary |
|---|---|
| "legacyOrdered" | the v1 array-escaped format; preserved for wire-compat |
| "compactOrdered" | the v2 string-escaped format introduced in PR #1260 |
| "verifyEncoding" | the double-decode framing-check applied in compactOrdered to user-provided encoders |
| "liberal decode" | the framing-validation decode that resolves remotable / promise / error to `undefined` |
| "embeddable" | safely placeable inside an encoded array element; free of C0 controls and reserved markers |
| "C0 controls" | U+0000 through U+001F; rejected by the regex in verifyEncoding |
| "depth tracking" | the decoder's mechanism for skipping nested arrays during outer-array element extraction |

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L332-L475) at commit `c423ed37`.
