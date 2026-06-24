---
title: §the-named-line-level-eslint-disable-with-context-rationale
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

Line 79-80: `// eslint-disable-next-line import/export\nexport * from './types-index.js';` — line-level eslint disable specifically marks the wildcard export's potential conflict with the named exports above. Compare to cycle 324 atomics.js's three line-level `no-bitwise` disables (which marked individual deliberate bitwise ops). Cycle 326's disable marks a *single* wildcard export with a *contextual* lint rule (import/export reports possible conflicts between `export *` and named exports).

**§three-cycles-with-named-line-level-eslint-disable** (324 + 326; both line-level; cycle 314 + 318 were file-level). §two-shapes-of-eslint-disable continues to apply.
