---
title: Translation
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "86-158"
source_commit: c423ed37b4c574aaccd778fc72acb2ff8910d586
comment_subject: "IEEE-754 double-to-bits encoding with sign-aware bit-complement so the base-16 ASCII of the bytes sorts lexicographically in the same order the floats sort numerically; lockdown-independent NaN canonicalization with a WebIDL-shaped canonical NaN constant"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement
---

| encodePassable idiom | Adjacent vocabulary |
|---|---|
| "C union" | the `BigUint64Array` + `DataView` aliasing trick over a single backing buffer |
| "lockdown-independent NaN canonicalization" | the rationale for a marshal-side canonical NaN constant; SES's tame-array shim is the alternative |
| "sign-aware bit-complement" | the two XOR masks (`0x8000000000000000n` for positive, `0xffffffffffffffffn` for negative) |
| "lexicographic sort order matches numeric order" | the encoding invariant; "rank-order preserving" is the same idea named at the concept level |

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L86-L158) at commit `c423ed37`.
