---
id: optional-attribute-query
aliases: [OptionalAttributeQuery, Plan::OptionalScan, Proposition::OptionalAttribute, optional field left-join, scalar associative layer, set-widening, Absent fallback, Resolution enum, maybe field, "#348"]
topics: [datalog-query]
---

# optional-attribute-query

Dialog's resolution of where optionality lives in the query engine: the associative (raw EAV / triple) layer operates on **scalars only** (`the(of, is)` with a present value), and all optionality (`Option`, `Absent`, set-widening) belongs in the **semantic** (concept) layer, composed from scalar scans. Optionality had leaked *down* into the associative `AttributeQuery` (a set-widened `is` term plus an in-scan `Absent` fallback guarded by `Resolution`/`entity_known`), the root cause of the #348 bug (an optional scan with an unbound entity leads and silently drops entities lacking the fact) and the unplannable standalone-optional query. The fix is layering, not a planner heuristic. As built on `feat/operator-ir`, the left-join is a first-class construct — `OptionalAttributeQuery` (premise `Proposition::OptionalAttribute`, plan `Plan::OptionalScan`) wrapping a scalar `DynamicAttributeQuery` — whose schema hard-requires the entity slot and set-widens `is`/`cause`, so attribute schemas are uniform, feasibility and inference need no special cases, the #348 symptom patch was reverted, and set-widening is confined to the concept layer where `this` is always bound (so "absent for whom?" is always answerable).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-scalar-associative-layer--optionality-leaked-into-associative-layer](../sections/dialog-db--notes-scalar-associative-layer--optionality-leaked-into-associative-layer.md) | The root cause: optionality leaked into the associative AttributeQuery; what must be removed. |
| [dialog-db--notes-scalar-associative-layer--semantic-layer-set-widening](../sections/dialog-db--notes-scalar-associative-layer--semantic-layer-set-widening.md) | The concept layer takes over set-widening as a per-entity left-join; the projection-operator vs coalesce options; blast radius. |
| [dialog-db--notes-scalar-associative-layer--decisions-optional-attribute-query](../sections/dialog-db--notes-scalar-associative-layer--decisions-optional-attribute-query.md) | As built on feat/operator-ir: OptionalAttributeQuery as a first-class left-join; term-level Option fate; Cardinality::Many. |
| [dialog-db--notes-guide--running-example-and-two-layers](../sections/dialog-db--notes-guide--running-example-and-two-layers.md) | User-facing: the associative layer is scalar, the optional lookup (this left-join) lives in the semantic layer and reports what it found instead of dropping the entity. |
| [dialog-db--notes-guide--absent-is-a-claim](../sections/dialog-db--notes-guide--absent-is-a-claim.md) | This operator is the sole producer of Absent; its entity-must-be-bound contract and its four input/output behaviors. |
| [dialog-db--notes-guide--consuming-optional-values-filter-by-default](../sections/dialog-db--notes-guide--consuming-optional-values-filter-by-default.md) | When a sibling premise proves presence the planner demotes this optional lookup to a plain scalar scan (same semantics, less work). |
| [dialog-db--notes-guide--why-it-is-layered-this-way](../sections/dialog-db--notes-guide--why-it-is-layered-this-way.md) | Why the contract lives in one operator: one place to be correct, types that tell the truth, and a single node for the future incremental-subscription demand hook. |

## See also

- [[schema-on-read]] — the concept/attribute semantic layer that owns optionality once the associative layer is scalar-only.
- [[formula-scheme]] — the same "filter, don't fabricate" discipline in the value/type dimension; the `Coalesce` opt-in for absence is the literal parallel to polymorphic literals for type strata.
