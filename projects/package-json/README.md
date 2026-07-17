# Project: package-json

A journal-only research and reference project: a consolidated, navigable synthesis of the `package.json` manifest - the schema and semantics of every known property, and how each property is consumed by every relevant package manager, module system/runtime, and bundler, with the cross-tool interactions, inconsistencies, and fruitful-usage strategies the maintainer asked for. There is no upstream repository and no fork; the deliverable is this project tree plus the library section it draws on ([`../../library/topics/package-manifest.md`](../../library/topics/package-manifest.md)).

## What this is (rules of engagement)

- **Journal-only.** This project produces reference material under `journal/projects/package-json/` and library material under `journal/library/`. It initiates no GitHub interaction of any kind (no issues, PRs, comments, or cross-references), on any repository.
- **Curated, not invented.** Property schema and runtime semantics trace to authoritative primary sources at pinned commits: the Node.js "Modules: Packages" reference (`nodejs/node` `doc/api/packages.md` at `cc37ad5`) and npm's field catalog (`npm/cli` `docs/lib/content/configuring-npm/package-json.md` at `ce7681f`), both ingested into the library this cycle, plus the Endo `@endo/compartment-mapper` README (`endojs/endo` `packages/compartment-mapper/README.md` at `ca77052`, read directly). Consumer rows for tools not yet ingested as library sources (bundlers, Yarn Berry / pnpm / Bun, TypeScript, Deno) are synthesis from their public documentation and are flagged for library-backing by the follow-on `scholar-*` jobs listed below.
- **The liaison owns any future rules-of-engagement / identity surface.** The scholar authored this initial README and owns the topic index at the bottom and the `<topic>.md` siblings.

## Coverage status (2026-07-17, first cycle)

Ingested to the library this cycle: the two authoritative property sources (Node runtime, npm CLI). Written this cycle: the property catalog and semantics (library), the property-by-consumer matrix, the inconsistencies section, and the strategies topic (this project tree). Deferred to follow-on `scholar-*` jobs (each posted to the job board and recorded in this cycle's `result` entry):

- `scholar-package-json-bundlers` - webpack, Rollup, esbuild, Vite, Turbopack, Parcel, swc, Babel: which fields each honors, condition resolution order, `sideEffects` and `browser` handling.
- `scholar-package-json-package-managers` - Yarn Classic, Yarn Berry (PnP), pnpm (strict/symlinked layout), Bun: `resolutions`/`pnpm.overrides`, `packageManager`, workspace protocols, peer-install differences.
- `scholar-package-json-typescript` - TypeScript's `types`/`typesVersions`, the `types` export condition, and `moduleResolution` `bundler`/`node16`/`nodenext`; publishing types correctly.
- `scholar-package-json-runtimes` - Deno (`deno.json`, npm specifiers, `exports` handling), Bun runtime, and a deeper Endo compartment-mapper library ingest (Package Descriptors + Language Extensions sections).

## Topic files

| Topic | What it covers |
|-------|----------------|
| [property-consumer-matrix](property-consumer-matrix.md) | The property-by-consumer matrix: which of npm / Yarn / pnpm / Bun / Node / Deno / Endo / TypeScript / bundlers reads each property, plus per-consumer resolution/precedence notes. |
| [inconsistencies](inconsistencies.md) | Cross-interactions and inconsistencies: `exports` vs legacy `main`/`module`/`browser`, condition resolution order across tools, the dual-package hazard, PnP vs node_modules vs pnpm strict, `sideEffects`, peer-install differences, and the three override dialects. |
| [strategies](strategies.md) | Fruitful-usage strategies: platform/architecture-specific packages (`os`/`cpu`/`libc` + per-platform `optionalDependencies`), dual ESM/CJS done right, `sideEffects` tree-shaking, `publishConfig`, and monorepo `workspaces` publishing. |
