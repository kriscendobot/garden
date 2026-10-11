---
title: "ADR 0029: Adapters and schema authority"
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

> Abstract: MCP tools and resources, REST OpenAPI and JSON Schema, and gRPC protobuf and reflection specialize one IPC-surface contract rather than becoming unrelated framework features.

The declared schema is authoritative whether supplied inline or by a shared schema-only Component. Schema-first client and server generation is enabled but not required. GraphQL remains out of scope because its introspection and versioning semantics warrant a separate adapter decision.

Source: [docs/decisions/0029-ipc-surface-contract.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0029-ipc-surface-contract.md) at commit `fcc40bc6`.
