---
title: Why These Requirements Matter
source: docs/commit-hygiene.md
source_repo: agoric/agoric-sdk
source_commit: 61325fe5
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [repository-governance]
status: current
---

> Abstract: Rationale: agoric-sdk's CI is expensive (consensus + chain integration tests); pre-commit hygiene reduces feedback-loop time and catches issues before merge.

## Why These Requirements Matter

- **Codegen**: Ensures generated code is in sync with proto definitions
- **Package Locks**: Keeps all yarn.lock files synchronized across the monorepo, preventing version conflicts
- **Formatting**: Maintains consistent code style across the codebase
- **Linting**: Catches common errors and enforces code quality standards
- **Testing**: Prevents regressions and ensures functionality


Source: [docs/commit-hygiene.md](https://github.com/agoric/agoric-sdk/blob/61325fe5/docs/commit-hygiene.md) at commit `61325fe5`.
