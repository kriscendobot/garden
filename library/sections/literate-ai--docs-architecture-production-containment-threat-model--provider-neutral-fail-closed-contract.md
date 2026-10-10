---
title: Provider-neutral fail-closed isolation contract
source: docs/architecture/production-containment-threat-model.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [sandbox-platforms, agentic-sdlc]
status: current
---

> Abstract: Immutable isolation policy, request, observation, and decision records bind exact stage, subject, target, controls, policy, backend, and execution identities, while deterministic evaluation refuses missing stages, mismatched closures, incomplete enforcement, weak levels, absent controls, noncanonical records, and unacknowledged ambient-host execution.

The provider-neutral contract evaluates supplied facts but never discovers a backend, starts a process, or upgrades an observation. Exact recomputation detects substituted inputs but remains non-authorizing. The wire schema keeps local observations explicitly unauthenticated so a future authenticated evidence envelope can enclose them without redefining their meaning.

`unsupported`, `rejected`, and `reported-sufficient` are all pre-authorization states. `host-yolo` cannot claim containment controls, and even mutually permitted and acknowledged ambient-host execution needs a separate scoped, expiring, non-replayable operator grant before launch.

Source: [docs/architecture/production-containment-threat-model.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/production-containment-threat-model.md) at commit `fcc40bc`.
