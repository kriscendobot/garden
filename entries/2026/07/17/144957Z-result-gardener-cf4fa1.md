---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T14:49:59Z
---
# Result: scholar-package-json-bundlers

Ingested how the four resolver-bundlers consume `package.json`, backing the `package-json` project's bundler rows.

## Sources ingested (6 sources, 7 sections)
- `webpack--config-resolve` (webpack/webpack.js.org src/content/configuration/resolve.mdx `c0038eb`) — 1 section (mainFields, conditionNames dynamic default, exportsFields/importsFields/aliasFields).
- `webpack--guides-tree-shaking` (…/guides/tree-shaking.mdx `6f1e6f2`) — 1 section (`sideEffects` flag; false vs glob array; vs usedExports).
- `rollup--node-resolve-readme` (rollup/plugins packages/node-resolve/README.md `d455fff`) — 1 section (exportConditions base set, mainFields `['module','main']`, browser option).
- `web--esbuild-api` (esbuild.github.io/api single-page docs; no docs git repo, content-sha256 `2c986ac` anchor) — 2 sections (conditions/main-fields/packages=external; tree-shaking + sideEffects + @__PURE__ + --ignore-annotations).
- `vite--config-shared-options` (vitejs/vite docs/config/shared-options.md `9beae37`) — 1 section (client resolve.conditions/mainFields/dedupe).
- `vite--config-ssr-options` (docs/config/ssr-options.md `01337ad`) — 1 section (ssr conditions `node`-not-`browser`, externalConditions, ssr.external/noExternal).

## Topic/index updates
- topics/package-manifest.md: +7 section rows (now 35 rows; topics/README count regenerated to 35).
- sources/README.md: new "## Package-manifest bundler and compiler sources" section listing the 6 sources.
- sections/README.md: regenerated (idempotent lander) — new sections indexed.

## Project matrix/inconsistencies updated
- property-consumer-matrix.md: intro now cites the bundler sources; `module`/`imports`/`exports`/`sideEffects` rows re-grounded with section links (Parcel-only left as synthesis); the "### Bundlers" section rewritten into a grounded per-bundler breakdown (webpack/Rollup/esbuild/Vite cited; Parcel/Turbopack/swc/Babel marked synthesis).
- inconsistencies.md: §1 (main/module/browser fallback), §2 (condition resolution order), §5 (sideEffects) re-grounded with per-bundler defaults + section citations; intro synthesis note narrowed to Parcel/Turbopack/swc/Babel.
- projects/package-json/README.md coverage status: marked `scholar-package-json-bundlers` done; named the `scholar-package-json-bundlers-2` follow-on.

## Follow-on posted
- `scholar-package-json-bundlers-2` — Parcel (`targets`/`source`/`sideEffects`/dependency-resolution), Turbopack, swc, Babel, and Vite `optimizeDeps`.

## Integrity gate (step 8)
- `library-link-check.sh --changed`: OK — every checked link resolves to a committed file.
- `regenerate-topics-counts.sh --check`: counts current.
- Final landing: `regenerate-sections-index.sh` landed the refreshed flat index; `regenerate-topics-counts.sh` idempotent (nothing to land).

## Remaining synthesis
Parcel, Turbopack, swc, Babel bundler/compiler behavior, and Vite `optimizeDeps` — carried by the posted follow-on.

Self-improvement: esbuild has no public docs git repository, so its canonical single-page docs were ingested as a `source_kind: web` source with a `source_content_sha256` idempotency anchor (like a paper) rather than a git commit — a reusable pattern for tools whose only authoritative docs are a rendered website. Worth noting in the scholar brief that some bundler docs (esbuild, Parcel) are website-only and take the web-source shape.
