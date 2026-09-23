---
title: "`makeFullOrderComparatorKit`: the strict refinement of rank order via first-seen-ordering of remotables; the BEWARE on observable mutable state; the fresh-comparator-of-scalars invariant; the no-store-ordering caveat; the long-lived vs short-lived WeakMap/Map choice"
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "598-642"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Why makeFullOrderComparatorKit assigns remotables an order by first-seen-time; the BEWARE that this is observable mutable state and unsharable across subsystems that must not communicate; why fresh full-order comparators preserve already-sorted scalar arrays but not passable arrays in general; why the kit cannot be used for store ordering (no memory of deleted keys); the longLived parameter's WeakMap vs Map trade-off"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
kind: index
section_count: 4
---

Sections:

- [Abstract](endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state--abstract.md)
- [Body](endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state--body.md)
- [Translation](endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state--translation.md)
- [See also](endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state--see-also.md)

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L598-L642) at commit `337d16a8`.
