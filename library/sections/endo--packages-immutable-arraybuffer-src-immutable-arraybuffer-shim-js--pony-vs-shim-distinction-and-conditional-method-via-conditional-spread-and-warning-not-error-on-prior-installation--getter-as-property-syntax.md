---
title: §Getter as property syntax
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation
---

```js
get immutable() {
  return isBufferImmutable(this);
},
```

§The-`get immutable()`-syntax IS the getter declaration inside an object literal. §The-getter-is-a-non-method-property + §accessing-`buffer.immutable`-calls-the-function + §the-getter-IS-the-shape-of-a-read-only-property.

§When-a-platform-prototype-needs-a-read-only-property-not-a-method, §use-the-getter-syntax + §the-consumer-accesses-without-calling-parentheses + §the-shape-matches-how-built-in-platform-properties-typically-look (e.g., `Array.prototype.length` is a property, not a method).

§Sibling-pattern-to-cycle-235's-`get nodes()-returns-new-Set` — §two-cycles-with-getter-syntax-on-object. §Cycle-235's-getter-makes-a-defensive-copy; §cycle-245's-getter-is-a-pure-predicate-with-no-side-effects.
