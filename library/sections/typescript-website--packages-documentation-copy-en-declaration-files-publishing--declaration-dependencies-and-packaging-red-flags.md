---
title: Declaration dependencies and packaging red flags
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

> Abstract: A library whose public declarations expose another package's types must publish that declaration dependency in `dependencies`, rather than copying its declarations or hiding it in `devDependencies`; use `/// <reference types="…" />`, not filesystem-relative triple-slash paths.

All package dependencies are managed through npm. If a library's declaration surface exposes a dependency's declarations, consumers must receive that dependency too, so it belongs in `dependencies`; `devDependencies` is suitable only when consumers do not need it, such as for a command-line application. Keep dependent declarations in their own package: do not combine or copy them into this package. Where a referenced library does not ship types, depend on its `@types` package. For triple-slash directives, name the package with `/// <reference types="…" />` rather than hard-coding a relative declaration path.

Source: [packages/documentation/copy/en/declaration-files/Publishing.md](https://github.com/microsoft/TypeScript-Website/blob/c8170c35bda4811c9516cbb69c39241ae4beb6d9/packages/documentation/copy/en/declaration-files/Publishing.md) at commit `c8170c35`.
