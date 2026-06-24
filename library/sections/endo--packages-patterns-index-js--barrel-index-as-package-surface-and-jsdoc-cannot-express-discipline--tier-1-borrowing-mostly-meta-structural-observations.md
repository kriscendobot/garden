---
title: Tier-1 borrowing (mostly meta-structural observations)
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

This is a *short* file (98 lines, mostly export statements). The observations are necessarily fewer than a 300+-line implementation file would yield, but they are *meta-structural* — about how the package presents itself to consumers rather than how it does work internally:

- **§the-named-barrel-index-as-package-surface-artifact** — readable in one sitting; gives the full API view
- **§the-named-JSDoc-cannot-express-TypeScript-declarations-discipline** — name the documentation-language limitation surgically (which features, which exports, which workaround)
- **§the-named-three-TS-features-JSDoc-cannot-express** — namespace merge + type predicate + asserts signature
- **§the-named-typed-re-export-for-JSDoc-limitations** — the workaround pattern (separate types-index.js)
- **§the-named-deprecation-tag-with-canonical-pointer** — `@deprecated / Import directly from <path>`
- **§the-named-section-divider-as-separator** — visual `// ///////` divider for sections within a file
- **§the-named-line-level-eslint-disable-with-context-rationale** — disable the lint rule with the context that triggered it visible
