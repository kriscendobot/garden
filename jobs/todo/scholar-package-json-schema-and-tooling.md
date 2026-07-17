---
role: scholar
---
# Scholar: the package.json manifest — every property, and how each tool interprets it

Build a navigable library section + project report on the **`package.json` manifest**: the schema
and usage of **every known property**, and how each property is consumed by every relevant package
manager, module system/runtime, and bundler — with cross-interactions, inconsistencies, and
strategy write-ups. Journal-only work per `roles/scholar/AGENT.md`.

## Scope — what to cover
1. **Every known property + its schema/semantics.** name, version, description, keywords, homepage,
   bugs, license, author/contributors, funding, files, main, module, browser, types/typings,
   typesVersions, exports, imports, type, bin, man, directories, repository, scripts, config,
   dependencies, devDependencies, peerDependencies, peerDependenciesMeta, bundleDependencies,
   optionalDependencies, overrides (npm) / resolutions (yarn) / pnpm.overrides, engines, engineStrict
   (legacy), os, cpu, libc, private, publishConfig, workspaces, sideEffects, packageManager, and the
   tool-namespaced blocks (`pnpm`, `resolutions`, `bin`, custom `exports` conditions). Note deprecated/
   legacy fields.
2. **Consumer matrix — how each tool reads the relevant properties.** Do a property-by-consumer pass:
   - **Package managers:** npm, Yarn Classic (v1), Yarn Berry (v2+, incl. PnP), pnpm, Bun (as a PM).
   - **Module systems / runtimes:** Node.js (CJS require + ESM import resolution, conditional
     `exports`/`imports`), Deno, **Endo** (`@endo/compartment-mapper` — how it maps `exports`/`main`/
     `module`/`browser`/`type`; cite the repo), Bun (runtime).
   - **Bundlers / compilers:** webpack, Rollup, esbuild, Vite, Turbopack, Babel, Parcel, swc; plus
     **TypeScript**'s use (`types`, `typesVersions`, `exports` types conditions, `moduleResolution`
     bundler/node16/nodenext).
   For each, record which properties it honors, its resolution/precedence order, and quirks.
3. **Cross-interactions & inconsistencies (a dedicated section).** e.g. `exports` vs legacy
   `main`/`module`/`browser` and who still falls back; conditional-export **condition resolution order**
   differences across Node vs bundlers vs Deno; ESM/CJS **dual-publishing** hazards (dual-package
   hazard, `type: module`); Yarn **PnP** vs `node_modules` vs pnpm's **symlinked/strict** layout;
   `sideEffects` tree-shaking semantics; `peerDependencies` auto-install differences; `overrides` vs
   `resolutions` vs `pnpm.overrides`; how Deno/Endo/Bun **diverge** from Node.
4. **Strategy articles (the fruitful-usage angle the maintainer asked for).** Collect and synthesize
   guidance on: **publishing architecture-/platform-specific packages** (`os`/`cpu`/`libc`,
   `optionalDependencies` of per-platform prebuilt-binary sub-packages — the esbuild / swc /
   @napi-rs / prebuildify pattern), platform-conditional `exports`, dual ESM/CJS publishing done
   right, `sideEffects` for tree-shaking, `publishConfig`, and monorepo `workspaces` publishing.

## Sources
Prefer authoritative docs — many live in public repos you can read via `gh`/a scratch clone: the npm
docs, the **Node.js** docs (`packages.md` / ESM resolution), pnpm docs, Yarn Berry docs, Deno docs,
Bun docs, the bundler docs (Vite/Rollup/webpack/esbuild/Babel/Turbopack), the **TypeScript** handbook
(module resolution + publishing), and the Endo `compartment-mapper` source. Add well-regarded articles
on dual publishing and platform-specific packages. Record per-source provenance (source_url + the
per-file commit sha where applicable) per `journal/library/conventions.md`.

## Output (scholar's normal shape — partition cleanly, many small files)
- **Library ingestion** under `journal/library/`: a source-index per source; topic files partitioned
  **by property** and **by consumer**; concept files for the cross-cutting ideas (`conditional-exports`,
  `dual-esm-cjs`, `platform-specific-packages`, `dependency-resolution-overrides`,
  `pnp-vs-node-modules`). Update the README indexes + `keywords.md`.
- **Project report** at `journal/projects/package-json/README.md` (+ topic files): a consolidated,
  navigable synthesis including a **property x consumer matrix** and the **inconsistencies** section,
  and a **strategies** topic for platform/architecture-specific publishing.

## Bounds & fan-out
Standard scholar bounds (`roles/scholar/AGENT.md`): journal-only writes (`library/`, `projects/`,
`entries/`); **no sub-agent dispatch**; no external systems beyond reading sources. This is large — if
it exceeds one cycle's budget, write what is well-supported this cycle and **post follow-on
`scholar-*` jobs** for the remainder (e.g. one per consumer family: bundlers, package managers,
runtimes, strategies). Record a `result` entry with what was covered and what was deferred.
