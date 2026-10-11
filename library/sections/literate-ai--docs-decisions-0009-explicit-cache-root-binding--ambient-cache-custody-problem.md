---
title: "ADR 0009: Ambient cache-custody problem"
source: docs/decisions/0009-explicit-cache-root-binding.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: `BUILD_DIR` and `OBJ_DIR` changed lifecycle behavior solely through ambient environment and were absent from receipts, making warm and cold runs of one revision indistinguishable and obstructing diagnosis even though an explicit binding seam and custody identity already existed.

The generated-source and object/tool cache roots came from environment variables or
project-local defaults. Make accepted overrides and external drivers propagated an
allowlist, but `litai rebuild`, the receipt-producing entry point, had no corresponding
flags. Operators could not express custody in the command itself.

`CacheDirectories.identity` already bound the project, build, and object roots, and
`bind_cache_directories()` already accepted explicit paths without consulting ambient
state. Receipts nevertheless omitted the identity. During the 0.5.2 cycle, a warm
sample run passed while a cold rebuild failed on the same revision, and the evidence
did not disclose the difference.

Source: [docs/decisions/0009-explicit-cache-root-binding.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0009-explicit-cache-root-binding.md) at commit `fcc40bc6` (source lines 1-52).
