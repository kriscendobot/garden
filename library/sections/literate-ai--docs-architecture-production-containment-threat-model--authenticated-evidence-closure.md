---
title: Authenticated evidence closure and retention
source: docs/architecture/production-containment-threat-model.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [sandbox-platforms, agentic-sdlc]
status: current
---

> Abstract: DSSE-wrapped in-toto predicates, independently supplied trust policy and run expectations, bounded content-addressed resolution, complete graph-role checking, current revocation rechecks, and authenticated retention claims combine into an evidence closure that still does not itself grant execution or release authority.

Signed derivation, platform, matrix, and locator assertions bind exact subjects, byte sizes, media types, run context, child edges, artifacts, cells, stores, and retention deadlines. Signatures authenticate assertions; verifier-owned requirements decide which assertions are necessary and whether repository, revision, workflow, target, invocation, timing, and matrix coverage match.

One resolution session enforces object, byte, and signature-work budgets across the complete graph. It verifies every fetched object, rejects ambiguous routing and corrupt mirrors, preserves exact envelope and proof bytes, and refreshes trusted time and revocation state after I/O. Retention signatures authorize store claims but do not replace observed retrieval or promise future availability.

Source: [docs/architecture/production-containment-threat-model.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/production-containment-threat-model.md) at commit `fcc40bc`.
