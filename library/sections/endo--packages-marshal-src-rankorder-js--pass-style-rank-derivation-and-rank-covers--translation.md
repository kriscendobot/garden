---
title: Translation
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "107-148"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "How rankOrder.js sorts and walks passStylePrefixes to derive per-PassStyle rank index and rank cover; the BMP/printable-ASCII assumption on prefixes; the multi-character-prefix sortedness assertion; why getPassStyleCover advertises that the cover may be an overestimate (no smallest/biggest bigint forces bounding by adjacent style boundaries)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--pass-style-rank-derivation-and-rank-covers
---

| rankOrder idiom | Adjacent vocabulary |
|---|---|
| "passStyleRanks" | the derived record mapping each PassStyle to its index (sort position) and its cover (a [low, high) bracket pair) |
| "RankCover" | a [low, high] pair of Passables whose lexicographic-with-rank-comparator range contains every encoded value of a given PassStyle (plus possibly some adjacent values to be filtered) |
| "trivialComparator" | the wrapper around native `<`/`===`/`>` returning -1/0/1; used here because all prefixes are in the BMP printable-ASCII range |
| "BMP / printable-ASCII assumption" | the constraint that every character in `passStylePrefixes` is a code unit U+0000-U+FFFF (in practice 0x20-0x7E), so JavaScript's native string comparison agrees with code-point order |
| "sortedness assertion" | the `prefixes === prefixes.split('').sort().join('')` check that catches an out-of-order multi-character prefix before it silently produces an empty or wrong cover |
| "overestimate" | a cover whose range contains every value of the target PassStyle *and possibly some adjacent values*; intentional consequence of the unbounded-bigint problem |

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L107-L148) at commit `337d16a8`.
