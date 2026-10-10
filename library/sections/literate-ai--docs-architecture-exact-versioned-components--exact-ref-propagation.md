---
title: Propagating exact refs through composition, locks, routing, skills, and publication
source: docs/architecture/exact-versioned-components.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Exact refs propagate through every consumer: Component composition, Flavor locks, model groups and route decisions, skill catalogs and dependency refs, bundle manifests, and publication manifests and receipts; bare-ID routing survives only while unique, and import rejects a mismatched coordinate, version, or revision before copying.

- Component composition accepts and emits exact Component refs while preserving exact revision dependency edges.
- Flavor locks bind the exact base Component ref, versioned target profile, and ordered exact Flavor refs.
- Model groups may pin exact endpoint refs, policies may pin exact group refs, and route decisions record both selected exact refs. Bare-ID routing remains a compatibility path only while unique.
- Skill catalogs retain all revisions. `SkillRef` selects exact skill bytes; exact dependency refs reject a same-ID but different-version substitute.
- Bundle manifests and every bundle dependency bind a `ComponentRevisionRef`; the ref participates in the content-addressed manifest identity.
- Publication manifests and receipts carry the exact Component ref. Import requires an expected ref and rejects a different coordinate, version, or revision before copying content.

Source: [docs/architecture/exact-versioned-components.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/exact-versioned-components.md) at commit `fcc40bc`.
