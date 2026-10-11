---
title: "ADR 0029: Missing cross-protocol contract"
source: docs/decisions/0029-ipc-surface-contract.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations]
status: current
---

> Abstract: Literate AI had schema, structured-error, description, and identity rules for MCP but no equivalent versioned, discoverable, contract-tested boundary for REST or gRPC.

Frontend-to-API compositions consequently agreed by convention, served no canonical machine description, and lacked an oracle that compared runtime responses with the declared interface. Separate protocol skills would reproduce and eventually drift on the same schema, versioning, and error rules.

Source: [docs/decisions/0029-ipc-surface-contract.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0029-ipc-surface-contract.md) at commit `fcc40bc6`.
