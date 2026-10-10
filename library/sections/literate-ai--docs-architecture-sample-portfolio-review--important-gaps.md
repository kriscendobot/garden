---
title: "Sample portfolio review: important gaps"
source: docs/architecture/sample-portfolio-review.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The portfolio overrepresents deterministic JSON calculators, so its next samples should cover a durable idempotent job queue, layered configuration with secret references, text ingestion and search, and auditable authorization policy, while retaining portability, independent verification, public contracts, and small composable capability boundaries.

The portfolio still overrepresents deterministic JSON calculators because they are
portable, cheap to regenerate, and easy to verify independently. Popular software is
also built from stateful and interactive boundaries. The next high-value samples should
add, in this order:

1. a durable job queue with idempotency keys and queued-work semantics beyond the
   snapshot collector's bounded lease/retry proof;
2. a schema-driven configuration loader with layered overrides and secret references;
3. a text ingestion, indexing, and search pipeline; and
4. authentication/authorization policy with auditable decisions.

Each should remain portable and independently verifiable. They should not flatten an
entire product into one Component merely to look impressive: public contracts and small
composable capability boundaries are part of the lesson.

Source: [docs/architecture/sample-portfolio-review.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/sample-portfolio-review.md) at commit `fcc40bc` (source lines 101–116).
