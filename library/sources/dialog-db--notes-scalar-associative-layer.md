---
source: notes/scalar-associative-layer.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: An investigation-then-decision note that fixes a layering boundary: the associative (raw EAV / triple) layer should operate on scalars only, and all optionality (`Option`, `Absent`, set-widening) belongs in the semantic (concept) layer, composed from scalar scans. Optionality had leaked *down* into the associative `AttributeQuery` (a set-widened `is` term plus an in-scan `Absent` fallback), the root cause behind the #348 bug (an optional scan with an unbound entity leads and silently drops entities lacking the fact) and the unplannable standalone-optional query. The fix is layering, not a planner heuristic. As built on `feat/operator-ir`: the left-join is a first-class construct, `OptionalAttributeQuery` (premise `Proposition::OptionalAttribute`, plan `Plan::OptionalScan`) wrapping a scalar `DynamicAttributeQuery`, so attribute schemas are uniform, feasibility and inference need no special cases, the #348 symptom patch was reverted, and set-widening is confined to the concept layer where `this` is always bound.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [optionality-leaked-into-associative-layer](../sections/dialog-db--notes-scalar-associative-layer--optionality-leaked-into-associative-layer.md) | datalog-query | current |
| [semantic-layer-set-widening](../sections/dialog-db--notes-scalar-associative-layer--semantic-layer-set-widening.md) | datalog-query | current |
| [decisions-optional-attribute-query](../sections/dialog-db--notes-scalar-associative-layer--decisions-optional-attribute-query.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `ebd8f739` (2026-07-01), authored by Irakli Gozalishvili. Orthogonal to but co-landed with the `feat/operator-ir` planner restructure — see `notes/operator-ir.md` (the operator-IR chapter, which confines set-widening to the `OptionalAttributeQuery` left-join) and `notes/query-engine-design.md` (the resulting engine).
- Ingested in the `scholar-ingest-dialog-db-remainder-4` follow-on cycle (2026-07-06). The prior remainder-2 cycle's `operator-ir` source cross-references this note as the deferred optionality restructure; it is now ingested.
