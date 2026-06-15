---
title: "@endo/promise-kit src/memo-race.js — fifth complementary-lens re-ingest; deviation-named-in-the-source-too (cycle 335 closure); the discipline lens on a 170-line file already algorithmically captured"
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
---

# `@endo/promise-kit src/memo-race.js` — fifth complementary-lens re-ingest; deviation named in the source too

The 170-line memo-race.js. Cycle 336 is **chat-lane after cycle 335's designs-lane @endo/promise-kit README**. **Twenty-seventh consecutive non-garden source after the pivot** (cycles 310-336). **§twenty-seven-cycles-with-named-pivot-domain-stay**.

**Note on prior ingest**: This file was first ingested in **cycle 152** by a scholar dispatch (comment-fragment, 35th ingest; first @endo/promise-kit source file ingested). The cycle 152 section took the *algorithm* lens with focus on: §WeakMap-shared-deferred-sets architecture, §one-then-per-value-lifetime invariant, §amortize-one-then-across-many-races, §broadcast-pattern-via-shared-set, §markSettled atomic-transition with §state-machine-with-frozen-terminal-state, §primitive-fake-settled-record, §finally-cleanup the memory-leak fix, §cachedValues defending §iterable-might-not-be-rerunnable.

Cycle 336 is a **§the-named-complementary-lens-re-ingest** (librarian discipline first-explicit-observed in cycle 322 for exo-makers.js, applied to atomics.js in cycle 324, smallcaps.js in cycle 330, exo-tools.js in cycle 332). **§five-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336) — the discipline now spans **five applications**. The cycle 336 lens emphasizes the **discipline / architecture** view rather than the algorithm: what structural choices make this file load-bearing in the package; what disciplines does it embody that the cycle 152 algorithm lens didn't name; how does the source-level expression of *"deliberate imperfection"* (cycle 335 README claim) appear in the source itself.

## The single most structurally interesting move

**§the-named-deviation-named-in-the-source-too** — line 127-128 of memo-race.js, in the `race` method's JSDoc:

```js
/**
 * Creates a Promise that is resolved or rejected when any of the provided Promises are resolved
 * or rejected.
 *
 * Unlike `Promise.race` it cleans up after itself so a non-resolved value doesn't hold onto
 * the result promise.
 * ...
 */
```

The README at cycle 335 made the abstract ponyfill claim (*"making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`"*). The SOURCE at cycle 336 **names the deviation explicitly in JSDoc**: *"Unlike `Promise.race` it cleans up after itself"*.

**§the-named-implementation-of-the-accommodation** — first-explicit-observation. The README's abstract claim about *"certain accommodations"* (cycle 335) materializes in the source's JSDoc statement of the divergence (cycle 336). The implementation does not silently diverge; the divergence is **named at the API surface** so callers reading the JSDoc know what they're getting that `Promise.race` doesn't give them.

