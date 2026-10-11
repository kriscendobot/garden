---
title: "ADR 0031: Central user configuration root"
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

> Abstract: One platform-resolved configuration root holds reusable worker and MCP catalogs plus project-ID-keyed live-test selection, with absolute explicit overrides taking precedence.

POSIX hosts use `LITAI_CONFIG_DIR`, then XDG configuration, then `$HOME/.config/literate-ai`; Windows uses the Roaming AppData Known Folder through an adapter. Checked-in public examples remain project authority and are never silently converted into private configuration.

Source: [docs/decisions/0031-durable-user-configuration-home.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0031-durable-user-configuration-home.md) at commit `fcc40bc6`.
