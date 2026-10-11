---
title: "ADR 0013: Atomic acceptance and Component decomposition"
source: docs/decisions/0013-intent-refinement-and-specification-sufficiency.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Accepting a draft is an explicit, atomic, identity-bound write that materializes reviewed authority without generating or executing code, and decomposition preserves separate executable lifecycles rather than flattening multiple entrypoints into one Component.

Acceptance may create or update Component specifications, public contracts, assets,
Flavor selectors, and acceptance contracts. It fails on unresolved blockers, stale
authored bases, foreign draft identities, omissions, extra answers, silent assumptions,
host choices copied into portable behavior, or independently executable surfaces
collapsed together. Each decision records its draft, answer, reviewer authority, and
resulting content identities; later refinement produces a new historical basis.

The binding operations are draft, explain, and explicitly accept, regardless of final
CLI spelling. Preview is the default, machine-readable findings are primary, and exit
status distinguishes complete drafts, drafts needing decisions, and invalid or failed
refinement. Component splitting follows lifecycle ownership: independent entrypoint,
contract, generation context, cache, build, test, SBOM, version, deployment, or
publication needs a Component. Shared domain logic belongs in a library Component and
executable surfaces compose through public capabilities.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 182-250).
