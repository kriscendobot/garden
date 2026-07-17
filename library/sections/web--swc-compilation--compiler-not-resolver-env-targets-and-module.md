---
title: swc is a compiler, not a resolver — env.targets and module config
source_kind: web
source_url: https://swc.rs/docs/configuration/compilation
source_content_sha256: 2981937c068e445230973ab42dc0a22a92b824c68ef2531165d2207636d5a045
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [swc contributors]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: swc is a compiler/transformer, not a module resolver. Its compilation reference documents only its own `.swcrc` configuration — `jsc` (syntax, transforms), `env` (`env.targets`, `env.coreJs`), `module` (`module.type`), and `isModule` — and does **not** describe resolving `package.json` `exports`, `main`, `module`, or `browser`. `env.targets` accepts browserslist-style query strings, query arrays, or browser-version maps (`{ "chrome": "79" }`), but this page does not document reading the `package.json` `browserslist` field or `.browserslistrc`. Module format is chosen by `module.type` / `isModule`, not by the `package.json` `type` field.

**A compiler, not a resolver.** swc reads its configuration from `.swcrc` (it publishes an official JSON Schema for it). The compilation reference does **not** address resolving module specifiers or the `package.json` `exports`/`main`/`module`/`browser` fields — those resolution concerns belong to the bundler or runtime that drives swc, not to swc itself.

**Core keys.**

- `jsc` — the JavaScript-compiler settings (parser syntax, transforms, target).
- `env` — environment targeting (an alternative to a manual `jsc.target`), including `env.targets` and `env.coreJs` (for example `"3.26.1"`).
- `module` — output module settings, including `module.type` for the emitted module format.
- `isModule` — `true`, `false`, or `"unknown"`; when `"unknown"`, the input "will be `Module` if it's esm and `Script` otherwise" (syntactic detection, not a `package.json` `type` read).

**`env.targets`** accepts:

- query strings such as `"Chrome >= 48"` (browserslist-style),
- arrays of such queries (`string[]`),
- browser-version maps such as `{ "chrome": "79" }`.

The reference does **not** mention resolving targets from the `package.json` `browserslist` field or a `.browserslistrc` file — a caller wanting that must pass the resolved targets in.

**Bottom line for the matrix.** swc reads `.swcrc` (`jsc`/`env`/`module`/`isModule`) and does not consume the resolution-oriented `package.json` fields; the `package.json` field most adjacent to swc is `browserslist`, and even that is not documented as auto-read here.

Source: [swc compilation configuration](https://swc.rs/docs/configuration/compilation) fetched 2026-07-17 (content sha256 `2981937c`), sections *jsc*, *env*, *module*, and *isModule*.
