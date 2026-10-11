---
title: "ADR 0030: Host-platform path policy"
source: docs/decisions/0030-executable-cross-layer-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: An immutable injectable host-path policy centrally resolves semantic config, data, cache, state, tool, install, and temporary locations while leaving portable logical paths and OS-owned roots distinct.

Static checks reject ambient home discovery, host-root environment reads, and absolute path literals outside the owner, with narrow exceptions for target-machine transport code and stage-zero bootstrap. Explicit overrides retain precedence, and migrations never silently merge conflicting locations.

Source: [docs/decisions/0030-executable-cross-layer-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0030-executable-cross-layer-authority.md) at commit `fcc40bc6`.
