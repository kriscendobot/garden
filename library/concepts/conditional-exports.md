---
id: conditional-exports
aliases: [conditional exports, exports conditions, condition resolution order, import condition, require condition, types condition, browser condition, node condition, default condition, module-sync condition, node-addons condition, user conditions, --conditions, community conditions]
topics: [package-manifest, module-loader]
---

# conditional-exports

A `package.json` `"exports"` (or `"imports"`) mechanism that maps one specifier to different target files depending on named **conditions** that describe how and where the package is being loaded. Node.js implements a fixed set (`node-addons`, `node`, `import`, `require`, `module-sync`, `default`) and resolves them in **object key order**, most-specific first, so the first matching condition wins and `"default"` must come last. `"import"` and `"require"` are mutually exclusive and select by the load method rather than the target file's actual format, which is the root of the [[dual-package-hazard]]. Conditions nest like `if` statements, custom conditions are enabled at runtime with `--conditions=NAME`, and the Node docs additionally curate ecosystem-wide **community conditions** (`types` first, `browser`, `development`/`production` mutually exclusive) whose meaning is agreed but whose resolution each tool implements itself. Bundlers and other runtimes honor a superset/subset of Node's conditions and may resolve them in a different order, which is a common source of cross-tool divergence.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [node--doc-api-packages--conditional-exports](../sections/node--doc-api-packages--conditional-exports.md) | The fixed condition set, order significance, nested conditions, user `--conditions`, and the curated community conditions. |
| [node--doc-api-packages--subpath-exports-imports-and-patterns](../sections/node--doc-api-packages--subpath-exports-imports-and-patterns.md) | `"imports"` uses the same conditional resolution for internal `#`-prefixed specifiers and may map to external packages. |
| [node--doc-api-packages--self-referencing-and-dual-package](../sections/node--doc-api-packages--self-referencing-and-dual-package.md) | How the `import`/`require` conditions create the dual-package hazard. |

## See also

- [[dual-package-hazard]] - the failure mode the `import`/`require` conditions can produce.
- [[subpath-exports]] - the `"exports"` map that conditions are expressed within.
- [[package-type-field]] - `"type"` decides the format of the target a condition selects.
