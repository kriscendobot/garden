---
title: §the-named-barrel-index-as-package-surface-artifact
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

The file is **96 export statements** organized into clusters by source file (eight source files), plus a deprecation section. Reading this single file tells the user:

- **What @endo/patterns exports** (the full public API in one place)
- **Which source file each export lives in** (one cluster per source file)
- **Which exports are deprecated** (with canonical pointers to where to find them now)

**§the-named-organized-export-clusters-by-source-file** — each cluster has a comment-free `export { ... } from './path/to/source.js';` shape; the cluster boundaries (= source-file boundaries) are visible by file path. First-explicit-observation.

**§eight-source-files-aggregated** by the index:
- `./src/keys/checkKey.js` (cycle 102 — 224-cycle arc implied)
- `./src/keys/copySet.js` (cycle 110 — 216-cycle arc implied; `coerceToElements`)
- `./src/keys/copyBag.js` (cycle 115 — 211-cycle arc implied; `coerceToBagEntries`)
- `./src/keys/compareKeys.js` (cycle 104 — 222-cycle arc implied)
- `./src/keys/merge-set-operators.js` (cycle 123 — 203-cycle arc implied)
- `./src/keys/merge-bag-operators.js` (cycle 125 — 201-cycle arc implied)
- `./src/patterns/patternMatchers.js` (not yet ingested — patternMatchers.js is 2402 lines; the only @endo/patterns/src file still un-ingested)
- `./src/patterns/getGuardPayloads.js` (cycle 127 — 199-cycle arc implied)

These are **implicit** arc closures (the index *aggregates* the source files; it doesn't deeply re-examine them). I count only the cycle 325 → 326 arc as a direct closure; the seven file-citations are *acknowledgments* that the index gathers what those earlier cycles examined.
