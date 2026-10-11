---
title: "ADR 0031: Conflict-safe migration"
source: docs/decisions/0031-durable-user-configuration-home.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: A dry-run-first migration validates legacy assets, rejects symlinks, stages and verifies destination bytes, publishes atomically, and removes a source only after durable success.

Existing identical destinations make replay idempotent; differing destinations are typed conflicts that preserve both sides. Reports identify source, destination, and kind without printing credentials, endpoints, or event payloads, and partial failure keeps the original intact.

Source: [docs/decisions/0031-durable-user-configuration-home.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0031-durable-user-configuration-home.md) at commit `fcc40bc6`.
