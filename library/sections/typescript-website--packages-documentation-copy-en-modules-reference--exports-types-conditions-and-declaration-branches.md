---
title: exports types conditions and declaration branches
source: packages/documentation/copy/en/modules-reference/Reference.md
source_repo: microsoft/TypeScript-Website
source_commit: c8170c35bda4811c9516cbb69c39241ae4beb6d9
source_date: 2026-07-06
source_authors: [typescript-automation[bot]]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, typescript-conventions]
status: current
---

> Abstract: In `node16`, `nodenext`, and `bundler` resolution, TypeScript reads package `exports`, always matches `types` and `default`, and follows the runtime's `import` or `require` branch; each dual-runtime branch must therefore put its own `types` condition before its runtime `default` target.

With `resolvePackageJsonExports` enabled, the modern resolution modes follow Node's `exports` structure but perform declaration-oriented extension substitution after a target is selected. `types` and `default` are always eligible conditions; a versioned `types@{selector}` condition follows the same matching rules as `typesVersions`, and `customConditions` adds configured conditions. The presence of `exports` also blocks unlisted subpaths.

For a dual ESM/CJS subpath, nest declarations under both runtime branches, with `types` before `default`, so the declaration extension follows the selected implementation format:

```json
{
  "exports": {
    "./subpath": {
      "import": {
        "types": "./types/subpath/index.d.mts",
        "default": "./es/subpath/index.mjs"
      },
      "require": {
        "types": "./types/subpath/index.d.cts",
        "default": "./cjs/subpath/index.cjs"
      }
    }
  }
}
```

The ordering is material: conditions are inspected in object order. A top-level `types` branch cannot express separate ESM and CJS declaration formats; putting each `types` branch first inside its corresponding `import` or `require` branch preserves the runtime-to-types pairing.

Source: [packages/documentation/copy/en/modules-reference/Reference.md](https://github.com/microsoft/TypeScript-Website/blob/c8170c35bda4811c9516cbb69c39241ae4beb6d9/packages/documentation/copy/en/modules-reference/Reference.md) at commit `c8170c35`.
