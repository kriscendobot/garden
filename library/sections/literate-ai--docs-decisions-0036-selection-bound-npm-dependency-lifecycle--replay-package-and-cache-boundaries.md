---
title: "ADR 0036: Replay, package, and cache boundaries"
source: docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, capability-security]
status: current
---

> Abstract: Shell-free lock replay runs in fresh object custody, seals the exact installed graph beside the application, blocks ambient Node and npm authority, and distrusts reopened artifact self-manifests.

Preflight validates manifest, lock, imports, SBOM agreement, and the dependency-bearing target before npm runs. Scripts, audit, funding, binary links, global installs, authentication, publication, ambient paths, options, configuration, and compile caches remain unauthorized.

Observation rejects links, native payloads, authority-escaping entrypoints and imports, and unresolved package closure. Same-process cache hits rely on outside identity; reopened lifecycles rebuild fresh and require byte-identical output.

Source: [docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0036-selection-bound-npm-dependency-lifecycle.md) at commit `fcc40bc6`.
