---
title: "@endo/far/src/{index,exports}.js — the curated re-export set + the dummy .js companion to exports.d.ts"
source-slug: endo--packages-far-src-index-js-and-exports-js
url: https://github.com/endojs/endo/blob/master/packages/far/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/far/src/index.js + packages/far/src/exports.js
total-lines: 7 (5 + 2)
status: published
ingest-cycle: 258
ingest-date: 2026-06-10
lane: chat
---

# @endo/far/src/{index,exports}.js

A 5-line `index.js` that re-exports four canonical capability operations from two upstream packages (`E` from `@endo/eventual-send` + `Far`, `getInterfaceOf`, `passStyleOf` from `@endo/pass-style`), plus a 2-line `exports.js` dummy companion to `exports.d.ts` for pure-type exports. The package's entire runtime surface is seven lines.

## Key design moves

- **§The package IS a curated re-export set** — `@endo/far` is not a runtime library; it's a single import path that bundles the canonical capability-call operations.
- **§Four named re-exports from two named upstream packages**.
- **§The dummy `.js` companion to a `.d.ts` file** — TypeScript-and-runtime bridge pattern.
- **§The comment explains the non-obvious purpose** of a trivial file.
- **§Curated re-export package IS the abstraction boundary** — the application decouples from implementation package structure.
- **§The canonical Far vocabulary** — `E` + `Far` + `getInterfaceOf` + `passStyleOf` as the named four exports.
- **§Five-line `src/index.js`** as curated-re-export-package entry point (smallest ingested).
- **§Two-line `exports.js`** as companion to `.d.ts` (smallest file ingested yet).
- **§`export *` with `eslint-disable-next-line import/export`** (recurring with cycle 254).

## Section files

- [§the-package-IS-a-curated-re-export-set + §the-dummy-exports.js-companion + §the-five-line-package](../sections/endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package.md) — full 7-line module ingest (pair).

## Ingest scope

Cycle 258 (chat-lane after cycle 257's designs-lane): full 7-line module-pair ingest. First-direct-ingest from `@endo/far/src/`. §First-explicit-observation of seven patterns: §the-package-IS-a-curated-re-export-set + §the-dummy-`.js`-companion-to-a-`.d.ts`-file + §curated-re-export-package-IS-the-abstraction-boundary + §the-canonical-Far-vocabulary + §five-line-`src/index.js`-as-curated-re-export-package-entry-point + §the-comment-explains-the-non-obvious-purpose-of-a-trivial-file + §two-line-`exports.js`-as-companion-to-`.d.ts`.
