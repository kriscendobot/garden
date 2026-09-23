---
title: Main fields and condition names
source: src/content/configuration/resolve.mdx
source_repo: webpack/webpack.js.org
source_commit: c0038eb5eb2040d8abbb0f1a8d9882c202d1135a
source_date: 2026-05-18
source_authors: [webpack documentation contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: How webpack reads `package.json` to resolve a bare import: `resolve.mainFields` picks the legacy entry field (target-dependent default `["browser", "module", "main"]` for web, `["module", "main"]` for node), `resolve.conditionNames` selects `exports`/`imports` conditions from a dynamically-composed default (`["webpack", <mode>, <target>]` plus per-dependency `import`/`require`/`module-sync`/`module`), and `resolve.exportsFields`/`importsFields`/`aliasFields` name which manifest fields drive `exports`, `imports`, and `browser` substitution.

Webpack resolves a bare package import (`import * as D3 from 'd3'`) by consulting several `package.json` fields, each governed by a `resolve.*` option that names which fields to read and in what order.

**`resolve.mainFields`** — the legacy entry chain, used when no `exports` entry matches. The default depends on `target`:

- `target` is `webworker`, `web`, or unspecified: `["browser", "module", "main"]`.
- any other target, including `node`: `["module", "main"]`.

The order is significant: the first field present in the manifest wins. So given `{ "browser": "build/upstream.js", "module": "index" }`, a web build resolves to the `browser` file (first in the list) while a node build resolves to the `module` file. `module` is a non-standard field bundlers prefer because an ESM build tree-shakes better.

**`resolve.conditionNames`** — the conditions webpack matches against a package's `exports`/`imports` map (Node's [conditional exports](https://nodejs.org/api/packages.html#conditional-exports)). The default is composed dynamically, not fixed:

- Base conditions always include `"webpack"` and `"production"`/`"development"` (from `mode`; `"production"` is used when mode is `"none"` or `"production"`).
- A target-specific condition is appended: `web` → `"browser"`, `node` → `"node"`, `webworker` → `"worker"`, `electron` → `"electron"`, `nwjs` → `"nwjs"`. With `target: "web"` and `mode: "production"` the base defaults to `["webpack", "production", "browser"]`.
- Per-dependency-type conditions are layered via `resolve.byDependency`, with `"..."` inheriting the base list: ESM/wasm/loader-imports get `["import", "module-sync", "module", "..."]`; `commonjs`/amd/loader/unknown get `["require", "module-sync", "module", "..."]`; workers prepend `"worker"`; `css-import` uses `["webpack", <mode>, "style"]`. (`"module-sync"` was added in 5.107.0 to align with Node's synchronously-loadable-ESM community condition, so packages publishing a `module-sync` export are picked up without extra config.) `resolveLoader` uses different defaults: `["loader", "require", "node"]`.

Setting `conditionNames` explicitly replaces the default; the `"..."` token can be placed first or last to prepend or append a custom condition to the computed base.

**`resolve.exportsFields`** (`["exports"]` by default) and **`resolve.importsFields`** name which manifest fields hold the exports/imports maps — settable to read a company-private field name such as `"myCompanyExports"`. **`resolve.aliasFields`** (`["browser"]` by default) and the historical `browser`-in-`mainFields` handling drive the `browser` field's per-module replacement map.

Source: [src/content/configuration/resolve.mdx](https://github.com/webpack/webpack.js.org/blob/c0038eb5eb2040d8abbb0f1a8d9882c202d1135a/src/content/configuration/resolve.mdx) at commit `c0038eb`.
