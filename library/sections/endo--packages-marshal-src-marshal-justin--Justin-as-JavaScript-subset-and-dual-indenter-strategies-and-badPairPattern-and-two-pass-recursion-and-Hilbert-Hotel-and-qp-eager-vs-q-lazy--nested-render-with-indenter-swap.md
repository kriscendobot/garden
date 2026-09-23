---
title: §Nested-render-with-indenter-swap
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
case 'slot': {
  const { iface } = rawTree;
  const index = Number(Nat(rawTree.index));
  const nestedRender = arg => {
    const oldOut = out;
    try {
      out = makeNoIndenter();
      decode(arg);
      return out.done();
    } finally {
      out = oldOut;
    }
  };
  // ...
}
```

§Closure-captures-`out`-as-mutable-reference + §temporarily-swaps-it-to-makeNoIndenter + §try-finally-restores-it. §The-`nestedRender`-helper produces a §self-contained-no-indent-string-for-embedding inside an outer indented context.

§Borrowable-pattern: §closure-captures-mutable-state + §try-finally-swap-and-restore. §When-an-inner-rendering-needs-a-different-strategy-than-the-outer-rendering, §swap-the-state + §restore-it-in-finally.

§Sibling to cycle 132 local.js's §getMethodNames-prototype-walk discipline — both designs §closure-state-with-bounded-mutation.
