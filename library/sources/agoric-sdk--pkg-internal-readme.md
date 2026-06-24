---
source: packages/internal/README.md
source_repo: agoric/agoric-sdk
source_commit: 059a66a1ebec72f9f8015ff010fed5fc902ed907
source_date: 2025-09-16
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 1
status: current
notes: This package is the explicit "internal-only" sandbox: never reach 1.0 (perpetual 0.y.z SemVer), never export ambient types, may not depend on other repo packages except for a small allowlist (base-zone, store, cosmic-proto — all themselves destined for migration). Agents importing from this package should always use deep imports (`@agoric/internal/src/...`) to keep bundle sizes small.
---

> Abstract: `@agoric/internal` is the unsupported intra-repo utility-modules home. **Never** reaches 1.0 (deliberately stays in 0.y.z per SemVer spec item 4 — anything may change at any time). May not depend on any other agoric-sdk packages except base-zone, store, and cosmic-proto (each of which has no agoric deps and may itself migrate). Never exports ambient types. Consumers should use **deep imports** (e.g., `import { defineName } from '@agoric/internal/src/js-utils.js'`) to keep `@endo/bundle-source` bundle sizes small.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-internal-readme--overview.md) | repository-governance | current |

## Source

[packages/internal/README.md](https://github.com/Agoric/agoric-sdk/blob/059a66a1ebec72f9f8015ff010fed5fc902ed907/packages/internal/README.md) at commit `059a66a1`.
