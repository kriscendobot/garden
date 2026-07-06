---
title: What the papers contribute (magic sets, SIPS, propagators, DBSP)
source: notes/query-engine-design.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, change-propagation]
status: current
---

> Abstract: The engine is built on the **magic-sets / sideways-information-passing (SIPS)** line, with the **propagator** model informing the constraint side and **DBSP/DRed** the forward (incremental) direction. A SIPS (Alviano Def. 3.1.3) is a pair `(≺ᵅ, fᵅ)`: `≺` a strict partial order over body atoms — in dialog-db the **`DependencyGraph`** (per-premise binds/needs + `requires` edges), half the SIPS *by definition*; `f` the **binding function** — in dialog-db `feasibility::feasible`. Two settled facts adopted here: **cost is not part of the SIPS** (Balbin et al.: cost selects *among* feasible SIPS at planning time — dialog-db's greedy planner *is* the SIPS-selection stage), and **adornment is generated on demand and memoized, never enumerated** (Alviano's demand-driven `Adorn`; dialog-db caches the plan per adornment, avoiding a global table to sync across peers). dialog-db premises are *richer* than Datalog atoms (formulas/constraints have real input requirements), so `f` is a real "can it run yet" predicate carrying `NeedsAll`. Negation-as-demand (Tekle & Liu `n.p`), propagators (Radul & Sussman — bidirectional constraints as directional sub-premises over a three-state `unbound`/`Present`/`Absent` lattice, `Coalesce` a small propagator), and DBSP Z-sets + DRed over-delete/re-derive/insert inform the planned demand-driven (pull, not DBSP's push) incremental subscriptions.

The engine is built on the **magic-sets / sideways-information-passing (SIPS)** line of work, with the **propagator** model informing the constraint side and **DBSP / DRed** informing the forward (incremental) direction.

**Magic sets and the SIPS** (Beeri & Ramakrishnan; Balbin et al. 1991; Alviano). A *SIPS* is the formal account of how bindings flow through a rule body. Alviano (Def. 3.1.3) defines a SIPS for a rule and adornment as a pair `(≺ᵅ, fᵅ)`:

- **`≺`**: a strict partial order over the body atoms (head precedes body; which atom feeds which). In dialog-db this is the **`DependencyGraph`** (per-premise binds/needs plus the `requires` edges) — half the SIPS *by definition*, not an optional cache; the demand work consumes it.
- **`f`**: the **binding function** — given what is bound, the variables an atom makes bound after it runs. In dialog-db this is **`feasibility::feasible`** (built on `categorize`). There is exactly one such function; the planner orders by it.

Two facts the papers settle, both adopted here:

1. **Cost is *not* part of the SIPS.** Balbin et al. (§3.1): the choice of one SIPS over another is guided by relation sizes and indexing, assumed already made. Cost selects *among* feasible SIPS at planning time — the gate/rank split. dialog-db's greedy planner *is* the SIPS-selection stage; a future cost redesign improves only the selector and never touches `f` or `≺`.
2. **Adornment is generated on demand and memoized, never enumerated.** Alviano's `Adorn`/`ProcessQuery` drive compilation from a worklist of adornments seen so far, adding each only when a (sub-)query demands it. dialog-db's concept-rule planning derives the adornment from the first match and caches the plan per adornment — the same demand-driven, memoized strategy, avoiding a global adornment table to keep in sync across peers.

dialog-db's premises are *richer* than Datalog atoms: formulas and constraints have genuine input *requirements* (a formula can't run until its input is bound), so feasibility is a real "can it run yet" predicate, not merely an adornment pattern. This is why `f` carries a `NeedsAll` error naming the still-required variables, and why the optional lookup (`OptionalAttributeQuery`) hard-requires its entity bound.

**Negation as demand** (Tekle & Liu, *Extended Magic for Negation*, arXiv:1909.08246): the `n.p` complement-predicate construction — a negated literal becomes a query that *excludes* from the positive set, made sound by stratification + demand. dialog-db already treats `Negation` as a filter that consumes bindings without producing them; this is the basis for planned demand-driven negation in the incremental work.

**Propagators** (Radul & Sussman, *The Art of the Propagator*, MIT-CSAIL-TR-2009-002; Radul, *Propagation Networks*, TR-2009-053): a multidirectional constraint (e.g. `sum(x, y, total)`) is built from unidirectional propagators sharing cells; whichever has enough inputs fires. This is the model for dialog-db's bidirectional constraints/formulas: decompose into directional sub-premises, each a trivial one-output case the planner runs when feasible. Cells accumulate *partial information* and combine by `merge`; dialog-db's three-state binding (`unbound` / `Present` / `Absent`) is a (currently equality-only) instance of that lattice, and `Coalesce` is a small propagator over it.

**Forward / incremental direction** (DBSP; DRed/FBF): for the planned incremental-subscription work (not yet built), DBSP gives the algebra of what each incremental operator needs (Z-sets, chain/bilinear rules); DRed/FBF give over-delete → re-derive → insert for retraction with multiple derivations. The architecture is demand-driven (magic sets / pull) rather than DBSP's world-driven push, because dialog-db holds partial replicas.

Source: [notes/query-engine-design.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/query-engine-design.md) at commit `ebd8f739`.
