---
title: The packageManager field and Corepack
source: README.md
source_repo: nodejs/corepack
source_commit: 05bc5f3df188f135e0924207f378dfa89afc55bf
source_date: 2026-05-15
source_authors: [Antoine du Hamel, Frieder Bluemle, Jonathan Netley, Leonardo Rocha]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Corepack is a zero-runtime-dependency Node.js script that bridges Node projects to the package managers they are meant to be used with — in practice, letting you use Yarn, npm, and pnpm without installing them. It reads the `packageManager` field of `package.json` to know which manager (and exact version) a project expects, intercepts `yarn`/`pnpm`/`npm` calls, downloads and caches the pinned version, and refuses to run a different manager against a project pinned to another. The `packageManager` value is `name@x.y.z` (required) optionally with `+sha224.<hash>` for validation; permitted names are `yarn`, `npm`, and `pnpm`, or a URL to a `.js` (CommonJS module) or `.tgz` (whose `bin` field selects the entry). Corepack also honors `devEngines.packageManager` — which, unlike `packageManager`, may carry a version *range* and an `onFail` policy (`ignore`/`error`/`warn`) — as both a validator and a fallback when the top-level `packageManager` field is absent. Corepack shipped with Node from 14.19.0 up to (not including) 25.0.0; `corepack enable` installs the Yarn/pnpm shims on PATH.

## What Corepack is

Corepack "lets you use Yarn, npm, and pnpm without having to install them." You run your package managers as usual (`yarn install`, `pnpm install`, `npm`); Corepack catches the call and:

- if the project is configured for the manager you invoked, downloads and caches the latest compatible version;
- if the project is configured for a *different* manager, asks you to rerun with the right one (avoiding corrupted install artifacts);
- if the project is configured for no manager, uses the pinned "Known Good Release."

## Authoring: the packageManager field

Set the project's manager with `packageManager` in `package.json`:

```json
{
  "packageManager": "yarn@3.2.3+sha224.953c8233f7a92884eee2de69a1b92d1f2ec1655e66d08071ba9a02fa"
}
```

`name` is the manager, at a version, with an optional SHA-224 hash for validation. `packageManager@x.y.z` (an exact version) is **required**; the hash is optional but strongly recommended as a security practice. Permitted names: `yarn`, `npm`, `pnpm`. The value may instead be a URL to a `.js` file (interpreted as a CommonJS module) or a `.tgz` (interpreted as a package whose `bin` field picks the file):

```json
{ "packageManager": "yarn@https://registry.npmjs.org/@yarnpkg/cli-dist/-/cli-dist-3.2.3.tgz#sha224.16a0797d1710d1fb7ec40ab5c3801b68370a612a9b66ba117ad9924b" }
```

## devEngines.packageManager

When `devEngines.packageManager` is an object with a `"name"` (optionally `version` and `onFail`), Corepack uses it to validate you are using a compatible manager. Per `onFail`: `ignore` (no output), unset or `error` (throw on mismatch), `warn`/other (warn on mismatch). If the top-level `packageManager` field is **missing**, Corepack falls back to `devEngines.packageManager` — in which case you must give a specific `version` (ideally with a hash). Unlike the exact-version `packageManager`, `devEngines.packageManager` may express a version range.

## Known Good Releases and install

In a project that lists no supported manager, Corepack uses a set of "Known Good Releases"; with none for the requested manager, it looks up the latest on the npm registry and caches it. `corepack enable` installs the Yarn/pnpm binaries on PATH; `corepack install -g` updates the Known Good Releases system-wide. Corepack was distributed with Node.js from 14.19.0 up to (but not including) 25.0.0.

Source: [README.md](https://github.com/nodejs/corepack/blob/05bc5f3df188f135e0924207f378dfa89afc55bf/README.md) at commit `05bc5f3`.
