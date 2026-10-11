---
title: "ADR 0019: Consequences and acceptance"
source: docs/decisions/0019-opt-in-external-source-intelligence.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Acceptance requires identical no-provider behavior for default projects, portable sync and check for explicit projects, fail-closed required stages, zero ambient provisioning, and equivalent focused regressions on both release lines.

ADR 0016 continues to govern defaults, automatic provisioning, worker capabilities, and
framework prerequisites. External providers become available only as explicitly managed
project dependencies. Tests must show that `none` invokes nothing, opted-in operation
works across Linux, macOS, and Windows, and missing, stale, malformed, tampered, or
version-incompatible evidence is rejected without adding packages or global setup.

Source: [docs/decisions/0019-opt-in-external-source-intelligence.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0019-opt-in-external-source-intelligence.md) at commit `fcc40bc6` (source lines 83-102).
