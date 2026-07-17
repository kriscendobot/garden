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

## See also

- [[subpath-exports]] - a package's own public surface, versus overrides which reshape its dependencies' resolution.
