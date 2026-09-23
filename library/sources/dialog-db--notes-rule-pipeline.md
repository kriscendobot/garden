---
source: notes/rule-pipeline.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The three-phase compilation pipeline that turns a user-supplied deductive rule into an executable plan — Parse (`DeductiveRuleDescriptor` → `Vec<Premise>` + conclusion), Analyze (type inference, required-head check, Coalesce-contract validation, yielding an immutable `AnalyzedRule` with shared `types` and a `DependencyGraph`), and Plan (greedy cost-based ordering, re-inference, per-step narrowing, assembly into a `Conjunction`). Plus the rationale for narrowing types once at plan time (the `is_optional()` Absent-fallback saving), how evaluation folds the already-narrowed steps, adornment-based replanning, and the "what lives where" and error-table references.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [parse-analyze-plan](../sections/dialog-db--notes-rule-pipeline--parse-analyze-plan.md) | datalog-query | current |
| [narrowing-replanning-and-errors](../sections/dialog-db--notes-rule-pipeline--narrowing-replanning-and-errors.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `f777fe7c` (2026-07-05, repo HEAD), authored by Irakli Gozalishvili. The implementation-level companion to `notes/query-engine-design.md` and `notes/operator-ir.md`.
- Ingested in the `scholar-ingest-dialog-db-remainder-2` follow-on cycle (2026-07-06), part of the query-planner/rules cluster.
