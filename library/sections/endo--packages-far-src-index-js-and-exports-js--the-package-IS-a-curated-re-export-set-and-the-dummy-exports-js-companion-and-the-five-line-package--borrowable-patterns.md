---
title: §Borrowable patterns
source-slug: endo--packages-far-src-index-js-and-exports-js
source-url: https://github.com/endojs/endo/blob/master/packages/far/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/far/src/index.js + packages/far/src/exports.js
total-lines: 7 (5 + 2)
ingest-cycle: 258
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package
---

**Tier-1 (highest borrowing value):**

- §The package IS a curated re-export set — named-package-purpose distinct from implementation.
- §Four-named-re-exports from two named upstream packages — `@endo/far` collects `E` + `Far` + `getInterfaceOf` + `passStyleOf`.
- §The dummy `.js` companion to a `.d.ts` file — TypeScript-and-runtime bridge pattern.
- §The comment explains the non-obvious purpose — when a file's existence is non-obvious, the comment IS the evidence.
- §Curated re-export package IS the abstraction boundary — the application decouples from implementation package structure.
- §The canonical Far vocabulary as the named-four-exports of `@endo/far`.
- §Five-line `src/index.js` as curated re-export package entry point.

**Tier-2 (named comparisons):**

- §Three-cycles-with-`export {};`-marker (249 + 256 + 258) — three different roles.
- §Three-cycles-with-named-import-isolation (242 elevator + 254 no-shim + 258 curated-re-export).
- §Three-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254 + 258).
- §Three-cycles-with-named-identifier-or-comment-encodes-the-discipline (247 function-name + 252 parameter-name + 258 file-purpose-comment).
- §Two-cycles-with-named-curated-package-as-stable-import-path (242 + 258).
- §Two-cycles-with-`export *`-with-named-eslint-disable (254 + 258).
- §Two-cycles-with-multiple-export-styles-in-one-file (254 + 258).

**Tier-3 (file-shape patterns):**

- §Five-line `src/index.js` as smallest package entry point ingested yet.
- §Two-line `exports.js` as smallest companion file ingested (smaller than cycle 243's 9 lines).
- §Eight-cycles-with-small-files-that-each-isolate-one-named-decision (239 + 241 + 243 + 247 + 249 + 252 + 256 + 258).
