---
source_kind: repo-doc
source_repo: nodejs/node
source_path: doc/api/packages.md
source_commit: cc37ad592f347b7ff40c4629956f2278d3ec3451
source_date: 2026-06-23
source_authors: [Joyee Cheung, Geoffrey Booth, Antoine du Hamel]
ingested: 2026-07-17
ingested_by: scholar
section_count: 8
status: current
---

Abstract: The Node.js "Modules: Packages" reference (`doc/api/packages.md`), the authoritative specification for how the Node.js runtime reads `package.json`. It covers the two entry-point fields (`"main"` and `"exports"`) and the encapsulation `"exports"` imposes; how Node determines a file's module system from `"type"`, extension, `--input-type`, and syntax detection, and the divergent `require()` vs `import` resolution algorithms; subpath exports, `#`-prefixed subpath imports, and `*` subpath patterns; conditional exports (the fixed condition set, order significance, nested conditions, user `--conditions`, and the curated community conditions); self-referencing a package by name; the dual CommonJS/ES module hazard pointer; the experimental package-maps resolver that works without `node_modules`; and the exact five fields the runtime honors versus the metadata it ignores. This is the primary source for the runtime/module-system column of the package.json consumer matrix.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/node--doc-api-packages--overview.md) | package-manifest, module-loader | current |
| [determining-module-system](../sections/node--doc-api-packages--determining-module-system.md) | package-manifest, module-loader | current |
| [package-entry-points](../sections/node--doc-api-packages--package-entry-points.md) | package-manifest, module-loader | current |
| [subpath-exports-imports-and-patterns](../sections/node--doc-api-packages--subpath-exports-imports-and-patterns.md) | package-manifest, module-loader | current |
| [conditional-exports](../sections/node--doc-api-packages--conditional-exports.md) | package-manifest, module-loader | current |
| [self-referencing-and-dual-package](../sections/node--doc-api-packages--self-referencing-and-dual-package.md) | package-manifest, module-loader | current |
| [package-maps](../sections/node--doc-api-packages--package-maps.md) | package-manifest, module-loader | current |
| [field-definitions](../sections/node--doc-api-packages--field-definitions.md) | package-manifest, module-loader | current |

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
