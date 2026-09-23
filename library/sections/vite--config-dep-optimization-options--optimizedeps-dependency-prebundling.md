---
title: Vite optimizeDeps — dependency pre-bundling
source_kind: repo-doc
source_repo: vitejs/vite
source_path: docs/config/dep-optimization-options.md
source_commit: 9beae37d7221b25463a011feb40b0303ca328d87
source_date: 2026-07-17
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Vite's `optimizeDeps` options govern its dev-only dependency pre-bundler, which discovers a project's bare `node_modules` dependencies, converts CommonJS/UMD packages to ESM, and caches the result so the browser sees ESM. Discovery crawls `.html` files by default (or the configured `input`, or `optimizeDeps.entries` globs), ignoring `node_modules`/`build.outDir`/`__tests__`/`coverage`. `include` force-bundles linked or deep-import packages; `exclude` opts a dependency out (but CommonJS deps must not be excluded); `noDiscovery` limits optimization to `include`. `holdUntilCrawlEnd`, `needsInterop`, and `force` tune cold-start behavior. Unless noted, these options apply only in dev.

**`optimizeDeps.entries`** (`string | string[]`) — By default Vite crawls all `.html` files to detect dependencies that need pre-bundling (ignoring `node_modules`, `build.outDir`, `__tests__`, and `coverage`). If the top-level `input` or `build.rolldownOptions.input` is set, Vite crawls those entry points instead. A custom `tinyglobby` pattern (relative to project root) overwrites default inference; then only `node_modules` and `build.outDir` are ignored by default, and a leading `!` marks an ignore pattern.

**`optimizeDeps.exclude`** (`string[]`) — dependencies to exclude from pre-bundling. CommonJS dependencies should **not** be excluded; if an ESM dependency is excluded but has a nested CommonJS dependency, add that nested dep to `include` as `'esm-dep > cjs-dep'`.

**`optimizeDeps.include`** (`string[]`) — linked packages outside `node_modules` are not pre-bundled by default; use `include` to force one. Experimentally, a trailing glob pre-bundles all deep imports at once (`'my-lib/components/**/*.vue'`), avoiding repeated pre-bundling as new deep imports appear.

**`optimizeDeps.noDiscovery`** (`boolean`, default `false`) — disables automatic discovery; only `include` dependencies are optimized. CJS-only dependencies must then be listed in `include` during dev.

**`optimizeDeps.holdUntilCrawlEnd`** (experimental `boolean`, default `true`) — holds the first optimized-deps result until all static imports are crawled on cold start, avoiding full-page reloads when new deps trigger new common chunks. Disable it when all deps are found by the scanner plus `include`, to let the browser parallelize.

**`optimizeDeps.needsInterop`** (experimental `string[]`) — forces ESM interop when importing the named dependencies. Vite usually detects interop needs automatically; listing packages here can speed cold start by avoiding full-page reloads.

**`optimizeDeps.force`** (`boolean`) — forces re-bundling, ignoring the previously cached optimized dependencies.

**`optimizeDeps.rolldownOptions`** — options passed to Rolldown during dep scanning/optimization (certain options omitted for compatibility; `plugins` merge with Vite's dep plugin). **`optimizeDeps.esbuildOptions`** is deprecated and converted to `rolldownOptions` internally. **`optimizeDeps.disabled`** is deprecated (as of Vite 5.1 build-time pre-bundling was removed); use `noDiscovery` instead.

**Relation to `package.json`.** The pre-bundler resolves bare specifiers to their `node_modules` packages (via the same `resolve.conditions`/`mainFields`/`exports` resolution as the rest of Vite), reads each dependency's entry, and rewrites CommonJS/UMD to ESM so it can be served as a single cached ES module — the mechanism that lets Vite consume CJS-only packages published without an ESM `exports`/`module` entry.

Source: [docs/config/dep-optimization-options.md](https://github.com/vitejs/vite/blob/9beae37d7221b25463a011feb40b0303ca328d87/docs/config/dep-optimization-options.md) at commit `9beae37`.
