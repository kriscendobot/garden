---
title: "ADR 0021: Interactive and headless setup"
source: docs/decisions/0021-operator-local-mcp-catalog.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations]
status: current
---

> Abstract: Agent sessions may discover attached or registered servers and author the catalog with human choice, while bare CLI use offers only an interactive TTY setup and headless or JSON operation writes nothing.

Setup runs when the catalog is absent or empty or the user asks. A coding session may
inspect already-connected MCPs and optionally consult a reachable registry. A no-agent
CLI may offer an ids-only flow only on a TTY; declining writes an empty catalog so the
offer does not repeat. Continuous integration and other noninteractive uses continue
with an empty in-memory catalog. No discovery daemon is introduced.

Source: [docs/decisions/0021-operator-local-mcp-catalog.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0021-operator-local-mcp-catalog.md) at commit `fcc40bc6` (source lines 37-49).
