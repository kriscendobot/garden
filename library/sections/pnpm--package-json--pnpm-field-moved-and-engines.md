---
title: The pnpm field moved to pnpm-workspace.yaml (v11); engines, engines.runtime, devEngines
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

Abstract: The load-bearing change for anyone reasoning about pnpm's override dialect: **since pnpm v11, pnpm no longer reads settings from the `pnpm` field of `package.json`** — settings must be defined in `pnpm-workspace.yaml` instead. This moves `pnpm.overrides` → `overrides`, `pnpm.packageExtensions` → `packageExtensions`, `pnpm.peerDependencyRules` → `peerDependencyRules`, `pnpm.patchedDependencies` → `patchedDependencies` out of the manifest and into the workspace YAML root (documented in the `pnpm--settings` source). This section also covers pnpm's manifest-resident version/runtime fields: `engines` (advisory unless `engineStrict`), `engines.runtime` and `devEngines.runtime` (auto-download/pin a JS runtime), and `devEngines.packageManager` (a version-*range* pin for pnpm, distinct from the exact `packageManager` field). pnpm also accepts `package.json5` and `package.yaml` manifest formats.

## The `pnpm` field is gone (v11)

> Since v11, pnpm no longer reads settings from the `pnpm` field of `package.json`. Settings must be defined in `pnpm-workspace.yaml` instead.

The manifest is still a standard `package.json` (metadata, dependencies, title, author) preserved across all major Node package managers; pnpm additionally supports `package.json5` (via json5) and `package.yaml` (via js-yaml). But the pnpm-specific *settings* that earlier synthesis placed under a `pnpm` manifest block — `overrides`, `packageExtensions`, `peerDependencyRules`, `patchedDependencies`, and the build-gate settings — now live in `pnpm-workspace.yaml`. See the `pnpm--settings` library source for those fields.

## engines

Specify the Node and pnpm versions the software works on:

```json
{ "engines": { "node": ">=10", "pnpm": ">=3" } }
```

During local development pnpm always **fails** if its own version does not match the `engines.pnpm` range. Unless the user sets the `engineStrict` config, the field is otherwise advisory and only warns when the package is installed as a dependency.

## engines.runtime and devEngines.runtime

- **`engines.runtime`** (v10.21.0+): specifies the Node.js runtime a *dependency* requires; pnpm auto-installs that Node version. For CLI apps pnpm binds the CLI to the required Node version; for packages with `postinstall` scripts, the script executes under the specified Node version.
- **`devEngines.runtime`** (v10.14+): one or more JS runtime engines the *project* uses (Node, Deno, or Bun), each an object with `name`/`version`/`onFail` (`onFail: "download"` auto-fetches). `pnpm install` resolves the range to the latest matching version, saves the exact version + checksum in the lockfile, and scripts use the local runtime. Override `onFail` at runtime with the `runtimeOnFail` setting rather than editing the manifest.

## devEngines.packageManager

(v11.0.0+) Specifies the pnpm version via `devEngines.packageManager` — and unlike the exact `packageManager` field, this **supports version ranges** (`">=11.0.0 <12.0.0"`). The resolved version is stored in `pnpm-lock.yaml` under `packageManagerDependencies` and reused while it still satisfies the range. (When pnpm is declared via the legacy `packageManager` field instead, its resolution info is *not* written to the lockfile unless the pinned version is v12+, keeping the lockfile stable across a v10→v11 upgrade.) Override `onFail` with the `pmOnFail` setting.

Source: [docs/package_json.md](https://github.com/pnpm/pnpm.io/blob/047db9af593b88a141cf7810ea9c0c8cf2354292/docs/package_json.md) at commit `047db9a`.
