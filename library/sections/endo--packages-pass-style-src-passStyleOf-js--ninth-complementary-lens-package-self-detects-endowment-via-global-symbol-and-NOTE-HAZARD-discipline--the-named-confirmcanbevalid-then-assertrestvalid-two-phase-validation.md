---
title: §the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation
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

The helpers implement a two-phase validation:
- `helper.confirmCanBeValid(inner, reject)` — checks structural applicability (silent or throwing depending on `reject`)
- `helper.assertRestValid(inner, passStyleOfRecur)` — checks the remaining requirements

```js
for (const helper of passStyleHelpers) {
  if (helper.confirmCanBeValid(inner, false)) {
    helper.assertRestValid(inner, passStyleOfRecur);
    return helper.styleName;
  }
}
```

**§the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation** — first-explicit-observation. The discipline:
1. **Phase 1**: silent check whether the helper APPLIES to this candidate
2. **Phase 2**: assert the REMAINING requirements (throws on failure)

If phase 1 returns false, try the next helper. If phase 2 throws, the entire passStyleOf throws (no fallback).

**§the-named-two-phase-validation-with-silent-applicability-then-throwing-completeness** — first-explicit-observation as a tier-3 meta-pattern. Sibling to cycle 102 @endo/patterns/checkKey.js's §the-named-trio-pattern (Confirm/Is/Assert); cycle 350's two-phase pattern is the DISPATCH version where the question is "which helper applies?".
