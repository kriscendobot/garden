---
title: Bun package exports and legacy entry points
source: docs/runtime/module-resolution.mdx
source_repo: oven-sh/bun
source_commit: 6352b790f21c6272daad967387f1e0dded3b659d
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Bun uses Node-style package lookup, then chooses the first matching `exports` condition in manifest order. Its runtime adds `bun`, supports `imports`, and falls back to `main` before `module` when exports is absent.

After locating a package in `node_modules`, Bun reads its `package.json`. It evaluates the `exports` map in object order, recognizing `bun`, `node-addons` unless disabled, `node`, `require` or `import` according to the importer, and `default`. It honors subpath `exports` and `imports`; as in Node, declaring an exports map encapsulates unlisted package subpaths. The `bun` condition may point at untranspiled TypeScript, which Bun executes directly.

Without `exports`, Bun uses legacy entry fields: it prefers `main`, or an implicit `index.*`, and then `module`. Both `bun build` and the runtime accept extra `--conditions`, so a package's chosen branch is configurable. This source does not document Bun's package-manager fields such as `trustedDependencies`; that synthesis remains for the package-manager follow-on.

Source: [docs/runtime/module-resolution.mdx](https://github.com/oven-sh/bun/blob/6352b790f21c6272daad967387f1e0dded3b659d/docs/runtime/module-resolution.mdx) at commit `6352b79`.
