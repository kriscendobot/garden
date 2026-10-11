---
title: "ADR 0031: Fail-closed cutover and validation"
source: docs/decisions/0031-durable-user-configuration-home.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: New resolvers refuse silent legacy fallback and instead return a typed migration-required diagnostic naming the explicit apply command.

Validation covers dry-run purity, idempotence, conflicts, relative paths, symlinks, permissions, platform simulations, project isolation, and secret-free output. Legacy ignore entries remain temporarily as a commit-safety net, but read-only commands never migrate private data implicitly.

Source: [docs/decisions/0031-durable-user-configuration-home.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0031-durable-user-configuration-home.md) at commit `fcc40bc6`.
