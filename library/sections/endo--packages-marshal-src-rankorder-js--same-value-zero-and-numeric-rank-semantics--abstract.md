---
title: Abstract
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "19-22, 33-46, 95-115, 218-237"
source_commit: 2e9333096fc82fabc9a3c1f6d3e268336e7df943
comment_subject: "Why marshal's rank-order equality is sameValueZero (Map/Set's equality, with NaN equal to NaN and -0 equal to 0); why compareNumerics places NaN last and self-equal; why -0 collapses to 0 in marshal's distributed semantics; why the ENDO_RANK_STRINGS environment option exists (utf16-code-unit-order vs unicode-code-point-order vs error-if-order-choice-matters)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics
---

`rankOrder.js` opens with three numeric-and-equality decisions that
together establish the foundation of marshal's rank-order regime.
The **`sameValueZero` predicate** is the equality used by JavaScript's
`Map` and `Set` (where `NaN === NaN` and `-0 === 0`) and is what
marshal uses to decide whether two passables are tied at rank 0; the
file calls out a `TODO` lamenting the EcmaScript spec name as a poor
API choice. The **`compareNumerics` function** is the per-style rank
comparator for numbers and bigints: it places `NaN` self-equal and
*after* every other number, and treats `-0` and `+0` as tied. The
**`ENDO_RANK_STRINGS` environment option** selects one of three
string-comparison modes: the default `utf16-code-unit-order`
(JavaScript's native `<` operator, the legacy behavior), the
`unicode-code-point-order` alternative (code-point-by-code-point
comparison via `compareByCodePoints`, which differs from UTF-16
unit order on surrogate-pair boundaries), and the diagnostic
`error-if-order-choice-matters` mode which runs both comparators
and fails fast on disagreement. Marshal's broader distributed-
semantics decision — `-0` serializes as `0`, so the rank-equality
treatment of `-0` matches the wire-equality treatment — is named
in the same comment.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L19-L237) at commit `2e933309`.
