---
title: Demand-driven evaluation (magic sets), not DBSP — the technique stack
source: notes/incremental-subscriptions.md
source_repo: dialog-db/dialog-db
source_commit: 005d8c7b123a1105a46458bea2c05d01134cacfa
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, datalog-query]
status: current
---

> Abstract: The architectural pivot from the earlier DBSP exploration. Two evaluation polarities exist for incremental views: **push/world-driven** (differential dataflow, DBSP) where deltas arrive at the leaves and propagate forward, and stateful operators (join, dist, aggregate) *retain their full integrated input* to be ready for any delta — that retained state is the cost center and is in direct tension with a partial replica, re-materializing exactly the data the replica is designed not to hold; and **pull/query-driven** (magic sets / demand transformation) where the query determines which data is relevant and only that is fetched and computed. This design is **pull-driven**; DBSP's algebra stays a precise account of *what* each incremental operator must compute, but the *architecture* is demand transformation over the existing top-down engine. The technique stack: **magic sets / SIPS** (sideways information passing) for demand, **Dynamic Magic Sets** (Alviano) for a demand cone that grows with data under recursion/activated negation, the **`n.p` complement-predicate** rewrite plus stratified evaluation order (Tekle-Liu) for demand through stratified negation, **DRed** (over-delete, re-derive, insert) with **FBF** for incremental retraction of facts with multiple derivations, and the prolly-tree `differentiate(range)` for a signed, range-scopable delta. Negation is rewritten `not p(args)` → fresh `n.p(args)` + rule `n.p(x…) ← not p(x…)`, computed as "p, take what's not there," sound only when p is complete for the queried args — supplied by stratification (p in a lower stratum evaluated to fixpoint first) and demand (n.p needed only for demanded args). Retraction over-deletes a forward-reachable superset, re-derives each by a backward head→body query against surviving facts, then inserts forward to fixpoint; cardinality-one winner-selection is an instance.

## Two polarities

- **Push / world-driven** (differential dataflow, DBSP): deltas arrive at the leaves and propagate forward; stateful operators (join, dist, aggregate) **retain their full integrated input** to be ready for any delta. That retained state is the cost center and is in direct tension with a partial replica: it re-materializes locally exactly the data the replica is designed not to hold.
- **Pull / query-driven** (magic sets / demand transformation): the query determines which data is relevant; only that is fetched and computed.

This design is pull-driven. DBSP's algebra remains a precise account of *what* each incremental operator must compute (see `notes/dbsp.md`); the *architecture* here is demand transformation over the existing top-down engine.

## Technique stack

| Concern | Technique | Reference |
|---|---|---|
| Demand: only touch what the query needs | **Magic sets / SIPS** (sideways information passing) | Beeri-Ramakrishnan; Alviano Ch.3 |
| Demand cone that **grows with data** (recursion, activated negation) | **Dynamic Magic Sets**: magic atoms maintained during evaluation; sound/complete for stratified | Alviano, *Dynamic Magic Sets* |
| Demand **through stratified negation** | **`n.p` complement predicate** + stratified evaluation order; optimal (only query-relevant facts, O(1) per firing) | Tekle-Liu, *Extended Magic for Negation* (arXiv:1909.08246); Balbin et al. 1991 |
| **Incremental** maintenance with retraction | **DRed** (over-delete, re-derive, insert); **FBF** for facts with multiple derivations | Gupta-Mumick-Subrahmanian 1993; Tekle-Liu |
| Signed, range-scopable **delta** | prolly-tree `differentiate(range)` (`Add`/`Remove`, lazy, hash-skipping) | `dialog-prolly-tree` |

### Negation via `n.p`

A negated body literal `not p(args)` is rewritten to a fresh complement predicate `n.p(args)` plus one rule `n.p(x…) ← not p(x…)`; everything else is demand-transformed positively. `n.p` is computed as "p, take what's not there": negation is a query that excludes from the positive set. (This matches how the engine already treats `Negation`: a filter that consumes bindings rather than producing them.)

Soundness requires p be **complete for the queried args** before its absence is read. Two properties supply this:

- **Stratification**: p sits in a lower stratum, evaluated to fixpoint before any `not p` is consulted, so "p not derived for `a`" is final rather than premature. (Naively demanding the negated predicate makes the demand program non-stratified; the `n.p` rewrite + stratified evaluation order is the fix — Tekle-Liu Lemma 1, Balbin §6.)
- **Demand**: `n.p(args)` is only needed for the demanded args, so p is computed restricted to those args, not in full.

On this replica, "complete for the queried args" is the tree-layer materialization invariant: `d_n.p_s(args)` names the range of p that must be lazy-loaded; once the covering subtree is fully materialized and p is evaluated to fixpoint over it, absence is sound.

### Retraction via DRed

On a deletion: **over-delete** (remove everything reachable forward, a superset, since a fact may have other derivations), **re-derive** (for each over-deleted fact, evaluate rules backward, head→body as a query, to find a surviving derivation and restore it), **insert** (propagate additions forward to fixpoint). The re-derive step is a backward query against surviving facts, bounded by the over-deleted set. Cardinality-one winner-selection is an instance: retracting the current winner for `(the,of)` re-derives by querying the next-highest-cause fact for that key.

Source: [notes/incremental-subscriptions.md](https://github.com/dialog-db/dialog-db/blob/005d8c7b123a1105a46458bea2c05d01134cacfa/notes/incremental-subscriptions.md) at commit `005d8c7b`.
