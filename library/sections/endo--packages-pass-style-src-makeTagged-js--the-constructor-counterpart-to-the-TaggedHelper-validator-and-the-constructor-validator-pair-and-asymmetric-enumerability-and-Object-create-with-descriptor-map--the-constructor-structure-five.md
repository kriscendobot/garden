---
title: §The constructor structure — five operations in eleven lines
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

Lines 19-30:

```js
export const makeTagged = (tag, payload) => {
  typeof tag === 'string' ||
    Fail`The tag of a tagged record must be a string: ${tag}`;
  assertPassable(harden(payload));
  return harden(
    create(objectPrototype, {
      [PASS_STYLE]: { value: 'tagged' },
      [Symbol.toStringTag]: { value: tag },
      payload: { value: payload, enumerable: true },
    }),
  );
};
```

§Five-operations-in-the-constructor:

1. **§tag-must-be-string** check (line 20-21) — §the-predicate-OR-fail-idiom from cycle 260.
2. **§harden-the-payload-then-assertPassable** (line 22) — §harden-before-assert.
3. **§Object.create-with-descriptor-map** (line 24-28) — three property descriptors.
4. **§harden-the-result** (line 23, wrapping the return value).
5. **§return-the-hardened-CopyTagged**.

§First-explicit-observation in library: **§five-operations-in-a-thirty-line-constructor-with-explicit-harden-and-assertPassable-and-Object.create-and-descriptor-map**.
