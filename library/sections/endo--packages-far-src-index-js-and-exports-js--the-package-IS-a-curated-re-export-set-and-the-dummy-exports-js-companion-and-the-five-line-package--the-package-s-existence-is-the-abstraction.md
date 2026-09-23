---
title: §The package's existence IS the abstraction
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

§Why-not-just-`import { E } from '@endo/eventual-send'`-directly? §Because-the-curated-package-decouples-the-application-from-the-implementation-package-structure + §future-refactors-can-move-`E`-to-a-different-package-and-only-`@endo/far`-changes + §the-application-keeps-importing-from-`@endo/far`-unchanged.

§The-curated-package-IS-the-abstraction-boundary. §First-explicit-observation in library of §curated-re-export-package-IS-the-abstraction-boundary as named architectural pattern.

§Sibling-pattern-to-cycle-242's-elevator-module — §two-cycles-with-named-import-isolation-pattern: §cycle-242 elevator-isolates-platform-import + §cycle-258 curated-package-isolates-implementation-package-structure. §Three-cycles-with-named-import-isolation (242 + 254 no-shim + 258 curated-re-export).
