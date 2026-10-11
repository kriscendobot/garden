---
title: "ADR 0005: Lifecycle-driver trust provenance"
source: docs/decisions/0005-executable-component-semantics.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Framework-distributed and project-supplied lifecycle drivers have mutually exclusive provenance: standard drivers bind framework distribution and policy but carry no project authorization, while external drivers require exact project authorization and policy but cannot claim framework identity.

A standard lifecycle driver is distributed by literate-ai and binds the exact framework
distribution and policy identities. It cannot carry project authorization. An external
driver is project-supplied and requires an exact project authorization and policy
identity. It cannot claim a framework distribution identity. The two trust modes are
mutually exclusive and fail closed when their required authority is absent.

Source: [docs/decisions/0005-executable-component-semantics.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0005-executable-component-semantics.md) at commit `fcc40bc` (source lines 110–116).
