---
title: "ADR 0027: Conformance and operational consequences"
source: docs/decisions/0027-durable-split-service-pattern.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: A portfolio sample and conformance matrix bind the four-boundary topology into locks and CycloneDX evidence, with deterministic tests for scheduling, leases, restart, retries, long runs, cancellation, and cross-process status.

The pattern costs a nontrivial reference composition and skill, and depends on the
deployment-unit mechanism in
[ADR 0026](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0026-multi-entrypoint-deployment-units.md).
Its benefit is making restart-safe, credential-isolated service structure inheritable
and testable instead of repeatedly generated as a request-time collector monolith.

Source: [docs/decisions/0027-durable-split-service-pattern.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0027-durable-split-service-pattern.md) at commit `fcc40bc6`.
