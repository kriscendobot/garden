# Cross-interactions and inconsistencies

Where the `package.json` consumers disagree, fall back differently, or interact in ways that surprise. Grounded rows cite Node (`cc37ad5`), npm (`ce7681f`), Deno (`7bf3190`), Bun (`6352b79`), Endo (`46d4edf`), and the package-manager sources — Yarn Berry manifest (`ab0afaf`), pnpm `package.json` (`047db9a`) + settings (`0cf4bd3`), Bun overrides (`16a7269`) + lifecycle (`16a7269`), Corepack (`05bc5f3`) — library sources; unmarked remaining claims are **(synthesis)** and are queued for library-backing.

## 1. `exports` versus legacy `main` / `module` / `browser`

Once `"exports"` is present, Node **encapsulates** the package: any subpath not listed throws `ERR_PACKAGE_PATH_NOT_EXPORTED`, and `"exports"` takes precedence over `"main"` (source: package-entry-points section). But the fallback story diverges:

- **Node:** if `"exports"` is present it is authoritative; `main` is used only as the `"."` fallback when no `exports` matches `"."`, and `module`/`browser` are **ignored entirely** (Node reads only five fields).
- **Bundlers (synthesis):** when `exports` is absent, they walk a fallback chain, commonly `module` -> `browser` -> `main` (order and set vary per bundler). `module` is a non-standard field that exists **only** to give bundlers an ESM build to tree-shake; Node never reads it. A package that ships `module` but no `import` export condition therefore tree-shakes in bundlers but loads the CJS `main` in Node.
- **Bun (module-resolution guide `6352b79`):** uses `exports` first, then `main` (or implicit `index.*`) before `module`; `bun` can select a TypeScript source entry. This is a different legacy fallback order from common bundler practice.
- **Endo (README `46d4edf`):** reads `main`, `browser`, and `exports`; `browser` is drawn in over `main` under the `browser` condition. No `module` field.

Practical hazard: a package can present three different entry points to three tools (bundler via `module`, Node via `exports`/`main`, browser via `browser`), and they can drift out of sync silently.

## 2. Conditional-export **condition resolution order** differs across tools

Node matches conditions in **object key order**, most-specific-first, with `"default"` last, over a fixed built-in set (`node-addons`, `node`, `import`, `require`, `module-sync`, `default`) plus user `--conditions` (source: conditional-exports section). Divergences:

- **Bundlers (synthesis):** each defines its own default condition list and precedence. webpack's default `conditionNames`, Vite's SSR-vs-client condition sets, esbuild's `--conditions`, and Rollup plugin defaults are all configurable and not identical. A `development`/`production` or `browser`/`node` split can resolve differently in two bundlers.
- **Deno:** the ingested compatibility documentation establishes `npm:` and package-manifest operation but does not specify its export-condition set or order. Treat any `deno`-condition claim as remaining synthesis until a resolver specification or implementation source is ingested.
- **Endo (README `46d4edf`):** supports only `import`, `browser`, and `endo`. A package relying on `require`, `node`, `development`, or a custom condition gets Endo's fallback behavior, not the author's intended branch.
- **TypeScript:** under `moduleResolution` `node16`/`nodenext`/`bundler`, always matches `types` and `default` when present, then uses the import/require context. A dual package must put `types` first inside each matching runtime branch; otherwise one declaration format can shadow or fail to pair with its runtime branch while runtime loading still succeeds. The relevant `types`-condition ordering is now grounded in the TypeScript handbook source (`c8170c35`), rather than synthesis.

The safe rule the Node docs give: always include a `"default"` branch, and prefer `node` + `default` over `node` + `browser`, so unknown environments get a universal implementation instead of impersonating a known one.

## 3. The **dual-package hazard** (ESM/CJS dual publishing)

Selecting builds by the `import`/`require` conditions loads two separate module instances when a process reaches the package both ways: doubled package state and broken `instanceof` (concept [`../../library/concepts/dual-package-hazard.md`](../../library/concepts/dual-package-hazard.md); Node self-referencing-and-dual-package section). It is silent because the manifest is valid. Interacts with `"type"`: `.cjs`/`.mjs` extensions decide which build a file belongs to regardless of `"type"`. Mitigations: isolate stateful internals in one CJS module both builds wrap; or ship ESM-only with a synchronous `module-sync` entry `require()` can load; or ship CJS-only.

