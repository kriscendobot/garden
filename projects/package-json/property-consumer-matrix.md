# Property-by-consumer matrix

Which tool reads which `package.json` property, and how. The consumer families are: **package managers** (npm, Yarn Classic v1, Yarn Berry v2+, pnpm, Bun-as-PM), **module systems / runtimes** (Node.js CJS+ESM, Deno, Bun runtime, Endo `@endo/compartment-mapper`), and **bundlers / compilers** (webpack, Rollup, esbuild, Vite, Turbopack, Parcel, swc, Babel, plus TypeScript).

Rows grounded in ingested library sources: Node traces to [`../../library/sources/node--doc-api-packages.md`](../../library/sources/node--doc-api-packages.md) (`cc37ad5`), npm to [`../../library/sources/npm--configuring-npm-package-json.md`](../../library/sources/npm--configuring-npm-package-json.md) (`ce7681f`), TypeScript to its handbook sources (`c8170c35`), Deno to its [configuration](../../library/sources/deno--runtime-fundamentals-configuration-md.md) and [Node compatibility](../../library/sources/deno--runtime-fundamentals-node-md.md) guides (`7bf3190`), Bun to its [module-resolution guide](../../library/sources/bun--docs-runtime-module-resolution-mdx.md) (`6352b79`), and Endo to the [compartment-mapper manifest sections](../../library/sources/endo--pkg-compartment-mapper-readme-package-manifest.md) (`46d4edf`). Bundlers, Yarn Berry / pnpm, and Bun's package-manager behavior remain synthesis where marked.

## The property universe

Every property named in the job scope, grouped:

- **Identity / metadata:** `name`, `version`, `description`, `keywords`, `homepage`, `bugs`, `license` (+ deprecated `licenses`), `author`, `contributors`, `funding`, `repository`, `private`.
- **Entry points / module resolution:** `main`, `module` (non-standard, bundler convention), `browser`, `types`/`typings`, `typesVersions`, `exports`, `imports`, `type`, `sideEffects`.
- **Files / executables:** `files`, `bin`, `man`, `directories`, `gypfile`.
- **Scripts / config:** `scripts`, `config`.
- **Dependencies:** `dependencies`, `devDependencies`, `peerDependencies`, `peerDependenciesMeta`, `bundleDependencies` (+ alias `bundledDependencies`), `optionalDependencies`.
- **Resolution control (root-only):** `overrides` (npm), `resolutions` (Yarn), `pnpm.overrides` / `pnpm.*` (pnpm), `packageExtensions` (npm/Yarn/pnpm).
- **Environment constraints:** `engines`, `engineStrict` (legacy), `os`, `cpu`, `libc`, `devEngines`.
- **Publishing / workspaces / tooling:** `publishConfig`, `workspaces`, `packageManager`, and tool-namespaced blocks (`pnpm`, `parsers` for Endo, custom `exports` conditions).

## Compact matrix (property -> primary readers)

