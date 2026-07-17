---
title: Bun overrides and resolutions
source: docs/pm/overrides.mdx
source_repo: oven-sh/bun
source_commit: 16a7269639d9093da7685fcf3edcea53431df0a7
source_date: 2026-06-30
source_authors: [Alistair Smith, Lydia Hallie, Michael H]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Bun supports npm's `"overrides"` and Yarn's `"resolutions"` in `package.json`, both specifying a version range for *metadependencies* (the dependencies of your dependencies). Bun reads `resolutions` as Yarn's alternative to `overrides` with similar syntax, to make migration from Yarn easier. The one notable divergence from npm: Bun supports **only top-level** overrides — not npm's nested overrides — and likewise not nested resolutions. Setting one is the mechanism for pinning a metadependency away from a vulnerable version.

## overrides and resolutions

By default Bun installs the latest version of all dependencies and metadependencies within each package's declared ranges. If a security vulnerability appears in a metadependency (say `bar@4.5.6`, pulled in by your dependency `foo`), you can pin it:

```json
{
  "name": "my-app",
  "dependencies": { "foo": "^2.0.0" },
  "overrides": { "bar": "~4.4.0" }
}
```

Bun then defers to the specified range when determining which version of `bar` to install, whether `bar` is a direct dependency or a metadependency.

`"resolutions"` is Yarn's alternative to `"overrides"`, with similar syntax; Bun supports it to make migration from Yarn easier:

```json
{
  "name": "my-app",
  "dependencies": { "foo": "^2.0.0" },
  "resolutions": { "bar": "~4.4.0" }
}
```

**Limitation:** Bun supports only top-level `"overrides"`, not [nested overrides](https://docs.npmjs.com/cli/v9/configuring-npm/package-json#overrides). As with `"overrides"`, nested `"resolutions"` are not supported. So Bun reads the same two dialects npm and Yarn each use, but at reduced expressiveness (no parent-scoped nesting).

Source: [docs/pm/overrides.mdx](https://github.com/oven-sh/bun/blob/16a7269639d9093da7685fcf3edcea53431df0a7/docs/pm/overrides.mdx) at commit `16a7269`.
