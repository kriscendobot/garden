---
title: "ADR 0030: Canonical skill catalog"
source: docs/decisions/0030-executable-cross-layer-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: One application service owns sentinel-skill discovery, resource closure, ancestor inheritance, identity and reference validation, and change impact.

Initialization, validation, authoring, authority graphs, and changed-skill evaluation consume that catalog instead of scanning independently. A catalog is either complete or an explicitly validated subset; projections include owned resources and required ancestor context without recursively swallowing descendant scopes.

Source: [docs/decisions/0030-executable-cross-layer-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0030-executable-cross-layer-authority.md) at commit `fcc40bc6`.
