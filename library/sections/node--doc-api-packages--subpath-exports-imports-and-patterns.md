---
title: Subpath imports and subpath patterns
source: doc/api/packages.md
source_repo: nodejs/node
source_commit: cc37ad592f347b7ff40c4629956f2278d3ec3451
source_date: 2026-06-23
source_authors: [Joyee Cheung, Geoffrey Booth, Antoine du Hamel]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, module-loader]
status: current
---

Abstract: The `"imports"` field creates private mappings that apply only to specifiers from within the package itself; every key must start with `#` to disambiguate from external package specifiers. Unlike `"exports"`, `"imports"` may map to external packages, which makes it the idiomatic way to give internal modules the benefits of conditional resolution (for example a `"#dep"` that resolves to a native package under the `node` condition and a polyfill elsewhere). Subpath patterns use a single `*` as a string-replacement wildcard on both sides of a mapping, so `"./features/*.js": "./src/features/*.js"` exposes a whole folder while keeping exports statically enumerable (the pattern expands as a `**` glob over package files, and `node_modules` targets are forbidden). A `null` target excludes a subtree from a pattern.

## Subpath imports (`"imports"`, `#`-prefixed)

In addition to `"exports"`, a package `"imports"` field creates private mappings that only apply to import specifiers from within the package itself. Entries must always start with `#` to disambiguate from external package specifiers. The imports field can give internal modules the benefits of conditional exports:

```json
{
  "imports": { "#dep": { "node": "dep-node-native", "default": "./dep-polyfill.js" } },
  "dependencies": { "dep-node-native": "^1.0.0" }
}
```

Here `import '#dep'` gets the external package `dep-node-native` under the `node` condition and the local `./dep-polyfill.js` in other environments. Unlike `"exports"`, the `"imports"` field permits mapping to external packages. Resolution rules are otherwise analogous to `"exports"`. (Since v25.4.0/v24.14.0 imports may also start with `#/`.)

## Subpath patterns (`*` wildcard)

For packages with many subpaths, listing each entry causes `package.json` bloat; subpath export patterns solve this:

```json
{
  "exports": { "./features/*.js": "./src/features/*.js" },
  "imports": { "#internal/*.js": "./src/internal/*.js" }
}
```

`*` is a string-replacement wildcard only: every `*` on the right-hand side is replaced with the matched value, including any `/` separators. It is a direct static match and replacement with no special extension handling; including `*.js` on both sides restricts the exposed exports to JS files. Exports remain statically enumerable, because the right-hand target pattern can be treated as a `**` glob against the package's own files, and `node_modules` targets are forbidden so expansion depends only on the package itself.

To exclude private subfolders from patterns, use `null` targets:

```json
{ "exports": { "./features/*.js": "./src/features/*.js", "./features/private-internal/*": null } }
```

A request into the excluded subtree throws `ERR_PACKAGE_PATH_NOT_EXPORTED`.

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
