---
title: "@endo/exo README.md — sixth honesty-about-API-tradeoffs subtype (functionality-in-different-org via @agoric/vat-data pointer); same-code-with-and-without comparison; canonical three-facet least-authority example; closes seven citation arcs"
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
---

# `@endo/exo README.md` — sixth honesty-about-API-tradeoffs subtype; same-code-with-and-without

The 364-line README for `@endo/exo`. Cycle 331 is **designs-lane after cycle 330's chat-lane @endo/marshal/src/encodeToSmallcaps.js**. **Twenty-second consecutive non-garden source after the pivot** (cycles 310-331). **§twenty-two-cycles-with-named-pivot-domain-stay**. **Seventh package extends** (exo; cycles 108 + 118 + 239 + 322 previously ingested exo files).

## The single most structurally interesting move

**§the-named-honesty-about-API-tradeoffs gains a sixth subtype** — line 327-346 ("Virtual and Durable Exos" section) points to **@agoric/vat-data** for production exo variants:

> This package provides **heap-based exos** that don't survive vat termination. For production systems with high cardinality or upgrade requirements, see:
> - **[@agoric/vat-data](https://github.com/Agoric/agoric-sdk/tree/master/packages/vat-data)** — Provides: `defineVirtualExoClass`, `defineDurableExoClass`, `prepareExoClass`, `prepareExoClassKit`

**§the-named-cross-org-pointer-to-Agoric** — first-explicit-observation. The pointer crosses the **organizational boundary** from Endo (the @endo/* family) to Agoric (the @agoric/* family). This is the **sixth named subtype** of §the-named-honesty-about-API-tradeoffs:

| Subtype | Cycle | Phrase / pointer-to |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |
| Functionality-elsewhere | 325 | "For validation, see @endo/exo" (sibling Endo package) |
| Documentation-language-cannot-express | 326 | "JSDoc cannot express these" |
| Functionality-not-supported-at-all | 329 | "The marshal-based alternatives do not" |
| **Functionality-in-different-org** | **331** | **"see @agoric/vat-data"** (different org/repository) |

**§six-cycles-with-named-honesty-about-API-tradeoffs** (321 + 323 + 325 + 326 + 329 + 331) — the parameterized meta-pattern now spans six cycles with six distinct subtypes. The sixth subtype is *structurally different* from cycle 325's "functionality-elsewhere" because Agoric is a *different organization/repository*, not just a different package within the same family. **§the-named-cross-org-discipline-IS-named-organizational-boundary-crossing** — when a sibling-product in a different organization handles a related use case, name it explicitly.

**§the-named-positive-when-to-use-after-pointing-elsewhere** (line 342-346) — after pointing to Agoric for the production use cases, the README names what heap-exos *are* ideal for (development/testing + low cardinality + temporary session state + non-critical services). The pattern: when pointing elsewhere for X, also explicitly state what THIS package IS good for. **§the-named-scope-positive-naming-after-cross-pointer**. First-explicit-observation.

## §the-named-same-code-with-and-without-discipline

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

## Citation arcs closed

Cycle 331 closes **six clean citation arcs**:

| Closes arc with | Arc length | How |
|---|---|---|
| Cycle 108 (exo-makers.js comment-fragment) | 223 cycles | README describes the factory trio (makeExo + defineExoClass + defineExoClassKit) |
| Cycle 118 (exo-tools.js comment-fragment) | 213 cycles | README describes the guards-validate-automatically discipline |
| Cycle 239 (get-interface.js) | 92 cycles | README has dedicated GET_INTERFACE_GUARD section (line 297-325) |
| Cycle 322 (exo-makers.js full-source) | 9 cycles | README describes the factory trio with worked examples |
| Cycle 325 (pass-style README) | 6 cycles | "Foundation: @endo/pass-style" role-label |
| Cycle 327 (patterns README) | 4 cycles | "Validation: @endo/patterns" role-label |

**§thirty-five-citation-arc-closures-in-pivot-now** (29 + 6).

## Other key moves

- **§the-named-Exo-IS-Far-plus-InterfaceGuard-combination** (line 1-12) — opening defines Exo as `Far + InterfaceGuard`. Two ingredients combine into a defensive remotable. First-explicit-observation.

- **§the-named-three-patterns-for-creating-exos** with **§the-named-makeExo-defineExoClass-defineExoClassKit-trio** (line 14-17) — the three factories named with one-line description each. Cycle 322 source already documented the trio; this README is the documentation-side closure.

- **§the-named-Why-Exo-section-with-Far-comparison** (line 19-55) — *Why-X-section-discipline* applied to a single binary comparison (Far vs Exo). §two-cycles-with-named-Why-X-section-discipline (327 patterns + 331 exo) — first-explicit-observation as a recurring discipline.

- **§the-named-when-to-use-checklist-discipline** (line 80-83, 124-126, 193-197) — each of the three patterns has a "When to use:" bullet list. Three checklists in one README. **§three-when-to-use-bullets-per-pattern**. First-explicit-observation.

- **§the-named-least-authority-as-named-discipline** (line 135-136) — *"the key pattern for least authority: give each client only the facet they need"*. Names capability-security discipline. First-explicit-observation. Closes citation arc with cycle 322 exo-makers.js (which discussed amplify capability for inter-facet access).

- **§the-named-canonical-three-facet-example** (line 142-191) — *up* (increment) + *down* (decrement) + *reader* (getValue). The canonical least-authority illustration: each client gets only the facet they need. **§the-named-incrementer-decrementer-reader-canonical-trio** — first-explicit-observation. Sibling to cycle 321 eventual-send's mint→purse→payment→deposit canonical example.

- **§the-named-this.state-and-this.facets-canonical-shapes** — `this.state` is per-instance (defineExoClass) or shared (defineExoClassKit); `this.facets` for inter-facet communication (defineExoClassKit only).

- **§the-named-M.callWhen-three-or-four-step-semantics** (line 226-230) — four numbered steps: validate pattern → await if promise → validate resolved value → call method. **§the-named-numbered-step-semantics-discipline**. First-explicit-observation. Closes cycle 327 patterns README arc (which named M.callWhen as async-method-guard).

- **§the-named-GET_INTERFACE_GUARD-as-meta-method** (line 297-325) — dedicated section on runtime interface introspection. **§the-named-four-named-uses-of-interface-introspection** (runtime discovery + dynamic client generation + documentation generation + protocol negotiation). First-explicit-observation as a numbered-uses pattern.

- **§the-named-cache-staleness-on-upgrade-warning** (line 324-325) — *"The interface can change across vat upgrades, so clients caching it may become stale."* First-explicit-observation. Closes cycle 239's *cache staleness caveat* arc (which named the same warning in get-interface.js).

- **§the-named-three-runtime-backing-tiers** — heap (this package) + virtual (paged storage) + durable (survives vat upgrade). The README names all three explicitly. **§the-named-three-tier-runtime-backing-IS-named-canonical-axis**. First-explicit-observation.

- **§the-named-vat-data-package-pointed-to-with-API-surface** (line 332-338) — the cross-org pointer names not just the package but its *specific exports*: defineVirtualExoClass + defineDurableExoClass + prepareExoClass + prepareExoClassKit. **§the-named-cross-package-pointer-names-the-specific-API-surface** — first-explicit-observation.

- **§the-named-Integration-with-Endo-Packages-with-role-labels** (line 348-355) — Foundation + Validation + Communication. **§four-cycles-with-named-role-label-before-package-name** (321 + 325 + 327 + 331) — the discipline now spans four cycles.

- **§the-named-Complete-Tutorial-link** (line 357-359) — `../../docs/message-passing.md`. **§four-cycles-with-named-monorepo-docs-reference** (321 + 325 + 327 + 331).

- **§the-named-See-Also-section-pointing-to-Exo-Taxonomy** (line 361-364) — points to `./docs/exo-taxonomy.md` for *complete API reference*. **§the-named-See-Also-IS-named-completeness-pointer**.

- **§the-named-no-Hardened-JavaScript-section** — like cycles 323, 325, 327: no dedicated Hardened-JS section; implicit via citation. **§four-cycles-with-named-Hardened-JS-discipline-streak-continues-broken** (323 + 325 + 327 + 331).

- **§the-named-nine-section-README-shape** — Overview + Why Exo? + Three Patterns (three sub-sections) + Async Methods + State Management + Introspection + Virtual and Durable Exos + Integration with Endo Packages + See Also. Nine top-level sections; deep-feature-package shape. Compare to cycle 321 eventual-send (twelve-section substrate); cycle 327 patterns (substantial; multiple sub-sections); cycle 331 exo is between substrate and utility — deep-feature without being substrate.

## Patterns the cycle extends

- §twenty-two-cycles-with-named-pivot-domain-stay (310-331)
- §six-cycles-with-named-honesty-about-API-tradeoffs (321 + 323 + 325 + 326 + 329 + 331; six named subtypes)
- §thirty-five-citation-arc-closures-in-pivot-now (29 + 6)
- §four-cycles-with-named-role-label-before-package-name (321 + 325 + 327 + 331)
- §four-cycles-with-named-monorepo-docs-reference (321 + 325 + 327 + 331)
- §four-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (323 + 325 + 327 + 331)
- §two-cycles-with-named-Why-X-section-discipline (327 + 331)
- §two-cycles-with-named-side-by-side-comparison-discipline (329 + 331)
- §two-cycles-with-named-defensive-programming-as-named-discipline (327 + 331)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability:

- **§the-named-honesty-about-API-tradeoffs gains a sixth subtype** (functionality-in-different-org via cross-org pointer)
- **§the-named-positive-when-to-use-after-pointing-elsewhere** (after admitting limits, state what THIS package IS good for)
- **§the-named-same-code-with-and-without-discipline** (show identical logic with and without the discipline)
- **§the-named-cross-package-pointer-names-the-specific-API-surface** (name the API exports, not just the package)
- **§the-named-canonical-three-facet-example** (incrementer + decrementer + reader as canonical least-authority illustration)
- **§the-named-M.callWhen-three-or-four-step-semantics** with numbered steps
- **§the-named-cache-staleness-on-upgrade-warning** at the canonical place

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-two-cycles-with-named-pivot-domain-stay
- §six-cycles-with-named-honesty-about-API-tradeoffs (six named subtypes; rich tier-3 meta-pattern)
- §four-cycles-with-named-role-label-before-package-name
- §four-cycles-with-named-monorepo-docs-reference
- §four-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
- §two-cycles-with-named-Why-X-section-discipline
- §two-cycles-with-named-side-by-side-comparison-discipline

## Tier-3 borrowing (meta-patterns)

- **§the-named-honesty-about-API-tradeoffs** with six named subtypes (low-utility + relaxed-security + functionality-elsewhere + documentation-language-cannot-express + functionality-not-supported-at-all + functionality-in-different-org)
- **§the-named-cross-org-discipline-IS-named-organizational-boundary-crossing** — when a sibling-product in a different organization handles a related use case, name it explicitly
- **§the-named-positive-when-to-use-after-pointing-elsewhere** — pair the "for X see other-package" pointer with "here's what THIS package IS good for"
- **§the-named-same-code-with-and-without-discipline** — show the same code in two contexts (with and without a discipline applied) to illustrate the discipline's effect
- **§the-named-cross-package-pointer-names-the-specific-API-surface** — when pointing to a sibling package, name the specific exports the reader should look for
- **§the-named-canonical-three-facet-example** — incrementer + decrementer + reader for least-authority illustration
- **§the-named-numbered-step-semantics-discipline** (M.callWhen's four-step semantics)

## Synthesis-target

Slot machine library **§`@game/exo/README.md`** — defensive game-entity factories:

1. Opening sentence: "Combining game-Far objects with game-InterfaceGuards creates defensive game-entities."
2. Three-pattern trio: makeGameExo (single) + defineGameClass (instances) + defineGameClassKit (facets).
3. **Why-Game-Exo section** with same-code-with-and-without comparison.
4. **When-to-use checklist** per pattern.
5. **Canonical three-facet example**: dealer + player + reader (analogous to up/down/reader).
6. **State access discipline**: `this.state` semantics (per-instance vs shared) and `this.facets` for inter-facet communication.
7. **Async method guards** with numbered-step semantics.
8. **Introspection meta-method** for runtime interface discovery; cite the four-named-uses (discovery + dynamic clients + docs + protocol negotiation).
9. **Cache-staleness warning** for any introspectable interface that can change across upgrades.
10. **Three-runtime-backing-tier** if applicable (heap + virtual + durable for game state).
11. **Cross-org pointer** for production/cross-system variants (sixth subtype of honesty).
12. **Positive when-to-use** after cross-pointer (what THIS package IS good for).
13. **Cross-package pointer names the specific API surface** (not just the package).
14. Integration with role labels; Complete Tutorial link; See Also section.

## Library state after cycle 331

- §library-reaches-843-sections from 378 source documents
- §one-hundred-and-sixty-fourth consecutive designs-chat alternation
- §twenty-two-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §thirty-five-citation-arc-closures-in-pivot-now
- §six-cycles-with-named-honesty-about-API-tradeoffs (six named subtypes; meta-pattern is structurally rich)
- §four-cycles-with-named-role-label-before-package-name
- §four-cycles-with-named-monorepo-docs-reference
- §four-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
