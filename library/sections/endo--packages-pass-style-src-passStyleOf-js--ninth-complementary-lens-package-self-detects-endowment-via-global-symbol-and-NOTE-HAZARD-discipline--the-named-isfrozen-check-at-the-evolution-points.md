---
title: §the-named-isFrozen-check-at-the-evolution-points
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

Lines 167 and 201 are the TWO POINTS where passStyleOf currently checks `isFrozen`:

```js
// Line 167 (object case):
if (!isFrozen(inner)) {
  assert.fail(
    isTypedArray(inner)
      ? X`Cannot pass mutable typed arrays like ${inner}.`
      : X`Cannot pass non-frozen objects like ${inner}. Use harden()`,
  );
}

// Line 201 (function case):
isFrozen(inner) ||
  Fail`Cannot pass non-frozen objects like ${inner}. Use harden()`;
```

**§the-named-isFrozen-check-at-the-evolution-points** — first-explicit-observation. Cycle 349's preparing-for-stabilize.md said: *"`passStyleOf` instead checked that each relevant object is frozen... With these changes, even such manual transitive freezing will not make an object passable."* Cycle 350 reveals the **two specific lines** where the change will land — line 167 (objects) and line 201 (functions).

**§the-named-known-future-change-site-named-at-implementation-level** — first-explicit-observation. Cycle 349's design-doc cycle 350's source-level evolution-point identification. Tier-3 framing: when a future change is described at the design level, identifying the SPECIFIC SOURCE LINES that will change is the implementation-level closure.

**§the-named-TypedArrays-get-special-treatment-error-distinction** — first-explicit-observation. Line 169-172 distinguishes the error message: TypedArrays get *"Cannot pass mutable typed arrays like X"* while other non-frozen objects get *"Cannot pass non-frozen objects like X. Use harden()"*. The error message tells the caller WHY harden() won't help (TypedArrays have special treatment in harden()).

**§the-named-error-message-discriminates-by-failure-cause** — first-explicit-observation as a tier-3 meta-pattern. When the same predicate fails for two different structural reasons, the error message should DISCRIMINATE the reason so the caller knows the appropriate remedy.
