# Fruitful-usage strategies

The publishing-architecture patterns the maintainer asked for: how to use the manifest well for platform/architecture-specific packages, dual ESM/CJS, tree-shaking, and monorepo publishing. Field schema is grounded in the ingested Node ([`../../library/sources/node--doc-api-packages.md`](../../library/sources/node--doc-api-packages.md), `cc37ad5`) and npm ([`../../library/sources/npm--configuring-npm-package-json.md`](../../library/sources/npm--configuring-npm-package-json.md), `ce7681f`) sources; the assembled patterns are synthesis from those fields plus well-established ecosystem practice, flagged **(pattern)** where the shape is community convention rather than a spec requirement.

## 1. Platform / architecture-specific packages (the prebuilt-binary pattern)

The problem: a package with a native addon needs a different compiled binary per OS + CPU (+ libc on Linux), and you do not want every consumer to run a compiler.

The manifest tools (npm-grounded): `os`, `cpu`, and `libc` gate whether a package **installs** on the host (`os` = `process.platform`, `cpu` = `process.arch`, `libc` only when `os` is `linux`; allowlist plus `!`-blocklist). `optionalDependencies` do not fail the install when they cannot be installed. Combining them is the pattern.

The pattern (esbuild / swc / `@napi-rs` / Rollup's `@rollup/rollup-*` all use it):

1. Publish one **per-platform sub-package** for each target, each with a narrow `os`/`cpu`(/`libc`) so it installs only on its matching host - for example `@scope/pkg-linux-x64-gnu`, `@scope/pkg-darwin-arm64`, `@scope/pkg-win32-x64-msvc`, each shipping only its prebuilt binary.
2. In the **main package**, list every per-platform sub-package in `optionalDependencies`. On any given host, only the matching one installs successfully (the others are skipped because their `os`/`cpu`/`libc` excludes the host and because they are optional); the install does not fail.
3. At runtime the main package `require`s whichever sub-package installed, or falls back to a WASM build or a from-source compile.

Why `optionalDependencies` and not `dependencies`: a hard dependency on a non-matching-platform binary would fail the install on every host that is not that platform. Optional + platform-gated is what lets one manifest resolve to the right single binary everywhere.

**Platform-conditional `exports` (pattern):** for pure-JS platform splits (not native binaries), a custom condition resolved by the runtime/bundler can select a platform build, but note Node ignores unknown conditions unless passed via `--conditions`, so this is fragile across tools; the `os`/`cpu` + `optionalDependencies` route is the robust one for binaries. The alternatives - `prebuildify` (bundle prebuilt binaries inside one package, selected at runtime) and `node-gyp` from-source builds gated by `gypfile` - trade install-size for sub-package count.

## 2. Dual ESM/CJS publishing done right

The goal: ship both formats without triggering the [dual-package hazard](inconsistencies.md#3-the-dual-package-hazard-esmcjs-dual-publishing).

Grounded rules (Node conditional-exports + self-referencing-and-dual-package sections):

- Use `exports` with `import` and `require` conditions pointing at the two builds; set `"type"` so the default extension resolves correctly, and use `.cjs`/`.mjs` for the files whose format must be unambiguous.
- Keep **all package state in a single module** that both builds re-export, so there is one instance of any singleton/registry/class even if both builds load. Or:
- Prefer **ESM-only with a synchronous `module-sync` entry** so `require()` can load it (no async graph, or `ERR_REQUIRE_ASYNC_MODULE` is thrown), which sidesteps the hazard by not shipping two instances at all.
- Always include a `"default"` condition last, and put `types` first so TypeScript resolves.
- For older toolchains, include `"main"` alongside `"exports"` pointing at the same module (Node package-entry-points section).

Common mistake: two independent builds that each carry their own copy of a stateful class. `instanceof` then fails across the boundary; the fix is the shared-state-module pattern above.

## 3. `sideEffects` for tree-shaking (pattern)

- Set `"sideEffects": false` when importing any module for its exports has no observable side effect: bundlers may then drop unused imports.
- Set `"sideEffects": ["*.css", "./src/polyfill.js"]` (an array of globs) when specific files **do** have side effects that must survive tree-shaking (CSS imports, global polyfills, `import`-for-effect modules).
- Pair with a `module` field (or an `import`/`module` export condition) so the bundler has an ESM build to tree-shake in the first place; CJS does not tree-shake.
- Verify in the bundled output, not in Node: a wrong `false` silently drops a needed side-effect and only the bundle breaks.

## 4. `publishConfig`

Use `publishConfig` (npm-grounded) to pin publish-time config independent of the developer's environment: `registry` (publish a scoped package to an internal registry), `access` (`public`/`restricted`), and `tag` (avoid tagging a pre-release as `latest`). Combine with `"private": true` on the repo root of a monorepo so the aggregate root is never published while its workspace packages are.

## 5. Monorepo `workspaces` publishing

- Declare workspaces with the `workspaces` array (npm/Yarn/Bun) or `pnpm-workspace.yaml` (pnpm - the [workspaces divergence](inconsistencies.md#9-workspaces-is-not-universal-synthesis)). Each workspace is symlinked into the top-level `node_modules` so cross-workspace imports resolve during development.
- Set `"private": true` on the workspace root; publish the individual packages (Changesets, `npm publish --workspaces`, or `pnpm -r publish`).
- Use the `repository.directory` field to point each package at its subdirectory within the monorepo (npm files-entry-points section), so registry links resolve to the right folder.
- `packageExtensions` (or `pnpm.packageExtensions`) is the monorepo-hygiene tool for declaring dependency edges a third-party package forgot, which matters under strict/isolated layouts (pnpm, `install-strategy=linked`, Yarn PnP) where hoisting no longer papers over the omission.

## Follow-on depth

Each strategy above is grounded in the ingested property sources. Dedicated package-manager layout sections now back Yarn PnP, pnpm's strict symlinked layout, and the workspace protocols (see [README](README.md)); remaining deepening targets are the exact per-bundler `sideEffects` and condition-order behavior.
