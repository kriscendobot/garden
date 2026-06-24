---
title: §Three-named-TODO-cases-acknowledged-with-Fail
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
case 'error': {
  const {
    name,
    message,
    cause = undefined,
    errors = undefined,
  } = rawTree;
  cause === undefined ||
    Fail`error cause not yet implemented in marshal-justin`;
  name !== `AggregateError` ||
    Fail`AggregateError not yet implemented in marshal-justin`;
  errors === undefined ||
    Fail`error errors not yet implemented in marshal-justin`;
  return out.next(`${name}(${quote(message)})`);
}
```

§Three-named-not-yet-implemented-cases for error encoding:
1. §error-cause-not-yet-implemented.
2. §AggregateError-not-yet-implemented.
3. §error-errors-not-yet-implemented.

§Borrowable-pattern: §use-Fail-with-named-not-yet-implemented-message to §refuse-to-silently-produce-wrong-output. §The-implementation-throws-when-it-encounters-these-instead-of-silently-producing-output-that-loses-information.

§Sibling to cycle 215 @endo/hex's §native-error-rerun-polyfill (both designs §refuse-silent-degradation when the implementation can't produce correct output).