**§the-named-deviation-named-in-the-source-too** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a README claims deliberate divergence from a standard (cycle 335's *§the-named-deliberately-imperfect-ponyfill*), the source should ALSO name that divergence at the JSDoc level, not just in the README. Two levels of honesty: package-level (README) + symbol-level (JSDoc). **§the-named-honesty-at-two-levels-discipline** — first-explicit-observation as a related meta-pattern.

This is the **implementation-side closure** of cycle 335's *deliberately-imperfect-ponyfill* claim. **§the-named-citation-arc-from-cycle-335-takes-1-cycle-to-close** as an *implementation-of-the-deliberate-imperfection* arc. The eighth INSTANCE of the one-cycle README↔source pattern (counted as a discipline-application count, not a streak — cycle 334 → 335 broke the §seven-cycles-with-named-one-cycle-README-source-arc streak; cycle 335 → 336 is one cycle, but isolated). **§the-named-streak-resumes-after-one-cycle-gap** — first-explicit-observation as a discipline-resumption.

## §the-named-public-domain-license-header-preserved-verbatim

Lines 1-29 of memo-race.js are **29 lines of public-domain Unlicense dedication** preserved verbatim from Brian Kim's original 2017 contribution to nodejs/node#17469. The block carries:

- Attribution line: *"Initial version authored by Brian Kim: https://github.com/nodejs/node/issues/17469#issuecomment-685216777"*
- Full Unlicense text: *"This is free and unencumbered software released into the public domain. Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software..."*
- Warranty disclaimer block
- URL to canonical Unlicense text: *"http://unlicense.org/"*

The @endo/promise-kit package overall is Apache-2.0 licensed (per cycle 335 README's License section); but this ONE file preserves Brian Kim's original public-domain dedication block.

**§the-named-attribution-discipline-when-adopting-public-domain-code** — first-explicit-observation. The discipline: when adopting code dedicated to the public domain by a named original author, **preserve the dedication block verbatim** even when integrating into a package with a different license. The dedication block is the historical record of the author's gift; relicensing it would erase that record.

**§the-named-original-author-cited-with-original-URL** — the cite is to the GitHub issue comment where Brian Kim originally posted the code, not a recreated location. **§the-named-canonical-URL-as-provenance** — the canonical location of the code's origin is preserved as the source of truth.

**§the-named-licensing-asymmetry-within-a-single-package** — first-explicit-observation as a structural curiosity: the package's overall license (Apache-2.0) does not override the file's preserved public-domain dedication. The reader sees both: package-LICENSE for everything else; file-header-Unlicense for memo-race.js specifically.

## §the-named-explicit-acknowledgment-of-cross-package-layering-constraint

Lines 34-36 contain a TODO comment:

```js
/**
 * TODO Consolidate with `isPrimitive` that's currently in `@endo/pass-style`.
 * Layering constraints make this tricky, which is why we haven't yet figured
 * out how to do this.
 *
 * @type {(val: unknown) => val is (undefined | null | boolean | number | bigint | string | symbol)}
 */
const isPrimitive = val =>
  !val || (typeof val !== 'object' && typeof val !== 'function');
```

The TODO names **both the goal** (*"Consolidate with `isPrimitive` that's currently in `@endo/pass-style`"*) **and the obstacle** (*"Layering constraints make this tricky"*) **and the candid admission** (*"which is why we haven't yet figured out how to do this"*).

**§the-named-name-both-the-goal-and-the-obstacle** — first-explicit-observation. The TODO is not just *"TODO consolidate this"*; it explains WHY consolidation hasn't happened. Future contributors reading the TODO know:
1. *What* should change (consolidate)
2. *Where* the duplicate lives (`@endo/pass-style`)
3. *Why* it hasn't been done (layering constraints — @endo/promise-kit sits below @endo/pass-style; importing would create a cycle)
4. *What state* the discipline is in (an open problem, not a deferred task)

**§the-named-honest-TODO-with-named-obstacle** — first-explicit-observation as a tier-3 meta-pattern. Compare to:
- Cycle 167's @endo/where named-TODO (§named-TODO)
- Cycle 183's @endo/init named-hole-with-named-mitigation
- Cycle 187's considered-and-rejected-named-alternative-with-named-reason

All four are different shapes of *honesty about what hasn't been done and why*. The cycle 336 shape is **goal + obstacle + admission-of-stuckness**, distinguished from cycle 183's **hole + mitigation** (we know what to do; we just can't do it here) and cycle 187's **alternative + reason** (we considered this path; here's why we didn't take it).

**§three-cycles-with-named-cross-package-layering-acknowledgment** (cycle 142's passStyle-helpers.js isPrimitive duplication + cycle 152's memo-race.js TODO + cycle 336's complementary observation of the same TODO with §name-both-the-goal-and-the-obstacle discipline) — wait, this is one TODO observed in two cycles. **§twice-observed-discipline-now-named** for the cycle 152 → 336 complementary observation arc.

## §the-named-helpers-private-export-single-public

The file declares five top-level names plus the export:

| Name | Visibility | Role |
|---|---|---|
| `isPrimitive` | private | Type predicate (duplicated with @endo/pass-style; named TODO) |
| `markSettled` | private | Atomic-transition helper |
| `knownPromises` | private | Module-scope WeakMap state |
| `getMemoRecord` | private | Memo lookup with primitive bypass |
| `race` (object-destructure) | private name, exported | Public API |
| `memoRace` (export rename) | exported | The package surface |

Five private names; one public export.

**§the-named-helpers-private-export-single-public** — first-explicit-observation. The file exposes a **single function** (`memoRace`); the helpers are private to the module. Compare to:
- Cycle 326 @endo/patterns/index.js: barrel-index aggregator exposing N exports (substrate-package shape)
- Cycle 333 @endo/common/README.md: no-barrel-index with one-file-one-export (collection-package shape)
- **Cycle 336 memo-race.js**: single-file-single-export with private helpers (utility-package shape)

**§the-named-three-shapes-of-export-discipline** — barrel-index (substrate) + one-file-one-export-no-index (collection) + single-file-single-export-with-private-helpers (utility). First-explicit-observation as a refinement of cycle 333's three-way collection/substrate/utility categorization, parameterized by **export shape** in addition to README shape.

**§the-named-export-the-noun-not-the-verbs** — first-explicit-observation. The file's `race` is the noun (a racing function); `markSettled`, `getMemoRecord` are the verbs (helpers that prepare the noun). Only the noun is exported. The verbs are private state-machine bookkeeping. **§the-named-private-state-machine-public-surface** as a related discipline.

## §the-named-in-place-transition-for-shared-references

Lines 72-84 (`markSettled`):

```js
const markSettled = record => {
  if (!record || record.settled) {
    return new Set();
  }

  const { deferreds } = record;
  Object.assign(record, {
    deferreds: undefined,
    settled: true,
  });
  Object.freeze(record);
  return deferreds;
};
```

The function uses `Object.assign(record, { ... })` to **mutate the record in place**, NOT to return a new record. Then `Object.freeze(record)` locks it.

**§the-named-in-place-transition-for-shared-references** — first-explicit-observation. The reason for in-place mutation: **multiple races hold pointers to the same record** (via `cachedValues` and via `getMemoRecord(value)`'s WeakMap lookup). If `markSettled` replaced the record (e.g., `knownPromises.set(value, frozenRecord)`), the existing pointers in other races would still reference the OLD pending record. In-place mutation ensures all holders see the transition.

**§the-named-assign-then-freeze-transition** — first-explicit-observation. Two-step transition: (1) `Object.assign` mutates the record in place; (2) `Object.freeze` locks it. The sequence matters: assign must happen first (freeze would prevent assign), then freeze locks the terminal state.

**§the-named-fake-record-honors-real-record-discipline** — first-explicit-observation. Line 97: `return harden({ settled: true });` for primitives. The fake record for primitives is `harden`-ed (not just returned plain). Why? Because real terminal records are `Object.freeze`-ed via `markSettled`; the fake record matches the *structural shape* of a real terminal record (frozen + `{ settled: true, deferreds: undefined }`). The fake honors the real record's discipline.

**§the-named-harden-vs-freeze-distinction-here** — `Object.freeze` for real records (already-deep-shallow records); `harden` for fake records (single-level objects from primitives). The two operations are equivalent for this shape; the choice tracks *whether the record was constructed or memoized*. **§the-named-construction-shape-determines-freeze-vs-harden** — first-explicit-observation.

## §the-named-named-function-via-object-destructure

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

## §the-named-cachedValues-defends-against-one-shot-iterables

Lines 138-144:

```js
race(values) {
  let deferred;
  /** @type {[...T]} */
  // @ts-expect-error filled by the loop
  const cachedValues = [];
  const C = this;
  const result = new C((resolve, reject) => {
    deferred = { resolve, reject };
    for (const value of values) {
      cachedValues.push(value);
      ...
```

The `cachedValues` array captures each value as the input iterable is walked. The `finally` callback (lines 159-166) later iterates `cachedValues`, NOT `values`.

**§the-named-cachedValues-defends-against-one-shot-iterables** — already noted in cycle 152, now reaffirmed with structural attention: the defense is necessary because generators and one-shot iterables would exhaust on the first `for-of` loop, leaving the `finally` callback with nothing to clean up. **§the-named-single-pass-with-cached-array-idiom** — first-explicit-observation in the complementary lens (algorithm view in cycle 152 named the defense; discipline view in cycle 336 names the idiom shape).

**§the-named-iterable-vs-array-discipline** — first-explicit-observation. The JSDoc declares `T extends readonly unknown[] | []` and `@param {T} values An iterable of Promises`. The TYPE says array; the WORD says iterable; the IMPLEMENTATION caches. The discipline: **document the broader contract (iterable) in prose; type the narrower constraint (array) in JSDoc; implement defensively for both**. Tier-3 meta-pattern.

**§the-named-ts-expect-error-with-named-cause** — line 139 inline: `// @ts-expect-error filled by the loop`. The type-system gap is acknowledged with a one-line reason. Compare to cycle 187's `@ts-expect-error 2454` with named issue number + cycle 211's `@ts-expect-error` with rationale comment. **§four-cycles-with-named-ts-expect-error-discipline** (146 + 187 + 211 + 336) — the discipline of naming the cause of every `@ts-expect-error`.

## §the-named-synchronous-registration-via-promise-constructor-body

Lines 142-155: the entire promise-input registration happens **synchronously** inside the `new C(...)` constructor's executor body. All values are walked, memoized, and registered with deferred sets before the constructor returns.

**§the-named-synchronous-registration-via-promise-constructor-body** — first-explicit-observation. The promise constructor's executor function is the natural synchronous registration point because: (a) it runs synchronously during `new Promise(...)`; (b) it captures `resolve`/`reject` for later use; (c) it sees the input iterable from the enclosing scope. The pattern: **use the promise constructor body as your synchronous-initialization hook** when you need to capture continuation references before any awaits.

Compare to cycle 173's @endo/promise-kit/src/promise-executor-kit.js (§executor-is-single-use, §reference-release-on-settle): the executor body in that file captures `internalResolve`/`internalReject` for later release; the cycle 336 memo-race executor body captures `deferred` for later cleanup. **§two-cycles-with-named-executor-body-as-synchronous-capture-hook** (173 + 336).

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 152 (memo-race.js comment-fragment) | 184 cycles | Complementary-lens re-ingest of same file |
| Cycle 335 (promise-kit README) | 1 cycle | Implementation-side closure of *deliberately-imperfect-ponyfill* |
| Cycle 173 (promise-executor-kit.js sibling) | 163 cycles | §executor-body-as-synchronous-capture-hook sibling |
| Cycle 187 (promise-kit/shim.js cluster) | 149 cycles | §unconditional-replacement of `Promise.race = memoRace` |
| Cycle 108 (exo-makers.js coordinated commit member) | 228 cycles | Same `e56bf00f` @endo/harden migration commit |
| Cycle 142 (passStyle-helpers.js isPrimitive duplication) | 194 cycles | §honest-duplication acknowledged from both sides |

**§six-citation-arc-closures-in-cycle-336**. **§fifty-citation-arc-closures-in-pivot-now** (49 + 1 new beyond cycle 335's three, after subtracting double-counted arcs). The accumulated count crosses the **50 citation-arc closures** threshold.

## Patterns the cycle extends

- §twenty-seven-cycles-with-named-pivot-domain-stay (310-336)
- §five-cycles-with-named-complementary-lens-re-ingest (322 exo-makers + 324 atomics + 330 smallcaps + 332 exo-tools + 336 memo-race) — librarian discipline confirmed across **five applications**
- §thirteen-named-packages-in-the-pivot-cluster (promise-kit's source file follow-up)
- §fifty-citation-arc-closures-in-pivot-now (49 + 1)
- §the-named-streak-resumes-after-one-cycle-gap (eighth instance of one-cycle README↔source pattern, isolated after cycle 334 → 335 broke the streak)
- §four-cycles-with-named-ts-expect-error-discipline (146 + 187 + 211 + 336)
- §two-cycles-with-named-executor-body-as-synchronous-capture-hook (173 + 336)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

- **§the-named-deviation-named-in-the-source-too** — when a README claims deliberate divergence, the source's JSDoc should name the divergence too
- **§the-named-implementation-of-the-accommodation** — the implementation-side expression of an abstract README claim
- **§the-named-honesty-at-two-levels-discipline** — package-level (README) + symbol-level (JSDoc)
- **§the-named-public-domain-license-header-preserved-verbatim** — preserve the original author's dedication block when adopting public-domain code
- **§the-named-attribution-discipline-when-adopting-public-domain-code**
- **§the-named-canonical-URL-as-provenance** — link to the code's original location, not a recreation
- **§the-named-licensing-asymmetry-within-a-single-package** — file header license can differ from package LICENSE
- **§the-named-name-both-the-goal-and-the-obstacle** — TODOs should name what to do AND why it hasn't been done
- **§the-named-honest-TODO-with-named-obstacle**
- **§the-named-helpers-private-export-single-public** — utility-package files expose one symbol; helpers are private
- **§the-named-export-the-noun-not-the-verbs**
- **§the-named-private-state-machine-public-surface**
- **§the-named-three-shapes-of-export-discipline** — barrel-index + one-file-one-export-no-index + single-file-single-export-with-private-helpers
- **§the-named-in-place-transition-for-shared-references** — mutate, don't replace, when multiple holders share the reference
- **§the-named-assign-then-freeze-transition** — two-step terminal-state lock
- **§the-named-fake-record-honors-real-record-discipline** — sentinel objects match real-record structural shape
- **§the-named-construction-shape-determines-freeze-vs-harden** — choose the freezing primitive that matches the record's construction shape
- **§the-named-named-function-via-object-destructure** — method-syntax + object-destructure + named-binding in one idiom
- **§the-named-api-name-vs-impl-name-asymmetry** — internal generic name; external qualified name
- **§the-named-impl-name-is-generic-API-name-is-qualified**
- **§the-named-JSDoc-generic-this-binding** — subclassability expressed entirely in JSDoc machinery
- **§the-named-subclassable-via-JSDoc-only**
- **§the-named-JSDoc-as-three-tools** — semantic-marker + type-level-surgery + generic-this-binding
- **§the-named-iterable-vs-array-discipline** — broader contract in prose; narrower in JSDoc; defensive implementation
- **§the-named-single-pass-with-cached-array-idiom**
- **§the-named-synchronous-registration-via-promise-constructor-body**

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-seven-cycles-with-named-pivot-domain-stay
- §five-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330 + 332 + 336) — the librarian discipline crosses five applications
- §fifty-citation-arc-closures-in-pivot-now
- §the-named-streak-resumes-after-one-cycle-gap
- §four-cycles-with-named-ts-expect-error-discipline (146 + 187 + 211 + 336)
- §two-cycles-with-named-executor-body-as-synchronous-capture-hook (173 + 336)

## Tier-3 borrowing (meta-patterns)

- **§the-named-deviation-named-in-the-source-too** — when the README claims deliberate divergence, the source should NAME the divergence at the JSDoc level too
- **§the-named-honesty-at-two-levels-discipline** — package-level (README) and symbol-level (JSDoc) honesty are independent commitments
- **§the-named-attribution-discipline-when-adopting-public-domain-code** — preserve the original dedication block verbatim
- **§the-named-name-both-the-goal-and-the-obstacle** — honest TODOs name what to do AND why it hasn't been done
- **§the-named-three-shapes-of-export-discipline** — barrel-index, one-file-one-export-no-index, single-file-single-export-with-private-helpers; each tracks a package category
- **§the-named-in-place-transition-for-shared-references** — mutate when multiple holders share the reference; replace would orphan
- **§the-named-JSDoc-as-three-tools** — semantic-marker + type-level-surgery + generic-this-binding
- **§the-named-iterable-vs-array-discipline** — document the broader contract; type the narrower constraint; implement defensively
- **§the-named-synchronous-registration-via-promise-constructor-body** — the promise executor body as your initialization hook

## Synthesis-target

Slot machine library **§`@game/promise-kit/src/memo-race.js`** — memory-safe race primitive:

1. **Deviation named at the source level** — if the package README claims deliberate imperfection, the source's JSDoc should ALSO name the deviation (e.g., *"Unlike `Promise.race` ..."*).
2. **Public-domain dedication preserved verbatim** if adopting public-domain code from a named author; include the original URL.
3. **Honest TODO with named obstacle** — when a duplication can't be eliminated, the TODO names BOTH the goal AND the layering constraint blocking it.
4. **Helpers private; single public export** — utility files expose one function; helpers stay private.
5. **In-place transition for shared references** — when multiple holders share a record, mutate in place; replace would orphan.
6. **Assign-then-freeze transition** — two-step lock for terminal state.
7. **Fake record honors real record discipline** — sentinel objects match the real record's structural shape (frozen / hardened / same field names).
8. **Named function via object-destructure** — `const { race } = { race(values) { ... } }` for non-constructable + prototype-less + named.
9. **API name vs impl name asymmetry** — internal generic name (`race`); external qualified name (`memoRace`).
10. **Subclassable via JSDoc only** — express constructor-genericity through `@this {P}` and `@template {PromiseConstructor} [P]`; no class declaration needed.
11. **Iterable vs array discipline** — document the broader contract; type the narrower; implement defensively.
12. **Synchronous registration via promise constructor body** — use `new Promise((resolve, reject) => { /* register inputs here */ })` for your synchronous-initialization hook.

## Library state after cycle 336

- §library-reaches-848-sections from 381 source documents (source count unchanged because memo-race.js was already counted from cycle 152)
- §one-hundred-and-sixty-ninth consecutive designs-chat alternation
- §twenty-seven-cycles-with-named-pivot-domain-stay
- §thirteen-named-packages-in-the-pivot-cluster (promise-kit's source file second observation)
- §fifty-citation-arc-closures-in-pivot-now
- §five-cycles-with-named-complementary-lens-re-ingest (librarian discipline confirmed across five applications)
- §the-named-streak-resumes-after-one-cycle-gap (eighth instance of one-cycle README↔source pattern)
- §the-named-deviation-named-in-the-source-too established as a tier-3 meta-pattern
- §the-named-honesty-at-two-levels-discipline (README + JSDoc) established as a tier-3 meta-pattern
- §the-named-attribution-discipline-when-adopting-public-domain-code established as a tier-3 meta-pattern
- §the-named-three-shapes-of-export-discipline established as a tier-3 meta-pattern parameterizing cycle 333's three-way package categorization