| Property | Primary readers | Notes |
|---|---|---|
| `name` | all PMs; Node (named imports / self-reference) | Node uses it for self-referencing via `"exports"`; PMs use it as the registry identifier. <=214 chars, URL-safe, optional `@scope/`. |
| `version` | all PMs | node-semver parseable; forms the unique identifier with `name`. Not read by the runtime. |
| `description`, `keywords`, `homepage`, `bugs`, `funding`, `author`, `contributors`, `license`, `repository` | PMs / registry / `npm fund` / `npm bugs` / `npm repo` | Pure metadata; runtimes and bundlers ignore. `license` uses SPDX identifiers/expressions; object/`licenses`-array forms deprecated. |
| `private` | npm, Yarn, pnpm, Bun (refuse publish) | Also gates `packageExtensions`/`overrides` publish refusal in npm. |
| `main` | Node runtime; all PMs; every bundler | The universal legacy entry. `"exports"` takes precedence when present (Node + modern bundlers). Defaults to `index.js` in npm. |
| `module` | bundlers (webpack, Rollup, esbuild, Vite, Parcel) **(synthesis)** | **Not a Node or npm field.** A bundler convention pointing at an ESM build for tree-shaking. Node ignores it entirely. |
| `browser` | bundlers; Endo (`browser` condition); Node ignores | String (replace `main`) or object (per-module replacement map). Endo draws in `browser` instead of `main` under its `browser` condition. |
| `types` / `typings` | TypeScript | Root declaration entry: legacy lookup prefers `types`, then synonymous `typings`, then `main`; retain `types` even when `exports` supplies declarations. Ignored by runtimes/PMs. |
| `typesVersions` | TypeScript | Ordered compiler-semver redirects for declaration layouts; supported in every TS resolution mode but not read when `exports` is active. |
| `exports` | Node runtime; modern bundlers; TypeScript (`node16`/`nodenext`/`bundler`); Endo; Bun | The central field. TS always matches `types`/`default` and selects `import` or `require` by resolution context; Bun reads ordered conditions including `bun`; Endo supports only `import`/`browser`/`endo` and no `*` patterns yet. Deno's ingested compatibility guide does not enumerate its export-condition algorithm. |
| `imports` | Node runtime; bundlers **(synthesis)**; Endo (not yet) | `#`-prefixed private internal mappings; may map to external packages. Endo README notes `imports` support is a future TODO. |
| `type` | Node runtime; bundlers; TypeScript; Endo; Bun; Deno | Decides CJS vs ESM for `.js`. Read by nearly everything that parses JS. npm itself does not use it. |
| `sideEffects` | bundlers (webpack, Rollup via plugins, esbuild, Vite, Parcel) **(synthesis)** | Tree-shaking hint: `false` = no side effects, or an array of side-effectful file globs. Node/PMs ignore. |
| `files` | npm, Yarn, pnpm, Bun (pack/publish); Endo (declared, not yet enforced) | Allowlist for the published tarball; defaults `["*"]`. Endo README: recognized but the `files` globs are not yet acted on. |
| `bin` | all PMs (link onto PATH) | String (= package name) or map. Target must start with `#!/usr/bin/env node`. |
| `man` | npm (metadata only since v12) | No longer installs system man pages. |
| `directories` | npm (`.bin`, `.man`) | `directories.bin` mutually exclusive with `bin`. Mostly vestigial. |
| `gypfile` | npm (node-gyp) | `false` opts out of automatic node-gyp build. |
| `scripts` | all PMs (lifecycle) | Runs at lifecycle events; `config` values surface as `npm_package_config_*`. |
| `config` | npm (scripts env) | Persists across upgrades; exposed to scripts. |
| `dependencies` | all PMs; Node/Endo (trust the arranged tree) | Rich specifier grammar (semver, tarball/git/GitHub/local URLs, dist-tags, `npm:` aliases). Runtimes do not read it; they trust the PM's `node_modules` arrangement. |
| `devDependencies` | all PMs (root install only) | Not installed for consumers. |
| `peerDependencies` | all PMs, differently | npm v7+ auto-installs; npm 3-6 warned only; Yarn Berry / pnpm have their own policies (see inconsistencies). |
| `peerDependenciesMeta` | npm, Yarn, pnpm | Marks a peer `optional`. |
| `bundleDependencies` / `bundledDependencies` | npm (pack), Yarn, pnpm | Names bundled into the `npm pack` tarball; boolean form bundles all/none. |
| `optionalDependencies` | all PMs | Build/fetch failure does not fail install; overrides same-named `dependencies`. The vehicle for per-platform prebuilt binaries. |
| `overrides` | npm, Bun (Bun reads npm `overrides`) **(synthesis for Bun)** | Root-only tree rewrite. |
| `resolutions` | Yarn Classic + Berry **(synthesis)** | Yarn's override dialect; glob-path selectors. Bun also reads `resolutions`. |
| `pnpm.overrides`, `pnpm.*` | pnpm **(synthesis)** | pnpm's override block under the `pnpm` key; also `pnpm.packageExtensions`, `pnpm.peerDependencyRules`, `pnpm.patchedDependencies`. |
| `packageExtensions` | npm; Yarn Berry (origin); pnpm (`pnpm.packageExtensions`) | Adds/corrects third-party manifest dependency metadata. Root-only; npm refuses to publish a non-private package containing it. |
| `engines` | all PMs (advisory unless `engine-strict`) | `node`/`npm`/other tool versions. |
| `engineStrict` (legacy) | npm (removed) **(synthesis)** | Formerly a per-package strict-engine flag; removed in favor of the `engine-strict` config. Ignored today. |
| `os`, `cpu`, `libc` | all PMs (install gate) | Allowlist plus `!`-blocklist; `libc` only when `os` is `linux`. The install-gating mechanism behind per-platform packages. |
| `devEngines` | npm (before install/ci/run) | Distinct shape from `engines`; keys `cpu`/`os`/`libc`/`runtime`/`packageManager` with `onFail`. |
| `publishConfig` | npm, Yarn, pnpm (publish time) | Overrides `registry`/`tag`/`access` at publish. |
| `workspaces` | npm, Yarn, Bun; pnpm uses `pnpm-workspace.yaml` instead **(synthesis for pnpm)** | Array of path/glob workspace folders. pnpm ignores `workspaces` and reads a separate YAML file. |
| `packageManager` | Corepack (Node), Yarn/pnpm via Corepack **(synthesis)** | `name@version[+hash]`; pins the PM. Not a runtime field. |
| `parsers` | Endo compartment-mapper | Per-package extension-to-language override (for example `{ "png": "bytes" }`). Endo-specific. |

## Per-consumer resolution and precedence notes

### Node.js (runtime)

