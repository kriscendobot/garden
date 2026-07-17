---
title: Parcel package entry order, exports, and conditions
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

> Abstract: When resolving a bare or relative dependency to a package's entry, Parcel checks `package.json` fields in a fixed precedence: `source`, then `exports`, then `browser`, then `module`, then `main`, falling back to index files. The `exports` field is **disabled by default** and enabled per-project with the `@parcel/resolver-default` `packageExports` flag; when active it honors a broad ordered condition set. The `#`-prefixed `imports` field defines private internal mappings, and the `browser` field substitutes files (string or per-module object form) for browser builds.

**Package entry precedence.** For a dependency that resolves to a package directory, Parcel checks these `package.json` fields in order and uses the first that applies:

1. `source` — used to compile the module from source when it is behind a symlink (a monorepo package, or an `npm link`ed dependency).
2. `exports` — package exports with conditional support (see below).
3. `browser` — a browser-specific version; when building for a browser environment the `browser` field overrides other fields.
4. `module` — the ES-module version.
5. `main` — the CommonJS version.

If none exist, resolution falls back to index files.

**The `exports` field (opt-in).** `exports` is disabled by default. It is enabled per-project by configuring the default resolver in the project's `package.json`:

```json
{
  "@parcel/resolver-default": {
    "packageExports": true
  }
}
```

`exports` may be a single string (`"exports": "./dist/index.js"`), a subpath object (`{".": "./dist/index.js", "./bar": "./dist/bar.js"}`), or wildcard patterns (`"./*": "./dist/*.js"`).

**Conditional exports.** Parcel supports these condition names: `import`, `require`, `module`, `sass`, `less`, `stylus`, `style`, `node`, `browser`, `worker`, `worklet`, `electron`, `development`, `production`, and `default`. "The order that exports conditions are resolved follows the order they are defined in the `package.json`" — that is, key order in the manifest, not a Parcel-fixed precedence.

**The `imports` field.** The `#`-prefixed `imports` field defines private mappings that apply to import specifiers within the package, and supports the same conditional logic as `exports`.

**The `browser` field.** For browser builds, `browser` maps files. It accepts a string (a single replacement) or an object mapping source files to browser variants, for example `{ "browser": { "./fs.js": "./fs-browser.js" } }`.

Source: [Parcel dependency resolution](https://parceljs.org/features/dependency-resolution/) fetched 2026-07-17 (content sha256 `ce144ef`), sections *Package entries*, *Package exports*, *Package imports*, and *Browser field*.
