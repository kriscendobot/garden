---
source_kind: web
source_url: https://babeljs.io/docs/options
source_content_sha256: 068855fa82918c37cbd6ff6bc214776700a2c624f7b0dac88b303910828a842a
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Babel contributors]
ingested: 2026-07-17
ingested_by: scholar
section_count: 1
status: current
notes: "Babel's canonical options reference is babeljs.io/docs/options. Fetched direct via fetch-source.sh 2026-07-17; content sha256 068855fa. Idempotency anchor is the content hash. Ingested to confirm Babel is a compiler/transformer, not a package.json resolver, and to pin the one package.json field it does read (browserslist, via browserslistConfigFile)."
---

Abstract: Babel's options reference, ingested to establish that Babel is a compiler/transformer, not a module resolver: it reads its own config (`babel.config.json`, `.babelrc`, controlled by `configFile`/`babelrc`/`rootMode`) and does not resolve `package.json` `exports`/`main`/`module`/`browser`. The one `package.json` field it consumes is `browserslist` (via `browserslistConfigFile`, feeding `@babel/preset-env` `targets`); module vs script comes from the explicit `sourceType` option, not the `package.json` `type` field. It backs the Babel row in the package-manifest consumer matrix.

| Section | Topics | Status |
|---------|--------|--------|
| [compiler-not-resolver-browserslist-and-sourcetype](../sections/web--babel-options--compiler-not-resolver-browserslist-and-sourcetype.md) | package-manifest | current |

Source: [Babel options](https://babeljs.io/docs/options) fetched 2026-07-17 (content sha256 `068855fa`).
