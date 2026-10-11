---
title: "ADR 0035: Operator front door and plan-apply"
source: docs/decisions/0035-explicit-operator-adoption-state.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Doctor, onboard, and status become the operator front door over shared versioned JSON, with read-only content-identified planning separated from acknowledged mutation.

Doctor performs bounded project-independent observations without invoking a model. Onboarding apply reconstructs the plan immediately before mutation and can require the exact reviewed plan identity. Existing initialization and conversion services remain the only project mutators.

Adoption plans reuse deterministic conversion facts such as languages, Flavors, quarantine entries, retained runners, Gitlink blockers, and the landing stage rather than reproducing discovery in a model prompt.

Source: [docs/decisions/0035-explicit-operator-adoption-state.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0035-explicit-operator-adoption-state.md) at commit `fcc40bc6`.
