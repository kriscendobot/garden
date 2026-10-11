---
title: "ADR 0019: Opt-in policy and fail-closed observation"
source: docs/decisions/0019-opt-in-external-source-intelligence.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: `none` remains a no-discovery, no-execution default, while an explicit `codegraph-cli` policy binds command, version, artifact, stage, and publication settings and fails required stages closed on unavailable or unstable evidence.

New projects select `none` with all stages off unless a caller explicitly requests the
external provider. Opted-in projects use the existing policy fields as authority and may
run sync or check only through the configured command. Required observations reject a
missing or old executable, missing or stale database, malformed status, changed source
identity, or artifact mutation during observation. Optional stages report bounded
unavailability and off stages do no provider work.

The project index does not automatically describe a separately quarantined generated
source tree. Repository-source admission therefore remains off unless a project supplies
a distinct provider for that tree, preserving the boundary between project observation
and generated-source evidence.

Source: [docs/decisions/0019-opt-in-external-source-intelligence.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0019-opt-in-external-source-intelligence.md) at commit `fcc40bc6` (source lines 25-49).
