---
title: Refinements — the goal of carrying value constraints to key ranges
source: notes/refinements.md
source_repo: dialog-db/dialog-db
source_commit: d8c90b907a6c726e3db38199cb1b9908ddbfc64d
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, change-propagation]
status: current
---

> Abstract: A design note for the refinement layer (dialog-db-51): how a constraint a rule proves about a variable's *values* (not just its types) travels from the predicate that proved it, through inference, to the storage boundary, where it becomes index key-range bounds. `?a.starts_with("person/")` already narrows `?a`'s kind to the textual members the prefix could begin, but the *prefix itself* is knowledge: a scan feeding `?a` need not read the whole attribute index and filter — it can read only the `person/*` key range. The refinement layer makes such constraints first-class on the type lattice so one mechanism carries them end to end (`starts-with schema → inference (meet) → planner stamp → selector → key range`). Downstream, the same narrowed kinds are what demand covers are computed from, so subscriptions watch less and partial replication pulls less (M5); M3's concept-membership constraints on Entity are the same mechanism with a different payload. Companion to `formula-schemes.md` (the predicates that produce refinements) and the planned order-preserving value encoding (dialog-db-57).

> Design note for the refinement layer (dialog-db-51): how a constraint a rule proves about a variable's *values* (not just its types) travels from the predicate that proved it, through inference, to the storage boundary, where it becomes index key-range bounds. Companion to [`formula-schemes.md`](./formula-schemes.md) (the predicates that produce refinements) and the planned order-preserving value encoding (dialog-db-57, which widens what can consume them).

## Goal

`?a.starts_with("person/")` narrows `?a`'s kind to the textual members the prefix could begin — that landed with the predicates. But the *prefix itself* is knowledge too: a scan feeding `?a` need not read the whole attribute index and filter; it can read only the `person/*` key range. The refinement layer makes such constraints first-class on the type lattice so that one mechanism carries them end to end:

```
starts-with schema  →  inference (meet)  →  planner stamp  →  selector  →  key range
```

Downstream, the same narrowed kinds are what demand covers are computed from, so subscriptions watch less and partial replication pulls less (M5); M3's concept-membership constraints on Entity are the same mechanism with a different payload.

Source: [notes/refinements.md](https://github.com/dialog-db/dialog-db/blob/d8c90b907a6c726e3db38199cb1b9908ddbfc64d/notes/refinements.md) at commit `d8c90b90`.
