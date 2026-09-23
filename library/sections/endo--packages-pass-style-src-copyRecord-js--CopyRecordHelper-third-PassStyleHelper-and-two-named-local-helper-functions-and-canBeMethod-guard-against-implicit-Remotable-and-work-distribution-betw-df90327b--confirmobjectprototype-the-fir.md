---
title: §confirmObjectPrototype — the first named local helper
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

Lines 14-23:
```js
const confirmObjectPrototype = (candidate, reject) => {
  return (
    getPrototypeOf(candidate) === objectPrototype ||
    (reject && reject`Records must inherit from Object.prototype: ${candidate}`)
  );
};
```

§The-canonical-prototype-validation-pattern from cycles 260 + 262, now extracted into a named function — §the-direct-prototype-equality-check-IS-named.

§Three-cycles-with-direct-prototype-equality-as-canonical-validation (260 immutableArrayBufferPrototype + 262 arrayPrototype + 264 objectPrototype) — the discipline is now canonical across the cluster's leaf-helpers; §the-pattern-named-three-times-IS-the-discipline.

§The-reject-callback-pattern (cycle 260's named pattern): `reject &&` short-circuit returns the rejected diagnostic string when reject is passed; returns false (via the `||` left-falsy result) when reject is not.

§First-explicit-observation in library: **§extracting-the-canonical-prototype-check-into-a-named-local-function-is-the-shape-the-third-instance-takes — §when-a-pattern-recurs-three-times-across-siblings, §extract-it-from-each-into-a-named-helper-function**.
