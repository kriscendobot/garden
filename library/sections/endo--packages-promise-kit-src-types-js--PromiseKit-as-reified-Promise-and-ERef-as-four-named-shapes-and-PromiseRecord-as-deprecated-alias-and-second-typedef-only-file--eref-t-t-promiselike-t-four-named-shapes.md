---
title: §`ERef<T> = T | PromiseLike<T>` — four named shapes
source-slug: endo--packages-promise-kit-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file
---

```js
/**
 * @template T
 * @typedef {T | PromiseLike<T>} ERef
 * A reference of some kind for to an object of type T. It may be a direct
 * reference to a local T. It may be a local presence for a remote T. It may
 * be a promise for a local or remote T. Or it may even be a thenable
 * (a promise-like non-promise with a "then" method) for a T.
 */
```

§The-`ERef<T>`-typedef-is-`T | PromiseLike<T>`-at-the-TypeScript-level + §but-the-JSDoc-prose-names-four-distinct-shapes-the-type-accepts:

1. §A-direct-reference-to-a-local-T (`T` itself).
2. §A-local-presence-for-a-remote-T (the Far-ref or remote-presence shape).
3. §A-promise-for-a-local-or-remote-T (`Promise<T>` proper).
4. §A-thenable — *a promise-like non-promise with a "then" method* — for a T (`PromiseLike<T>` that isn't a Promise).

§Four-named-shapes-distinguished-in-prose-not-in-type-narrower-than-T | PromiseLike<T>. §The-TypeScript-type-collapses-the-distinction-but-the-JSDoc-preserves-it-in-prose.

§First-explicit-observation in library of §four-named-shapes-of-ERef as named reference-vocabulary.

§Sibling-pattern-to-cycle-252's-thenable-vs-genuine-Promise distinction — §cycle-252-distinguishes-thenable-vs-genuine-Promise + §cycle-256-distinguishes-local-T-vs-remote-presence-vs-genuine-Promise-vs-thenable. §The-distinction-IS-load-bearing-in-capability-systems-because-each-shape-has-different-trust-and-locality-properties.

§The-`promise-like non-promise with a "then" method` paraphrase IS the most precise definition of a thenable. §When-a-type-includes-thenables, §the-prose-must-define-thenable-explicitly + §don't-assume-the-reader-knows.
