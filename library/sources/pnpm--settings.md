---
source_kind: repo-doc
source_repo: pnpm/pnpm.io
source_path: docs/settings.md
source_commit: 0cf4bd35393b8d3712debd5a301bcdf2163d5b69
source_date: 2026-06-24
source_authors: [Zoltan Kochan, Dasa Paddock, Igal Klebanov, Ilya Priven]
ingested: 2026-07-17
ingested_by: scholar
section_count: 2
status: current
---

Abstract: pnpm's `pnpm-workspace.yaml` settings reference — the new home (since pnpm v11) of the dependency-resolution controls that earlier synthesis placed under a `pnpm` block in `package.json`. This is the authoritative source for pnpm's override dialect and its peer-dependency relaxation rules: `overrides` (force/replace/remove any dependency in the graph, root-only, with `parent>dep` selectors, `catalog:` references, and `-` removal, applying to peer dependencies too), `packageExtensions` (add/correct `dependencies`/`optionalDependencies`/`peerDependencies`/`peerDependenciesMeta` on a third-party manifest — the same database Yarn and pnpm co-maintain), and `peerDependencyRules` (`ignoreMissing`, `allowedVersions`, `allowAny` — pnpm's answer to npm's stricter peer handling). Only the resolution-control and peer-rule sections are ingested here; the full settings catalog (store, hoisting, node-linker, network) is out of scope for the package-manifest topic. This backs the pnpm cells of the override-dialects and peer-dependency rows in the property-consumer matrix, and corrects the location of pnpm's override block.

| Section | Topics | Status |
|---------|--------|--------|
| [overrides](../sections/pnpm--settings--overrides.md) | package-manifest, node-packaging | current |
| [package-extensions-and-peer-rules](../sections/pnpm--settings--package-extensions-and-peer-rules.md) | package-manifest, node-packaging | current |

Source: [docs/settings.md](https://github.com/pnpm/pnpm.io/blob/0cf4bd35393b8d3712debd5a301bcdf2163d5b69/docs/settings.md) at commit `0cf4bd3`.
