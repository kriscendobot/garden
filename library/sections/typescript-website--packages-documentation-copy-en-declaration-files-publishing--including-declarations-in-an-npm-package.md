---
title: Including declarations in an npm package
source: packages/documentation/copy/en/declaration-files/Publishing.md
source_repo: microsoft/TypeScript-Website
source_commit: c8170c35bda4811c9516cbb69c39241ae4beb6d9
source_date: 2026-07-06
source_authors: [typescript-automation[bot]]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, typescript-conventions]
status: current
---

> Abstract: A typed npm package points `package.json` `types` at its bundled root declaration file; `typings` is the synonymous legacy spelling. Generated declarations belong with the source package, while hand-authored declarations without source types belong on DefinitelyTyped.

If a package has a JavaScript main file, its manifest should declare the corresponding root declaration file, for example `"main": "./lib/main.js"` paired with `"types": "./lib/main.d.ts"`. `typings` means the same thing, but `types` is the current spelling. Both TypeScript and JavaScript projects can generate declarations with the compiler's `declaration` option. When types are generated from source, publish them with that source; otherwise, submit a declaration package to DefinitelyTyped for publication under `@types`.

Source: [packages/documentation/copy/en/declaration-files/Publishing.md](https://github.com/microsoft/TypeScript-Website/blob/c8170c35bda4811c9516cbb69c39241ae4beb6d9/packages/documentation/copy/en/declaration-files/Publishing.md) at commit `c8170c35`.
