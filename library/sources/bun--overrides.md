---
source_kind: repo-doc
source_repo: oven-sh/bun
source_path: docs/pm/overrides.mdx
source_commit: 16a7269639d9093da7685fcf3edcea53431df0a7
source_date: 2026-06-30
source_authors: [Alistair Smith, Lydia Hallie, Michael H]
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
---

Abstract: Bun's dependency-override support — it reads **both** npm's `overrides` and Yarn's `resolutions` from `package.json`, deliberately supporting the latter to ease migration from Yarn. Both fields pin a version range for metadependencies (the dependencies of your dependencies). Bun's key limitation versus npm: it supports **only top-level** overrides/resolutions, not npm's nested-override selectors. This backs the Bun cell of the override-dialects row in the property-consumer matrix.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/bun--overrides--overview.md) | package-manifest, node-packaging | current |

Source: [docs/pm/overrides.mdx](https://github.com/oven-sh/bun/blob/16a7269639d9093da7685fcf3edcea53431df0a7/docs/pm/overrides.mdx) at commit `16a7269`.
