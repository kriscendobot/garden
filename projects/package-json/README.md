# Project: package-json

A journal-only research and reference project: a consolidated, navigable synthesis of the `package.json` manifest - the schema and semantics of every known property, and how each property is consumed by every relevant package manager, module system/runtime, and bundler, with the cross-tool interactions, inconsistencies, and fruitful-usage strategies the maintainer asked for. There is no upstream repository and no fork; the deliverable is this project tree plus the library section it draws on ([`../../library/topics/package-manifest.md`](../../library/topics/package-manifest.md)).

## What this is (rules of engagement)

- **Journal-only.** This project produces reference material under `journal/projects/package-json/` and library material under `journal/library/`. It initiates no GitHub interaction of any kind (no issues, PRs, comments, or cross-references), on any repository.
- **Curated, not invented.** Property schema and runtime semantics trace to authoritative primary sources at pinned commits: Node (`cc37ad5`), npm (`ce7681f`), TypeScript (`c8170c35`), Deno configuration and Node-compatibility guides (`7bf3190`), Bun's module-resolution guide (`6352b79`), and Endo's compartment-mapper README (`46d4edf`). Bundlers, Yarn Berry / pnpm, and the remaining Bun package-manager details remain synthesis and are flagged for library-backing below.
- **The liaison owns any future rules-of-engagement / identity surface.** The scholar authored this initial README and owns the topic index at the bottom and the `<topic>.md` siblings.

## Coverage status (2026-07-17, first cycle)

Ingested to the library: Node, npm, and TypeScript property sources, then Deno, Bun runtime, and Endo package-manifest sources. The Deno guides establish configuration and npm-specifier behavior but do not enumerate an exports-condition algorithm, so that narrow resolver detail remains synthesis. Deferred to follow-on `scholar-*` jobs:

- `scholar-package-json-bundlers` - webpack, Rollup, esbuild, Vite, Turbopack, Parcel, swc, Babel: which fields each honors, condition resolution order, `sideEffects` and `browser` handling.
- `scholar-package-json-package-managers` - Yarn Classic, Yarn Berry (PnP), pnpm (strict/symlinked layout), Bun: `resolutions`/`pnpm.overrides`, `packageManager`, workspace protocols, peer-install differences.
- `scholar-package-json-runtimes` - Deno (`deno.json`, npm specifiers, `exports` handling), Bun runtime, and a deeper Endo compartment-mapper library ingest (Package Descriptors + Language Extensions sections).

## Topic files

| Topic | What it covers |
|-------|----------------|
| [property-consumer-matrix](property-consumer-matrix.md) | The property-by-consumer matrix: which of npm / Yarn / pnpm / Bun / Node / Deno / Endo / TypeScript / bundlers reads each property, plus per-consumer resolution/precedence notes. |
| [inconsistencies](inconsistencies.md) | Cross-interactions and inconsistencies: `exports` vs legacy `main`/`module`/`browser`, condition resolution order across tools, the dual-package hazard, PnP vs node_modules vs pnpm strict, `sideEffects`, peer-install differences, and the three override dialects. |
| [strategies](strategies.md) | Fruitful-usage strategies: platform/architecture-specific packages (`os`/`cpu`/`libc` + per-platform `optionalDependencies`), dual ESM/CJS done right, `sideEffects` tree-shaking, `publishConfig`, and monorepo `workspaces` publishing. |
