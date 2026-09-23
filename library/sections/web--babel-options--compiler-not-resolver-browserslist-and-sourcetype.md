---
title: Babel is a compiler, not a resolver — browserslist and sourceType
source_kind: web
source_url: https://babeljs.io/docs/options
source_content_sha256: 068855fa82918c37cbd6ff6bc214776700a2c624f7b0dac88b303910828a842a
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Babel contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: Babel is a compiler/transformer, not a module resolver. Its options reference documents configuration discovery (`babel.config.json`, `.babelrc`, via `configFile`/`babelrc`/`rootMode`) and transform options, and does **not** resolve `package.json` `exports`/`main`/`module`/`browser`. The one `package.json` field Babel consumes is `browserslist`: `browserslistConfigFile` (default on) lets `@babel/preset-env`'s `targets` read "the browserslist key inside `package.json`" (and `.browserslistrc`). Module-vs-script is decided by the explicit `sourceType` option (`module`/`script`/`commonjs`/`unambiguous`), **not** by the `package.json` `type` field.

**A compiler, not a resolver.** Babel transforms source; it does not perform module resolution and does not read `package.json` `exports`/`main`/`module`/`browser` to locate dependencies. Configuration is discovered from files, not resolved through the manifest:

- `configFile` — defaults to searching for a `babel.config.json`, but can be given the path of any JS or JSON5 config file.
- `babelrc` — when `true`, searches for `.babelrc.json` (and the legacy `.babelignore`) relative to the file being compiled.
- `rootMode` / `root` — control project-root discovery for the above.

The options page documents these config-file mechanisms; it does not document a `"babel"` config key in `package.json`.

**The one `package.json` field: `browserslist`.** Babel integrates with browserslist for `@babel/preset-env` `targets`. `browserslistConfigFile` "toggles whether or not browserslist config sources are used, which includes searching for any browserslist files or referencing the browserslist key inside `package.json`." It defaults on, so Babel reads the `package.json` `browserslist` key, `.browserslistrc`, and other browserslist sources when computing `targets`. The `targets` option itself may also be given explicitly (a browserslist query, or a versions map).

**`sourceType`, not `type`.** `sourceType` accepts `"script" | "module" | "commonjs" | "unambiguous"` and must be set in Babel configuration; Babel does **not** read the `package.json` `type` field to decide module vs script. `"unambiguous"` asks Babel to detect the kind from the source syntax.

Source: [Babel options](https://babeljs.io/docs/options) fetched 2026-07-17 (content sha256 `068855fa`), options *configFile*, *babelrc*, *rootMode*, *targets*, *browserslistConfigFile*, and *sourceType*.
