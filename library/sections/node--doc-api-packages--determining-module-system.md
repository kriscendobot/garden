---
title: Determining the module system (type, extensions, syntax detection)
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

Abstract: How Node.js decides whether a file is CommonJS or an ES module, driven by the nearest parent `package.json` `"type"` field, file extension, the `--input-type` flag, and (for ambiguous input) syntax detection. `.mjs` is always ESM and `.cjs` is always CommonJS regardless of `"type"`; a `.js` file is ESM only when the nearest parent `package.json` has `"type": "module"`, otherwise CommonJS. The `"type"` field applies not just to the entry file but to every `.js` referenced by `import`/`import()`. Syntax detection (stable-by-default since v22.7.0/v20.19.0) parses ambiguous `.js`/no-extension/string input and treats it as ESM if it contains ESM-only syntax. This section also captures the divergent resolution rules for `require()` versus `import`: `require` supports folders-as-modules and extension searching (`.js`, `.json`, `.node`) and forbids URL specifiers; `import`/`import()` requires fully specified paths, does no extension searching, and accepts `file:`/`data:` URLs.

## The `type` field and extensions

Within a package, the `"type"` field defines how Node.js interprets `.js` files that have that `package.json` as their nearest parent. Absent a `"type"` field, `.js` files are CommonJS. A value of `"module"` makes `.js` files ES modules. The nearest parent `package.json` is the first found searching the current folder, its parent, and so on up to a `node_modules` folder or the volume root.

The `"type"` field applies not only to the initial entry point (`node my-app.js`) but also to files referenced by `import` statements and `import()` expressions.

- Files ending `.mjs` are always ES modules regardless of the nearest `package.json`.
- Files ending `.cjs` are always CommonJS regardless of the nearest `package.json`.
- `.mjs`/`.cjs` let you mix types within one package: a `.cjs` file inside a `"type": "module"` package is CommonJS; an `.mjs` file inside a `"type": "commonjs"` package is ESM.

Package authors should always include the `"type"` field, even in all-CommonJS packages: being explicit future-proofs against a possible default change and helps build tools and loaders.

## Syntax detection

Since v21.1.0/v20.10.0 (enabled by default since v22.7.0/v20.19.0, Stability 1.2 release candidate), Node.js inspects the source of ambiguous input and treats it as an ES module if ESM syntax is detected. Ambiguous input is: `.js` or extensionless files with either no controlling `package.json` or one lacking a `type` field; and string input (`--eval`/STDIN) with no `--input-type`. ESM syntax is syntax that would throw when evaluated as CommonJS: `import` statements (but not `import()`), `export` statements, `import.meta`, top-level `await`, and lexical redeclaration of the CommonJS wrapper variables (`require`, `module`, `exports`, `__dirname`, `__filename`). Writing ESM syntax in ambiguous files incurs a performance cost, so being explicit is encouraged.

## The `--input-type` flag

Strings passed to `--eval` (`-e`) or piped via STDIN are ES modules when `--input-type=module` is set. `--input-type=commonjs` runs string input as CommonJS explicitly (the default when unspecified).

## `require()` versus `import`: two resolution algorithms

Node.js has two resolution and loading algorithms, chosen by how the module is requested.

`require()` (default in CommonJS, or via `createRequire()`): resolution supports folders-as-modules; if no exact match, it appends extensions (`.js`, `.json`, then `.node`) and tries folders-as-modules; it does not support URL specifiers by default. Loading: `.json` is JSON, `.node` is a compiled addon via `process.dlopen()`, `.ts`/`.mts`/`.cts` are TypeScript, anything else is JavaScript. `require()` can load an ES module from CommonJS only if the ES module and its dependencies are synchronous (no top-level await).

Static `import` / `import()`: resolution does not support folders-as-modules (directory indexes must be fully specified) and does no extension searching (a file extension must be provided for relative or absolute file URLs); it supports `file:` and `data:` URLs. Loading: JSON requires an import type attribute (`with { type: 'json' }`); `.node` needs `--experimental-addon-modules`; only `.js`, `.mjs`, `.cjs` are accepted for JavaScript; `.wasm` is a WebAssembly module; any other extension throws `ERR_UNKNOWN_FILE_EXTENSION` (extendable via customization hooks). `import`/`import()` can load CommonJS, with named exports available when statically analyzable.

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
