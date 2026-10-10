---
title: Hexagonal architecture and authority boundary
source: docs/architecture/domain-model.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Literate AI separates immutable domain values and transition rules from application orchestration, injected effectful ports, concrete adapters, and presentation layers, so model providers and filesystem operations do not become behavioral authority.

The domain contains Components, specifications, capabilities, runs, evidence, packages, identities, lifecycle, security, settings, and publications. Application services coordinate injected ports such as model invocation, validation, classification, build authorization, build, workspace, and events. Adapters perform I/O; CLIs and UIs invoke application services without reaching into adapter state.

This architecture makes the authority boundary testable: model choice, filesystem discovery, and coding-CLI transport remain adapters or policy, while canonical identities and lifecycle semantics remain language-neutral domain contracts. An outer agent or task ledger integrates through content-addressed derivation-run envelopes rather than shared mutable workflow state.

Source: [docs/architecture/domain-model.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/architecture/domain-model.md) at commit `2820f85`.
