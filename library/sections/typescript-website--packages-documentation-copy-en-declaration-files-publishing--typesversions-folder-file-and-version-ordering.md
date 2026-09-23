---
title: typesVersions folder, file, and version ordering
source: packages/documentation/copy/en/declaration-files/Publishing.md
source_repo: microsoft/TypeScript-Website
source_commit: c8170c35bda4811c9516cbb69c39241ae4beb6d9
source_date: 2026-07-06
source_authors: [typescript-automation[bot]]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, typescript-conventions]
status: current
---

> Abstract: `typesVersions` chooses alternate declaration paths by TypeScript compiler semver range: it can redirect a whole folder or exact files, affects only a package's external API, falls back to `types` when no range matches, and uses first matching range order.

When opening a manifest for type resolution, TypeScript first checks `typesVersions`. A range maps requested package-relative paths to replacement paths, so `"*": ["ts3.1/*"]` redirects the root and subpaths into a compiler-specific folder, while an exact `"index.d.ts"` mapping can replace one file. These redirects apply to consumers importing the package, not to a package's own relative imports. If no version range matches, TypeScript falls back to `types`. Ranges use Node semver syntax and overlap is resolved in manifest-object order, so more specific/newer ranges must precede broader/older ones.

Source: [packages/documentation/copy/en/declaration-files/Publishing.md](https://github.com/microsoft/TypeScript-Website/blob/c8170c35bda4811c9516cbb69c39241ae4beb6d9/packages/documentation/copy/en/declaration-files/Publishing.md) at commit `c8170c35`.
