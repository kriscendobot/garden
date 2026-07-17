---
title: The sideEffects package.json flag
source: src/content/guides/tree-shaking.mdx
source_repo: webpack/webpack.js.org
source_commit: 6f1e6f26086d0c617444783754bfe178cd045ef0
source_date: 2026-06-25
source_authors: [webpack documentation contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: webpack's `"sideEffects"` `package.json` property tells the compiler which files in a package are "pure" and safe to prune when their exports go unused. `false` marks the whole package side-effect-free; an array of glob patterns names the files that DO have side effects (which must be preserved). `sideEffects` skips whole modules/subtrees and is more effective than `usedExports` tree shaking, which only prunes unused exports within a still-included module.

The `"sideEffects"` property, introduced in webpack 4, is a hint the package author gives the compiler about which files are "pure" — files whose only effect on import is exposing exports, with no observable behavior such as a polyfill mutating the global scope.

- `"sideEffects": false` declares that the whole package is free of import-time side effects, so webpack may safely drop any module whose exports are all unused.
- `"sideEffects": ["./src/some-side-effectful-file.js"]` names the files that *do* have side effects and must never be pruned. The array accepts simple glob patterns (`*`, `**`, `{a,b}`, `[a-z]`) via glob-to-regexp; a pattern without a `/`, such as `*.css`, is treated as `**/*.css`.

A practical trap: any imported file is subject to tree shaking, so a CSS file pulled in for its side effect (via `css-loader`) must be listed — otherwise production mode drops it. `"sideEffects"` can also be supplied through the `module.rules` configuration rather than the manifest.

`sideEffects` and `usedExports` (the classic "tree shaking") are distinct optimizations. `usedExports` removes unused *exports* within a module that is still bundled; `sideEffects` is far more effective because it lets webpack skip whole modules, files, and their complete import subtree.

Source: [src/content/guides/tree-shaking.mdx](https://github.com/webpack/webpack.js.org/blob/6f1e6f26086d0c617444783754bfe178cd045ef0/src/content/guides/tree-shaking.mdx) at commit `6f1e6f2`.
