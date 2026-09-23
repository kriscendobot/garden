---
title: Cost as a work-class ladder, and how analysis and planning consume the SIPS
source: notes/planning-adornment-and-cost.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, change-propagation]
status: current
---

> Abstract: Cost stays a per-premise method decoupled from feasibility and only ever asked of a *feasible* premise (the planner calls `adorn` first), made to depend on more than bound/unbound booleans. Two refinements: model cost as an explicit **work-class ladder** (point lookup < bounded range read < large range scan < full index scan, with additive overheads for winner-verification and rule evaluation) so a formula with no IO sits below any scan by construction; and make cost depend on *which* bound variable, not just how many — an entity-bound scan is narrower than a value-bound one, a cardinality-one lookup narrower still, with selectivity-driven cost (worst-case-optimal joins) the longer-term anchor and the index-prefix ladder enough for now. `Cost` may later be a `(class, tie-breaker)` pair. **How analysis and planning consume this:** analysis builds the SIPS once — the `DependencyGraph` is the SIPS skeleton (order plus variable flow), computed via `adorn` and *retained* rather than discarded; planning consumes graph + `estimate`, ordering by `adorn` for feasibility and `estimate` for cost with just-in-time memoized adornment; and the compiled `Plan` carries the graph-derived `binds`/`needs` per step so neither replanning nor analysis needs a stored syntactic premise. Open questions close the note: decompose vs k-of-n, the serializable `Feasibility` descriptor, scalar vs `(class, selectivity)` cost, and how far to take the cell/merge analogy.

## Cost: `estimate`

Cost stays a per-premise method and keeps doing what the papers delegate to it, but is decoupled from feasibility and made to depend on more than bound/unbound booleans. It is only ever asked of a *feasible* premise (the planner calls `adorn` first), so it never re-derives feasibility.

```rust
impl Premise /* per variant */ {
    /// Cost of running this premise under `bound`. Only called when
    /// `adorn(bound)` is `Ok`, so it assumes feasibility.
    fn estimate(&self, bound: &BTreeSet<String>) -> Cost;
}
```

Cost should capture the distinctions the current flat `usize` already gestures at, made explicit:

- **Work class, not just a magic number.** The existing constants (`LOOKUP`, `RANGE_READ`, `RANGE_SCAN`, `INDEX_SCAN`, plus `VERIFICATION`, `CONCEPT_OVERHEAD`) are really an ordinal ladder: point lookup < bounded range read < large range scan < full index scan, with additive overheads for a winner-verification pass and for rule evaluation. Model cost as that ladder so the comparison the planner makes (cheapest feasible premise) is over a principled order, and a formula (no IO) sits below any scan by construction, addressing "computing a sum is far cheaper than a scan that binds the same variable."
- **Which bound variable matters, not just how many.** The current table already distinguishes entity-bound from value-bound scans (`{of}` → `RANGE_READ`/`RANGE_SCAN` vs `{is}` → `INDEX_SCAN`), and cardinality-one verification cost. Generalize this: cost is a function of *which* index prefix the bound set forms and the attribute's cardinality/selectivity — an entity-bound scan is narrower than a value-bound one, and a cardinality-one lookup narrower still. The right longer-term anchor is selectivity-driven cost (worst-case-optimal joins); for now the index-prefix ladder the table already encodes is enough, lifted out of the hand-written arms onto a per-prefix cost so it is derived, not enumerated.

`Cost` need not be a single scalar forever: a `(class, tie-breaker)` pair (work class as primary, estimated row count / selectivity as secondary) lets the planner order within a class. Start with the scalar ladder to preserve current behavior; leave room for the selectivity tie-breaker.

## How analysis and planning consume this

- **Analysis builds the SIPS once.** The dependency graph (`DependencyGraph` in `analyzer.rs`: per-premise `binds`/`needs` and the `requires[i]` edges) is precisely the SIPS skeleton: the order plus variable flow. It is currently computed and then discarded (used only as a validation gate). Analysis should compute `binds`/`needs` via `adorn` (with the entry adornment) and retain the graph.
- **Planning consumes the graph + `estimate`.** The planner orders by asking `adorn` for feasibility (against the running bound set) and `estimate` for cost, rather than re-walking the per-slot schema each call. Just-in-time, memoized adornment is kept (it is the textbook algorithm); the change is that feasibility and cost are now distinct, expressive, and declarable.
- **The compiled `Plan` carries the graph-derived binding info** (`binds`/`needs`) per step, so neither replanning nor analysis needs a stored syntactic premise: the leaf payload plus the SIPS subsume it.

## Open questions

- **Decompose vs. k-of-n.** The propagator model says decompose multidirectional premises into directional sub-premises rather than enrich feasibility with k-of-n. Open: decompose at the *premise* level (a `sum` premise lowers to three directional `Plan` nodes) or keep one premise whose `adorn` reports the directional options. Decomposition matches the papers and keeps each node's adornment trivial; the cost is more nodes for the planner to order.
- **Serializable `Feasibility` descriptor.** With decomposition, most premises need only `Prefix` (ordered inputs, one output). Whether `AnyOf` (equality) and `All` are enough, with `KOf` reserved for non-decomposable atoms.
- **Cost as scalar vs. `(class, selectivity)`.** Whether to land the selectivity tie-breaker now or keep the scalar ladder and add it when demand reification needs sharper estimates.
- **Where `Feasibility` lives on each premise** so it survives the AST→IR lowering as data on the `Plan` variant.
- **How far to take the cell/merge analogy.** Whether the binding environment stays equality-only or generalizes to a partial-information cell merge (intervals, type/set narrowing), relevant only for constraint *narrowing*, not just ground binding. Out of scope for the planner; noted for the incremental-subscriptions work.

## Pointers

- Magic sets / SIPS: Balbin et al. 1991; Alviano *Dynamic Magic Sets* (the lazy `Adorn`/`ProcessQuery` worklist).
- Propagators: Radul and Sussman, *The Art of the Propagator* (MIT-CSAIL-TR-2009-002); Radul, *Propagation Networks* (MIT-CSAIL-TR-2009-053), §3.2 (the `sum` decomposition, Fig 3-3).
- Cost / selectivity (forward pointer): worst-case-optimal joins.
- This repo: `rust/dialog-query/src/schema.rs` (`Cardinality::estimate` 16-arm table, `Requirement`/`Group`), `rust/dialog-query/src/planner/` (the implicit SIPS), `rust/dialog-query/src/rule/analyzer.rs` (`DependencyGraph`).

Source: [notes/planning-adornment-and-cost.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/planning-adornment-and-cost.md) at commit `f777fe7c`.
