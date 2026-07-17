---
title: Turbopack module resolution — aliases, extensions, and conditions
source_kind: web
source_url: https://nextjs.org/docs/app/api-reference/config/next-config-js/turbopack
source_content_sha256: 871ded2b10f23cf96ecb9c22e7579818f2c9811593ccf3c4b3594bca6c4ec49d
source_fetched_via: direct
source_date: 2026-02-13
source_authors: [Vercel]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Turbopack's user-facing resolution config, modeled on webpack's `resolve.*`, exposes `resolveAlias` (map imports to other modules, with Node-style conditional aliasing limited to the `browser` condition today) and `resolveExtensions` (default `['.mdx', '.tsx', '.ts', '.jsx', '.js', '.mjs', '.json']`, overwritten wholesale when set). Loader rules can be gated on built-in `condition`s (`browser`, `foreign`, `development`, `production`, `node`, `edge-light`), where `foreign` matches `node_modules`. The public reference does **not** enumerate a `package.json` `exports` condition set or a `mainFields` chain; Turbopack resolves `exports`/`imports`/`browser`/`module`/`main` in a webpack-compatible manner, but this reference does not spell out the precedence.

**`resolveAlias`** maps aliased imports to replacement modules, like webpack's `resolve.alias`:

```js
module.exports = {
  turbopack: {
    resolveAlias: {
      underscore: 'lodash',
      mocha: { browser: 'mocha/browser-entry.js' },
    },
  },
}
```

"Turbopack also supports conditional aliasing through this field, similar to Node.js' conditional exports. At the moment only the `browser` condition is supported." So `import 'mocha'` aliases to `mocha/browser-entry.js` when Turbopack targets browser environments.

**`resolveExtensions`** lists the extensions to try when importing files, like webpack's `resolve.extensions`:

```js
module.exports = {
  turbopack: {
    resolveExtensions: ['.mdx', '.tsx', '.ts', '.jsx', '.js', '.mjs', '.json'],
  },
}
```

"This overwrites the original resolve extensions with the provided list. Make sure to include the default extensions." — the array shown is the default.

**Loader-rule conditions.** `turbopack.rules` can restrict where a loader runs with a `condition`, using boolean operators (`all`/`any`/`not`) and customizable operators (`path`, `content`, `query`, `contentType`) plus built-in conditions:

- `browser` — code that runs on the client (`{not: 'browser'}` matches server code).
- `foreign` — code in `node_modules` (plus some Next.js internals); loaders are usually restricted to `{not: 'foreign'}`.
- `development` — under `next dev`; `production` — under `next build`.
- `node` — code on the default Node.js runtime; `edge-light` — code on the Edge runtime.

These conditions gate loader application, not `package.json` `exports` resolution.

**Resolution scope.** Turbopack uses the project root to resolve modules; files outside the project root are not resolved (the `root` option widens this for linked dependencies). The root is auto-detected from a lockfile (`pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`, `bun.lock`, `bun.lockb`).

**Negative finding.** This reference documents `resolveAlias`, `resolveExtensions`, `rules`/`condition`, `type`, `debugIds`, and `root`. It does **not** document a `package.json` `exports`/`imports` condition-name set or a `mainFields` legacy chain for Turbopack, so those remain unenumerated in the public reference (unlike webpack's explicit `resolve.conditionNames`/`resolve.mainFields`).

Source: [Next.js `turbopack` configuration](https://nextjs.org/docs/app/api-reference/config/next-config-js/turbopack) fetched 2026-07-17 (content sha256 `871ded2b`), sections *Options*, *Resolving aliases*, *Resolving custom extensions*, and *Advanced webpack loader conditions*.
