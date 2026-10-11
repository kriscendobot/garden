---
title: "ADR 0019: Rejected policy alternatives"
source: docs/decisions/0019-opt-in-external-source-intelligence.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: The ADR rejects a universal provider prerequisite, weakening a derived project's required evidence policy, maintaining a private framework fork, and restoring only a writer CLI that downstream lifecycle gates would ignore.

Fully restoring CodeGraph would burden projects that did not opt in. Preserving ADR
0016 by changing the derived project to `none` would weaken authored evidence, while a
private framework fork would break repository lineage. Restoring only the parser and
index writer would create false evidence if validation and lifecycle code continued to
ignore or reject the resulting artifact.

Source: [docs/decisions/0019-opt-in-external-source-intelligence.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0019-opt-in-external-source-intelligence.md) at commit `fcc40bc6` (source lines 65-81).
