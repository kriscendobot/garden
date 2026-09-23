---
title: Translation
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

| rankOrder idiom | Adjacent vocabulary |
|---|---|
| "full order" | a strict total order that ties no two remotables; opposite of rank order's NaN-based all-remotables-tied default |
| "strict refinement" | the relation "every array sorted by the full-order comparator is also rank-sorted by the corresponding rank comparator"; consequence of the full-order being a strict superset of the rank-order's deterministic decisions |
| "BEWARE: observable mutable state" | the hazard that a shared full-order comparator's ordinal table is queryable, creating a covert channel between subsystems holding it |
| "fresh comparator" | a kit whose `seen` table is empty; freshly constructed |
| "scalars-cross-fresh-comparators" | the narrow invariant that scalar arrays (no remotables) sorted by one fresh full-order comparator remain sorted under any other fresh full-order comparator |
| "no memory of deleted keys" | the property that disqualifies the kit from use in persistent stores; re-adding a deleted key produces a different ordinal |
| "longLived parameter" | the WeakMap vs Map choice; default `Map` for short-lived kits where the leak is bounded; opt-in `WeakMap` for long-lived kits where remotable GC matters |
| "ordinal-mapping table" | the persistent alternative for stores (per encodePassable.js's `\|` ordinal-mapping prefix); a separate keyed table from remotable → ordinal that survives deletion |

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L598-L642) at commit `337d16a8`.
