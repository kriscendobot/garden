---
title: Conditions
source: packages/bundle-source/README.md
source_repo: endojs/endo
source_commit: 1af1999ec5a7b77f39a1044073ed545ff526c90b
source_date: 2025-08-02
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling]
status: current
---

> Abstract: Package.json export conditions: how bundle-source resolves which file to bundle for a given package based on conditions (default, node, browser, import, require, etc.).

## Conditions

Node.js introduced [conditions](https://nodejs.org/api/packages.html#conditional-exports).
The `--condition`/`-C` option accordingly influences `bundle-source` module
resolution decisions.

The "browser" condition additionally implies the selection of the `browser`
entry instead of `main` in `package.json`, if not overridden by explicit
`exports`.

The "development" condition additionally implies that the bundle may import
`devDependencies` from the package containing the entry module.


Source: [packages/bundle-source/README.md](https://github.com/endojs/endo/blob/1af1999ec5a7b77f39a1044073ed545ff526c90b/packages/bundle-source/README.md) at commit `1af1999e`.
