---
title: Build (yarn install + node_modules layout + kernel bundles)
source: README.md
source_repo: agoric/agoric-sdk
source_commit: 511d4f74bae7144be5bc904dd7a50f01d09648ed
source_date: 2026-03-25
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, bundles]
status: current
---

> Abstract: The standard build sequence: `corepack enable && yarn install && yarn build`. Explains the node_modules layout: top-level `node_modules/` holds shared deps; per-subproject `node_modules/` holds the deps unique to that subproject (with an aspirational goal to eliminate all such uniqueness). Inter-subproject deps are symlinks (e.g., `node_modules/@endo/marshal` → `packages/marshal`). `yarn workspaces info` reports the dependency graph; the `mismatchedWorkspaceDependencies` section identifies symlink-blockers (version mismatches) the contributor should resolve. `yarn build` generates kernel bundles.

## Build

From a new checkout of this repository, run:

```sh
corepack enable
yarn install
yarn build
```

When the `yarn install` is done, the top-level `node_modules/` will contain all
the shared dependencies, and each subproject's `node_modules/` should contain
only the dependencies that are unique to that subproject (e.g. when the version
installed at the top level does not meet the subproject's constraints). Our goal
is to remove all the unique-to-a-subproject deps.

When one subproject depends upon another, `node_modules/` will contain a symlink
to the subproject (e.g. `ERTP` depends upon `marshal`, so
`node_modules/@endo/marshal` is a symlink to `packages/marshal`).

Run `yarn workspaces info` to get a report on which subprojects (aka
"workspaces") depend upon which others. The `mismatchedWorkspaceDependencies`
section tells us when symlinks could not be used (generally because e.g. `ERTP`
wants `marshal@0.1.0`, but `packages/marshal/package.json` says it's actually
`0.2.0`). We want to get rid of all mismatched dependencies.

The `yarn build` step generates kernel bundles.

Source: [README.md](https://github.com/Agoric/agoric-sdk/blob/511d4f74bae7144be5bc904dd7a50f01d09648ed/README.md) at commit `511d4f74`.
