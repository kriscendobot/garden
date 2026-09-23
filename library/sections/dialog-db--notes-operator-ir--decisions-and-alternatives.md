---
title: The operator-IR decisions, with the alternatives considered and rejected
source: notes/operator-ir.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The design decisions, each recorded with the alternative it beat. **The dependency graph does not drive ordering** — choice-group satisfaction shifts with the bound set, so ordering needs per-scope feasibility a static graph cannot express; the graph's role is the dependency index that demand-driven replanning and incremental subscriptions consume. **Narrowed premises are not stored on the rule** — baking narrowing into stored premises would leak inferred kinds into the wire form and break serialize/deserialize identity, so the rule stores authored premises plus the inferred `TypeEnv` and planning projects onto a working copy. **`AnalyzedRule` was composed, not dissolved** (`DeductiveRule { analysis: AnalyzedRule }`). **Stateless feasibility replaced the stateful candidate** once characterization showed the statefulness was an optimization, not a contract. **Optionality is a structural operator, not a kind-driven scan mode** — a first-class `OptionalAttributeQuery` wrapping a scalar lookup, making a standalone optional lookup with an unbound entity inexpressible rather than mis-planned. **`Absent` across boundaries filters** — it never aborts and never silently defaults; `Coalesce` is the explicit opt-in for defaults, ordered strictly after its source. **Negation participates in typing not at all.** **Checked kinds filter at the data boundary, error at the contract boundary.** The note closes with the status (landed on `feat/operator-ir`) and the still-open design (richer `Infeasible` vocabulary, propagator decomposition, cost redesign).

**The dependency graph does not drive ordering.** The obvious move (feed the analysis-built graph to the planner so it stops re-categorizing premises) was considered and rejected: choice-group satisfaction shifts with the bound set (a group satisfied by a *bound variable* flips a slot from required to binding), so ordering needs per-scope feasibility that a static graph cannot express without changing plan order. The graph's actual role: it is the **dependency index** (given a binding, which premises it affects/unblocks), which is precisely what demand-driven re-planning and incremental subscriptions consume. Ordering uses the shared `categorize`; the graph is kept for the consumers that need static structure.

**Narrowed premises are not stored on the rule.** The earlier design had analysis bake narrowing into the stored premises, making the planner type-free. Rejected on a round-trip argument: a rule's serialized descriptor is reconstructed from its premises, and baked-in narrowing would leak inferred kinds into the wire form, so serialize/deserialize would not be identity. Instead the rule stores the authored premises plus the inferred `TypeEnv`, and planning projects types onto a working copy. The single-inference property is preserved; the wire form is untouched.

**`AnalyzedRule` was composed, not dissolved.** The design called for collapsing `AnalyzedRule` into `DeductiveRule`. As built, `DeductiveRule { analysis: AnalyzedRule }`: composition gives the same guarantee (the rule *is* its analysis) with less churn, and the inductive sibling shares the type.

**Stateless feasibility replaced the stateful candidate.** The old planner kept per-premise `Candidate` state, incrementally updated as scope grew, with subtle stickiness semantics on paths real planning never took. Characterization established that the statefulness was an optimization, not a contract (only the output plan is observable), so the candidate machinery was deleted in favor of recomputing `feasible` per round. (The dependency edges enable re-checking only affected premises if this ever shows up in profiles.)

**Optionality as a structural operator, not a kind-driven scan mode.** Alternatives: (1) keep deriving scan behavior from the value term's kind and patch the planner heuristics — rejected because the #348 family showed the guards' meaning depended on orderings the planner is free to choose; a type system that cannot constrain the plan cannot guarantee its own semantics. (2) compose optional fields from a scalar scan plus `Coalesce` — rejected because the fallback still needs left-join row semantics underneath (emit nothing vs. emit Absent), so the operator is needed anyway and the composition adds nothing. Chosen: a first-class `OptionalAttributeQuery` premise/plan construct wrapping a *scalar* lookup, with the contracts in its schema. A standalone optional lookup with an unbound entity is thereby *inexpressible* rather than mis-planned ("absent for whom?").

**`Absent` across boundaries filters; it never aborts and never silently defaults.** A scalar slot (scan, formula input, equality against a non-widened term) matches nothing against an `Absent` claim: the row is excluded, in both polarities. The error alternative (reject optional-into-required at analysis, demand explicit coalescing everywhere) was rejected as call-site ceremony contrary to the set-widening reading of optionality: in a relational language, the demanding premise *is* the evidence of presence. `Coalesce` remains the explicit opt-in for defaults, and orders strictly after its source so a default can never shadow a present value.

**Negation participates in typing not at all.** Negated premises neither contribute their demands to inference (else "unless the nickname is banned" would silently strengthen to "must have a nickname, and it must not be banned") nor receive the positive narrowing (a negated subquery is a hypothetical, typed in its own context). The second direction is a judgment call with arguments both ways, recorded with its alternatives in `polarity-and-negation.md`.

**Checked kinds: filter at the data boundary, error at the contract boundary.** Attribute values are dynamically typed in the store (one attribute may hold several value types across facts), so a typed scan slot treats a mismatched fact as a non-match and filters it. `Match::bind` rejecting a value outside the variable's kind is the opposite case: by then every data-dependent filter has run, so a mismatch is a construction-path bug and surfaces as an error.

## Status and remaining design

Landed on `feat/operator-ir`, guarded throughout by characterization, plan-ordering, and end-to-end optionality tests. Still open from the companion design (tracked on the roadmap): the richer `Infeasible` vocabulary (`NeedsAnyOf`/`NeedsKOf`) and the serializable per-premise `Feasibility` descriptor; propagator decomposition of multidirectional formulas (`math/sum` as adder plus subtractors rather than k-of-n feasibility); and the cost redesign (work-class plus selectivity in place of magic constants).

Source: [notes/operator-ir.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/operator-ir.md) at commit `f777fe7c`.
