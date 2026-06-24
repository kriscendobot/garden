---
title: §the-named-deprecation-re-export-with-canonical-pointer
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

Lines 82-98 form a deprecation section with two re-exports:

```js
// /////////////////////////// Deprecated //////////////////////////////////////

export {
  /**
   * @deprecated
   * Import directly from `@endo/common/list-difference.js` instead.
   */
  listDifference,
} from '@endo/common/list-difference.js';
```

**§the-named-deprecated-but-still-working** — the deprecated re-exports *still work*; backwards compatibility holds. The `@deprecated` JSDoc tag triggers IDE/lint warnings but doesn't break callers. **§the-named-deprecation-tag-with-canonical-pointer**: the JSDoc points to *exactly where* the new import path is. First-explicit-observation. Sibling to cycle 321's "Most users don't need this" (which named *low-utility paths*); the deprecation discipline names *paths the package wants you to abandon over time*.

**§the-named-section-divider-as-separator** (line 82) — `// /////////////////////////// Deprecated //////////////////////////////////////` is a visual divider; the slashes echo the file's structure (export statements / divider / deprecated exports). Compare to cycle 322 exo-makers's use of comments-as-warnings (state-sealed-not-frozen repeated three times); this is comments-as-section-delimiters. First-explicit-observation.
