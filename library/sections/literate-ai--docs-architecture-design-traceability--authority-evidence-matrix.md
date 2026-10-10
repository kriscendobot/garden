---
title: Authority-to-evidence traceability matrix
source: docs/architecture/design-traceability.md
source_repo: jordanhubbard/literate-ai
source_commit: 31ebd4e99bed67f3091e7e3bb47dfb499d306b49
source_date: 2026-10-05
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Literate AI maintains a large design-traceability matrix that maps each lifecycle concern to its authority classification, canonical inputs, enforcing implementation boundary, and concrete proof obligations, making the intended trust boundary reviewable rather than implicit.

The matrix spans specification provenance, component resolution, model routing, source generation, worker capacity, cache custody, source admission, build authorization, testing, packaging, publication, and release evidence. Its recurring pattern is four-way: identify which artifact or actor has authority, name the exact typed input, identify the service or adapter that may act, and list deterministic plus end-to-end tests that demonstrate the boundary.

The matrix also distinguishes stable invariants from replaceable policy and incomplete guarantees. This keeps an architectural claim from becoming a feature-completeness claim and makes deferred proof visible. When behavior changes, the document calls for updating the owning authority artifact, public schema where applicable, observable flow, a seam test, and an end-to-end proof.

Source: [docs/architecture/design-traceability.md](https://github.com/jordanhubbard/literate-ai/blob/31ebd4e99bed67f3091e7e3bb47dfb499d306b49/docs/architecture/design-traceability.md) at commit `31ebd4e`.
