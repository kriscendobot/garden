---
source_kind: repo-doc
source_repo: oven-sh/bun
source_path: docs/pm/lifecycle.mdx
source_commit: 16a7269639d9093da7685fcf3edcea53431df0a7
source_date: 2026-06-30
source_authors: [Alistair Smith, Jarred Sumner, Lydia Hallie, robobun]
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
---

Abstract: Bun's `trustedDependencies` field and its "default-secure" lifecycle-script policy — the security-relevant way Bun diverges from npm's run-everything-by-default behavior. Because lifecycle scripts (`preinstall`/`postinstall`/…) run arbitrary shell commands, Bun does **not** execute them by default; it only runs them for packages on an allow list. A curated built-in list covers popular npm packages; `trustedDependencies` in `package.json` lets a project name additional packages. The subtle, easy-to-miss semantics: defining `trustedDependencies` **replaces** the default list rather than extending it, and only npm-source packages are ever covered by the built-in list (never `file:`/`link:`/`git:`/`github:` sources). This backs the Bun cell of the lifecycle-scripts / `trustedDependencies` row in the property-consumer matrix.

| Section | Topics | Status |
|---------|--------|--------|
| [trusted-dependencies](../sections/bun--lifecycle--trusted-dependencies.md) | package-manifest, node-packaging | current |

Source: [docs/pm/lifecycle.mdx](https://github.com/oven-sh/bun/blob/16a7269639d9093da7685fcf3edcea53431df0a7/docs/pm/lifecycle.mdx) at commit `16a7269`.
