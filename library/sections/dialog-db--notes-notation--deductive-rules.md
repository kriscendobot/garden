---
title: Deductive rules (formal notation)
source: notes/notation.md
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: A **deductive rule** is an advanced composition that goes beyond stitching attributes together — it imposes constraints, computes derived values, and follows transitive paths. A rule's body is a set of premises; its conclusion is a concept instance, resolved at query time by the semantic layer. Schema: `deduce` (the conclusion concept), `when` (a conjunction of premises, all satisfied by the same bindings), and optional `unless` (exclusion patterns; if any can be satisfied the result is filtered — negation as failure under the closed-world assumption). A **premise** pairs an `assert` (a concept, a formula ref, or a constraint ref) with a `where` map binding field names to **terms** (variables `{ "?": { "name": "x" } }`, wildcards `{ "?": {} }`, or constants). The variable `this` is implicit in every rule and refers to the conclusion's entity. **Conjunction** is a rule's implied AND over its `when` premises; **disjunction** is expressed as multiple rules deducing the same concept — so a new rule from a different domain can extend an existing concept without touching the originals.

An advanced form of composition that goes beyond stitching attributes together. Rules can impose additional constraints, compute derived values using formulas, and follow transitive paths across relations. A rule's body is a set of premises; its conclusion is a concept instance. Rules are resolved at query time by the semantic layer.

Schema (`Rule`): `deduce` (required, a `Concept` — the conclusion derived when the body is satisfied), `when` (required, an array of `Premise`, `minItems: 1` — a conjunction all satisfied by the same bindings), `unless` (optional array of `Premise` — exclusion patterns, negation as failure).

A `Premise` combines an `assert` (`oneOf` a `Concept` inline definition, a `FormulaRef`, or a `ConstraintRef`) with a `where` map from named terms to `Term`s. A `Term` is `oneOf` a `Variable` or a `Constant`. A `Variable` is `{ "?": { "name": ... } }` (name omitted ⇒ a blank wildcard). A `Constant` is a string, number, or boolean.

### Variables

A variable represents a value to be bound by the query engine. A variable appearing in multiple positions within the same rule requires those positions to have equal values (unification). In the formal notation a named variable is `{ "?": { "name": "x" } }` and a blank (wildcard) matching any value without binding is `{ "?": {} }`. (In the abbreviated notation, `?person` and `_` are the shorthands.)

The variable `this` (`?this` abbreviated) is implicit in every rule and refers to the entity of the asserted concept. It must not be declared in the concept's `with` (it is not an attribute); it must be used in the `when` premises to bind the entity of the conclusion.

### Conjunction

A concept definition is effectively a rule with an implied conjunction. Every pattern in the `when` body must be satisfied by the same variable bindings for the rule to produce a result. For example, a three-premise `when` binding `name`, `quantity`, and `unit` all against the same `this` produces an `Ingredient` conclusion only when all three claims exist for one entity.

### Disjunction

Disjunction is expressed by defining multiple rules that deduce the same concept. Any rule can produce a match independently. Because disjunction is expressed by separate rules, a new rule deriving an existing concept can be added from a different domain without touching the original definitions. (For example, one `Employee` rule reading `org/title` and another reading `org/position`, both deducing the same `Employee`.)

### Negation

`unless` filters out matches where a given pattern holds. If the `unless` pattern can be satisfied, the result is excluded. This reflects the closed-world assumption: if something cannot be derived from what is known, it is treated as absent. A `SafeMeal` rule, for instance, deduces a meal from a `PlannedMeal` premise `unless` an allergy-conflict pattern can be satisfied for the same person and recipe.

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
