---
title: Comment Elision
source: packages/bundle-source/README.md
source_repo: endojs/endo
source_commit: 1af1999ec5a7b77f39a1044073ed545ff526c90b
source_date: 2025-08-02
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling]
status: current
---

> Abstract: How bundle-source removes JS comments from bundled sources. Important for size reduction and for stripping potentially-sensitive comment content.

## Comment Elision

The `--elide-comments`/`-e` option with default format "endoZipBase64" or
explicit format "endoScript" via `--format`/`-f` causes the bundler to blank out
the interior of comments, without compromising line or column number location of
the remaining source code.
This can reduce bundle size without harming the debug experience any more than
other transforms.

Comment elision preserves `/*! slashasterbang /` comments and JSDoc comments
with `@preserve`, `@copyright`, `@license` pragmas or the Internet Explorer
`@cc_on` pragma.

Comment elision does not strip comments entirely.
The syntax to begin or end comments remains.


Source: [packages/bundle-source/README.md](https://github.com/endojs/endo/blob/1af1999ec5a7b77f39a1044073ed545ff526c90b/packages/bundle-source/README.md) at commit `1af1999e`.
