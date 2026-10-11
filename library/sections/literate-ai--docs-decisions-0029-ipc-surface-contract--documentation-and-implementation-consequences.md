---
title: "ADR 0029: Documentation and implementation consequences"
source: docs/decisions/0029-ipc-surface-contract.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: Generated, discoverable, conformance-checked self-description becomes the always-current API documentation, while product narrative remains project authority.

Implementation adds a shared surface contract and oracle plus REST and gRPC adapters; MCP is reframed without changing its behavior. Protocol toolchains are acceptance-time dependencies only for Components that declare those surfaces, and deterministic fixtures keep credentials and verifier-only expected values outside generation prompts.

Source: [docs/decisions/0029-ipc-surface-contract.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0029-ipc-surface-contract.md) at commit `fcc40bc6`.
