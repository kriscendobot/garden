---
title: Environment constraints and publishing (engines, os, cpu, libc, devEngines, private, publishConfig, workspaces)
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

Abstract: npm's reference for the fields that constrain the runtime environment and govern publishing. `engines` declares compatible `node`/`npm` versions and is advisory (warnings only) unless `engine-strict` is set. `os`, `cpu`, and `libc` restrict install to platforms (allowlist plus `!`-prefixed blocklist; determined by `process.platform`/`process.arch`; `libc` applies only when `os` is `linux`) - the mechanism behind per-platform prebuilt-binary sub-packages. `devEngines` (distinct shape from `engines`) checks the developer's tooling before `install`/`ci`/`run`, supporting `cpu`/`os`/`libc`/`runtime`/`packageManager` keys each with `name`/`version`/`onFail` (`warn`/`error`/`ignore`). `private: true` makes npm refuse to publish. `publishConfig` overrides config values at publish time (tag, registry, access). `workspaces` is an array of paths/globs naming local workspace folders symlinked into the top-level `node_modules`. This is the reference for the environment-and-publishing column of the property matrix and the platform-specific-packages strategy.

## engines

`engines` declares the node versions your package works on, for example `{ "node": ">=0.10.3 <15" }`; an unspecified or `"*"` version accepts any. It can also constrain npm (`{ "npm": "~1.0.20" }`). Unless the user sets the `engine-strict` config, this is advisory only and produces warnings when the package is installed as a dependency.

## os, cpu, libc

`os` restricts the operating systems the module runs on (for example `["darwin", "linux"]`), and can block with a `!` prefix (`["!win32"]`); the host OS is `process.platform`. Blocking and allowing the same item is permitted but pointless. `cpu` restricts CPU architectures the same way (`["x64", "ia32"]` or `["!arm", "!mips"]`); the host architecture is `process.arch`. `libc` restricts which libc the code runs or builds against and applies only when `os` is `linux` (for example `{ "os": "linux", "libc": "glibc" }`).

## devEngines

`devEngines` helps engineers on a codebase share tooling; it runs before `install`, `ci`, and `run`. It differs from `engines` in object shape and function: `engines` alerts when a dependency uses a different npm/node version than the consuming project, while `devEngines` alerts people interacting with the source. Supported keys: `cpu`, `os`, `libc`, `runtime`, `packageManager`, each an object or array of objects that must contain `name` and optionally `version` and `onFail` (`warn`/`error`/`ignore`, default `error`). npm assumes you are running with `node`; setting `runtime.name` or `packageManager.name` to another string fails within the npm CLI.

## private, publishConfig

`"private": true` makes npm refuse to publish, preventing accidental publication. `publishConfig` is a set of config values used at publish time, handy for setting `tag`, `registry`, or `access` (for example to keep a scoped module private, publish to an internal registry, or avoid tagging `latest`).

## workspaces

`workspaces` is an array of file patterns naming locations in the local filesystem the install client looks up to find each workspace to symlink into the top-level `node_modules`. It can name direct folder paths or globs that resolve to them; for example `["./packages/*"]` treats every folder with a valid `package.json` under `./packages` as a workspace.

Source: [docs/lib/content/configuring-npm/package-json.md](https://github.com/npm/cli/blob/ce7681fe7dbcc20abb5f1379558e14ddd069654f/docs/lib/content/configuring-npm/package-json.md) at commit `ce7681f`.
