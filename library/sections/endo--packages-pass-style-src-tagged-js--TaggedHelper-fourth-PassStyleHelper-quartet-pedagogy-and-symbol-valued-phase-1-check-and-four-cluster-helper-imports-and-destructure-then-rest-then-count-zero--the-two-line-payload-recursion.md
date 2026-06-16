---
title: §The two-line `payload` recursion at the end
source-slug: endo--packages-pass-style-src-tagged-js
section-slug: TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/tagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/tagged.js
source-author: Endo project (collective)
total-lines: 49
ingest-cycle: 268
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-tagged-js--TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero
---

Lines 45-47:
```js
passStyleOfRecur(
  confirmOwnDataDescriptor(candidate, 'payload', true, Fail).value,
);
```

§The-payload-recursion-uses-the-same-shape-as-copyArray's-index-recursion (cycle 262) + copyRecord's per-property-recursion (cycle 264) — §`confirmOwnDataDescriptor(candidate, key, true, Fail).value` followed by `passStyleOfRecur(value)`; §the-shape-IS-now-canonical-across-three-cycles (262 + 264 + 268).

§First-explicit-observation in library: **§three-cycles-with-confirmOwnDataDescriptor-followed-by-passStyleOfRecur-on-the-value (262 indices + 264 each-property + 268 payload)**.
