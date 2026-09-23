---
title: §the-named-helper-table-with-assertions-on-table-construction
source: endo--packages-pass-style-src-passStyleOf-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/passStyleOf.js
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/passStyleOf.js
total-lines: 405
ingest-cycle: 350
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-package-self-detects-endowment-via-global-symbol
  - the-named-PassStyleOfEndowmentSymbol-as-canonical-name
  - the-named-NOTE-HAZARD-comment-discipline
  - the-named-liveslots-as-canonical-endower
  - the-named-isFrozen-check-at-the-evolution-points
  - the-named-TypedArrays-get-special-treatment-error-distinction
  - the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation
  - the-named-helper-table-with-assertions-on-table-construction
  - the-named-defensive-init-pattern-for-registries
  - the-named-PASS_STYLE-as-well-known-tag-symbol
  - the-named-complementary-lens-re-ingest
  - nine-cycles-with-named-complementary-lens-re-ingest
  - the-named-citation-arc-from-cycle-71-takes-279-cycles-to-close
  - forty-one-cycles-with-named-pivot-domain-stay
  - one-hundred-forty-two-citation-arc-closures-in-pivot-now
parent: endo--packages-pass-style-src-passStyleOf-js--ninth-complementary-lens-package-self-detects-endowment-via-global-symbol-and-NOTE-HAZARD-discipline
---

Lines 46-69 — `makeHelperTable`:

```js
const makeHelperTable = passStyleHelpers => {
  const HelperTable = {
    __proto__: null,
    copyArray: undefined,
    byteArray: undefined,
    copyRecord: undefined,
    tagged: undefined,
    error: undefined,
    remotable: undefined,
  };
  for (const helper of passStyleHelpers) {
    const { styleName } = helper;
    styleName in HelperTable || Fail`Unrecognized helper: ${q(styleName)}`;
    HelperTable[styleName] === undefined ||
      Fail`conflicting helpers for ${q(styleName)}`;
    HelperTable[styleName] = helper;
  }
  for (const styleName of ownKeys(HelperTable)) {
    HelperTable[styleName] !== undefined ||
      Fail`missing helper for ${q(styleName)}`;
  }
  return harden(HelperTable);
};
```

**§the-named-helper-table-with-assertions-on-table-construction** — first-explicit-observation. The table construction asserts THREE invariants:
1. **No unknown helpers**: every helper's styleName must be in the expected set
2. **No duplicates**: no two helpers can claim the same styleName
3. **No missing**: every expected styleName must have a helper

**§the-named-defensive-init-pattern-for-registries** — first-explicit-observation as a tier-3 meta-pattern. When a module's correctness depends on a registry being complete and unambiguous, the init code should ASSERT all invariants at construction time.

**§the-named-null-prototype-table** — first-explicit-observation. `{ __proto__: null }` creates an object with no prototype chain — defends against Object.prototype pollution. Each named entry is pre-declared as `undefined` so the `in` check is sound.
