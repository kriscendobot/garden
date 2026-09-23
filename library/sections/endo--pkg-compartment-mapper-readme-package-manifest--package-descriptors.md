---
title: Endo package descriptors
source: packages/compartment-mapper/README.md#package-descriptors
source_repo: endojs/endo
source_commit: 46d4edf31714c1488ec1d95492cc1ae9643c1f9f
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, bundles, compartments]
status: current
---

> Abstract: Compartment-mapper builds one compartment per package descriptor and reads exactly `name`, `type`, `main`, `exports`, `browser`, `dependencies`, and `files`, with only `import`, `browser`, and `endo` export conditions.

An application and every reachable dependency need a `package.json`; the mapper relies on the package manager to arrange satisfactory dependency versions in parent `node_modules` directories. `main`, `browser`, and `exports` determine modules exposed to other compartments. The supported conditions are `import` (select ESM), `browser` (also uses `browser` rather than `main`), and `endo` (signals this mapper). If no `exports` branch applies to the root `"."`, `main` is the default.

The README explicitly leaves `imports` and wildcard patterns in `exports`/`imports` as future work. `files` describes vendable files and implicitly includes JavaScript extensions while excluding `node_modules`, but files globs are not yet collected into archives. Extensionless module specifiers try `.js`, then `index.js` in the matching directory.

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/46d4edf31714c1488ec1d95492cc1ae9643c1f9f/packages/compartment-mapper/README.md) at commit `46d4edf`.
