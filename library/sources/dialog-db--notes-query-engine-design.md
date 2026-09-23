---
source: notes/query-engine-design.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 5
status: current
---

> Abstract: Dialog's query-engine design: a rule flows through a three-stage pipeline (`DeductiveRuleDescriptor` wire data → analyzed `DeductiveRule`, plannable by construction → `Conjunction`, the per-scope execution plan). Planning rests on a deliberate **gate/rank split** — feasibility (`feasible`/`categorize`, the binding function) decides which orderings are valid; cost (`estimate`) ranks the valid ones — with analysis cost-free (builds the SIPS space once) and planning cost-driven per scope. The planned `Conjunction` is a compiled `Plan` operator IR (`Scan`/`Maybe`/`Formula`/`Constraint`/`Concept`/`Negate`), where optionality contracts are schema-borne. Grounded in the magic-sets/SIPS literature (Beeri & Ramakrishnan, Balbin et al., Alviano), the propagator model (Radul & Sussman) for bidirectional constraints, negation-as-demand (Tekle & Liu), and DBSP/DRed for the planned demand-driven incremental direction. Types are enforced at evaluation, not advisory.

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-pipeline](../sections/dialog-db--notes-query-engine-design--overview-and-pipeline.md) | datalog-query | current |
| [feasibility-and-cost](../sections/dialog-db--notes-query-engine-design--feasibility-and-cost.md) | datalog-query | current |
| [operator-ir](../sections/dialog-db--notes-query-engine-design--operator-ir.md) | datalog-query | current |
| [what-the-papers-contribute](../sections/dialog-db--notes-query-engine-design--what-the-papers-contribute.md) | datalog-query, change-propagation | current |
| [pointers-and-type-checking](../sections/dialog-db--notes-query-engine-design--pointers-and-type-checking.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `ebd8f739` (2026-07-01), authored by Irakli Gozalishvili. Companion to `notes/operator-ir.md`, `notes/planning-adornment-and-cost.md`, `notes/incremental-subscriptions.md`, and `notes/guide.md` (deferred to follow-on cycles).
- Ingested in the `scholar-ingest-dialog-db-remainder` follow-on cycle (2026-07-06).
