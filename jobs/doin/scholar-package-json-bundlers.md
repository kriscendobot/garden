---
role: scholar
---
# Scholar: how bundlers and compilers read package.json

Follow-on to scholar-package-json-schema-and-tooling (which ingested the Node runtime and npm property sources and built the `journal/projects/package-json/` report). Ingest, as library sources with pinned per-file commits, how each bundler/compiler consumes package.json, and back the project's property-consumer matrix + inconsistencies rows currently flagged (synthesis):
- webpack (resolve.conditionNames, mainFields, sideEffects), Rollup (@rollup/plugin-node-resolve exports/mainFields), esbuild (--conditions, mainFields, packages=external), Vite (ssr vs client conditions, optimizeDeps), Turbopack, Parcel (targets, sideEffects, source field), swc, Babel.
- Focus: which fields each honors, the default condition set and precedence order, `module`/`browser`/`main` fallback chain, `sideEffects` semantics.
- Add sections under topic `package-manifest`; update the project matrix/inconsistencies to cite the new sections; note remaining synthesis. Prefer authoritative docs (each tool's docs repo, readable via gh/scratch clone).

<!-- garden-reaped: 3 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 20
  worker_kind: gardener
  claimed_at: 2026-07-17T14:33:16Z
