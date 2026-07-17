---
title: Scripts, config, and native-build fields (scripts, gypfile, config, default values)
source: docs/lib/content/configuring-npm/package-json.md
source_repo: npm/cli
source_commit: ce7681fe7dbcc20abb5f1379558e14ddd069654f
source_date: 2026-06-18
source_authors: [Max Black, Josh Soref, Michael Smith]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: npm's reference for the script-and-build fields. `scripts` is a dictionary keyed by lifecycle event; the value is the command run at that point. `config` holds parameters that persist across upgrades and surface to scripts as `npm_package_config_*` environment variables. `gypfile` controls node-gyp: a `binding.gyp` at the root with no custom `install`/`preinstall` makes npm build with node-gyp by default, and `"gypfile": false` opts out (for packages that ship prebuilt native addons or should not be built). npm also defaults some values from package contents: a root `server.js` sets `start` to `node server.js`; a root `binding.gyp` sets `install` to `node-gyp rebuild`; an `AUTHORS` file populates `contributors`.

## scripts

The `scripts` property is a dictionary of script commands run at various points in the package lifecycle; the key is the lifecycle event and the value is the command. (See the npm `scripts` documentation for writing package scripts.)

## config

A `config` object sets configuration parameters used in package scripts that persist across upgrades. For example, a package with `"config": { "port": "8080" }` can have a `start` script that references the `npm_package_config_port` environment variable.

## gypfile

If a `binding.gyp` file is at the package root and you have not defined your own `install` or `preinstall` scripts, npm defaults to building the module with node-gyp. To prevent that, set `"gypfile": false`. This is useful for packages that include native addons but handle the build differently, or that have a `binding.gyp` but should not be built as a native addon.

## DEFAULT VALUES

npm defaults some values based on package contents:

- If a `server.js` file is at the root, `start` defaults to `node server.js`.
- If a `binding.gyp` file is at the root and no `install`/`preinstall` is defined, `install` defaults to `node-gyp rebuild`.
- If an `AUTHORS` file is at the root, npm treats each line as `Name <email> (url)` (email and url optional) to populate `contributors`; lines starting with `#` or blank are ignored.

Source: [docs/lib/content/configuring-npm/package-json.md](https://github.com/npm/cli/blob/ce7681fe7dbcc20abb5f1379558e14ddd069654f/docs/lib/content/configuring-npm/package-json.md) at commit `ce7681f`.
