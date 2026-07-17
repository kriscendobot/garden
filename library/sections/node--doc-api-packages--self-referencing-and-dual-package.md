---
title: Self-referencing a package and the dual CommonJS/ES module hazard
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

Abstract: Within a package, modules can reference the package's own `"exports"` by the package's `"name"` (self-referencing), which respects the same `"exports"` restrictions as an external consumer: importing a subpath the `"exports"` field does not list fails at runtime. Self-referencing works with `import` and `require`, in ES and CommonJS modules, and with scoped names. The dual CommonJS/ES module packages section is a short pointer in this Node doc (deferred to the package-examples repository) but names the core hazard that the `"import"`/`"require"` conditions create: shipping a package as both formats can produce two distinct module instances of the same package in one process, so state and instanceof checks silently break.

## Self-referencing a package using its name

Within a package, the values in the package's `"exports"` can be referenced via the package's own `"name"`. Given:

```json
{ "name": "a-package", "exports": { ".": "./index.mjs", "./foo.js": "./foo.js" } }
```

any module in that package can `import { something } from 'a-package'` (loads `./index.mjs`). Self-referencing is available only if `package.json` has `"exports"`, and only allows importing what `"exports"` permits: `import { another } from 'a-package/m.mjs'` fails because the field does not export `./m.mjs`. Self-referencing works with `require` too, in both ESM and CommonJS, and with scoped packages (`@my/package`).

## Dual CommonJS/ES module packages (the hazard)

The Node doc's "Dual CommonJS/ES module packages" section defers details to the package examples repository, but the hazard is created by the `"import"` and `"require"` conditions covered under conditional exports: when a single package ships both a CommonJS build (selected by `"require"`) and an ESM build (selected by `"import"`), a process that reaches the package through both paths loads two separate module instances. Any package-level state (caches, registries, singletons) then exists twice, and `instanceof` checks against a class exported from one instance fail for objects created by the other. Mitigations include isolating stateful internals in a single CommonJS module that both builds wrap, or shipping ESM-only with a `"require"`-loadable synchronous entry via `module-sync`. See the package examples repository for worked patterns.

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
