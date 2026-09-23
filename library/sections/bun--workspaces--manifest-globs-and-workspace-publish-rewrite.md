---
title: Bun workspaces and workspace publish rewrite
source: docs/pm/workspaces.mdx
source_repo: oven-sh/bun
source_commit: 6618e7f7e390704358a705225e90dd0f55401773
source_date: 2026-07-17
source_authors: [Dylan Conway]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Bun reads root `package.json` `workspaces` patterns, links local workspace dependencies, and rewrites `workspace:` ranges to publishable versions.

Bun accepts full glob syntax, including negated patterns, in the root `workspaces` array. `bun install` installs all workspace dependencies and links a local workspace instead of downloading it. Workspace references may use semver or `workspace:`. On publication, `workspace:*`, `workspace:^`, and `workspace:~` are replaced with the workspace package version (exact, caret, and tilde forms), while a specific version wins over the current version.

Source: [docs/pm/workspaces.mdx](https://github.com/oven-sh/bun/blob/6618e7f7e390704358a705225e90dd0f55401773/docs/pm/workspaces.mdx) at commit `6618e7`.
