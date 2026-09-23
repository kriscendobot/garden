---
title: §the-named-explicit-acknowledgment-of-cross-package-layering-constraint
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
