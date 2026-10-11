---
title: "ADR 0007: Consequences and explicit conflict selection"
source: docs/decisions/0007-update-classification-and-semantic-merge.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Conflict review costs one optional model call per file and remains plan-only; explicit repeatable path selections authorize taking upstream conflicts or retaining otherwise removable dependencies within one validated rollback unit, with receipts separating operator choices from mechanical changes.

The comparison-reference fix (`UPDATE-CLASSIFICATION-001`) is a pure correctness
improvement with no new surface area: it should strictly reduce false `conflict`
classifications, never introduce new ones, and is safe to land without a review cycle
beyond ordinary code review.

The merge-review capability (`UPDATE-MERGE-001`) adds a new, real cost: one coding-agent
invocation per remaining conflict, opt-in and plan-only, so it costs nothing when unused
and costs one model call per conflict when requested.

Planning cycle (2026-08-28): the flag is `--review-conflicts`. Each review returns
`keep-local`, `take-upstream`, or `merge` with an identity-bound rationale in the
update JSON envelope (`literate-ai/project-update-conflict-review@1`). Nothing is
written from the review step; `--apply` still writes only the mechanical subset.
Rationale retention is the plan envelope (and work-item queue when
`--record-work-items` is used), not a second on-disk ledger.

0.9.0 amendment (2026-09-04): issue #244 exposed a dependency-closure gap in that
last sentence. A downstream could adopt a newly exported skill while a dependency
that it pins remained a true conflict. Validating the complete prospective tree then
correctly rejected the inconsistent selection, but there was no deterministic way to
apply the reviewed `take-upstream` choice inside the same rollback unit. A repeatable
`--take-upstream PATH` now authorizes only paths that the inherited-catalog plan
classified as `conflict`; complementary `--keep-local PATH` authorizes only planned
inherited-catalog removals whose bytes were otherwise safe to delete but remain a
dependency of local authority. Any other path fails before mutation. The selected
upstream bytes, retained compatibility paths, new additions, ordinary safe changes,
catalog provenance, framework changes, and repository lineage commit and validate
once or roll back together. The apply receipt records `taken_upstream` and `kept_local`
separately from mechanically safe `applied` and capability `adopted` paths. Unselected
conflicts and explicitly retained removals remain local authority and are omitted from
prospective import provenance rather than being falsely attributed to upstream. Agent
review remains plan-only: an operator must pass each accepted path explicitly.

Source: [docs/decisions/0007-update-classification-and-semantic-merge.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0007-update-classification-and-semantic-merge.md) at commit `2820f853` (source lines 109–142).
