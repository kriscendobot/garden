---
title: Synthesis-target
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
