---
title: bundler resolution
source: packages/documentation/copy/en/modules-reference/Reference.md
source_repo: microsoft/TypeScript-Website
source_commit: c8170c35bda4811c9516cbb69c39241ae4beb6d9
source_date: 2026-07-06
source_authors: [typescript-automation[bot]]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, typescript-conventions]
status: current
---

> Abstract: `moduleResolution: "bundler"` models a bundler that adopts package `exports`/`imports` while retaining CommonJS-like extensionless and directory lookup; it pairs with `module: "esnext"` or `"preserve"` and selects `import` or `require` conditions from source syntax.

Bundler resolution combines `node_modules` lookups, directory modules, and extensionless paths with modern package `exports` and `imports`. It accepts `paths`, `baseUrl`, `typesVersions`, package-relative paths when exports is absent, and both import/require condition branches, while always allowing extensionless relative paths. It must be paired with `module: "esnext"` or `"preserve"` and implies `allowSyntheticDefaultImports`.

Unlike `nodenext`, an ESM import under `esnext` or `preserve` stays an ESM import, so its package lookup selects the `import` condition. With `preserve`, a source file may use ESM imports and `import = require` together, and each resolves through its matching condition. This is appropriate when a bundler or TypeScript-first runtime processes raw TypeScript; libraries that publish `tsc` output should normally use Node-aware resolution so extensionless paths do not escape into code that fails in Node.

Source: [packages/documentation/copy/en/modules-reference/Reference.md](https://github.com/microsoft/TypeScript-Website/blob/c8170c35bda4811c9516cbb69c39241ae4beb6d9/packages/documentation/copy/en/modules-reference/Reference.md) at commit `c8170c35`.
