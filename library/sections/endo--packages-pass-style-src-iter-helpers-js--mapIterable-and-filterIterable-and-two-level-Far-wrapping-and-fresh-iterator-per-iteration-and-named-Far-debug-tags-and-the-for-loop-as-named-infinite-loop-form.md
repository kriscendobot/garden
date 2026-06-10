---
title: "@endo/pass-style/src/iter-helpers.js — mapIterable + filterIterable + two-level Far wrapping + fresh-iterator-per-iteration + named Far debug tags + `for (;;)` as named infinite-loop form"
source-slug: endo--packages-pass-style-src-iter-helpers-js
section-slug: mapIterable-and-filterIterable-and-two-level-Far-wrapping-and-fresh-iterator-per-iteration-and-named-Far-debug-tags-and-the-for-loop-as-named-infinite-loop-form
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/iter-helpers.js
source-repo: endojs/endo
source-path: packages/pass-style/src/iter-helpers.js
source-author: Endo project (collective)
total-lines: 60
ingest-cycle: 274
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/iter-helpers.js` — the second cluster utility module

A 60-line file that exports two iterator-helper utilities: `mapIterable` + `filterIterable`. **The last uningested pass-style source file** — cycle 274 completes the pass-style cluster's source-file ingest.

§First-explicit-observation in library: **§two-cycles-with-utility-file-shape-in-the-pass-style-cluster (272 string utility + 274 iter-helpers utility) — §the-cluster-has-two-named-file-shapes-instantiated-twice; §the-pattern-from-cycle-272-now-confirmed-as-a-cluster-discipline-not-a-singleton**.

§Pass-style cluster source-file ingest now complete:
- **Helper-files** (PassStyleHelper concrete instances): cycle 260 byteArray + 262 copyArray + 264 copyRecord + 268 tagged.
- **Utility-files**: cycle 272 string + 274 iter-helpers.
- **Metalanguage-file**: cycle 266 internal-types.
- **Constructor-file**: cycle 270 makeTagged.
- Plus the helpers-cluster sibling page (passStyle-helpers.js, ingested at an earlier cycle).

## §Two-level Far wrapping — iterable AND iterator are both Far

Lines 17-28 (mapIterable) and 44-58 (filterIterable) share a §two-level-Far-wrapping shape:

```js
Far('mapped iterable', {
  [Symbol.iterator]: () => {
    const baseIterator = baseIterable[Symbol.iterator]();
    return Far('mapped iterator', {
      next: () => { ... },
    });
  },
});
```

§First-explicit-observation in library: **§two-level-Far-wrapping-for-iterable-and-iterator — §the-outer-`Far('mapped iterable', ...)`-wraps-the-iterable-object + §the-inner-`Far('mapped iterator', ...)`-wraps-the-iterator-object + §both-levels-IS-Far-because-both-IS-passable**.

§Sibling-pattern to many capability-systems' wrap-everything discipline; §the-helper-doesn't-leak-bare-iteration-state + §every-returned-object-IS-a-passable-Far-reference.

§The-fresh-iterator-per-iteration-discipline — §`Symbol.iterator`-on-the-iterable-IS-a-FACTORY-not-a-getter; §every-call-to-`Symbol.iterator`-creates-a-NEW-iterator; §the-mapIterable-IS-an-iterable-NOT-an-iterator; §sibling-pattern to JavaScript's iterator protocol convention.

§First-explicit-observation in library: **§fresh-iterator-per-iteration-as-named-Far-wrapping-discipline — §when-a-helper-returns-a-derived-iterable, §the-`Symbol.iterator`-factory-creates-a-fresh-iterator-per-iteration + §each-iterator-IS-its-own-Far-reference**.

## §Named Far debug tags — descriptive iface tags

§Four named Far tags in 60 lines:
1. `'mapped iterable'`.
2. `'mapped iterator'`.
3. `'filtered iterable'`.
4. `'filtered iterator'`.

§First-explicit-observation in library: **§named-Far-debug-tags-as-named-debug-aid — §the-tags-IS-descriptive-not-numeric + §they-show-up-in-Far-introspection + §the-shape-`<verb>ed <noun>`-IS-the-convention (mapped iterable + filtered iterable)**.

§Sibling-pattern to cycle 134's make-far.js's `Alleged: Foo` discipline + cycle 136's named iface tags; §the-Far-tag-IS-the-iface-introspection-string; §two-named-shape-conventions in the @endo cluster: `Alleged: Foo` (untrusted) + `<verb>ed <noun>` (trusted derived).

## §mapIterable preserves element count + termination

Lines 4-9 (the JSDoc):
> *The result iterator has as many elements as the `baseIterator` and have the same termination — the same completion value or failure reason. But the non-final values are the corresponding non-final values from `baseIterator` as transformed by `func`.*

§First-explicit-observation in library: **§element-count-and-termination-shape-preservation-as-named-iterator-contract — §the-result-iterator-has-the-same-number-of-elements + §the-same-termination-shape (completion-value or failure-reason) + §only-the-non-final-values-differ**.

§Two-named-termination-kinds (completion-value + failure-reason) — §sibling-pattern to many iterator protocols that have a single "done" state but where the "done"-value can carry payload (the iterator return-value); §the-design-distinguishes-these-explicitly.

§Lines 22-24 (the mapIterable's next):
```js
const { value: baseValue, done } = baseIterator.next();
const value = done ? baseValue : func(baseValue);
return harden({ value, done: !!done });
```

§The-`done ? baseValue : func(baseValue)`-discriminator — §when-done-pass-the-baseValue-through-unchanged + §when-not-done-apply-the-mapping-function; §the-termination-value-IS-NOT-transformed (it's the iterator's completion signal, not a regular element).

§First-explicit-observation in library: **§the-discriminator-`done ? baseValue : func(baseValue)`-IS-the-named-termination-aware-transformation — §the-termination-value-IS-preserved-not-transformed + §only-the-non-final-values-flow-through-`func`**.

§The-`!!done`-boolean-coercion-as-named-defensive-discipline — §the-base-iterator-may-return-a-truthy-non-boolean-`done`; §the-helper-coerces-to-strict-boolean; §sibling-pattern to many defensive-coercion patterns; §first-explicit-observation in library.

## §filterIterable uses `for (;;)` infinite loop with skip-or-return

Lines 47-56 (the filterIterable's next):
```js
return Far('filtered iterator', {
  next: () => {
    for (;;) {
      const result = baseIterator.next();
      const { value, done } = result;
      if (done || pred(value)) {
        return result;
      }
    }
  },
});
```

§First-explicit-observation in library: **§the-`for (;;)`-as-named-infinite-loop-form — §the-pattern-IS-`for (;;)`-not-`while (true)` + §sibling-pattern to many systems-language conventions (C/C++)**.

§The-skip-or-return-shape — §inside-the-loop-call-the-base-next + §if-done-OR-pred-passes-return-the-result + §otherwise-loop-again-(skip-the-value); §the-loop-terminates-when-the-base-iterator-runs-out-or-when-a-value-passes-the-predicate.

§The-result-pass-through (line 53: `return result`) — §the-helper-returns-the-base-iterator's-result-object-DIRECTLY-not-a-reconstructed-one; §the-shape-IS-preserved-by-the-base-iterator + §the-helper-doesn't-rewrap; §sibling-pattern to many forwarding-iterator-conventions.

§First-explicit-observation in library: **§the-skip-or-return-loop-shape-in-filterIterable-uses-pass-through-not-rewrap-for-the-result-object**.

## §Two named iterator-result-shapes

The two utilities demonstrate §two-named-iterator-result-shapes:

| Helper          | Input shape   | Output shape  | Element-count change | Element-value change |
|-----------------|---------------|---------------|----------------------|----------------------|
| `mapIterable`   | `Iterable<T>` | `Iterable<U>` | unchanged            | transformed via func |
| `filterIterable`| `Iterable<T>` | `Iterable<T>` | shrunk (filtered)    | unchanged            |

§First-explicit-observation in library: **§two-named-iterator-result-shapes (same-element-count-transformed-values + subset-with-unchanged-values) — §the-cluster-pedagogy-of-two-utilities-with-different-shape-changes**.

§Sibling-pattern to functional-programming's map+filter duality; §the-cluster-presents-the-canonical-pair.

§Each-helper-IS-typed-via-template-parameters — §`mapIterable` uses `<T,U>` (input + output types differ); §`filterIterable` uses `<T>` (input = output); §the-template-parameter-count-correlates-with-the-shape-change.

§First-explicit-observation in library: **§the-template-parameter-count-correlates-with-the-shape-change (mapIterable has two; filterIterable has one) — §the-type-system-encodes-the-shape-change-discipline**.

## §The factory-harden-after-export idiom reappears

Lines 29 and 60: `harden(mapIterable);` and `harden(filterIterable);` — both factories hardened AFTER export.

§Two-cycles-with-factory-harden-after-export-idiom (270 makeTagged + 274 iter-helpers' two factories); §the-discipline-IS-now-canonical-across-three-named-factories (cycle 270's makeTagged + cycle 274's mapIterable + filterIterable).

§First-explicit-observation in library: **§three-named-factories-with-factory-harden-after-export-idiom — §the-discipline-IS-now-canonical-across-three-instances**.

## §The pass-style cluster source-file ingest IS now complete

Cycle 274 ingests the last source file in `@endo/pass-style/src/`. The cluster's source-file ingest is now **structurally complete**:

| File class       | Files                                                | Cycles ingesting              |
|------------------|------------------------------------------------------|-------------------------------|
| Helper-files     | byteArray + copyArray + copyRecord + tagged          | 260 + 262 + 264 + 268         |
| Utility-files    | string + iter-helpers                                | 272 + 274                     |
| Metalanguage     | internal-types                                       | 266                           |
| Constructor      | makeTagged                                           | 270                           |
| Helpers cluster  | passStyle-helpers (cluster-sibling)                  | earlier                       |
| Other ingested earlier | passStyleOf + remotable + symbol + typeGuards + deeplyFulfilled + error + make-far + safe-promise + tagged + types | earlier cycles |

§First-explicit-observation in library: **§the-pass-style-cluster-source-file-ingest-IS-now-structurally-complete — §every-`.js`-source-file-in-`packages/pass-style/src/`-has-been-ingested-at-some-cycle + §the-cluster-IS-a-completed-survey**.

§Two-named-file-classes (helper-files + utility-files) confirmed twice each; §the-cluster's-file-shape-taxonomy-IS-now-canonical.

## §Cycle 274 first-explicit-observations roundup (nine)

1. **§two-cycles-with-utility-file-shape-in-the-pass-style-cluster** (272 string + 274 iter-helpers).
2. **§two-level-Far-wrapping-for-iterable-and-iterator**.
3. **§fresh-iterator-per-iteration-as-named-Far-wrapping-discipline**.
4. **§named-Far-debug-tags-as-named-debug-aid** with the `<verb>ed <noun>` convention.
5. **§element-count-and-termination-shape-preservation-as-named-iterator-contract**.
6. **§the-discriminator-`done ? baseValue : func(baseValue)`-IS-the-named-termination-aware-transformation**.
7. **§the-`!!done`-boolean-coercion-as-named-defensive-discipline**.
8. **§the-`for (;;)`-as-named-infinite-loop-form**.
9. **§the-skip-or-return-loop-shape-in-filterIterable-uses-pass-through-not-rewrap-for-the-result-object**.
10. **§two-named-iterator-result-shapes** (same-element-count-transformed-values + subset-with-unchanged-values).
11. **§the-template-parameter-count-correlates-with-the-shape-change**.
12. **§three-named-factories-with-factory-harden-after-export-idiom** (270 makeTagged + 274 mapIterable + 274 filterIterable).
13. **§the-pass-style-cluster-source-file-ingest-IS-now-structurally-complete**.

## §Recurring meta-pattern counters bumped at cycle 274

- §**two-cycles-with-utility-file-shape-in-the-pass-style-cluster** (272 + 274).
- §**three-named-factories-with-factory-harden-after-export-idiom** (270 makeTagged + 274 mapIterable + 274 filterIterable).
- §**one-hundred-and-seventh consecutive designs-chat alternation cycles 166-250 + 252-274** (251 was out-of-band).
- §**the-pass-style-cluster-source-file-ingest-IS-now-structurally-complete**.

## §Synthesis target — slot machine library

§Two-iterator-utilities-as-the-cluster-pedagogy applies to the §game-engine-cluster:

- §**`mapGameRoll`** — transforms each dice-roll value while preserving the roll-count + termination shape.
- §**`filterGameRoll`** — subsets the rolls (e.g., only rolls above a threshold) while preserving the termination.
- §**§two-level-Far-wrapping** — the `GameRollIterable` and `GameRollIterator` are both Far references.
- §**§fresh-iterator-per-iteration** — each call to `Symbol.iterator` on a GameRollIterable creates a fresh iterator.
- §**§named-Far-debug-tags** with the `<verb>ed <noun>` convention (e.g., `'capped game rolls'`, `'high-pass game rolls'`).
- §**§factory-harden-after-export idiom** for both `mapGameRoll` and `filterGameRoll`.

## §Tier-1 borrowing

§two-cycles-with-utility-file-shape-in-the-pass-style-cluster + §two-level-Far-wrapping-for-iterable-and-iterator + §fresh-iterator-per-iteration-as-named-Far-wrapping-discipline + §named-Far-debug-tags-as-named-debug-aid + §element-count-and-termination-shape-preservation-as-named-iterator-contract + §the-discriminator-`done ? baseValue : func(baseValue)` + §the-`!!done`-boolean-coercion-as-named-defensive-discipline + §the-`for (;;)`-as-named-infinite-loop-form + §two-named-iterator-result-shapes + §the-template-parameter-count-correlates-with-the-shape-change.

## §Tier-2 borrowing

§the-skip-or-return-loop-shape-uses-pass-through-not-rewrap + §`<verb>ed <noun>`-naming-convention-for-derived-Far-references + §three-named-factories-with-factory-harden-after-export-idiom.

## §Tier-3 borrowing

§the-pass-style-cluster-source-file-ingest-IS-now-structurally-complete + §library-reaches-780-sections at cycle 274 + §one-hundred-and-seventh consecutive designs-chat alternation cycles 166-250 + 252-274.

## Pattern summary (tag-prefixed)

§the-second-cluster-utility-module + §two-cycles-with-utility-file-shape-in-the-pass-style-cluster (272 + 274) + §two-level-Far-wrapping-for-iterable-and-iterator (mapped iterable + mapped iterator) + §fresh-iterator-per-iteration-as-named-Far-wrapping-discipline + §named-Far-debug-tags-as-named-debug-aid (`<verb>ed <noun>` convention) + §element-count-and-termination-shape-preservation-as-named-iterator-contract + §two-named-termination-kinds (completion-value + failure-reason) + §the-discriminator-`done ? baseValue : func(baseValue)`-IS-the-named-termination-aware-transformation + §the-`!!done`-boolean-coercion-as-named-defensive-discipline + §the-`for (;;)`-as-named-infinite-loop-form + §the-skip-or-return-loop-shape-uses-pass-through-not-rewrap + §two-named-iterator-result-shapes (same-element-count-transformed-values + subset-with-unchanged-values) + §the-template-parameter-count-correlates-with-the-shape-change + §three-named-factories-with-factory-harden-after-export-idiom (270 + 274 × 2) + §the-pass-style-cluster-source-file-ingest-IS-now-structurally-complete.
