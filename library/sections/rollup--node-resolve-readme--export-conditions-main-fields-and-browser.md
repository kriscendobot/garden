---
title: exportConditions, mainFields, and the browser option
source: packages/node-resolve/README.md
source_repo: rollup/plugins
source_commit: d455fff64e1ae418d69e1ac1b6f0e13bc23c70db
source_date: 2025-03-11
source_authors: [rollup plugins contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: `@rollup/plugin-node-resolve` gives Rollup Node-style `package.json` resolution. It honors `exports`/`imports` entry points by default, matching a base condition set of `['default', 'module', 'import', 'development|production']` for imports (and `['default', 'module', 'require']` for CommonJS requires when paired with `@rollup/plugin-commonjs` v16+); `exportConditions` adds conditions on top; `mainFields` (default `['module', 'main']`) is the legacy fallback used only when no `exports` field is present; the `browser` option activates `browser`-field/condition resolution.

Rollup does not read `package.json` on its own; `@rollup/plugin-node-resolve` supplies that behavior. It supports the Node package-entrypoints feature (`exports`/`imports`) by default; only in the *absence* of those fields does it fall back to `mainFields`.

**`exportConditions`** (default `[]`) — additional `exports` conditions to match. The plugin's built-in base condition set when resolving imports is `['default', 'module', 'import', 'development|production']`: if neither `development` nor `production` is provided it defaults to `production`, or `development` when `NODE_ENV` is set to a non-`production` value. When used with `@rollup/plugin-commonjs` v16+, require-statement resolution uses `['default', 'module', 'require']` instead. Setting `exportConditions` *adds* conditions on top of these defaults; to obtain Node's own resolution behavior, set it to `['node']`.

**`mainFields`** (default `['module', 'main']`; valid values `['browser', 'jsnext:main', 'module', 'main']`) — the legacy entry fields scanned in order, first-found wins, used to pick the bundle entry point. Including `'browser'` makes the plugin apply the `package.json` `browser` field's key/value replacements.

**`browser`** (default `false`) — when `true`, the plugin uses browser module resolutions and adds `'browser'` to `exportConditions` if absent, so `browser` conditionals inside `exports` apply; when `false`, `browser` properties are ignored. This option takes precedence over `mainFields`, but does **not** work when the package uses `exports` entrypoints. Related resolution controls: `preferBuiltins` (prefer Node built-ins over local files of the same name), `modulesOnly` (require ESM), `dedupe`, and `ignoreSideEffectsForRoot`.

Source: [packages/node-resolve/README.md](https://github.com/rollup/plugins/blob/d455fff64e1ae418d69e1ac1b6f0e13bc23c70db/packages/node-resolve/README.md) at commit `d455fff`.
