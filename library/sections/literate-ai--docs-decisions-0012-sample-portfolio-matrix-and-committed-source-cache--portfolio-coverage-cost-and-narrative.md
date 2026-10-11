---
title: "ADR 0012: Portfolio coverage, cost, and narrative"
source: docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The sample portfolio simultaneously serves conformance, newcomer documentation, and premise validation, but opportunistic growth produced redundant simple cases, sparse composition-axis coverage, and repeated cold live generation despite an existing committed-cache target.

The proposed ADR observes 23 samples with heavy concentration on two portable skills,
thin or absent coverage for several languages, build systems, operating systems, and
deployment, and substantial overlap among starter examples. Accepted source remained
operator-local even though `generated/committed-source-cache/` already existed.

The maintainers frame the tradeoff as three constraints: cover simple through complex
capability combinations, avoid making every contributor pay for redundant cold
generation, and keep examples as relatable engineering narratives rather than an
arbitrary combinatorial suite.

Source: [docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md) at commit `fcc40bc6` (source lines 1-29).
