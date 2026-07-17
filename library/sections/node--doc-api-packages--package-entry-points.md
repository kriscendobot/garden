---
title: Package entry points and export target rules
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

Abstract: The mechanics of the `"exports"` main entry point: the sugar form (`"exports": "./index.js"`), the `"."` subpath, the encapsulation guarantee and its `ERR_PACKAGE_PATH_NOT_EXPORTED` error, and the validation rules Node enforces on export targets. Encapsulation is not strong: a direct `require('/abs/path/to/node_modules/pkg/subpath.js')` still loads the file, but a bare-specifier `require('pkg/subpath.js')` throws once `"exports"` is defined. Export targets must be relative URL strings starting with `./` (for security and encapsulation), must not traverse outside the package root, and must not contain `.`, `..`, or `node_modules` segments. For older-toolchain compatibility, an author may include `"main"` alongside `"exports"` pointing at the same module.

## Main entry point via `exports`

When writing a new package, use `"exports"`. When `"exports"` is defined, all subpaths of the package are encapsulated and no longer available to importers: `require('pkg/subpath.js')` throws `ERR_PACKAGE_PATH_NOT_EXPORTED`. This encapsulation gives more reliable guarantees about package interfaces for tools and across semver upgrades. It is not a strong encapsulation: a direct require of any absolute subpath such as `require('/path/to/node_modules/pkg/subpath.js')` still loads the file.

For projects on older Node.js or build tools, include `"main"` alongside `"exports"` pointing to the same module.

## Subpath exports and the `"."` sugar

Custom subpaths are defined by treating the main entry point as the `"."` subpath:

```json
{ "exports": { ".": "./index.js", "./submodule.js": "./src/submodule.js" } }
```

Only the defined subpaths can be imported; others error. If the `"."` export is the only export, the field can be written as its direct value (`"exports": "./index.js"`).

### Extensions in subpaths

Provide either extensioned (`import 'pkg/subpath.js'`) or extensionless (`import 'pkg/subpath'`) subpaths, so there is one canonical specifier per exported module. Extensionless masks the true file path; extensioned mirrors the mandatory-file-extension rule and keeps import maps compact via packages-folder mapping.

## Path rules and validation for export targets

Node enforces several rules on the values (targets) in the `"exports"` map:

- **Targets must be relative URLs** starting with `./`. Origin-relative (`/dist/main.js`), absolute (`file:///...`), and outside-package (`../common/util.js`) targets are rejected. This prevents exporting files outside the package's own directory (security) and keeps the package self-contained (encapsulation).
- **No path traversal or invalid segments.** Targets must not resolve outside the package root. Segments `.`, `..`, or `node_modules` (and URL-encoded equivalents) are disallowed after the initial `./`, both in a literal target and in any subpath substituted into a target pattern. Keys with such segments are also invalid.

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
