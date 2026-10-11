---
title: "ADR 0027: Monolith and request-time collection failure"
source: docs/decisions/0027-durable-split-service-pattern.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: Dashboard generators repeatedly coupled browser availability, upstream latency, credentials, and volatile state by recollecting provider data inside request handlers, motivating a reusable split-service composition.

The failure was not merely performance. A restart erased state, frontend requests
inherited collection failure, and read surfaces gained authority to reach upstream
systems. Two independently evolved projects converged on the same separation, showing
that the missing artifact was reusable architecture rather than another product kind.

Source: [docs/decisions/0027-durable-split-service-pattern.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0027-durable-split-service-pattern.md) at commit `fcc40bc6`.
