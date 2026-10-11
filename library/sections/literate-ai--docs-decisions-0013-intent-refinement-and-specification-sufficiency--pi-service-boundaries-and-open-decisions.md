---
title: "ADR 0013: Pi-service boundaries and open decisions"
source: docs/decisions/0013-intent-refinement-and-specification-sufficiency.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The distributed pi reference case separates mathematical logic, CPU and GPU workers, job service, progress protocol, web frontend, and deployment composition, then exposes unresolved numerical, streaming, lifecycle, measurement, trust, and placement decisions instead of letting generation invent them.

The proposed graph gives each independently generated or deployed surface a public
boundary. `pi-computation` owns mathematics and partitioning; workers realize CPU or GPU
targets behind one semantic protocol; the job service owns admission, scheduling,
persistence, retries, and APIs; the progress contract owns event schemas; the browser
owns presentation; deployment binds machines and Flavors. A progress library becomes a
Component only if it has an independent build, version, or publication lifecycle.

Blocking questions include the meaning and precision of the result, allowed algorithms,
cross-target equivalence, partition and reduction rules, provisional versus terminal
stream data, progress measurement, reconnect ordering, legal job states, worker-loss
and cancellation behavior, resource-counter semantics and availability, authentication,
encryption, tenancy, quotas, hardware targets, placement, and restart persistence.
Refinement may propose bounded defaults but keeps these visible until accepted or
explicitly excluded.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 252-328).
