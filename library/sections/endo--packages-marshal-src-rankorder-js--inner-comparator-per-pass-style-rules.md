---
title: "The inner comparator's per-PassStyle rank rules: tied-by-PassStyle (undefined / null / error / promise); trivial-less-than (boolean / bigint); BMP-or-code-point string order; symbol-via-name-string; per-style numeric for number; lexicographic-inverse-property-names for copyRecord; lexicographic-with-prefix for copyArray; shortlex for byteArray; tag-then-payload for tagged"
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "157-330"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "How the inner comparator dispatches per PassStyle: each per-style rank rule, including the prefix-ranking property that lets a record/array X with a subset of Y's property names or a prefix of Y's elements sort earlier; the deep-tied implication of NaN as compareRemotables default; the byteArray shortlex rule; the @endo/immutable-arraybuffer prototype-check workaround"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules--abstract.md)
- [Body](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules--body.md)
- [Translation](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules--translation.md)
- [See also](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules--see-also.md)

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L157-L330) at commit `337d16a8`.
