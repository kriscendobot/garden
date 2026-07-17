---
id: dependency-overrides
aliases: [overrides, resolutions, pnpm.overrides, packageExtensions, dependency resolution override, force dependency version, replace transitive dependency, nested override]
topics: [package-manifest, node-packaging]
---

# dependency-overrides

The root-only `package.json` fields a project uses to override how its dependency tree resolves, forcing a specific version or replacement of a transitive dependency it does not directly declare. npm calls this `overrides`; Yarn calls the equivalent `resolutions`; pnpm uses `pnpm.overrides` (in the `pnpm` block). All three are honored only in the root/workspace-root manifest and ignored in installed dependencies. npm's `overrides` supports short (`{ "foo": "1.0.0" }`) and nested-selector forms, version-scoped parent keys (`"bar@2.0.0"`), and `$name` references to a direct dependency's spec; replacements may be `npm:`, `github:`, or `file:` specifiers. A distinct, complementary field, `packageExtensions` (npm and pnpm both have it; Yarn Berry originated it), does not change what an edge resolves to but **adds or corrects the dependency metadata that creates the edge** (missing `dependencies`/`peerDependencies` in a third-party manifest), which matters under strict/isolated layouts where a package sees only what it declared. The three override dialects have subtly different matching and merge semantics, a frequent porting hazard when moving a project between package managers.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [npm--configuring-npm-package-json--dependencies-and-overrides](../sections/npm--configuring-npm-package-json--dependencies-and-overrides.md) | npm's `overrides` (nested selectors, `$name` refs, replacements) and `packageExtensions` (add/correct dependency metadata), both root-only. |
| [yarn-berry--manifest-schema--resolutions](../sections/yarn-berry--manifest-schema--resolutions.md) | Yarn's `resolutions` dialect: flat glob-path selectors, one level of specificity, root-only. |
| [pnpm--settings--overrides](../sections/pnpm--settings--overrides.md) | pnpm's `overrides` (in pnpm-workspace.yaml since v11): parent>dep selectors, catalog refs, `-` removal, applies to peers. |
| [pnpm--settings--package-extensions-and-peer-rules](../sections/pnpm--settings--package-extensions-and-peer-rules.md) | pnpm's `packageExtensions` (add/correct metadata) and `peerDependencyRules`, the complement to overrides. |
| [bun--overrides--overview](../sections/bun--overrides--overview.md) | Bun reads both npm `overrides` and Yarn `resolutions`, top-level only (no nested selectors). |
| [yarn-berry--manifest-schema--dependency-metadata](../sections/yarn-berry--manifest-schema--dependency-metadata.md) | Yarn's `dependenciesMeta`/peer-with-default extensions that also reshape resolution. |

## See also

- [[subpath-exports]] - a package's own public surface, versus overrides which reshape its dependencies' resolution.

## Common confusions

- **pnpm's override block moved out of `package.json` in v11.** Earlier docs (and this page's abstract) describe pnpm's dialect as `pnpm.overrides` under a `pnpm` block in `package.json`. Since **pnpm v11**, pnpm no longer reads settings from the `pnpm` manifest field; `overrides`, `packageExtensions`, `peerDependencyRules`, and `patchedDependencies` live in **`pnpm-workspace.yaml`** at the root instead (see [pnpm--settings--overrides](../sections/pnpm--settings--overrides.md) and [pnpm--package-json--pnpm-field-moved-and-engines](../sections/pnpm--package-json--pnpm-field-moved-and-engines.md)).
- **Bun's overrides are top-level only.** Bun reads npm `overrides` and Yarn `resolutions` but supports neither's nested/parent-scoped selectors — a project relying on npm nested overrides will not port cleanly to Bun.
