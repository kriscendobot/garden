---
title: "ADR 0029: Protocol-neutral IPC surface"
source: docs/decisions/0029-ipc-surface-contract.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations, testing]
status: current
---

> Abstract: A protocol-neutral IPC surface combines schema-validated operations, generated self-description, independent conformance acceptance, and a semantic-version compatibility promise.

Invalid input fails before execution with a structured error. A verifier launches the shipped deployment unit, fetches its description, compares it with the declared schema, drives deterministic request cases, and validates typed responses. Surface versions reuse the Component compatibility mechanism so breaking changes become explicit transitions.

Source: [docs/decisions/0029-ipc-surface-contract.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0029-ipc-surface-contract.md) at commit `fcc40bc6`.
