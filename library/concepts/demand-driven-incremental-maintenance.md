---
id: demand-driven-incremental-maintenance
aliases: [demand-driven incremental maintenance, incremental view maintenance, IVM, magic sets, "magic sets / SIPS", SIPS, sideways information passing, demand transformation, dynamic magic sets, DBSP, differential dataflow, "push vs pull", world-driven vs query-driven, "n.p complement", complement predicate, DRed, "over-delete re-derive insert", FBF, standing subscriptions, query subscriptions, result delta, "differentiate(range)", selective replication, selective pull]
topics: [change-propagation, datalog-query]
---

# demand-driven-incremental-maintenance

Dialog's approach to incrementally maintained query results: register a query once and receive the *delta* to its result as data changes, fetching and recomputing only the data the query touches. The design (`notes/incremental-subscriptions.md`, revising the earlier `notes/dbsp.md` exploration) distinguishes two polarities. **Push / world-driven** (differential dataflow, DBSP): deltas arrive at leaves and propagate forward, and stateful operators retain their full integrated input — a cost center in direct tension with a partial replica, since it re-materializes exactly the data the replica is designed not to hold. **Pull / query-driven** (magic sets / demand transformation): the query determines what is relevant and only that is fetched. Dialog chooses **pull-driven**, keeping DBSP's algebra only as the account of *what* each incremental operator must compute. The enabler is a single local content-addressed tree whose lazy-load (subtree fetch by hash through `ContentAddressedStorage`) *is* the demand — the planner's existing SIPS is the access pattern — and which makes negation a checkable tree-materialization invariant. The technique stack: magic sets/SIPS, Dynamic Magic Sets for growing demand cones, the `n.p` complement-predicate rewrite + stratified order for negation, DRed (over-delete, re-derive, insert) with FBF for retraction, and the prolly-tree `differentiate(range)` signed delta. The build path is AST→operator IR, reify demand, subscription layer, dynamic demand maintenance.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-dbsp--context-and-storage-architecture](../sections/dialog-db--notes-dbsp--context-and-storage-architecture.md) | The top-down engine + prolly-tree store whose root-pointer change enables selective subtree replication. |
| [dialog-db--notes-dbsp--goal-hypothesis-selective-pull](../sections/dialog-db--notes-dbsp--goal-hypothesis-selective-pull.md) | The goal of DBSP-based IVM that pulls only query-relevant facts, and the unified-evaluation hypothesis. |
| [dialog-db--notes-dbsp--query-model-and-exploration](../sections/dialog-db--notes-dbsp--query-model-and-exploration.md) | The typed query model and the incremental-vs-initial selective-replication exploration. |
| [dialog-db--notes-incremental-subscriptions--goal-and-replication-model](../sections/dialog-db--notes-incremental-subscriptions--goal-and-replication-model.md) | Standing subscriptions over one local tree; demand = the query's subtree-access pattern; negation as a tree-layer property. |
| [dialog-db--notes-incremental-subscriptions--magic-sets-not-dbsp](../sections/dialog-db--notes-incremental-subscriptions--magic-sets-not-dbsp.md) | Why pull-driven magic sets over push-driven DBSP; the n.p negation rewrite and DRed retraction. |
| [dialog-db--notes-incremental-subscriptions--codebase-provides-and-build-path](../sections/dialog-db--notes-incremental-subscriptions--codebase-provides-and-build-path.md) | The planner's implicit SIPS and prolly-tree deltas already present; the four-step dependency-ordered build path. |

## See also

- [[prolly-tree]] — the content-addressed index substrate whose `differentiate` yields the signed, range-scopable delta and whose lazy-load is the demand.
- [[divergence-clock]] — the causal-ordering half of reconciliation; incremental maintenance owns evaluation, the divergence clock owns concurrent-commit ordering.
- [[merkle-crdt]] — the query-time merge semantics over the content-addressed tree the subscription reads.
- [[optional-attribute-query]] — the operator-IR split (build-path step 1) is the same rework that relocated optional-attribute set-widening.
