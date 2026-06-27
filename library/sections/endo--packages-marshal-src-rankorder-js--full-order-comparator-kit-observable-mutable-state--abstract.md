---
title: Abstract
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
parent: endo--packages-marshal-src-rankorder-js--full-order-comparator-kit-observable-mutable-state
---

`makeFullOrderComparatorKit` is the **strict alternative to the
NaN-default rank comparator**: it constructs a `compareRemotables`
that tags each remotable on first encounter with a monotonically-
increasing integer and compares remotables by that tag. The
resulting comparator is *strictly more precise* than rank order
— any array sorted by a full order comparator passes
`isRankSorted` against the corresponding rank comparator — at
the cost of carrying **observable mutable state**. The file's
longform comment opens with a `BEWARE` clause that names the
sharing hazard: any subsystem with access to such a comparator
can probe its internal order by sorting probe values, so the
comparator must not be shared across mutually-distrusting
subsystems. Three further facts the comment names: a *fresh*
full-order comparator (one that has not yet seen any remotables)
will keep an *already-sorted scalar array* sorted under a
*different* fresh comparator (because no remotables are involved,
the only state that varies between comparators), but this is
*not* generally true for passable arrays (where remotables would
get reassigned different first-seen ordinals); the kit *cannot*
be used for store ordering because it has no memory of deleted
keys (re-adding a previously-deleted key would assign it a new
ordinal, breaking persistence invariants); and the `longLived`
parameter chooses between `WeakMap` (cheap for short-lived
comparators) and `Map` (with a leak bounded by the Map's own
lifetime, but with better performance for long-lived
comparators).

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L598-L642) at commit `337d16a8`.
