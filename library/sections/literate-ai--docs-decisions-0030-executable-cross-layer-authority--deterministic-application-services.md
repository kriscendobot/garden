---
title: "ADR 0030: Deterministic application services"
source: docs/decisions/0030-executable-cross-layer-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations]
status: current
---

> Abstract: CLI and MCP handlers become adapters over shared Python services for record mutation, catalogs, channel ingestion, compatibility resolution, and artifact inspection.

Agent skills retain routing, judgment, and fail-closed boundaries but call exact commands or resources for identifier allocation, parsing, path resolution, and structured edits. This replaces prompt-reproduced algorithms with one deterministic implementation exposed through multiple surfaces.

Source: [docs/decisions/0030-executable-cross-layer-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0030-executable-cross-layer-authority.md) at commit `fcc40bc6`.
