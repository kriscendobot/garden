---
title: §Two-pass-recursion (prepare + decode)
source-slug: endo--packages-marshal-src-marshal-justin
section-id: Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/marshal-justin.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/marshal-justin.js
total-lines: 510
status: shipping
ingest-cycle: 229
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
---

```js
const prepare = rawTree => {
  // ... validation traversal ...
};

const decode = rawTree => {
  // ... emission traversal ...
};

prepare(encoding);
decode(encoding);
```

§Two-passes-over-the-same-tree:
1. **§prepare** — validates input shape; throws if invalid.
2. **§decode** — emits Justin tokens; relies on prepare having validated.

§The-honest-TODO:

> TODO now that ibids are gone, we should fold this back together into one validating pass.

§Borrowable-pattern: §two-pass-with-TODO-to-fold-back-to-one — §the-passes-are-currently-separate-for-historical-reasons + §the-design-acknowledges-they-could-be-unified. §The-history-is-visible-in-the-code-comment.

§The-comment also names the §maintenance-contract:

> Its control flow should mirror `recur` as closely as possible and the two should be maintained together. They must visit everything in the same order.

§Borrowable-pattern: §when-two-passes-must-visit-the-same-tree-in-the-same-order, §document-the-co-maintenance-constraint-in-the-source. §The-comment-IS-the-API-contract-between-the-two-functions.

§Sibling to cycle 227 PassStyleHelper's §two-phase-validation (confirmCanBeValid + assertRestValid) — same shape; different layer.
