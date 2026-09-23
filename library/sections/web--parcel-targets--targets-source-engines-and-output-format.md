---
title: Parcel targets, source, engines, and output format
source_kind: web
source_url: https://parceljs.org/features/targets/
source_content_sha256: 6dd8deabe26519ca653ff559ebcd0432a805a6b47135f4505702883caa9cf43d
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Parcel contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Parcel is target-driven: the `targets` `package.json` field defines named build environments, and four built-in targets — `main`, `module`, `browser`, `types` — are read directly from their like-named manifest fields, where the field value doubles as the output path and the field name selects the output format. `main` outputs CommonJS by default but ES modules when `"type": "module"` or a `.mjs` path is set; `module` always outputs ESM; `browser` is a browser-specific CommonJS override of `main`; `types` emits TypeScript declarations. Entry points come from the `source` field (top-level or per-target), and the environment comes from `engines` (`node`, `browsers`) and `browserslist`.

**The `targets` field** defines how code compiles for different environments; each target is a named object of configuration:

```json
{
  "targets": {
    "modern": { "engines": { "browsers": "Chrome 80" } },
    "legacy": { "engines": { "browserslist": "> 0.5%, last 2 versions, not dead" } }
  }
}
```

**Built-in library targets.** Parcel recognizes four built-in targets that correspond to `package.json` fields; the field's value is the output location and its name selects the format:

- `main` — by default outputs CommonJS. If the `.mjs` extension is used, or `"type": "module"` is specified, an ES module is output instead.
- `module` — outputs an ES module.
- `browser` — a browser-specific override of the `main` field; outputs CommonJS.
- `types` — outputs TypeScript declarations.

**Source entry points.** Entry files come from the top-level `source` field (`"source": "src/index.html"`, or an array), or from `targets.<name>.source` for entries specific to one target.

**Environment.** For browser targets, `"browserslist": "> 0.5%, last 2 versions, not dead"` names the supported browsers; for Node targets, `"engines": { "node": ">= 12" }` uses semver ranges, and the `engines.browsers` subfield functions like `browserslist`.

**Per-target options** (nested under `targets.<name>`) include `context` (`node`, `browser`, `web-worker`, `service-worker`, `worklet`, `electron-main`, `electron-renderer`), `outputFormat` (`global`, `esmodule`, `commonjs`), `engines`, `scopeHoist` (boolean; default enabled for production, and cannot be disabled for library targets), `isLibrary` (requires `outputFormat` be `esmodule`/`commonjs`), `optimize` (default enabled for production, disabled for libraries), `includeNodeModules` (boolean/array/object; library targets do not bundle `node_modules` dependencies by default), `sourceMap`, `distDir`, and `publicUrl` (default `/`). Multiple targets output to `dist/${targetName}` unless customized.

Source: [Parcel targets](https://parceljs.org/features/targets/) fetched 2026-07-17 (content sha256 `6dd8dea`), sections *Targets*, *Library targets*, *Source*, *Environments*, and *Target options*.