## 4. Yarn **PnP** versus `node_modules` versus pnpm's **symlinked/strict** layout

Three different physical realizations of the same manifest, with different visibility semantics:

- **npm / Yarn Classic:** hoisted `node_modules`. A package can accidentally `require` a dependency it never declared (a phantom / hoisted dependency) because hoisting placed it in a visible parent folder. Works until the tree reshuffles.
- **Yarn Berry PnP:** no `node_modules`; a `.pnp.cjs` resolver maps package locations and enforces that a package sees **only** its declared dependencies. Phantom dependencies fail immediately. Missing edges can be supplied through `.yarnrc.yml` `packageExtensions` ([PnP resolver](../../library/sections/yarn-berry--plugnplay--resolver-and-strict-visibility.md)).
- **pnpm:** package files are hardlinked into `node_modules/.pnpm`, then the dependency graph and root direct dependencies are built with symlinks. It limits visibility to declared dependencies while remaining compatible with Node's filesystem resolution; compatibility hoisting can relax that strictness ([symlinked layout](../../library/sections/pnpm-io--symlinked-node-modules-structure--store-and-strict-visibility.md)). Peer-resolution sets make distinct store-path variants ([peer contexts](../../library/sections/pnpm-io--how-peers-are-resolved--peer-context-store-variants.md)).
- **Node's experimental package maps** (`--experimental-package-map`, added v26.4.0) are a fourth model: resolution from a static data table with no `node_modules` at all, explicitly to prevent phantom dependencies (Node package-maps section).

The manifest is identical; the strictness a package experiences (whether `packageExtensions` is needed to declare a missing edge) depends on the selected layout and its hoisting configuration. npm's own docs call out that `packageExtensions` is "especially useful with `install-strategy=linked`" for exactly this reason. Yarn's install modes make the PnP, pnpm-style, and node-modules trade-off explicit ([install modes](../../library/sections/yarn-berry--install-modes--pnp-pnpm-and-node-modules-linkers.md)); Bun supplies a fourth practical comparison through its isolated `.bun` store and symlinks ([isolated installs](../../library/sections/bun--isolated-installs--bun-store-and-strict-layout.md)).

## 5. `sideEffects` tree-shaking semantics (synthesis)

`sideEffects: false` tells bundlers that importing a module for its exports triggers no observable side effect, so unused imports can be dropped; an array value names the files that **do** have side effects (CSS imports, polyfills). Node and package managers ignore it. Inconsistency: bundlers implement the pruning slightly differently (webpack honors it directly, Rollup via its tree-shaking plus plugins, esbuild and Vite have their own handling), and a wrong `false` silently drops a needed side-effect import - a correctness bug that only appears in the bundled build, never in Node.

## 6. `peerDependencies` auto-install differences

- **npm:** 3-6 warned but did not install; **v7+ installs by default** (source: dependencies-and-overrides section). A conflicting peer requirement can now fail the install.
- **Yarn Berry / pnpm (library-backed):** do not silently auto-install peers the way npm v7 does. pnpm surfaces peer issues loudly and relaxes them via `peerDependencyRules` (`ignoreMissing`/`allowedVersions`/`allowAny`), now in `pnpm-workspace.yaml` ([pnpm--settings--package-extensions-and-peer-rules](../../library/sections/pnpm--settings--package-extensions-and-peer-rules.md)). Yarn Berry relies on its resolver and additionally supports **peer-dependencies-with-default** — a dependency listed in both `dependencies` and `peerDependencies` solves the peer first and falls back to the regular dependency ([yarn-berry--manifest-schema--dependency-metadata](../../library/sections/yarn-berry--manifest-schema--dependency-metadata.md)). pnpm's `dependenciesMeta.injected` further lets one workspace package satisfy the *same* peer differently for different consumers via hard-linked copies ([pnpm--package-json--dependencies-meta-and-publishconfig](../../library/sections/pnpm--package-json--dependencies-meta-and-publishconfig.md)).

The same manifest therefore produces different installed trees under different managers, and a package author testing only under one manager can ship a peer graph that breaks under another.

## 7. `overrides` versus `resolutions` versus pnpm `overrides` (library-backed)

Three dialects for the same job (force a transitive dependency version), all root-only, with different selector syntax and merge rules (concept [`../../library/concepts/dependency-overrides.md`](../../library/concepts/dependency-overrides.md)):

