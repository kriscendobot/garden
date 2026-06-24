---
title: §The `@import {Rejector}` JSDoc-named-protocol
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
---

Lines 6-9 (the JSDoc `@import` block):
```js
/**
 * @import {Rejector} from '@endo/errors/rejector.js';
 * @import {PassStyleHelper} from './internal-types.js';
 */
```

§The-`Rejector`-type-from-`@endo/errors/rejector.js` is the named protocol for the reject callback signature; §sibling-pattern to cycle 102's checkKey trio's Rejector vocabulary; §the-type-is-imported-via-JSDoc-`@import`-not-runtime-import — §types-only-import-via-JSDoc; §named-import-discipline-via-JSDoc-rather-than-runtime-import-when-the-import-is-types-only; §first-explicit-observation in library of §the-`@import`-via-JSDoc-block-pattern-with-multiple-typedefs-comma-separated-not-but-each-on-its-own-line.

§the-`@import`-block-IS-the-types-only-imports-list — §two-named-import-styles-across-the-cluster (runtime imports at top + JSDoc `@import` block for types-only); §two-cycles-with-types-only-`@import`-block (243 + 264 — actually look earlier cycles too; the @import discipline is throughout but the cluster-block form here is distinctive).
