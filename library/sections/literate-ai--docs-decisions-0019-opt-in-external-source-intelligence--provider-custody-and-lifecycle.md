---
title: "ADR 0019: Provider custody and lifecycle"
source: docs/decisions/0019-opt-in-external-source-intelligence.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance, software-supply-chain]
status: current
---

> Abstract: Operators or derived projects own installation and worker provisioning; Literate AI only verifies and invokes a configured command, and all lifecycle consumers honor the same explicit policy without silently weakening it.

The framework adds no package dependency, executable bootstrap, companion worker
capability, or universal prerequisite. Installation remains outside its custody.
Validation, verification, and lifecycle boundaries consume one bounded observation for
the selected stage. A required external-provider policy cannot be rewritten to `none`,
while default-none projects retain the dependency-free behavior of ADR 0016.

Source: [docs/decisions/0019-opt-in-external-source-intelligence.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0019-opt-in-external-source-intelligence.md) at commit `fcc40bc6` (source lines 51-63).
