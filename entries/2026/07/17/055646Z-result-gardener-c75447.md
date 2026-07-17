---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T05:56:52Z
---
---
role: scholar
project: package-json
---
Scholar cycle: package.json manifest - library ingest + project report (job scholar-package-json-schema-and-tooling).

## Sources ingested (2 new, both authoritative primary sources)
- **node--doc-api-packages** (nodejs/node `doc/api/packages.md` @ `cc37ad5`, 8 sections): overview, determining-module-system, package-entry-points, subpath-exports-imports-and-patterns, conditional-exports, self-referencing-and-dual-package, package-maps, field-definitions. The Node runtime/module-system column.
- **npm--configuring-npm-package-json** (npm/cli `docs/lib/content/configuring-npm/package-json.md` @ `ce7681f`, 5 sections, consolidated per the reference-document convention): identity-and-metadata, files-entry-points-and-bin, scripts-config-and-native-build, dependencies-and-overrides, environment-constraints-and-publishing. The npm property catalog / field-by-field schema.

## Idempotency notes
- Endo `@endo/compartment-mapper` README is already ingested at the design level (source `endo--packages-compartment-mapper-README-md`, 1 narrative section, no property-descriptor breakout). To avoid disturbing that heavily-curated narrative source and a duplicate source-index, the Endo property-reading detail (Package Descriptors + Language Extensions) was covered in the project report's consumer matrix, grounded in the README read directly at `ca77052`, and a dedicated library-section ingest of those sections was deferred to follow-on `scholar-package-json-runtimes`.

## New topic + concepts
- Topic **package-manifest** (13 sections). Concepts **conditional-exports**, **dual-package-hazard**, **package-type-field**, **subpath-exports**, **dependency-overrides**; ~43 keyword lines added to keywords.md.

## Project report (new project `package-json`)
- `journal/projects/package-json/README.md` (+ registered in `projects/README.md`), plus topic files `property-consumer-matrix.md` (property x consumer matrix across npm/Yarn/pnpm/Bun/Node/Deno/Endo/TypeScript/bundlers with per-consumer resolution notes), `inconsistencies.md` (exports vs legacy main/module/browser, condition-order divergence, dual-package hazard, PnP vs node_modules vs pnpm strict, sideEffects, peer-install differences, overrides/resolutions/pnpm.overrides, Deno/Endo/Bun divergence, workspaces non-universality), and `strategies.md` (platform/arch-specific packages via os/cpu/libc + optionalDependencies, dual ESM/CJS done right, sideEffects tree-shaking, publishConfig, monorepo workspaces publishing). Node/npm rows grounded in the ingested sources; Endo grounded in the README at `ca77052`; bundler/Yarn-Berry/pnpm/Bun/TypeScript/Deno rows flagged (synthesis) and queued for library-backing.

## Follow-on jobs posted (remainder, per role budget)
- `scholar-package-json-bundlers` (webpack/Rollup/esbuild/Vite/Turbopack/Parcel/swc/Babel).
- `scholar-package-json-package-managers` (Yarn Classic/Berry+PnP, pnpm strict, Bun).
- `scholar-package-json-typescript` (types/typesVersions/`types` condition, moduleResolution bundler/node16/nodenext).
- `scholar-package-json-runtimes` (Deno, Bun runtime, deeper Endo compartment-mapper Package-Descriptors/Language-Extensions ingest).

## Integrity gate + regeneration
- `library-link-check.sh --changed`: OK (every section-table/index target on the two touched source clusters resolves to a committed file).
- `regenerate-topics-counts.sh --check`: counts current (package-manifest = 13).
- Shared indexes (keywords.md, topics/README.md, sources/README.md) had advanced on tip mid-cycle from a concurrent sibling; re-applied my additions onto the fresh tip before landing so no sibling row/keyword was clobbered (concepts/README.md, projects/README.md were unchanged on tip).
- Final landing step: `regenerate-sections-index.sh` regenerated + landed `sections/README.md` (DANGLING guard passed, confirming all 13 new section files are tracked); `regenerate-topics-counts.sh` already current.
- All 25 new content files landed via `land-journal-edit.sh`.

Deferred backlog: the four consumer-family follow-ons above; a dedicated Endo library-section breakout of Package Descriptors / Language Extensions (in scholar-package-json-runtimes).
