---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T15:14:16Z
---
# Result: scholar-package-json-bundlers-2 (remaining bundler/compiler package.json consumers)

Follow-on to `scholar-package-json-bundlers` (which had completed to `jobs/tada/`). Ingested the remaining bundlers/compilers under topic `package-manifest` and grounded the project matrix + inconsistencies bundler/compiler rows.

## Sources ingested (7 new; 8 new section files)
- **web--parcel-dependency-resolution** (content `ce144ef`, fetch-source direct) — 2 sections: `entries-order-exports-and-conditions` (source→exports→browser→module→main precedence; opt-in `exports` via `packageExports`; condition set; `imports`; `browser`), `aliases-source-field-and-specifiers` (`alias` forms, `source` field, specifier grammar).
- **web--parcel-targets** (content `6dd8dea`) — 1 section: `targets-source-engines-and-output-format` (the `targets` field; built-in `main`/`module`/`browser`/`types` targets; `source`; `engines`/`browserslist`; output-format inference).
- **web--parcel-production** (content `898c5ec`) — 1 section: `tree-shaking-and-scope-hoisting`. **Negative finding:** Parcel's production docs do NOT document the `sideEffects` field (static-analysis + scope-hoisting only); corrected the earlier synthesis guess that grouped Parcel with webpack/esbuild as a documented `sideEffects` consumer.
- **web--nextjs-turbopack-config** (content `871ded2b`) — 1 section: `module-resolution-aliases-and-extensions` (`resolveAlias` with browser-only conditional aliasing; `resolveExtensions` default `['.mdx','.tsx','.ts','.jsx','.js','.mjs','.json']`; loader-rule conditions). **Honest gap:** the public config reference does not enumerate an `exports` condition set or `mainFields`.
- **web--swc-compilation** (content `2981937c`) — 1 section: `compiler-not-resolver-env-targets-and-module`. Confirmed swc is a compiler/transformer, not a resolver (reads `.swcrc`; `env.targets` browserslist queries; does not read `package.json` `exports`/`main`/`module`/`browser` or the `browserslist` key per its docs).
- **web--babel-options** (content `068855fa`) — 1 section: `compiler-not-resolver-browserslist-and-sourcetype`. Confirmed Babel is a compiler/transformer (own config files; the one `package.json` field it reads is `browserslist` via `browserslistConfigFile`; module vs script from `sourceType`, not `type`).
- **vite--config-dep-optimization-options** (repo-doc vitejs/vite, commit `9beae37`) — 1 section: `optimizedeps-dependency-prebundling` (the cycle-1-deferred `optimizeDeps` detail: entry crawling, include/exclude/noDiscovery, CJS→ESM interop, holdUntilCrawlEnd/needsInterop/force).

## Topic / index pages touched
- `library/topics/package-manifest.md` — added 15 Section rows: my 8 new sections PLUS the 7 cycle-1 bundler sections (webpack ×2, Rollup, esbuild ×2, Vite client/SSR) that cycle 1 had left out of the topic page.
- `library/sources/README.md` — added a new "## Bundler and compiler sources" section (13 rows) indexing all bundler/compiler sources across both cycles; cycle 1 had never indexed its bundler sources here.
- `library/sections/README.md` and `library/topics/README.md` counts — regenerated as the final landing step (`regenerate-sections-index.sh`, `regenerate-topics-counts.sh`); both idempotent and current.

## Matrix + inconsistencies grounding (concurrency repair)
Discovered that cycle 1's two supervising gardeners on two hosts had **clobbered each other's whole-file lands**: host ece02cb4 grounded the bundler rows (a411d3c8f / 9dea4d179) while host garden2 grounded the PM/workspace rows (b6132e4b2 / 528f4ce3a), and each later land reverted the other family to synthesis. Neither tip was a superset. Repaired by **merging**: based my edits on the current tip (latest PM/workspace grounding) and re-applied the four-bundler grounding plus my five new tools.
- `projects/package-json/property-consumer-matrix.md` — grounded intro line for all 8 tools; grounded `module`/`exports`/`imports`/`sideEffects` rows (dropped their bundler synthesis markers); rewrote the "### Bundlers and compilers" section with per-tool grounded bullets for webpack/Rollup/esbuild/Vite/Parcel/Turbopack/swc/Babel. Only Yarn Classic v1 and the non-bundler `engineStrict` synthesis markers remain (out of scope).
- `projects/package-json/inconsistencies.md` — grounded §1 (mainFields fallback), §2 (condition-order divergence), §5 (`sideEffects`, incl. the Parcel-not-documented outlier); added §10 "Compilers (swc, Babel) are not resolvers". Only the Deno exports-condition-algorithm synthesis note remains (out of scope).

## Integrity gate (step 8)
- `library-link-check.sh --changed`: **PASS** (every touched source/section/index link resolves to a committed file).
- `regenerate-topics-counts.sh --check`: stale-then-reconciled by the step-9 `--land` (my new rows); no missing topic page.
- Post-land verification: every `../../library/...` link in the landed matrix + inconsistencies resolves; the PM/workspace grounding survived the merge; no concurrent writer landed in my window (only my own lands at 15:10–15:12).

## Follow-on / deferred
- **None required for this job's scope.** All tools named (Parcel, Turbopack, swc, Babel, Vite `optimizeDeps`) are ingested and grounded.
- Minor future note: Turbopack's `exports` condition set / `mainFields` are not in the public Next.js config reference; grounding them fully would need the Turbopack Rust source (vercel/next.js turbopack crates), not the docs — left as an honest gap, not a posted job.
- Concept pages (`conditional-exports`, etc.) were not given per-section rows this cycle (cycle 1 likewise did not for bundlers); the topic page + matrix carry navigation. Not gating.

Self-improvement: the root cause of the cycle-1 damage was two gardeners doing concurrent WHOLE-FILE lands of the same project files (matrix, inconsistencies) via `land-journal-edit.sh`, whose sync-to-tip prevents git-level loss but NOT semantic clobber when each body was composed against a stale base grounding a different column-family. A cheap guard: `land-journal-edit.sh` could warn (or require `--force`) when the target file changed between the caller's read-base and the tip for non-append whole-file replacements — surfacing "you may be overwriting a concurrent edit" the way the sections/topics regenerators already detect drift. Reported here for the mentor/liaison rather than landed (scholar does not edit scripts).
