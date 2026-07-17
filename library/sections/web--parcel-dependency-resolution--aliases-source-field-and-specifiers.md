---
title: Parcel alias field, source field, and specifier grammar
source_kind: web
source_url: https://parceljs.org/features/dependency-resolution/
source_content_sha256: ce144ef07d01dec77197f513b11f469647f61d07f3d903dc2c859b73dae526a4
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Parcel contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Beyond the standard entry fields, Parcel reads two Parcel-specific `package.json` fields — `alias` (redirect packages, files, globs, or shims, and reference runtime globals) and `source` (compile-from-source for symlinked packages) — and resolves five specifier shapes (relative, bare, absolute, tilde, hash) plus optional glob specifiers. `node_modules` directories are searched upward from the importing file, stopping at the project root.

**The `alias` field** redirects a specifier. Its forms:

- **Package aliases** override a `node_modules` dependency, for example `"alias": { "react": "preact/compat", "lodash/clone": "tiny-clone" }`.
- **File aliases** use relative paths to replace specific files.
- **Glob aliases** do pattern-based replacement with captured groups such as `$1`.
- **Shim aliases** map a specifier to `false` to exclude a module entirely.
- **Global aliases** reference a runtime global, for example `"alias": { "jquery": { "global": "$" } }`.

Aliases can be defined locally (the nearest `package.json`) or globally (the project-root `package.json`).

**The `source` field** points at a package's un-compiled source and is honored when the package is behind a symlink (a monorepo package, or via `npm link`), so Parcel compiles the module from source rather than its published entry.

**Specifier grammar.** Parcel classifies import specifiers by prefix:

- **Relative** — begins with `.` or `..`.
- **Bare** — no special prefix; resolves within `node_modules`. Subpaths (`import 'lodash/clone'`) access submodules.
- **Absolute** — begins with `/`; resolves from the project root.
- **Tilde** — begins with `~`; resolves from the nearest package root.
- **Hash** — begins with `#`; a private internal `imports` mapping (or a URL hash).
- **Glob** — matches multiple files via a pattern (requires `@parcel/resolver-glob`).

**`node_modules` search.** `node_modules` directories are searched upward from the importing file; the search stops at the project-root directory.

Source: [Parcel dependency resolution](https://parceljs.org/features/dependency-resolution/) fetched 2026-07-17 (content sha256 `ce144ef`), sections *Aliases*, *Named pipelines / source*, and *Specifiers*.
