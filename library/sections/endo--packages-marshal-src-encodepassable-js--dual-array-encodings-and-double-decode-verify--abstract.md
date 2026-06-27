---
title: Abstract
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

`encodePassable.js` carries **two parallel array encodings**: the
`legacyOrdered` format uses `[` as the start-of-array marker, U+0000
NULL as the element terminator, and U+0001 START OF HEADING as the
escape prefix for embedded U+0000 or U+0001 bytes; the
`compactOrdered` format uses `^` as the start-of-array marker and a
literal space (U+0020) as the element terminator. The `compactOrdered`
format omits per-element escaping at the array level because each
element's string-encoded form has already had the reserved characters
escaped at the string level (sister section). The wire-bytes tradeoff:
`compactOrdered` pays string-level overhead only for characters that
actually appear, while `legacyOrdered` paid array-level overhead on
every element's encoded bytes regardless of content. The encoder
*additionally* applies a **double-decode verification step** to the
output of every user-provided `encodeRemotable` / `encodePromise` /
`encodeError` callback in the `compactOrdered` format: it wraps the
candidate encoding inside a synthetic three-element array between
`null` markers, decodes it back, and confirms the round trip matches.
That check enforces the invariant that user-provided encodings must
remain free of C0 controls and must be safely embeddable inside an
encoded array — i.e., the user cannot accidentally inject an
array-element terminator or escape prefix and break the framing.

In code quotations below, U+0000 is rendered as `<NUL>` and U+0001
as `<SOH>` to keep the file readable; the upstream source uses
the literal control characters.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L332-L475) at commit `c423ed37`.
