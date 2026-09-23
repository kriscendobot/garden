---
title: Package maps (experimental resolution without node_modules)
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

Abstract: Package maps (added v26.4.0, Stability 1 Experimental, behind `--experimental-package-map`) are a JSON configuration that controls how bare specifiers resolve without relying on the `node_modules` folder structure. A `packages` object maps each package ID to a `url` (file-protocol only) and a `dependencies` object that maps bare specifiers to other package IDs. The resolver runs without inspecting the filesystem, which enables monorepo dependency isolation (no phantom dependencies), explicit workspace edges without symlinks or hoisting, and multiple versions of the same dependency selected per importing package. Because two package IDs may share one `url`, consumers must key module instances by both module URL and package ID and propagate the originating package ID through resolution, or Node throws rather than guess. Package maps only affect non-builtin bare specifiers; relative/absolute paths and `node:` builtins use standard resolution.

## What package maps do

Package maps provide a mechanism to control package resolution without relying on the `node_modules` folder structure. Enabled via `--experimental-package-map`, Node uses a JSON configuration file to determine how bare specifiers resolve. Useful for: monorepos (explicit workspace dependency edges without symlinks or hoisting), dependency isolation (preventing access to undeclared / phantom dependencies), and low filesystem coupling (resolution runs on static data tables without touching the filesystem).

## Configuration file format

The file has a `packages` object; each key is a package ID. Each entry has:

- `url` (required): an absolute or relative `file:`-protocol URL parsed with the WHATWG URL API against the config file URL. Multiple packages may share the same URL; consumers must key module instances by both module URL and package IDs.
- `dependencies` (object): maps bare specifiers (the import names in source) to package keys in `packages`. Defaults to empty.

## Resolution algorithm

On a bare specifier: Node determines which package performs the request (from the importer file's package ID, if provided, else by locating the file within a mapped package's `url`). If no package ID is available and the file is outside any mapped package, `ERR_PACKAGE_MAP_EXTERNAL_FILE` is thrown. Node looks up the specifier's package name in the importing package's `dependencies` to find the target package key, locates that package's `url`, and forwards to the regular Node resolution algorithm (`index.js`, exports field, and so on). A specifier not in `dependencies` throws `MODULE_NOT_FOUND`.

## Multiple versions and shared URLs

Because `dependencies` maps specifiers to package keys, two packages can map the same specifier to different targets, so different parts of the tree can depend on different versions of the same package. Multiple package entries may also share one `url` (to address complex hoisting); resolving a bare specifier from a file within that URL is ambiguous unless the originating package ID is known. Implementers must key module instances by package ID and propagate it from each resolution result to subsequent requests, so the runtime knows which dependency version to select.

## Limitations

The map must be a single static file (no dynamic configuration); circular dependency detection is not performed; the file is loaded synchronously at startup.

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
