---
title: dependenciesMeta, peerDependenciesMeta, and peer-dependencies-with-default
source: packages/docusaurus/static/configuration/manifest.json
source_repo: yarnpkg/berry
source_commit: ab0afaf88dcbf6eb52731d0bc25bbe9fed655f8b
source_date: 2025-04-07
source_authors: [Gautier Ben Aïm, Maël Nison]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Yarn Berry's per-dependency metadata fields and its peer-dependency extensions. `dependenciesMeta.<pkg>` carries `built` (deny/allow-list a package's postinstall build script — the vehicle behind Yarn's `enableScripts`-off allow-list mode), `optional` (identical effect to `optionalDependencies`, into which `optionalDependencies` internally compiles), and `unplugged` (force a package to be extracted to disk rather than loaded from its zip, needed for packages containing non-JS build artifacts like `nan`'s C++ headers). Most `dependenciesMeta` settings are root-only in a workspaced project, except `optional` which is allowed anywhere. `peerDependenciesMeta.<pkg>.optional` silences the unsatisfied-peer warning. Yarn also extends the peer-dependency semantics with **"peer dependencies with default"**: a package listing a dependency in both `dependencies` and `peerDependencies` will try to solve the peer first and fall back to the regular dependency when the peer cannot be satisfied. This backs the Yarn cell of the peer-dependency-behavior row in the property-consumer matrix.

## dependenciesMeta

Extra settings affecting how `dependencies` and `devDependencies` are interpreted. In a workspaced project most of these settings affect **all workspaces** and so must be specified at the **root** — the field is ignored inside a non-root workspace unless noted otherwise. Per-package keys:

- **`built`** (boolean): whether to run the package's postinstall build script. If `false`, the package is **never built** (a deny-list). This behavior reverses when the `enableScripts` yarnrc setting is off — then only packages with `built` explicitly `true` are built (an allow-list), while those explicitly `false` have their build-script warnings downgraded to notices.
- **`optional`** (boolean): identical effect to `optionalDependencies` — in fact `optionalDependencies` compiles down to this internally. Unlike most `dependenciesMeta` settings, `optional` is allowed **anywhere** in the dependency tree.
- **`unplugged`** (boolean): if `true`, the package is automatically unplugged (extracted to disk) at install time. Needed for packages containing scripts in languages other than JavaScript (for example `nan`, which ships C++ headers).

## peerDependenciesMeta

Extra settings affecting how `peerDependencies` is interpreted; unlike `dependenciesMeta`, `peerDependenciesMeta` is allowed in **any** part of the dependency tree. Its per-package `optional` (boolean): if `true`, the selected peer is marked optional, silencing the warning Yarn would otherwise emit when it is unsatisfied.

## Peer dependencies, and "peer dependencies with default"

Yarn's peer-dependency semantics guarantee that when the package requires the dependency it receives the exact same object instance the package's ancestor would receive — the mechanism that makes peer dependencies the way to share singleton state across packages. As an extension, Yarn supports **peer dependencies with default**: a dependency listed in *both* the `dependencies` and `peerDependencies` fields will try to solve the peer dependency first, but falls back to the regular dependency if the peer cannot be satisfied otherwise. This differs from npm (which auto-installs peers as of v7) and from pnpm (which surfaces peer issues loudly and offers `peerDependencyRules` to relax them): the same manifest produces different installed trees under different managers.

Source: [packages/docusaurus/static/configuration/manifest.json](https://github.com/yarnpkg/berry/blob/ab0afaf88dcbf6eb52731d0bc25bbe9fed655f8b/packages/docusaurus/static/configuration/manifest.json) at commit `ab0afaf`.
