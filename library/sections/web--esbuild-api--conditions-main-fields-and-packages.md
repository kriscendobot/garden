---
title: esbuild conditions, main fields, and packages=external
source_kind: web
source_url: https://esbuild.github.io/api/
source_content_sha256: 2c986ac415f99cc403a5af6de4962ef94d76daba20f7b560dec3edfd6b563dfc
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Evan Wallace]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: esbuild's resolution honors `exports` conditions, legacy `mainFields`, and the `packages` setting. Its automatic conditions are platform-derived — `import`/`require` (by import kind), `browser` (only when `platform: browser`), `node` (only when `platform: node`), and `module` (auto-included for browser/node when no custom conditions are configured, giving bundler ESM preference); `--conditions` adds custom ones. Default `mainFields` depend on platform. `--packages=external` marks every bare `package.json` dependency external in one flag.

**Conditions** (`--conditions` / `conditions`) control how `exports` is interpreted. esbuild automatically applies a platform-derived set:

- `import` / `require` — selected by how the import is written.
- `browser` — active only when `platform` is `browser`; `node` — active only when `platform` is `node` (and when running natively in node).
- `module` — a bundler-specific condition (originating from webpack) that selects the ESM variant for better tree-shaking. It is auto-included for `browser`/`node` platforms **only when no custom conditions are configured**; supplying any `conditions` value (even an empty list) suppresses the automatic `module`. esbuild warns that combining the `require` and `import` conditions can put a package into the bundle twice (the dual-package hazard).

Custom conditions (`--conditions=custom1,custom2`) are entirely author-defined; Node has endorsed only `development` and `production` as recommended customs.

**Main fields** (`--main-fields` / `mainFields`) name the legacy entry fields to try when a package has no matching `exports`. esbuild documents the three common fields — `main` (CommonJS-oriented, hard-coded into Node), `module` (an unadopted ESM proposal that bundlers took up for tree-shaking; misusing it for browser-only code defeats tree-shaking, so browser code belongs in `browser` instead), and `browser` (bundler replacement of node-specific files with browser-friendly versions). The default main-fields set depends on the current `platform`; it can be overridden, e.g. `--main-fields=module,main`.

**Packages** (`--packages=external`) marks all imports that "look like" package imports (paths not starting with `/`, `.`, or `..`, excluding `#` subpath-imports and tsconfig `paths`/`baseUrl` remappings) as external in one setting — equivalent to passing each dependency to `external`, useful when bundling for node. The default `--packages=bundle` allows package imports to be bundled.

Source: [esbuild API documentation](https://esbuild.github.io/api/) fetched 2026-07-17 (content sha256 `2c986ac`), sections *Conditions*, *Main fields*, and *Packages*.
