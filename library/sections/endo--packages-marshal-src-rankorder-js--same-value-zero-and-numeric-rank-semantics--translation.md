---
title: Translation
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "19-22, 33-46, 95-115, 218-237"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Why marshal's rank-order equality is sameValueZero (Map/Set's equality, with NaN equal to NaN and -0 equal to 0); why compareNumerics places NaN last and self-equal; why -0 collapses to 0 in marshal's distributed semantics; why the ENDO_RANK_STRINGS environment option exists (utf16-code-unit-order vs unicode-code-point-order vs error-if-order-choice-matters)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics
---

| rankOrder idiom | Adjacent vocabulary |
|---|---|
| "sameValueZero" | the SameValueZero abstract operation in the EcmaScript spec; the equality used by `Map` and `Set` for key identity; the rank-order tie predicate |
| "compareNumerics" | the per-style rank comparator for both `number` and `bigint`; places `NaN` last and self-equal; treats `+0`/`-0` as tied |
| "rank order" | the total preorder on Passables that establishes a deterministic, PassStyle-aware sort order; the basis for CopyMap/CopyBag/CopySet sorted-collection key ordering |
| "compareByCodePoints" | the code-point-iterator-based string comparator used for `unicode-code-point-order` mode |
| "trivialComparator" | the wrapper around native `<`/`===`/`>` that returns -1/0/1; used as the leaf comparator for booleans, BMP-string ranges, and the `default` numeric rank logic |
| "ENDO_RANK_STRINGS" | the env-option selector with three valid values: `utf16-code-unit-order`, `unicode-code-point-order`, `error-if-order-choice-matters` |

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L19-L237) at commit `337d16a8`.
