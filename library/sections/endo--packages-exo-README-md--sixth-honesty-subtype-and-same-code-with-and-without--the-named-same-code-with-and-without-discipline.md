---
title: §the-named-same-code-with-and-without-discipline
source: endo--packages-exo-README-md
url: https://github.com/endojs/endo/blob/master/packages/exo/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/exo/README.md
total-lines: 364
ingest-cycle: 331
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-honesty-about-API-tradeoffs-gains-sixth-subtype
  - the-named-functionality-in-different-org-subtype
  - the-named-cross-org-pointer-to-Agoric
  - the-named-same-code-with-and-without-discipline
  - the-named-Exo-IS-Far-plus-InterfaceGuard-combination
  - the-named-three-patterns-for-creating-exos
  - the-named-makeExo-defineExoClass-defineExoClassKit-trio
  - the-named-Why-Exo-side-by-side-comparison
  - the-named-when-to-use-checklist-discipline
  - the-named-least-authority-as-named-discipline
  - the-named-canonical-three-facet-example
  - the-named-this.state-and-this.facets-canonical-shapes
  - the-named-M.callWhen-three-or-four-step-semantics
  - the-named-GET_INTERFACE_GUARD-as-meta-method
  - the-named-four-named-uses-of-interface-introspection
  - the-named-cache-staleness-on-upgrade-warning
  - the-named-three-runtime-backing-tiers
  - the-named-positive-when-to-use-after-pointing-elsewhere
  - twenty-two-cycles-with-named-pivot-domain-stay
  - six-cycles-with-named-honesty-about-API-tradeoffs
  - four-cycles-with-named-role-label-before-package-name
  - four-cycles-with-named-monorepo-docs-reference
  - four-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
  - thirty-five-citation-arc-closures-in-pivot-now
parent: endo--packages-exo-README-md--sixth-honesty-subtype-and-same-code-with-and-without
---

The Why-Exo section (line 19-55) shows the *literally same counter logic* twice:

```js
// Far object - no validation
const counter1 = Far('Counter', {
  increment(n) {
    count += n;  // What if n is not a number? undefined? a string?
    return count;
  }
});

// Exo - automatic validation
const counter2 = makeExo('Counter', CounterI, {
  increment(n) {
    count += n;  // n is guaranteed to be a number by the guard
    return count;
  }
});
```

Plus the failing case (`counter2.increment('5'); // throws`). The code is *identical* except for the wrapping factory (`Far` vs `makeExo`); the only difference is what the validation does. The same comment changes meaning between the two: *"What if n is not a number?"* in the Far version becomes *"n is guaranteed to be a number"* in the Exo version. **§the-named-same-code-with-and-without-discipline** — first-explicit-observation.

Sibling to cycle 329 marshal README's side-by-side smallcaps/original comparison (which showed the same NaN in two output formats). **§two-cycles-with-named-side-by-side-comparison-discipline** (329 + 331) — the discipline of *showing the same input/code in two different contexts simultaneously* recurs. Different from cycle 327's three Why-X sections (which compared chosen design vs natural alternative in *prose*); here the comparison is in *code blocks*.
