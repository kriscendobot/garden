---
title: §`Object.create(objectPrototype, descriptors)` — the canonical descriptor-map construction
source-slug: endo--packages-pass-style-src-makeTagged-js
section-slug: the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/makeTagged.js
source-author: Endo project (collective)
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
---

Line 24-28:
```js
create(objectPrototype, {
  [PASS_STYLE]: { value: 'tagged' },
  [Symbol.toStringTag]: { value: tag },
  payload: { value: payload, enumerable: true },
}),
```

§The-`Object.create(proto, descriptors)`-form (rather than `{}` literal + `Object.defineProperty` × 3) carries three named advantages:

1. **§Atomicity** — all properties defined in one expression; no intermediate object state visible.
2. **§Symbol-key support** — `{ [PASS_STYLE]: ... }` works in the descriptor map; cleaner than `defineProperty(obj, PASS_STYLE, descriptor)`.
3. **§Explicit prototype** — `objectPrototype` named as the prototype; §explicit-prototype-naming-IS-the-discipline (matches `getPrototypeOf` checks in cycle 264's copyRecord).

§First-explicit-observation in library: **§three-named-advantages-of-`Object.create`-with-descriptor-map-over-object-literal-plus-defineProperty (atomicity + symbol-key support + explicit prototype)**.

§sibling-pattern to cycle 264's copyRecord destructured `{ getPrototypeOf, prototype: objectPrototype } = Object` — §the-same-`objectPrototype`-binding-is-used-by-the-constructor-and-the-validator; §the-two-files-import-the-same-prototype-reference-from-the-same-realm; §realm-aware-prototype-consistency.
