---
title: §the-named-named-function-via-object-destructure
source: endo--packages-promise-kit-src-memo-race-js
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/memo-race.js
authors: [Brian Kim (original), Endo project (adopted)]
repo: endojs/endo
path: packages/promise-kit/src/memo-race.js
total-lines: 170
ingest-cycle: 336
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-deviation-named-in-the-source-too
  - the-named-implementation-of-the-accommodation
  - the-named-public-domain-license-header-preserved-verbatim
  - the-named-attribution-discipline-when-adopting-public-domain-code
  - the-named-explicit-acknowledgment-of-cross-package-layering-constraint
  - the-named-name-both-the-goal-and-the-obstacle
  - the-named-helpers-private-export-single-public
  - the-named-export-the-noun-not-the-verbs
  - the-named-in-place-transition-for-shared-references
  - the-named-assign-then-freeze-transition
  - the-named-fake-record-honors-real-record-discipline
  - the-named-named-function-via-object-destructure
  - the-named-api-name-vs-impl-name-asymmetry
  - the-named-JSDoc-generic-this-binding
  - the-named-cachedValues-defends-against-one-shot-iterables
  - the-named-complementary-lens-re-ingest
  - the-named-streak-resumes-after-one-cycle-gap
  - five-cycles-with-named-complementary-lens-re-ingest
  - twenty-seven-cycles-with-named-pivot-domain-stay
  - fifty-citation-arc-closures-in-pivot-now
parent: endo--packages-promise-kit-src-memo-race-js--fifth-complementary-lens-deviation-named-in-the-source-too
---

Lines 122-168:

```js
const { race } = {
  /**
   * Creates a Promise that is resolved or rejected when any of the provided Promises are resolved
   * or rejected.
   * ...
   */
  race(values) {
    ...
  },
};

export { race as memoRace };
```

The function is declared as a **method on an object literal**, then immediately destructured. Method-syntax (`race(values) { ... }` not `race = function(values) { ... }`) makes the function:
1. **Non-constructable** — `new race(...)` throws
2. **Prototype-less** — no `.prototype` property
3. **Named** — `race.name === 'race'`

**§the-named-named-function-via-object-destructure** — first-explicit-observation as a refinement of cycle 152's note. The idiom achieves three properties at once:
- Method-syntax for non-constructable + prototype-less
- Object-literal-destructure to capture the function into a `const` binding (not a method-bound function)
- Named-binding so `race.name === 'race'` for debugging

**§the-named-api-name-vs-impl-name-asymmetry** — first-explicit-observation as a tier-3 meta-pattern. The internal name is `race` (matches the method-syntax name); the exported name is `memoRace` (the public API). The asymmetry is intentional: internally the function is *a* race; externally it's *the memoized race* (distinguished from native `Promise.race`). **§the-named-impl-name-is-generic-API-name-is-qualified** — first-explicit-observation.

**§the-named-JSDoc-generic-this-binding** — lines 130-132:

```js
* @template {readonly unknown[] | []} T
* @template {PromiseConstructor} [P=PromiseConstructor]
* @this {P}
```

Two type-parameters: `T` (input array type) + `P` (the Promise constructor; defaults to `PromiseConstructor`). `@this {P}` declares the function's `this`-binding type. Line 141: `const C = this;` captures the constructor at call time; line 142: `const result = new C(...);` uses the captured constructor.

The function is **subclassable** — a Promise subclass can call `memoRace.call(SubclassPromise, values)` and the result is a `SubclassPromise`. But the subclassability is expressed entirely through **JSDoc machinery**; the file has no TypeScript signature, no class declaration, no `extends` clause.

**§the-named-subclassable-via-JSDoc-only** — first-explicit-observation. The subclassability is a runtime property (via `this`) that JSDoc machinery exposes to the type-checker. Compare to cycle 326's @deprecated tags (JSDoc as semantic marker) + cycle 334's typed-cast inline JSDoc (JSDoc as type-level surgery). **§the-named-JSDoc-as-three-tools** — first-explicit-observation as a tier-3 meta-pattern: JSDoc serves as semantic-marker (deprecation) + type-level-surgery (casts) + generic-this-binding (subclassability).
