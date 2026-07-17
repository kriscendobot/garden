# Cross-interactions and inconsistencies

Where the `package.json` consumers disagree, fall back differently, or interact in ways that surprise. Grounded rows cite the ingested Node ([`../../library/sources/node--doc-api-packages.md`](../../library/sources/node--doc-api-packages.md), `cc37ad5`) and npm ([`../../library/sources/npm--configuring-npm-package-json.md`](../../library/sources/npm--configuring-npm-package-json.md), `ce7681f`) sources and the Endo README (`ca77052`); rows about not-yet-ingested consumers are **(synthesis)** from public documentation and are queued for library-backing.

## 1. `exports` versus legacy `main` / `module` / `browser`

Once `"exports"` is present, Node **encapsulates** the package: any subpath not listed throws `ERR_PACKAGE_PATH_NOT_EXPORTED`, and `"exports"` takes precedence over `"main"` (source: package-entry-points section). But the fallback story diverges:

- **Node:** if `"exports"` is present it is authoritative; `main` is used only as the `"."` fallback when no `exports` matches `"."`, and `module`/`browser` are **ignored entirely** (Node reads only five fields).
- **Bundlers (synthesis):** when `exports` is absent, they walk a fallback chain, commonly `module` -> `browser` -> `main` (order and set vary per bundler). `module` is a non-standard field that exists **only** to give bundlers an ESM build to tree-shake; Node never reads it. A package that ships `module` but no `import` export condition therefore tree-shakes in bundlers but loads the CJS `main` in Node.
- **Endo (README `ca77052`):** reads `main`, `browser`, and `exports`; `browser` is drawn in over `main` under the `browser` condition. No `module` field.

Practical hazard: a package can present three different entry points to three tools (bundler via `module`, Node via `exports`/`main`, browser via `browser`), and they can drift out of sync silently.

## 2. Conditional-export **condition resolution order** differs across tools

Node matches conditions in **object key order**, most-specific-first, with `"default"` last, over a fixed built-in set (`node-addons`, `node`, `import`, `require`, `module-sync`, `default`) plus user `--conditions` (source: conditional-exports section). Divergences:

- **Bundlers (synthesis):** each defines its own default condition list and precedence. webpack's default `conditionNames`, Vite's SSR-vs-client condition sets, esbuild's `--conditions`, and Rollup plugin defaults are all configurable and not identical. A `development`/`production` or `browser`/`node` split can resolve differently in two bundlers.
- **Deno (synthesis):** adds a `deno` condition and resolves `node`/`import`/`default`; historically diverged on some ordering edge cases.
- **Endo (README `ca77052`):** supports only `import`, `browser`, and `endo`. A package relying on `require`, `node`, `development`, or a custom condition gets Endo's fallback behavior, not the author's intended branch.
- **TypeScript (synthesis):** resolves a `types` condition that the Node docs curate as "always included first," but only under `moduleResolution` `node16`/`nodenext`/`bundler`. Putting `types` anywhere but first breaks type resolution while runtime resolution still works, a silent split.

The safe rule the Node docs give: always include a `"default"` branch, and prefer `node` + `default` over `node` + `browser`, so unknown environments get a universal implementation instead of impersonating a known one.

## 3. The **dual-package hazard** (ESM/CJS dual publishing)

Selecting builds by the `import`/`require` conditions loads two separate module instances when a process reaches the package both ways: doubled package state and broken `instanceof` (concept [`../../library/concepts/dual-package-hazard.md`](../../library/concepts/dual-package-hazard.md); Node self-referencing-and-dual-package section). It is silent because the manifest is valid. Interacts with `"type"`: `.cjs`/`.mjs` extensions decide which build a file belongs to regardless of `"type"`. Mitigations: isolate stateful internals in one CJS module both builds wrap; or ship ESM-only with a synchronous `module-sync` entry `require()` can load; or ship CJS-only.

## 4. Yarn **PnP** versus `node_modules` versus pnpm's **symlinked/strict** layout (synthesis)

Three different physical realizations of the same manifest, with different visibility semantics:

