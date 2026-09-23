---
title: §the-named-in-place-transition-for-shared-references
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
