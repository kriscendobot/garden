---
title: overrides (pnpm's dependency override dialect, in pnpm-workspace.yaml)
source: docs/settings.md
source_repo: pnpm/pnpm.io
source_commit: 0cf4bd35393b8d3712debd5a301bcdf2163d5b69
source_date: 2026-06-24
source_authors: [Zoltan Kochan, Dasa Paddock, Igal Klebanov, Ilya Priven]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: pnpm's `overrides` field — its dialect of the transitive-dependency override, and since pnpm v11 configured in **`pnpm-workspace.yaml`**, not the `pnpm` block of `package.json`. It instructs pnpm to override any dependency in the graph (including peer dependencies): enforce a single version, backport a fix, replace a dependency with a fork, or remove an unused dependency. Selectors support a bare package name, a name+range (`bar@^2.1.0`), and a parent-scoped `parent>dep` form (`qar@1>zoo` overrides `zoo` only under `qar@1`). Values may be a version/range, an `npm:` alias, a `catalog:` reference (to keep the override in sync with a catalog-defined version), or `-` to remove the dependency entirely (especially useful for skippable `optionalDependencies`). `overrides` is **root-only**. This is the reference for the pnpm cell of the override-dialects row in the property-consumer matrix.

## The `overrides` field

`overrides` (in `pnpm-workspace.yaml`) instructs pnpm to override any dependency in the dependency graph, including peer dependencies — useful for enforcing a single version, backporting a fix, replacing a dependency with a fork, or removing an unused dependency. It **can only be set at the root of the project**.

```yaml
overrides:
  "foo": "^1.0.0"
  "quux": "npm:@myorg/quux@^1.0.0"
  "bar@^2.1.0": "3.0.0"
  "qar@1>zoo": "2"
```

Selector forms:

- Bare name (`foo`) — override every occurrence.
- Name + range (`bar@^2.1.0`) — override only matching versions.
- **Parent-scoped** (`parent>dep`) — separate the package the overridden dependency belongs to from the dependency selector with `>`; `qar@1>zoo` overrides the `zoo` dependency of `qar@1` only, not `zoo` under any other parent.

**Catalog sync.** To keep an overridden version in sync with the version used elsewhere in the workspace, define it in a [catalog](https://pnpm.io/catalogs) and reference it with `catalog:`:

```yaml
catalog:
  foo: "^1.0.0"
overrides:
  foo: "catalog:"
```

**Removal.** Use `-` to remove a dependency you do not need (`"foo@1.0.0>bar": "-"`), which can cut install time; especially useful with `optionalDependencies`, most of which can be safely skipped.

## Overriding peer dependencies

Overrides also apply to `peerDependencies`, with behavior depending on the specifier type:

- **Semver ranges** (`^1.0.0`), **workspace**, and **catalog** protocols: the peer is overridden and **remains a peer dependency**.
- **Non-range specifiers** (`link:`, `file:`): the peer is overridden and **moved to `dependencies`**, since these are not valid peer ranges.
- **Removal** (`-`): the peer is removed entirely.

For example, `overrides: { "react-dom>react": "18.1.0" }` overrides the `react` peer of `react-dom`.

Source: [docs/settings.md](https://github.com/pnpm/pnpm.io/blob/0cf4bd35393b8d3712debd5a301bcdf2163d5b69/docs/settings.md) at commit `0cf4bd3`.
