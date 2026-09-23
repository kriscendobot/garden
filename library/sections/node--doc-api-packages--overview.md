---
title: Packages and entry points overview
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

Abstract: A package is a folder tree described by a `package.json` file: the folder holding the `package.json` and every subfolder up to the next `package.json` or a `node_modules` folder. Two fields define a package's entry points, `"main"` and `"exports"`, and both apply to CommonJS and ES module entry points alike. `"main"` is supported in every Node.js version but only names the single default entry; `"exports"` is the modern alternative that allows multiple entry points, conditional resolution per environment, and (crucially) encapsulation: once `"exports"` is present, any entry point not listed is forbidden, including `require('your-package/package.json')`. When both are present, `"exports"` takes precedence. Introducing `"exports"` on an existing package is likely a breaking change unless every previously reachable entry point is re-exported.

A package is a folder tree described by a `package.json` file. The package consists of the folder containing the `package.json` file and all subfolders until the next folder containing another `package.json` file, or a folder named `node_modules`.

## Two entry-point fields: `main` and `exports`

In a package's `package.json`, two fields can define entry points: `"main"` and `"exports"`. Both fields apply to both ES module and CommonJS module entry points.

- `"main"` is supported in all versions of Node.js, but its capabilities are limited: it only defines the single main entry point of the package.
- `"exports"` provides a modern alternative to `"main"`, allowing multiple entry points to be defined, conditional entry resolution support between environments, and **preventing any other entry points besides those defined in `"exports"`**. This encapsulation lets module authors clearly define the public interface for their package.

For new packages targeting currently supported Node.js versions, `"exports"` is recommended. For packages supporting Node.js 10 and below, `"main"` is required. If both `"exports"` and `"main"` are defined, `"exports"` takes precedence in supported versions.

## Encapsulation is a breaking change

Existing packages introducing `"exports"` will prevent consumers from using any entry point not defined, including the `package.json` itself (for example `require('your-package/package.json')`). This will likely be a breaking change. To make it non-breaking, ensure that every previously supported entry point is exported. A project that previously exposed `main`, `lib`, `feature`, and `package.json` can enumerate each, or use export patterns to expose whole folders both with and without extensioned subpaths, then restrict to specific features in a later major version.

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
