---
title: What the codebase already provides, and the dependency-ordered build path
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

> Abstract: The gap analysis and roadmap. **What the codebase already provides** toward demand-driven incremental subscriptions: the planner already computes a SIPS (the conceptual core of magic sets) — a partial order over body atoms plus a record of which variables each binds for later ones, driven by bound/free adornments, precisely `Candidate`/`Planner::plan` threading `env`/`binds`/`requires` with `TryFrom<&AttributeQueryAll> for ArtifactSelector` restricting fetches to bound slots, so the engine is *already* a top-down SIPS-driven demand evaluator and what's absent is *reifying* that SIPS into a demand program; `dialog-prolly-tree::differentiate(other)` yields a signed, lazy, hash-skipping, range-scopable `Stream<Add|Remove>` delta over the three EAV/AEV/VAE sort orders; `Tree::integrate` gives the merge/reconcile step and `ContentAddressedStorage` the on-demand subtree fetch; and the planned history index retains evicted/retracted facts as the prior-state a backward re-derive/`n.p` query reads (current indexes are the live positive set, history the signed change log — the weighted model is native, not imposed). **The build path** in dependency order: (1) split the syntactic AST into a compiled **operator IR** (there's no compiled plan to attach demand/incremental evaluation to; this also removes the optional-as-term-kind defect and stands alone — ready to implement); (2) **reify demand** by emitting `d_p_s` demand predicates and `n.p` complements from the SIPS the planner already computes; (3) the **incremental/subscription layer** (standing subscriptions, result-delta emission, DRed/FBF re-derive); (4) **dynamic demand maintenance** (Dynamic Magic Sets) so a subscription's read-set expands correctly as negation and recursion grow its demand cone.

## What the codebase already provides

- **The planner already computes a SIPS**: the conceptual core of magic sets. A SIPS is a partial order over body atoms plus a function recording which variables each atom binds for later ones, driven by bound/free adornments. That is precisely `Candidate`/`Planner::plan` threading `env`/`binds`/`requires`, with `TryFrom<&AttributeQueryAll> for ArtifactSelector` restricting fetches to bound slots. The engine is already a top-down, SIPS-driven demand evaluator; what's absent is *reifying* that SIPS into a demand program.
- **`dialog-prolly-tree::differentiate(other)`** yields `Stream<Change = Add | Remove>`: a signed delta (`Remove` = negative weight / retraction), lazy and hash-skipping (`O(changed subtrees)`), range-scopable via `expand(range)`. This is the delta source. The EAV/AEV/VAE indexes are three sort orders, giving three prefix-scopable diff views.
- **`Tree::integrate`** with deterministic conflict resolution provides the merge/reconcile step; tree access through `ContentAddressedStorage` provides the on-demand subtree fetch.
- **The planned history index** retains evicted/retracted facts, supplying the prior-state a backward (re-derive / `n.p`) query reads. Retraction physically evicts from the current EAV/AEV/VAE indexes, so the current indexes are the live positive set and history is the signed change log: the weighted model is native, not imposed.

## Path to build it (dependency order)

1. **AST → operator IR.** `evaluate` currently lives on the syntactic AST across four pass-through layers; there is no compiled plan to attach demand or incremental evaluation to. Splitting the syntactic AST from a compiled operator IR is the prerequisite and stands alone; it also removes a present defect (optionality encoded on a term kind, the `entity_known` guard, and constructible nonsense optional queries; see the optional-as-outer-join discussion). Ready to implement.
2. **Reify demand.** Emit `d_p_s` demand predicates and the `n.p` complement construction from the SIPS the planner already computes, so demand becomes first-class data that scopes which subtrees an evaluation touches.
3. **Incremental / subscription layer.** Standing subscriptions, result-delta emission, DRed/FBF re-derive. (`datalogui/datalog` demonstrates the subscription surface — a `.view()` handle over incremental results — though it is differential dataflow and materializes all relations, which the partial-replica model excludes; the subscription shape transfers, the demand-gated evaluation is specific here.)
4. **Dynamic demand maintenance.** Negation makes a subscription depend on absence; recursion makes its demand cone grow with data. The demand/magic predicates must be **maintained incrementally** (Dynamic Magic Sets) so the set of subtrees a subscription reads expands correctly as data changes, and the materialization invariant for negation continues to hold as the cone grows.

## Pointers

- This repo: `notes/dbsp.md` (IVM / selective-pull exploration + DBSP formalism), `dialog-prolly-tree/src/differential.rs` (delta + merge primitives), `dialog-query/src/planner/` (the implicit SIPS).
- Papers: Tekle-Liu *Extended Magic for Negation* (arXiv:1909.08246); Alviano *Dynamic Magic Sets*; Balbin et al. 1991 *Efficient Bottom-Up Computation … Stratified Databases*; DBSP VLDB'23/'25 + spec + Lean proof.
- Related systems: `RhizomeDB/rs-rhizome` (semi-naïve RAM VM, content-addressed); `datalogui/datalog` (differential-dataflow subscriptions in JS).

Source: [notes/incremental-subscriptions.md](https://github.com/dialog-db/dialog-db/blob/005d8c7b123a1105a46458bea2c05d01134cacfa/notes/incremental-subscriptions.md) at commit `005d8c7b`.
