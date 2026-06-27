---
title: Translation
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "160-247"
source_commit: c423ed37b4c574aaccd778fc72acb2ff8910d586
comment_subject: "Variant Elias-delta encoding of bigints with sign-aware unary-prefix alphabets and ten's-complement digit encoding so positive and negative bigints of arbitrary magnitude sort in their natural numeric order"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets
---

| encodePassable idiom | Adjacent vocabulary |
|---|---|
| "Elias delta coding" | a length-self-delimiting code for arbitrary-precision integers; the `~`/`#` unary length-of-length is the Elias-delta variant |
| "unary string" | a count expressed as repeated marker characters (`~` or `#`) |
| "ten's complement" | the decimal-base analog of two's-complement; for each digit, replace `d` with `9 - d`; for the number `n` and digit-count `k`, replace `n` with `10^k + n` |
| "type character" | the single leading byte (`n` for negative, `p` for positive) |
| "rank-order preserving" | the sort-invariant the encoding maintains across all bigint magnitudes |

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L160-L247) at commit `c423ed37`.
