---
title: The two gaps in the per-slot schema and the declarable `adorn` feasibility
source: notes/planning-adornment-and-cost.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: What dialog-db has today and the two gaps the redesign closes. `Cardinality::estimate(the, of, is)` is a 16-arm truth table over which of the three slots are bound that already fuses feasibility and cost (`None` = infeasible, the all-free adornment `fff`; `Some(n)` = feasible with cost `n` reflecting the index prefix) — so the per-predicate feasibility-as-method already exists. The per-slot `Requirement` schema (`Required(None)`/`Required(Some(group))`/`Optional`, with choice `Group`s) is its declarative encoding. **Gap 1 — feasibility is entangled with cost and silent:** `estimate -> Option<usize>` returns one number or `None`, unable to say *why* a premise is infeasible or *which variables* it would bind; the verdict, its reason, and its produced bindings should travel together. **Gap 2 — the per-slot vocabulary cannot express k-of-n:** a `Group` expresses one-of-n but not either-of-2-symmetric or k-of-n with k>1 (`math/sum(a,b,c)` needs any two of three to derive the third). The proposed shape: each premise advertises an `adorn(bound) -> Result<Binds, Infeasible>` feasibility function (`Result` not `Option` so it reports why); `Binds` is the SIPS function `f_r^α`. The requirement stays *declarable* as a serializable `Feasibility::{Prefix, AnyOf, KOf, All}` descriptor a peer's rule carries as data, generalizing the weaker `Requirement`/`Group` prototype.

`Cardinality::estimate(the, of, is)` (in `schema.rs`) is a 16-arm truth table over *which of the three slots are bound*. It already fuses feasibility and cost into one per-predicate method: `None` = infeasible (the all-free adornment `fff`), `Some(n)` = feasible with cost `n`, where the cost reflects which index prefix the bound slots form. So the per-predicate feasibility-as-method already exists; the instinct behind `estimate` was right.

The per-slot `Requirement` schema (`Required(None)` / `Required(Some(group))` / `Optional`, with choice `Group`s) is the *declarative* feasibility encoding the planner walks in `Candidate`. It exists so that binding requirements are data, so a premise can advertise its requirements without bespoke code. Two gaps:

1. **Feasibility is entangled with cost and is silent.** `estimate(env) -> Option<usize>` returns one number or `None`. It cannot say *why* a premise is infeasible (which bindings it still needs), nor *which variables it would bind* on success. The planner reconstructs binds/needs separately by re-walking the schema. The verdict, its reason, and its produced bindings should travel together.
2. **The per-slot vocabulary cannot express k-of-n.** A `Group` expresses "any one of these slots bound satisfies the group": one-of-n. It cannot express either-of-2 symmetric (equality binds the other cell given *either* one; works as a single 2-member group, the one case that fits) or k-of-n with k > 1 (`math/sum(a, b, c)` needs *any two of three* bound to derive the third — no combination of per-slot `Required`/`Optional`/`Group` expresses "2 of these 3, don't care which"). This is the propagator-style requirement the current schema fails on.

So the redesign keeps `estimate` as the cost method, keeps requirements declarative, and replaces the per-slot flag vocabulary with a per-premise feasibility function expressive enough for k-of-n.

## Proposed shape — feasibility: `adorn`

Each premise advertises a feasibility function: given the set of currently bound variables, either it can run (yielding the variables it will bind) or it cannot, with a reason naming what is still missing.

```rust
/// What a premise binds once it runs, given an entry adornment.
struct Binds(BTreeSet<String>);

/// Why a premise cannot run yet under the current bindings.
enum Infeasible {
    /// Needs at least one of these still-unbound variables bound.
    NeedsAnyOf(BTreeSet<String>),
    /// Needs at least `k` of these bound; currently `have` are.
    NeedsKOf { k: usize, of: BTreeSet<String>, have: usize },
    /// Needs all of these still-unbound variables.
    NeedsAll(BTreeSet<String>),
}

impl Premise /* per variant */ {
    fn adorn(&self, bound: &BTreeSet<String>) -> Result<Binds, Infeasible>;
}
```

`Result` rather than `Option` so an infeasible premise reports *why*: the planner surfaces it as the required-bindings diagnostic, and demand reification (the magic-sets step) reads it to know which variables to demand next. `Binds` is the SIPS function `f_r^α`: the variables passed onward from this literal. The cases fall out per premise without a flag table — Scan is feasible once the slots forming a selector are bound; `Equality(a, b)` is feasible if either `a` or `b` is bound and binds the other; `math/sum(a, b, c)` is feasible with ≥2 of three bound *if modeled as one premise*, but the propagator model says decompose it instead so k-of-n never arises at the feasibility layer.

Keeping this **declarable** is the open requirement: `adorn` is a method, but its *data* should be a small per-premise requirement descriptor the method interprets — an enum `Feasibility::{ Prefix(ordered slots), AnyOf(set), KOf(k, set), All(set) }` stored on the premise, so a rule loaded from a peer carries its feasibility as serializable data, not opaque code. The current `Requirement`/`Group` schema is the weaker prototype of this; `Feasibility` is its generalization.

Source: [notes/planning-adornment-and-cost.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/planning-adornment-and-cost.md) at commit `f777fe7c`.
