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

## See also

- [[schema-on-read]] — the concept/attribute semantic layer that owns optionality once the associative layer is scalar-only.
- [[formula-scheme]] — the same "filter, don't fabricate" discipline in the value/type dimension; the `Coalesce` opt-in for absence is the literal parallel to polymorphic literals for type strata.
