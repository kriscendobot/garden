---
title: "ADR 0030: Compatibility and migration consequences"
source: docs/decisions/0030-executable-cross-layer-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance, testing]
status: current
---

> Abstract: Centralization proceeds in externally testable stages, preserving explicit overrides and compatibility while adding checks that prevent new duplicate discovery or host-default logic.

The immediate gate repairs keep ordinary tests off live models and preserve optional-dependency authority. The longer migration accepts stronger internal service boundaries and legacy-path tests in exchange for fewer divergent taxonomy, dependency, and platform implementations.

Source: [docs/decisions/0030-executable-cross-layer-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0030-executable-cross-layer-authority.md) at commit `fcc40bc6`.
