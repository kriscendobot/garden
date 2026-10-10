---
title: Workflow, acceptance, and receipts
source: docs/architecture/domain-model.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: A typed workflow produces source-only candidates before build authority exists, then re-indexes, authorizes, builds, tests, independently accepts, admits, and receipts a candidate; compact current receipts deliberately exclude generated artifacts and operational noise.

The stage order is resolve, plan, prepare, generate or resume an exact source-only candidate, index that tree, obtain current build authorization, finalize the plan, build, test, execute, accept, and atomically admit. Packaging, cache publication, and release are later explicit consumers rather than side effects of generation.

Generated tests come from the same authority as implementation and therefore are not the acceptance oracle. A separate verifier can produce a compact ProjectTestReceipt bound to current project authority, subject identity, suite identity, runner policy, minimum test count, and required evidence kinds. The committed receipt is a local Git assertion, not remote or cryptographic attestation; stronger consumers must authenticate the referenced evidence independently.

Source: [docs/architecture/domain-model.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/architecture/domain-model.md) at commit `2820f85`.
