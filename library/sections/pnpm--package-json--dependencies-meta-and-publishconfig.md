---
title: dependenciesMeta.injected, peerDependenciesMeta.optional, and pnpm's publishConfig
source: docs/package_json.md
source_repo: pnpm/pnpm.io
source_commit: 047db9af593b88a141cf7810ea9c0c8cf2354292
source_date: 2026-05-25
source_authors: [Erick Zhao, Khải, Mister-Hope, Nikoloz Buligini]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: pnpm's manifest-resident dependency-metadata and publishing fields. `dependenciesMeta.<pkg>.injected` addresses a problem pnpm's symlinked layout creates: a workspace package is normally symlinked into a consumer's `node_modules`, so its `peerDependencies` resolve to a single shared version — which breaks when two consumers (`card` on `react@16`, `form` on `react@17`) need it to see different peer versions. Setting `injected: true` installs a **hard-linked copy** of the workspace package in the virtual store (`node_modules/.pnpm`) per consumer, so each copy resolves the peer in its consumer's context. The cost: the copies must be re-synced after each rebuild (via `pnpm install`, a `prepare` script, or tools like pnpm-sync). `peerDependenciesMeta.<pkg>.optional` marks a peer optional (and even names not present in `peerDependencies` can be listed to allow any version). pnpm's `publishConfig` overrides fields before packing and adds `directory` (publish a built subdirectory), `linkDirectory` (symlink that directory during local dev), and `executableFiles`.

## dependenciesMeta.*.injected

Additional meta for dependencies declared in `dependencies`, `optionalDependencies`, and `devDependencies`. `injected` targets a **local workspace package**:

- `injected: false` (or unset, the default): the dependency is installed by creating a `node_modules` symlink pointing at the package's source directory in the workspace — faster, and modifications are immediately visible to consumers.
- `injected: true`: the dependency is installed as a **hard-linked copy** in the virtual store (`node_modules/.pnpm`).

Why it exists: with plain symlinking there is no way for a workspace package's peer dependency (say `button` needing `react`) to be satisfied *differently* by different consumers. If `card` uses `react@16` and `form` uses `react@17`, symlinking forces one shared `react`. Marking `button` as an injected dependency of both `card` and `form` (each also declaring its own `react`) makes `button` resolve `react@16` in `card`'s context and `react@17` in `form`'s. The tradeoff: injected copies are snapshots of the source directory and must be refreshed whenever the code changes — after each injected package rebuilds but before its consumers rebuild. `pnpm install` re-syncs them; a `"prepare": "pnpm run build"` script or third-party tools (`pnpm-sync-lib`, `pnpm-sync-dependencies-meta-injected`) automate it with watch-mode support.

## peerDependenciesMeta.*.optional

Marks a peer dependency optional, so the consumer omitting it is no longer reported as an error. A name may be listed in `peerDependenciesMeta` even when it is **not** in `peerDependencies` — pnpm then assumes any version is fine. A name that *is* in `peerDependencies` is optional only to its declared version range.

## publishConfig

Overrides fields in the manifest before the package is packed. Overridable fields: `bin`, `main`, `exports`, `types`/`typings`, `module`, `browser`, `esnext`, `es2015`, `unpkg`, `umd:main`, `typesVersions`, `cpu`, `os`, and (v10.22.0+) `engines`. Add the publish version of the field under `publishConfig` (for example `publishConfig.main: "lib/index.js"` while the dev `main` points at `src/index.ts`). Extra pnpm-specific sub-fields:

- **`publishConfig.executableFiles`**: additional files to mark executable (`+x`) in the archive beyond those in `bin`.
- **`publishConfig.directory`**: publish a customized subdirectory (relative to the current `package.json`) instead — expected to contain a modified `package.json`, usually produced by a build tool.
- **`publishConfig.linkDirectory`** (default `true`): when true, the project is symlinked from the `publishConfig.directory` location during local development.

Source: [docs/package_json.md](https://github.com/pnpm/pnpm.io/blob/047db9af593b88a141cf7810ea9c0c8cf2354292/docs/package_json.md) at commit `047db9a`.
