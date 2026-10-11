---
title: "ADR 0038: Generated tests and independent acceptance"
source: docs/decisions/0038-importable-library-artifact-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Framework-owned drivers report exact selected generated cases, while verifier-owned per-capability oracles independently import and observe the sealed artifact in fresh custody.

Generated test adapters cannot add, omit, rename, or convert aggregate results into favorable per-case evidence. Acceptance binds specifications, public interfaces, import surface, artifact identity, and harness source.

Python and JavaScript load only bounded artifact roots; Rust builds a separate verifier crate whose exact path dependencies resolve to the sealed graph. Stale oracles, capability mismatches, import escapes, artifact substitution, and unexpected cases fail acceptance.

Source: [docs/decisions/0038-importable-library-artifact-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0038-importable-library-artifact-authority.md) at commit `fcc40bc6`.
