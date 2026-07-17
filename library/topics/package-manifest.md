# Topic: package-manifest

> Abstract: The `package.json` manifest: the schema and semantics of every known property, and how each is consumed by package managers, module systems/runtimes, and bundlers. This topic collects the authoritative primary sources for the manifest - the Node.js "Modules: Packages" runtime spec (`"type"`, `"main"`, `"exports"`, `"imports"`, conditional exports, subpath patterns, package maps) and npm's field-by-field property catalog (identity/metadata, files/entry-points/bin, scripts/config, the full dependency surface with `overrides`/`packageExtensions`, and the environment/publishing fields `engines`/`os`/`cpu`/`libc`/`private`/`publishConfig`/`workspaces`). It is the library backbone for the `package-json` project report's property-by-consumer matrix, the cross-tool inconsistencies section, and the platform-specific-publishing strategies. Concepts split out for lookup: [[conditional-exports]], [[dual-package-hazard]], [[package-type-field]], [[subpath-exports]], [[dependency-overrides]]. Seeded 2026-07-17 from the Node.js and npm docs; deeper per-consumer ingests (bundlers, Yarn Berry/pnpm/Bun, TypeScript, Deno, Endo compartment-mapper) are queued as follow-on scholar jobs.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [node--doc-api-packages--overview](../sections/node--doc-api-packages--overview.md) | node packages.md | A package is a folder tree described by `package.json`; `"main"` and `"exports"` define entry points, and `"exports"` encapsulates everything it does not list. |
| [node--doc-api-packages--determining-module-system](../sections/node--doc-api-packages--determining-module-system.md) | node packages.md | How Node picks CommonJS vs ESM from `"type"`, extension, `--input-type`, and syntax detection, plus the divergent `require()` vs `import` resolution algorithms. |
| [node--doc-api-packages--package-entry-points](../sections/node--doc-api-packages--package-entry-points.md) | node packages.md | The `"exports"` main entry, the `"."` sugar, the encapsulation guarantee and `ERR_PACKAGE_PATH_NOT_EXPORTED`, and the relative-URL/no-traversal target rules. |
| [node--doc-api-packages--subpath-exports-imports-and-patterns](../sections/node--doc-api-packages--subpath-exports-imports-and-patterns.md) | node packages.md | The `#`-prefixed `"imports"` field (may map to external packages) and the `*` string-replacement subpath patterns with `null` exclusion. |
| [node--doc-api-packages--conditional-exports](../sections/node--doc-api-packages--conditional-exports.md) | node packages.md | The fixed condition set, order significance, nested conditions, user `--conditions`, and the curated community conditions (`types` first, `browser`, `development`/`production`). |
| [node--doc-api-packages--self-referencing-and-dual-package](../sections/node--doc-api-packages--self-referencing-and-dual-package.md) | node packages.md | Referencing a package's own `"exports"` by its `"name"`, and the dual CommonJS/ES module hazard the `import`/`require` conditions create. |
| [node--doc-api-packages--package-maps](../sections/node--doc-api-packages--package-maps.md) | node packages.md | The experimental `--experimental-package-map` resolver that maps bare specifiers to package IDs without a `node_modules` structure. |
| [node--doc-api-packages--field-definitions](../sections/node--doc-api-packages--field-definitions.md) | node packages.md | The exact five fields the Node runtime honors (`name`, `main`, `type`, `exports`, `imports`) versus the metadata it ignores. |
| [npm--configuring-npm-package-json--identity-and-metadata](../sections/npm--configuring-npm-package-json--identity-and-metadata.md) | npm package-json.md | name, version, description, keywords, homepage, bugs, license (SPDX), author/contributors, funding. |
| [npm--configuring-npm-package-json--files-entry-points-and-bin](../sections/npm--configuring-npm-package-json--files-entry-points-and-bin.md) | npm package-json.md | `files` with its always-included/always-ignored lists, exports/main/type/browser, bin, man, directories, repository. |
| [npm--configuring-npm-package-json--scripts-config-and-native-build](../sections/npm--configuring-npm-package-json--scripts-config-and-native-build.md) | npm package-json.md | scripts (lifecycle events), config (`npm_package_config_*`), gypfile/node-gyp, and npm's defaulted values. |
| [npm--configuring-npm-package-json--dependencies-and-overrides](../sections/npm--configuring-npm-package-json--dependencies-and-overrides.md) | npm package-json.md | The full dependency surface and specifier grammar, plus the root-only `overrides` and `packageExtensions` resolution controls. |
| [npm--configuring-npm-package-json--environment-constraints-and-publishing](../sections/npm--configuring-npm-package-json--environment-constraints-and-publishing.md) | npm package-json.md | engines, os, cpu, libc, devEngines, private, publishConfig, workspaces. |

## See also

- node-packaging - npm package layout and OS-distribution packaging.
- module-loader - the loaders (Node ESM/CJS, Endo compartment-mapper, System) that read these fields at resolution time.
- bundles - Endo's compartment-mapper module loading and bundling, which reads a subset of these fields.
- tooling - build/publish tooling that consumes the manifest.
