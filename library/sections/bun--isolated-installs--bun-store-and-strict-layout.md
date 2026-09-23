---
title: Bun isolated installs and strict layout
source: docs/pm/isolated-installs.mdx
source_repo: oven-sh/bun
source_commit: 6618e7f7e390704358a705225e90dd0f55401773
source_date: 2026-07-17
source_authors: [Dylan Conway]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Bun's isolated linker uses `node_modules/.bun` store entries plus symlinks to prevent phantom dependencies; it is the default for new workspace projects with lockfile `configVersion = 1`.

`bun install --linker isolated` creates a non-hoisted layout where packages access only declared dependencies. Store entries live under `node_modules/.bun/<package>@<version>/node_modules`, and top-level dependencies are symlinks to them. Peer contexts are encoded in store entry names and identical package-ID plus peer-set entries are shared. Workspace packages are symlinked directly to source directories. New workspace projects using lockfile `configVersion = 1` default to the isolated linker; `--linker hoisted` or Bun configuration selects the conventional alternative.

Source: [docs/pm/isolated-installs.mdx](https://github.com/oven-sh/bun/blob/6618e7f7e390704358a705225e90dd0f55401773/docs/pm/isolated-installs.mdx) at commit `6618e7`.
