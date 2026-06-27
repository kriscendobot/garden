---
title: "`sameValueZero` and `compareNumerics`: the rank-order equality predicate, the NaN-self-equal-and-last placement, the +0/-0 collapse, and the `ENDO_RANK_STRINGS` mode selector"
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
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics--abstract.md)
- [Body](endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics--body.md)
- [Translation](endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics--translation.md)
- [See also](endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics--see-also.md)

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L19-L237) at commit `337d16a8`.
