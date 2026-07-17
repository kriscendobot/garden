---
title: Symlinked node_modules store and visibility
source: docs/symlinked-node-modules-structure.md
source_repo: pnpm/pnpm.io
source_commit: 8a01423859b423bba444cb241bf91aa7d9d499f2
source_date: 2026-07-12
source_authors: [Jiří Podivín]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: pnpm materializes package files as hardlinks in `node_modules/.pnpm` and builds the dependency graph with symlinks, preserving Node compatibility while limiting access to declared dependencies.

Each package has a `.pnpm/<name>@<version>/node_modules/<name>` location whose files are hardlinks to pnpm's content-addressable store. Dependencies are symlinked beside that package and root direct dependencies are symlinked into root `node_modules`. The nested `node_modules` segment lets a package import itself and avoids circular symlinks; Node follows the real package path so its dependencies resolve there. This keeps the filesystem depth constant as the graph deepens. pnpm can hoist dependencies into `.pnpm/node_modules` for compatibility, so maximum strictness requires configuring hoisting accordingly.

Source: [docs/symlinked-node-modules-structure.md](https://github.com/pnpm/pnpm.io/blob/8a01423859b423bba444cb241bf91aa7d9d499f2/docs/symlinked-node-modules-structure.md) at commit `8a01423`.
