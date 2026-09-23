---
title: Synthesis-target
source: endo--packages-patterns-index-js
url: https://github.com/endojs/endo/blob/master/packages/patterns/index.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/patterns/index.js
total-lines: 98
ingest-cycle: 326
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-barrel-index-as-package-surface-artifact
  - the-named-organized-export-clusters-by-source-file
  - the-named-JSDoc-cannot-express-TypeScript-declarations-discipline
  - the-named-three-TS-features-JSDoc-cannot-express
  - the-named-typed-re-export-for-JSDoc-limitations
  - the-named-namespace-merge-for-M
  - the-named-type-predicate-for-matches
  - the-named-asserts-signature-for-mustMatch
  - the-named-deprecation-re-export-with-canonical-pointer
  - the-named-deprecated-but-still-working
  - the-named-section-divider-as-separator
  - the-named-line-level-eslint-disable-with-context-rationale
  - the-named-documentation-language-cannot-express-target-language-features
  - seventeen-cycles-with-named-pivot-domain-stay
  - ten-named-packages-in-the-pivot-cluster
  - fifteen-citation-arc-closures-in-pivot-now
  - the-named-citation-arc-from-cycle-325-takes-1-cycle-to-close
parent: endo--packages-patterns-index-js--barrel-index-as-package-surface-and-jsdoc-cannot-express-discipline
---

Slot machine library **§`@game/patterns/index.js`** — barrel index for game-pattern-matching library:

1. **Barrel-index** that enumerates the full public API.
2. **Organized-export-clusters by source file** so readers can navigate from each export to its source.
3. **Typed-re-export for JSDoc limitations** — if any exports require TS features JSDoc can't express (namespace merge for builder objects + type predicates for type-guards + asserts signatures for type-guard-asserts), put them in a separate `types-index.js` and re-export with `export * from './types-index.js'` (line-level eslint-disable for the wildcard).
4. **Deprecation section** with `@deprecated / Import directly from <path>` per export.
5. **Section divider** (`// /////////// Deprecated /////////////`) visually separates active from deprecated.
6. **Comment** above the typed-re-export naming which features JSDoc can't express.