- **npm `overrides`:** nested-object selectors, version-scoped parent keys (`"bar@2.0.0"`), `$name` references to a direct dependency's spec, `npm:`/`github:`/`file:` replacements (npm-grounded, dependencies-and-overrides section).
- **Yarn `resolutions`:** flat glob-path selectors (`parent/dep`, `parent@version/dep`), one level of specificity, root-only ([yarn-berry--manifest-schema--resolutions](../../library/sections/yarn-berry--manifest-schema--resolutions.md)). Bun also reads `resolutions`, but top-level only.
- **pnpm `overrides`:** **since pnpm v11 lives in `pnpm-workspace.yaml`, not a `pnpm` block in `package.json`** ([pnpm--package-json--pnpm-field-moved-and-engines](../../library/sections/pnpm--package-json--pnpm-field-moved-and-engines.md)); `parent>dep` selectors, `catalog:` references, `-` removal, and it applies to peer dependencies ([pnpm--settings--overrides](../../library/sections/pnpm--settings--overrides.md)).
- **Bun:** reads npm `overrides` and Yarn `resolutions` but supports **neither's nested selectors** (top-level only), a porting hazard from npm ([bun--overrides--overview](../../library/sections/bun--overrides--overview.md)).

Porting a project between managers requires translating the dialect, and a mistranslation silently fails to pin the intended version. `packageExtensions` is the complementary field (add/correct the metadata that creates the edge rather than change what it resolves to) and also exists in three places — npm `packageExtensions`, Yarn Berry (a `.yarnrc.yml` setting), and pnpm `packageExtensions` (in `pnpm-workspace.yaml` since v11); pnpm and Yarn co-maintain the shared `@yarnpkg/extensions` database ([pnpm--settings--package-extensions-and-peer-rules](../../library/sections/pnpm--settings--package-extensions-and-peer-rules.md)).

## 8. How Deno / Endo / Bun diverge from Node

- **Deno:** `deno.json` supplies import maps and Deno tooling; `package.json` supplies dependencies and scripts. `npm:` is an explicit package-specifier form, and package projects use manual `node_modules`. The detailed exports-condition algorithm remains synthesis.
- **Endo (README `46d4edf`):** a deliberately small subset - `name`/`type`/`main`/`exports`/`browser`/`dependencies`/`files`, three conditions (`import`/`browser`/`endo`), no `imports` and no `*` patterns yet, plus its own `parsers` field and `.ts` -> `.cts`/`.mts` hook. It can load CJS from ESM, ESM from CJS, and JSON without an import attribute, all documented as potentially reducing Node compatibility.
- **Bun (module-resolution guide `6352b79`; overrides/lifecycle guides `16a7269`):** honors `exports`/`imports`, ordered conditions including `bun`, and `main` before `module` fallback. As a PM it reads npm `overrides` and Yarn `resolutions` (top-level only) and is **default-secure** — it runs a dependency's lifecycle scripts only for allow-listed packages named in `trustedDependencies`, which *replaces* (not extends) the curated built-in list and covers only npm-source packages, so a package relying on a `postinstall` build silently does not build unless trusted ([bun--overrides--overview](../../library/sections/bun--overrides--overview.md), [bun--lifecycle--trusted-dependencies](../../library/sections/bun--lifecycle--trusted-dependencies.md)).

## 9. `workspaces` is not universal

npm, Yarn, and Bun read the `workspaces` array from `package.json`; **pnpm ignores it** and reads `pnpm-workspace.yaml` instead — the same file that (since pnpm v11) holds pnpm's `overrides`/`packageExtensions`/`peerDependencyRules` settings ([pnpm--package-json--pnpm-field-moved-and-engines](../../library/sections/pnpm--package-json--pnpm-field-moved-and-engines.md)). pnpm's YAML `packages:` field uses include/exclude globs, always includes the root, and includes only the root when omitted ([workspace YAML](../../library/sections/pnpm-io--pnpm-workspace-yaml--packages-and-root-membership.md)). Yarn's and Bun's `workspace:` protocol forms also differ in their publish rewrite details ([Yarn](../../library/sections/yarn-berry--workspaces--workspace-protocol-and-publish-rewrite.md), [Bun](../../library/sections/bun--workspaces--manifest-globs-and-workspace-publish-rewrite.md)). A repo moved from npm/Yarn to pnpm silently loses its workspace definition until the YAML file is added.
