---
title: typesVersions and legacy types fields
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

> Abstract: `typesVersions` supports compiler-version-specific declaration layouts in every resolution mode only when `exports` is not being read; outside that modern path, TypeScript chooses `types`, legacy `typings`, then `main` with declaration extension substitution.

`typesVersions` redirects declarations by compiler version and, for `node_modules` packages, by requested subpath. It enables newer declaration syntax alongside downlevel declarations, is recognized by every `moduleResolution` mode, and does not participate when `exports` is the active package-resolution mechanism. This makes `typesVersions` a legacy fallback mechanism, not a companion fallback for an `exports` package.

When `exports` is absent or not read for a package root, TypeScript tries `types`, then legacy `typings`, then `main`; if the first two are unavailable it substitutes declaration extensions around `main`. Authors should still include `types` even where extension substitution or `exports` would find declarations, because the npm registry uses that field to display its TypeScript marker.

Source: [packages/documentation/copy/en/modules-reference/Reference.md](https://github.com/microsoft/TypeScript-Website/blob/c8170c35bda4811c9516cbb69c39241ae4beb6d9/packages/documentation/copy/en/modules-reference/Reference.md) at commit `c8170c35`.