- **npm / Yarn Classic:** hoisted `node_modules`. A package can accidentally `require` a dependency it never declared (a phantom / hoisted dependency) because hoisting placed it in a visible parent folder. Works until the tree reshuffles.
- **Yarn Berry PnP:** no `node_modules`; a `.pnp.cjs` resolver enforces that a package sees **only** its declared dependencies. Phantom dependencies fail immediately. Requires runtime cooperation (the PnP loader), which some tools do not support.
- **pnpm:** a content-addressed store with a symlinked `node_modules/.pnpm` layout, also strict (only declared deps visible), but realized through symlinks rather than a resolver, so it works with tools that expect a real `node_modules`.
- **Node's experimental package maps** (`--experimental-package-map`, added v26.4.0) are a fourth model: resolution from a static data table with no `node_modules` at all, explicitly to prevent phantom dependencies (Node package-maps section).

The manifest is identical; the strictness a package experiences (whether `packageExtensions` is needed to declare a missing edge) depends entirely on the layout. npm's own docs call out that `packageExtensions` is "especially useful with `install-strategy=linked`" for exactly this reason.

## 5. `sideEffects` tree-shaking semantics (synthesis)

`sideEffects: false` tells bundlers that importing a module for its exports triggers no observable side effect, so unused imports can be dropped; an array value names the files that **do** have side effects (CSS imports, polyfills). Node and package managers ignore it. Inconsistency: bundlers implement the pruning slightly differently (webpack honors it directly, Rollup via its tree-shaking plus plugins, esbuild and Vite have their own handling), and a wrong `false` silently drops a needed side-effect import - a correctness bug that only appears in the bundled build, never in Node.

## 6. `peerDependencies` auto-install differences

- **npm:** 3-6 warned but did not install; **v7+ installs by default** (source: dependencies-and-overrides section). A conflicting peer requirement can now fail the install.
- **Yarn Berry / pnpm (synthesis):** do not silently auto-install peers the way npm v7 does; pnpm surfaces peer issues loudly and supports `pnpm.peerDependencyRules` to relax them; Yarn Berry reports peer requirements and relies on the resolver.

The same manifest therefore produces different installed trees under different managers, and a package author testing only under one manager can ship a peer graph that breaks under another.

## 7. `overrides` versus `resolutions` versus `pnpm.overrides` (synthesis + npm-grounded)

Three dialects for the same job (force a transitive dependency version), all root-only, with different selector syntax and merge rules (concept [`../../library/concepts/dependency-overrides.md`](../../library/concepts/dependency-overrides.md)):

- **npm `overrides`:** nested-object selectors, version-scoped parent keys (`"bar@2.0.0"`), `$name` references to a direct dependency's spec, `npm:`/`github:`/`file:` replacements (npm-grounded, dependencies-and-overrides section).
- **Yarn `resolutions`:** glob-path selectors (`**/foo`, `pkg/**/foo`); a flatter syntax.
- **pnpm `pnpm.overrides`:** lives under the `pnpm` manifest key; selector syntax closer to npm but with pnpm extensions.

Porting a project between managers requires translating the dialect, and a mistranslation silently fails to pin the intended version. `packageExtensions` is the complementary field (add/correct the metadata that creates the edge rather than change what it resolves to) and also exists in three places (npm `packageExtensions`, Yarn Berry, pnpm `pnpm.packageExtensions`).

## 8. How Deno / Endo / Bun diverge from Node

- **Deno (synthesis):** primary config is `deno.json` (import maps, tasks); reads npm-package `exports`/`type` for `npm:` specifiers with a `deno` condition; does not use `node_modules` by default.
- **Endo (README `ca77052`):** a deliberately small subset - `name`/`type`/`main`/`exports`/`browser`/`dependencies`/`files`, three conditions (`import`/`browser`/`endo`), no `imports` and no `*` patterns yet, plus its own `parsers` field. It also supports cross-format loading (CJS from ESM and ESM from CJS) more liberally than Node historically did, and can load JSON without an import attribute - both flagged in the README as reducing Node compatibility.
- **Bun (synthesis):** honors the standard fields plus a `bun` export condition, `trustedDependencies` (gates lifecycle scripts, a security divergence from npm's run-everything default), and reads both `overrides` and `resolutions`.

## 9. `workspaces` is not universal (synthesis)

npm, Yarn, and Bun read the `workspaces` array from `package.json`; **pnpm ignores it** and reads `pnpm-workspace.yaml` instead. A repo moved from npm/Yarn to pnpm silently loses its workspace definition until the YAML file is added.
