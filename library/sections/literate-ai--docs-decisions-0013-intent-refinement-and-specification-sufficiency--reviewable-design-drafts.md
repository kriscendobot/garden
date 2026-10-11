---
title: "ADR 0013: Reviewable design drafts"
source: docs/decisions/0013-intent-refinement-and-specification-sufficiency.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: A content-identified DesignDraft inventories the mission, proposed graph, boundaries, assumptions, questions, targets, acceptance obligations, sufficiency findings, unsupported concerns, and exact refinement provenance in typed fields that prose cannot override.

The draft is strictly validated and canonically ordered where order lacks meaning. It
records the exact request and provenance, reasons for Component boundaries, proposed
interfaces and dependency kinds, authority selection for each concern, assumptions and
defaults, blocking questions, portable-versus-target decisions, independent oracle
classes, non-goals, and the policy, skill, model, and source identities used when a
model participates.

Unresolved input is classified as `blocking`, `defaultable`, `target-bound`, or
`implementation-local`. Defaults become authority only through explicit acceptance;
target choices resolve through Flavor or deployment authority; implementation-local
choices are allowed only after observable consequences are bounded. Security and trust
boundaries default to blocking, so silence never implies unauthenticated, public,
encrypted, isolated, or trusted operation.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 148-180).
