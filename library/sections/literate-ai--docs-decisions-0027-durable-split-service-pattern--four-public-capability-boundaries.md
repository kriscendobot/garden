---
title: "ADR 0027: Four public-capability boundaries"
source: docs/decisions/0027-durable-split-service-pattern.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: The reusable pattern separates a credential-free browser frontend, a read-only snapshot API, a sole upstream-capable collector, and a durable single-writer SQL cache, connecting them only through public capabilities.

SQLite is the initial cache, configured for write-ahead logging, a busy timeout,
explicit migrations, and read-only reader connections. Each boundary is an independent
deployment unit. The pattern remains substitutable composition rather than a built-in
dashboard kind, so projects retain authority over schemas, providers, credentials, and
technology choices.

Source: [docs/decisions/0027-durable-split-service-pattern.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0027-durable-split-service-pattern.md) at commit `fcc40bc6`.