Reads exactly five fields (`name`, `main`, `type`, `exports`, `imports`); everything else is package-manager metadata it ignores (source: field-definitions section). `"exports"` takes precedence over `"main"`. Condition order is object-key order, most-specific-first, `"default"` last; the built-in conditions are `node-addons`, `node`, `import`, `require`, `module-sync`, `default`. `"type"` plus `.mjs`/`.cjs` extensions decide module format. `require()` and `import` use two different resolution algorithms (extension search + folders-as-modules for `require`; fully-specified paths + URL support for `import`).

### npm (package manager)

Reads the full metadata + dependency + publishing surface. Does **not** read `type` (delegates to Node) or `module`/`sideEffects`/`types` (bundler/TS conventions). Override dialect: `overrides` + `packageExtensions`, root-only. Installs `peerDependencies` by default (v7+).

### Yarn Classic (v1) / Yarn Berry (v2+) (synthesis)

Both read `resolutions` (not `overrides`). Berry adds Plug'n'Play (PnP): no `node_modules`, a `.pnp.cjs` resolver map, strict dependency visibility (a package sees only its declared dependencies). Berry originated `packageExtensions` and reads it from `.yarnrc.yml` and/or the manifest. Workspace protocol `workspace:*`. `publishConfig` honored.

### pnpm (synthesis)

Symlinked, content-addressed strict layout: a flat `node_modules/.pnpm` store with symlinks, so only declared dependencies are visible (like PnP's strictness, via symlinks rather than a resolver). Override dialect lives under the `pnpm` manifest key (`pnpm.overrides`, `pnpm.packageExtensions`, `pnpm.peerDependencyRules`, `pnpm.patchedDependencies`). Workspaces are declared in `pnpm-workspace.yaml`, not the `workspaces` field.

### Bun (PM + runtime)

As a runtime, Bun honors ordered `exports` conditions including `bun`, `node-addons`, `node`, importer-specific `require`/`import`, and `default`; it honors `imports`, then falls back to `main` (or implicit `index.*`) before `module`. As a PM, its `dependencies`/`overrides`/`resolutions`/`workspaces` and `trustedDependencies` behavior remains **(synthesis)** for the package-manager follow-on.

### Deno (runtime)

`package.json` and `deno.json` are first-class and composable: package dependencies and scripts come from the former, while Deno tool configuration and import maps come from the latter. `npm:<name>[@<range>][/<sub-path>]` is the explicit package-specifier form. For existing Node projects Deno installs package dependencies into manual `node_modules`, runs scripts with `deno task`, honors `type`, and warns on `node`/`deno` engine mismatches. The ingested Deno guide does not specify its `exports` condition set or ordering, so claims about a `deno` condition remain pending primary-source backing.

### Endo `@endo/compartment-mapper` (runtime)

Reads `name`, `type`, `main`, `exports`, `browser`, `dependencies`, and `files` (source: compartment-mapper README at `46d4edf`). Only three conditions are supported: `import` (prefer ESM over CJS), `browser` (also swaps in the `browser` property over `main`), and `endo` (signals the tool is in use). If no `exports` applies to `"."`, `main` is the default. `imports` and `*` patterns in `exports`/`imports` are future TODOs. A package-local `parsers` property overrides extension-to-language mapping; type-specific hooks support `.ts` as `.cts` or `.mts` semantics.

### TypeScript (compiler)

Reads `types`/`typings` and `typesVersions`, subject to a key precedence boundary: `typesVersions` is not read when the modern `exports` path is active. Under `moduleResolution` `node16`/`nodenext`/`bundler`, TypeScript reads `exports`, always matches `types` and `default`, and chooses `import` or `require` based on the resolution context. The correct dual-package recipe nests a first `types` condition inside each `import`/`require` branch, using `.d.mts` and `.d.cts` respectively. `bundler` supports exports/imports but permits extensionless and directory paths; `node16`/`nodenext` model Node's strict ESM paths and pair with Node-aware `module` settings. Sources: [`declaration-publishing`](../../library/sources/typescript-website--packages-documentation-copy-en-declaration-files-publishing.md), [`modules-reference`](../../library/sources/typescript-website--packages-documentation-copy-en-modules-reference-reference.md) (`c8170c35`).

### Bundlers (webpack, Rollup, esbuild, Vite, Turbopack, Parcel, swc, Babel) (synthesis)

Honor `exports` (with a bundler-chosen condition set, commonly including `module`, `browser`, `import`, `require`, `default`, plus custom conditions), the legacy `main`/`module`/`browser` fallback chain, `sideEffects` for tree-shaking, and `type`. `module` is a de-facto standard for "the ESM build" that these tools prefer over `main` when `exports` is absent. Condition-resolution order and the default condition set differ per bundler (a major inconsistency; see the inconsistencies topic). Babel and swc are compilers rather than resolvers and mostly read `type`, `browserslist`, and their own config; they do not resolve `exports`.
