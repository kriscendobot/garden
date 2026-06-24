---
title: Abstract
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "138-187"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why encodeToSmallcaps must produce a canonical JSON encoding (equal passables must JSON.stringify-equal), the copyRecord key-sort that achieves it, and the canonical-JSON aspiration the current implementation falls short of"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants
---

Smallcaps' encoding must be **canonical**: any two passables that
the distributed-object semantics considers equal must produce
`JSON.stringify`-byte-equal encodings. The longform JSDoc above
`encodeToSmallcaps​Recur` explains that two sources of
non-determinism stand in the way of canonicity. First, copyRecord
own-property *enumeration* order can differ between two records
the semantics considers equal; the encoder defends by sorting the
property names before traversal, leaning on `JSON.stringify`'s
guarantee to walk own-string-keyed properties in the order they
appear in the input object. Second, all *other* node types
(taggeds, errors, the special-prefix strings) are visited in the
order their object-literal expressions appear in the encoder
source, which agrees with canonical-JSON for copyRecord keys but
not in general. The comment marks the residual non-canonicalness
as a TODO: a canonical-JSON encoder would close the gap modularly.
The canonicity invariant exists to **reduce non-determinism
exposed outside a vat**, not because any reader inside marshal
should care about field order; readers must not depend on order at
all. The comment is the canonical source for this invariant, which
the smallcaps cheatsheet documents only obliquely as "keys sorted."

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L138-L187) at commit `e56bf00f`.
