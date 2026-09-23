---
title: §`applyMethod` is atomic lookup-of-method-and-apply
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

```js
/**
 * @property {(target: any, method: string | symbol | number, args: Array<any>) => any} applyMethod
 *   method invocation, which is an atomic lookup of method and apply
 */
```

§The-JSDoc-explicitly-names §applyMethod-as-an-atomic-lookup-of-method-and-apply. §The-distinction: §`obj.method()`-decomposes-into-get-then-apply + §`applyMethod(obj, 'method', args)`-is-one-atomic-operation-not-two.

§When-the-protocol-distinguishes-get-then-apply-from-applyMethod, §the-atomicity-IS-the-distinction. §The-get-then-apply-shape-exposes-the-method-as-a-detached-function (which can leak); §the-applyMethod-shape-never-exposes-the-method-as-a-separate-value. §Security-by-construction: §the-protocol's-atomic-applyMethod-prevents-method-detach-attacks.

§Sibling-to-cycle-146's-E-this-receiver-check (which defends against `const m = E(x).method` detach) — §two-different-shapes-of-defense-against-method-detach: §cycle-146-via-this-receiver-check + §cycle-249-via-atomic-applyMethod. §Two-cycles-with-explicit-defense-against-method-detach-as-named-discipline.

§First-explicit-observation in library of §applyMethod-as-atomic-lookup-of-method-and-apply as named-security-property.
