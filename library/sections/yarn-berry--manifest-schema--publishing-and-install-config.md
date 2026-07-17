---
title: publishConfig, installConfig, packageManager, and the shared environment fields
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

Abstract: Yarn Berry's publish-time and install-time control fields, plus the shared fields it reads with npm/Node. `publishConfig` overrides selected manifest fields **in the published tarball only** — `main`, `module`, `browser`, `bin`, and `type` (each pointing at the built artifact rather than the source), plus `registry`, `access` (`public`/`restricted`), `provenance`, and `executableFiles` (files to chmod +x in the tarball). `installConfig` tunes the local install: `hoistingLimits` (`workspaces`/`dependencies`/`none`, the highest point packages may hoist to) and `selfReferences` (whether a workspace may require itself). `packageManager` is the Corepack pin (for example `yarn@4.0.0`), which Yarn sets automatically on `yarn set version`. The `type` field is honored for CJS-vs-ESM `.js` interpretation, though Yarn 3+ always emits a `.pnp.cjs` under PnP regardless. `os`/`cpu`/`libc` gate whether a package installs or its postinstall runs; `optionalDependencies` are only installed if those filters match the host; `files` and `preferUnplugged` control packing. This backs the Yarn cells of the `publishConfig`, `packageManager`, and install-layout rows in the property-consumer matrix.

## publishConfig

Extra settings affecting how the package is published; each replaces the corresponding manifest field **in the published tarball** over the source value:

- `access`: `public` or `restricted` (the latter often requires a paid registry plan).
- `bin`, `main`, `module`, `browser`, `type`: replacement paths used in the published tarball over the main manifest's (point them at your `./build/...` artifacts).
- `executableFiles`: files that must be marked executable (`+x`) in the published tarball.
- `provenance`: whether to produce a provenance statement (overrides all other provenance settings).
- `registry`: replaces the configured registry when the package is pushed to a remote location.

## installConfig

Extra settings affecting how the package is installed:

- `hoistingLimits`: `workspaces` | `dependencies` | `none` (default `none`) — the highest point to which packages can be hoisted (mirrors the `nmHoistingLimits` yarnrc setting).
- `selfReferences`: boolean (default `true`) — whether workspaces are allowed to require themselves (mirrors `nmSelfReferences`).

## packageManager and the shared fields

- `packageManager` (for example `yarn@4.0.0`): used by [Corepack](https://nodejs.org/api/corepack.html) to detect the Yarn version in use — the same purpose as the lockfile, but for Yarn itself. Yarn sets it automatically when you run `yarn set version`.
- `type`: `commonjs` (default) or `module`, deciding `.js` interpretation. Yarn 3+ generates a `.pnp.cjs` file under PnP regardless of this option.
- `os` / `cpu` / `libc`: sets of platforms/architectures/C-standard-libraries the package works on. `process.platform()` / `process.arch()` / the host libc are compared at install time; no match means any postinstall script is skipped, and a package depended on **exclusively** through `optionalDependencies` is not installed at all.
- `optionalDependencies`: installed only if the `os`/`cpu`/`libc` fields match the host; allowed to have a failing `postinstall`; must still be *resolvable* (so a metadata-fetch failure remains distinguishable from an intentional skip).
- `files`: glob patterns included in the published tarball (defaults to `["*"]`); absent, Yarn falls back to the project `.gitignore` (or `.npmignore`).
- `preferUnplugged`: lets a package author override Yarn's zip-loadability heuristic, declaring whether the package works stored as an archive.
- `languageName`: internal linker selector (default `node`); not to be touched under normal use.

Source: [packages/docusaurus/static/configuration/manifest.json](https://github.com/yarnpkg/berry/blob/ab0afaf88dcbf6eb52731d0bc25bbe9fed655f8b/packages/docusaurus/static/configuration/manifest.json) at commit `ab0afaf`.
