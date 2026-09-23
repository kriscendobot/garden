# Project: package-json

A journal-only research and reference project: a consolidated, navigable synthesis of the `package.json` manifest - the schema and semantics of every known property, and how each property is consumed by every relevant package manager, module system/runtime, and bundler, with the cross-tool interactions, inconsistencies, and fruitful-usage strategies the maintainer asked for. There is no upstream repository and no fork; the deliverable is this project tree plus the library section it draws on ([`../../library/topics/package-manifest.md`](../../library/topics/package-manifest.md)).

## What this is (rules of engagement)

- **Journal-only.** This project produces reference material under `journal/projects/package-json/` and library material under `journal/library/`. It initiates no GitHub interaction of any kind (no issues, PRs, comments, or cross-references), on any repository.
- **Curated, not invented.** Property schema and runtime semantics trace to authoritative primary sources at pinned commits: Node (`cc37ad5`), npm (`ce7681f`), TypeScript (`c8170c35`), Deno configuration and Node-compatibility guides (`7bf3190`), Bun's module-resolution guide (`6352b79`), Endo's compartment-mapper README (`46d4edf`), and the package-manager sources — Yarn Berry manifest schema (`ab0afaf`), pnpm `package.json` fields (`047db9a`) and settings (`0cf4bd3`), Bun overrides (`16a7269`) and lifecycle/`trustedDependencies` (`16a7269`), and Corepack / the `packageManager` field (`05bc5f3`). Bundler consumer details remain synthesis and are flagged for library-backing below.
- **The liaison owns any future rules-of-engagement / identity surface.** The scholar authored this initial README and owns the topic index at the bottom and the `<topic>.md` siblings.

## Coverage status (2026-07-17, package-manager layout follow-on)

Ingested to the library: Node, npm, and TypeScript property sources; then Deno, Bun runtime, and Endo package-manifest sources; then the **package-manager sources** (Yarn Berry manifest schema, pnpm `package.json` + settings, Bun overrides + lifecycle, Corepack) and the package-manager **layout sources** (Yarn PnP and linkers, Yarn workspaces, pnpm's symlinked store and peer-context variants, `pnpm-workspace.yaml`, Bun workspaces, and Bun isolated installs). These back the Yarn / pnpm / Bun / `packageManager` columns and the override-dialect, peer-install, layout, and workspace inconsistency rows. The Deno guides establish configuration and npm-specifier behavior but do not enumerate an exports-condition algorithm, so that narrow resolver detail remains synthesis. Remaining synthesis is limited to bundler consumers and the explicitly noted narrow gaps. Deferred / follow-on `scholar-*` jobs:

- `scholar-package-json-bundlers` - webpack, Rollup, esbuild, Vite, Turbopack, Parcel, swc, Babel: which fields each honors, condition resolution order, `sideEffects` and `browser` handling.
- `scholar-package-json-package-managers` — **done (2026-07-17)**: Yarn Berry (`resolutions`, `dependenciesMeta`, `publishConfig`/`installConfig`), pnpm (`overrides`/`packageExtensions`/`peerDependencyRules` — now in `pnpm-workspace.yaml` since v11 — and `dependenciesMeta.injected`), Bun (`overrides`+`resolutions`, `trustedDependencies`), and Corepack / `packageManager` are library-backed.
- `scholar-package-json-pm-layout` — **done (2026-07-17)**: Yarn PnP's `.pnp.cjs` strict resolver and three linkers, Yarn `workspace:` range rewriting, pnpm's `.pnpm` hardlink/symlink layout and peer-context variants, pnpm workspace membership, and Bun's workspace and isolated-linker layouts are library-backed. No separate canonical Yarn Classic v1 layout document was found in the maintained `yarnpkg/yarn` source tree; its conventional hoisted `node_modules` behavior remains recorded as the legacy comparison, not a claimed separate specification.
- `scholar-package-json-runtimes` - Deno (`deno.json`, npm specifiers, `exports` handling), Bun runtime, and a deeper Endo compartment-mapper library ingest (Package Descriptors + Language Extensions sections).

## Topic files

| Topic | What it covers |
|-------|----------------|
| [property-consumer-matrix](property-consumer-matrix.md) | The property-by-consumer matrix: which of npm / Yarn / pnpm / Bun / Node / Deno / Endo / TypeScript / bundlers reads each property, plus per-consumer resolution/precedence notes. |
| [inconsistencies](inconsistencies.md) | Cross-interactions and inconsistencies: `exports` vs legacy `main`/`module`/`browser`, condition resolution order across tools, the dual-package hazard, PnP vs node_modules vs pnpm strict, `sideEffects`, peer-install differences, and the three override dialects. |
| [strategies](strategies.md) | Fruitful-usage strategies: platform/architecture-specific packages (`os`/`cpu`/`libc` + per-platform `optionalDependencies`), dual ESM/CJS done right, `sideEffects` tree-shaking, `publishConfig`, and monorepo `workspaces` publishing. |
