---
title: Source Maps
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments, tooling]
status: current
parent: endo--pkg-compartment-mapper-readme--language-extensions
---

The `makeArchive`, `makeAndHashArchive`, and `writeArchive` tools can receive a
`sourceMapHook` as one of its options.
The `sourceMapHook` receives a source map `string` for every module it
archives, along with details `compartment`, `module`, `location`, and `sha512`.
The `compartment` is the fully-qualified file URL of the package root.
The `module` is the package-relative module specifier.
The `location` is the fully-qualified file URL of the module file.
The `sha512`, if present, was generated with the `computeSha512` power from the
generated module bytes.

The functions `importArchive`, `loadArchive`, and `parseArchive`
tools can receive a `computeSourceMapLocation` option that recives the same
details as above and must return a URL.
These will be appended to each module from the archive, for debugging purposes.

The `@endo/bundle-source` and `@endo/import-bundle` tools integrate source maps
for an end-to-end debugging experience.

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
