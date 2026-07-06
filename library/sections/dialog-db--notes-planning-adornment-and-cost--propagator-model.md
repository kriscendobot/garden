---
title: The propagator model — decompose multidirectional constraints, cells and merge
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

> Abstract: Radul and Sussman's *The Art of the Propagator* answers the multidirectional-constraint question and reshapes the feasibility design: **a multidirectional constraint is built from unidirectional propagators sharing cells; whichever has enough inputs fires.** The canonical `sum` decomposes into `adder x y total` plus two `subtractor`s, so "2-of-3, don't-care-which" is not a k-of-n test on one node but three ordinary one-output nodes over shared cells, each with the trivial adornment "all inputs bound, binds the one output." The recommendation: **prefer decomposing relational/arithmetic premises into directional sub-premises over enriching feasibility with k-of-n** (`Equality` is already two inverse copy propagators; `sum`/`product` become three); `NeedsKOf` stays only for genuinely atomic non-decomposable premises. Two propagator ideas bear on the wider engine. **Cells accumulate information; merge is the combinator** — dialog-db's `Match` binding environment already implements this as a genuine three-state lattice (unbound = bottom, `Present(value)`, `Absent` = a distinct more-informative-than-bottom "known to have no value"), with `Match::bind`/`bind_absent` as the monotone merge and `Coalesce` as a propagator that *reads* the lattice; the one narrowing it lacks is merging two `Present` values by refinement rather than equality. **Direction is chosen by available data at run time**, the same demand-driven adornment as the magic-sets lazy worklist.

*The Art of the Propagator* (Radul and Sussman, MIT-CSAIL-TR-2009-002) and Radul's thesis *Propagation Networks* (MIT-CSAIL-TR-2009-053) answer the multidirectional-constraint question directly, and their answer reshapes the feasibility design.

**A multidirectional constraint is built from unidirectional propagators sharing cells; whichever has enough inputs fires.** The thesis's canonical example (§3.2, Fig 3-3) is exactly our `math/sum`:

```scheme
(define (sum x y total)
  (adder x y total)        ; total <- x + y
  (subtractor total x y)   ; x <- total - y
  (subtractor total y x))  ; y <- total - x
```

"It works because whichever propagator has enough inputs will do its computation. It doesn't buzz because the cells take care to not get too excited about redundant discoveries." So the "2-of-3, don't-care-which" requirement is **not** expressed as a k-of-n feasibility test on one node; it is three ordinary one-output nodes over shared variables. Each sub-node has the trivial adornment "all inputs bound, binds the one output." The planner needs no `KOf`; it just sees three candidate premises and runs whichever becomes feasible first.

This changes the recommendation: **prefer decomposing relational/arithmetic premises into directional sub-premises over enriching the feasibility vocabulary with k-of-n.** `Equality(a, b)` is already this shape (two inverse copy propagators); `sum`/`product` become three; the per-slot schema's failure to express k-of-n stops mattering because no single premise needs k-of-n. `NeedsKOf` stays only as a fallback for genuinely atomic non-decomposable premises.

Two further propagator ideas bear on the wider engine (not just planning), worth recording because the incremental-subscriptions direction will want them:

- **Cells accumulate information; merge is the combinator.** A cell holds *partial information* and starts at `nothing` (absence of a value); adding content `merge`s the increment with the current content (TR §3). Merge is monotone: it returns the *more informative* result, the old value unchanged if the new is redundant, or a distinguished *contradiction* if they conflict. dialog-db's binding environment (`Match`) already implements this merge, and as a genuine three-state lattice, not equality-only: `Binding` (`selection/match.rs`) has exactly the propagator structure — **unbound** (variable absent) = the cell's `nothing`/bottom; **`Present(value)`** = a ground value; **`Absent`** = a *distinct, more-informative-than-bottom* state, "known to have no value," itself a lattice point, which is why optional resolution can bind `Absent` and a later `Present` then *conflicts* rather than overwrites. `Match::bind`/`bind_absent` are the merge: binding into an unbound slot inserts (the `nothing → content` arm); re-binding the same `Present` value is idempotent; a different `Present`, or `Present` vs `Absent`, returns the contradiction (`EvaluationError::Assignment`). The engine already has a propagator that *reads* this lattice rather than only writing it: `Coalesce` (`constraint/coalesce.rs`) branches on `Present`/`Absent`/unbound to merge a `source` with a `fallback` — set-widening unwrap, one row in, one row out. The one axis where it is narrower than the propagator lattice: merging two `Present` values succeeds only on **equality**, never by *narrowing* (interval intersection, type/set refinement); generalizing the value lattice from "ground or conflict" to "narrow toward ground" would let bindings carry partial constraints, relevant to the incremental-subscriptions work, out of scope for the planner.
- **Direction is chosen by available data, at run time, not fixed at compile time** (TR §4: "whichever one has enough inputs will do its computation"). This is the same demand-driven, just-in-time adornment dialog-db already does for rules: it is the propagator-network restatement of the magic-sets lazy `Adorn` worklist. The two literatures agree: don't enumerate directions up front; let the bound set select the direction when the premise is reached.

Source: [notes/planning-adornment-and-cost.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/planning-adornment-and-cost.md) at commit `f777fe7c`.
