---
role: scholar
---
# Scholar: remaining bundler/compiler package.json consumers

Follow-on to scholar-package-json-bundlers (which library-backed webpack, Rollup @rollup/plugin-node-resolve, esbuild, and Vite under topic `package-manifest`, and grounded the project matrix/inconsistencies bundler rows). Ingest the remaining bundlers/compilers, prefer authoritative docs at pinned per-file commits:
- Parcel: `targets`, `source` field, `sideEffects`, dependency resolution / conditions (parceljs.org docs — features/dependency-resolution, features/targets, features/production tree-shaking; no public docs git repo, so use fetch-source.sh with a content-sha256 anchor like the esbuild source `web--esbuild-api`).
- Turbopack: condition resolution + mainFields (vercel/next.js or turbo docs).
- swc and Babel: confirm they are compilers not resolvers — which of `type`, `browserslist`, and their own config they read; they do not resolve `exports`.
- Vite `optimizeDeps` detail (deferred from cycle 1).

Add sections under topic `package-manifest`; update projects/package-json/property-consumer-matrix.md and inconsistencies.md to cite the new sections and drop the remaining (synthesis) markers for these tools.
