---
title: Node.js package.json field definitions (name, main, type, exports, imports)
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

Abstract: The exact set of `package.json` fields the Node.js runtime itself reads, as opposed to the far larger set that package managers such as npm consume and Node ignores. Node uses only five: `"name"` (relevant to named imports / self-referencing, and used by package managers as the package name), `"main"` (the default module when `"exports"` is absent, and for `require()` of a package directory), `"type"` (whether `.js` is CommonJS or ESM), `"exports"` (entry points and conditional exports, encapsulating unlisted submodules), and `"imports"` (private `#`-prefixed subpath imports for the package's own modules). This is the authoritative boundary between runtime-honored fields and package-manager metadata.

The Node doc states plainly: "This section describes the fields used by the Node.js runtime. Other tools (such as npm) use additional fields which are ignored by Node.js and not documented here." The runtime-honored fields:

- **`"name"`** {string}: relevant when using named imports within a package, and used by package managers as the name of the package. Can combine with `"exports"` to self-reference a package by its name. Publishing to npm requires a name satisfying npm's naming rules.
- **`"main"`** {string}: the entry point when a package is imported by name via a `node_modules` lookup; its value is a path. `"exports"`, if present, takes precedence over `"main"` when importing by name. `"main"` also defines the script used when a package directory is loaded via `require()` (folders-as-modules, so `require('./path/to/directory')` resolves to that directory's `main`, defaulting under CommonJS folder rules).
- **`"type"`** {string}: the module format Node uses for all `.js` files whose nearest parent `package.json` this is. `"module"` makes `.js` files ES modules; absent or `"commonjs"` makes them CommonJS; volume root with no `package.json` means CommonJS. `.mjs` is always ESM and `.cjs` is always CommonJS regardless of `"type"`.
- **`"exports"`** {Object|string|string[]}: defines the entry points of a package imported by name (via `node_modules` lookup or self-reference). Supported Node 12+ as an alternative to `"main"` that supports subpath exports and conditional exports while encapsulating internal unexported modules. All paths must be relative file URLs starting with `./`.
- **`"imports"`** {Object}: entries must be strings starting with `#`. Package imports may map to external packages. Defines subpath imports for the current package.

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
