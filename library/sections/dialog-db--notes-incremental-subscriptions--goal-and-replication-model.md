---
title: Goal and replication model — demand-driven standing subscriptions over one local tree
source: notes/incremental-subscriptions.md
source_repo: dialog-db/dialog-db
source_commit: 005d8c7b123a1105a46458bea2c05d01134cacfa
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, local-first-sync]
status: current
---

> Abstract: The target architecture: **standing subscriptions that are incrementally maintained**. Today queries are evaluated from scratch per request; the goal is to register a query once and have the subscriber receive the *delta* to the result as data changes, not a recomputed result — and to do it **demand-driven**, fetching and recomputing only the data a subscription actually touches, never the whole database. The enabling replication model is that the replica is a **single local content-addressed tree**; "peers" exist only at the merge boundary, never during query evaluation. Three steps: **merge** (pull subtrees from remote peers and reconcile overlapping subtrees into one authoritative root via `Tree::integrate`, deterministic higher-hash-wins / LWW); **local evaluation** (every query runs against that single tree — no cross-peer query, no "which peer" decision); and **on-demand replication via tree access** (every tree op is parameterized by a `ContentAddressedStorage` resolving nodes by hash, so touching an unmaterialized key range lazy-loads the covering subtree from remote-capable backing storage — replication is the tree's lazy-load, driven by which subtrees a query reads, transparent to the query, not orchestrated by the planner). Two consequences this buys for free that an across-peers model would not: demand *is* the query's subtree-access pattern (the planner's existing access pattern is the demand), and **negation correctness becomes a tree-layer property** — "is `p(a)` absent?" is answered against the materialized subtree covering `a`, and content-addressing makes "is this subtree fully materialized?" checkable because a subtree's hash commits to its full contents.

## Goal

Queries today are evaluated from scratch on each request. The target is **standing subscriptions that are incrementally maintained**: a query is registered once, and as the underlying data changes the subscriber receives the *delta* to the result rather than a recomputed result. Maintenance is **demand-driven**: only the data a subscription actually touches is fetched and recomputed, never the whole database.

## Replication model

The replica is a single local content-addressed tree; "peers" exist only at the merge boundary, never during query evaluation.

1. **Merge.** Pull subtrees from the remotes that represent peers and reconcile overlapping subtrees into one logical tree. Reconciliation is deterministic at the tree layer (`Tree::integrate`, higher-hash-wins / LWW). The result is one authoritative root.
2. **Local evaluation.** Every query runs locally against that single tree. There is no cross-peer query and no "which peer" decision.
3. **On-demand replication via tree access.** Every tree operation is parameterized by a `ContentAddressedStorage` and resolves nodes by hash through it. Touching a key range that is not materialized locally fetches the covering subtree(s) from the (remote-capable) backing storage. So replication is the tree's **lazy-load**, driven by which subtrees a query reads, transparent to the query, not orchestrated by the planner.

Consequences this model gives for free, that an across-peers query model would not:

- **Demand = the query's subtree-access pattern.** What gets replicated is exactly what the query touches; the planner's existing access pattern *is* the demand.
- **Negation correctness is a tree-layer property, not a distributed one.** "Is `p(a)` absent?" is answered against the materialized subtree covering `a`. The only obligation is that the covering subtree is **fully materialized** before reading absence, and content-addressing makes that checkable (a subtree's hash commits to its full contents).

Source: [notes/incremental-subscriptions.md](https://github.com/dialog-db/dialog-db/blob/005d8c7b123a1105a46458bea2c05d01134cacfa/notes/incremental-subscriptions.md) at commit `005d8c7b`.
