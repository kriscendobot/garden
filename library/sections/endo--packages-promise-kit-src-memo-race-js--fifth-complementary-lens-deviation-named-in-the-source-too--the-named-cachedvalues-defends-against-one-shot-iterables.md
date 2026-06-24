---
title: §the-named-cachedValues-defends-against-one-shot-iterables
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
