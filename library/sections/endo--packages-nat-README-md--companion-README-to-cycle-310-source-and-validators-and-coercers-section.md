---
title: "@endo/nat README.md — companion README to cycle 310's source ingest; §two-cycles-with-named-source-and-README-pair-for-the-same-package; §the-named-distinction-between-mathematical-numbers-and-JS-numbers; §the-named-Validators-and-Coercers-section (§two-named-function-classifications); §the-named-Nat-IS-named-interesting-mixture (coercer at one abstraction level + validator at another); §the-named-skippable-marker-discipline; §the-named-Caja-origin (Google Caja → @endo); §three-named-link-classes (spec authoritative + esdiscuss historical + tc39-notes deliberation)"
section-slug: endo--packages-nat-README-md--companion-README-to-cycle-310-source-and-validators-and-coercers-section
source-slug: endo--packages-nat-README-md
url: https://github.com/endojs/endo/blob/master/packages/nat/README.md
authors: [Endo project (Google Caja origin + Agoric maintainership; collective)]
repo: endojs/endo
path: packages/nat/README.md
total-lines: 116
ingest-cycle: 311
ingest-date: 2026-06-11
lane: designs
scope: full
---

# `@endo/nat README.md` (companion to cycle 310's source ingest)

A 116-line README for `@endo/nat`. **The companion README to cycle 310's source ingest**. **§two-cycles-with-named-source-and-README-pair-for-the-same-package** (310 source + 311 README); the cluster's first explicit source-then-README pair for one package across two cycles. The README explains the *why* (mathematical-vs-JS numbers, safe-integer range, validators-vs-coercers, Google Caja provenance) where the source carries the *what* (predicate + coercion + constants).

## Key moves

- **§the-named-source-and-README-pair-across-two-cycles** (first-explicit-observation): cycle 310 ingested `@endo/nat src/index.js` (the code); cycle 311 ingests `@endo/nat README.md` (the docs); both together cover the entire package. **§two-cycles-with-named-source-and-README-pair-for-the-same-package**. **§the-named-what-vs-why-split-across-two-cycles**: source carries the *what* (implementation); README carries the *why* (mathematical motivation + classification of function shape + historical provenance).

§the-named-pivot-extends-via-companion-document: cycle 310's named-deliberate-pivot pivoted *away* from garden cluster *to* @endo/nat source; cycle 311 stays in the new domain to complete the package's documentation pair. **§the-named-stay-in-new-domain-after-pivot-discipline**.

- **§the-named-distinction-between-mathematical-numbers-and-JS-numbers** (first-explicit-observation):

> JavaScript has two data types representing numbers, *JS numbers* (IEEE 64 bit floating point) and *bigints* (arbitrary precision integers). Not all abstract mathematical numbers are representable by these data types, and not all values of one of these data types represent mathematical numbers.

**§the-named-two-named-JS-numeric-types**: JS numbers (IEEE 754 64-bit) + bigints (arbitrary precision). **§the-named-bidirectional-imperfect-correspondence**: types-don't-cover-all-numbers AND values-don't-all-represent-numbers.

§the-named-three-named-non-mathematical-JS-number-values: `NaN`, `Infinity`, `-Infinity`. **§three-named-NaN-and-infinity-exclusions**. **§the-named-IEEE-754-special-values**.

§the-named-vocabulary-discipline-explicit: "we'll always say 'mathematical number' when that's what we mean." **§the-named-because-the-language-overloads-the-term-we-distinguish-explicitly**. **§the-named-vocabulary-discipline-IS-named-meta-pedagogy**.

- **§the-named-mathematical-natural-numbers-IS-named-non-negative-integers** (first-explicit-observation):

> This package IS concerned with the mathematical *natural numbers*, the non-negative integers. All of these can be safely represented as bigints, given enough memory. Some of these can be represented as JS numbers, and a smaller set can *safely* be represented as JS numbers, given a specific notion of safety.

**§the-named-non-negative-integers-IS-the-named-natural-number-definition**. **§the-named-three-named-representation-tiers**: bigints-all + JS-numbers-some + JS-numbers-safely-smaller-set.

§the-named-given-enough-memory-discipline: bigints are constrained only by memory, not by precision. **§the-named-memory-bound-vs-precision-bound-distinction**.

- **§the-named-skippable-detail-about-floating-point** (first-explicit-observation):

> A skippable detail about floating point:

**§the-named-skippable-marker-discipline**: the README explicitly labels a section as "skippable" so readers can choose their depth. **§the-named-explicit-depth-marker**. **§the-named-pedagogical-discipline-of-naming-depth**.

§the-named-2-to-the-70-plus-1-equals-2-to-the-70-example: concrete worked example showing precision loss outside the safe-integer range. **§the-named-worked-example-IS-named-evidentiary**. **§the-named-2-to-70-IS-named-canonical-illustration**.

§the-named-safe-integer-range-IS-named-concrete-bounds: `-(2**53-1)` to `2**53-1`. Safe natural number range: `0` to `2**53-1`. **§the-named-explicit-numeric-bounds**. **§the-named-2-to-53-minus-1-IS-named-IEEE-754-max-safe-integer**.

§the-named-no-other-integers-coerce-to-any-of-these: "No other integers coerce to any of these." **§the-named-coercion-exclusion-discipline**. **§the-named-out-of-range-integers-are-unreachable-via-coercion**.

§the-named-additive-correctness-property: "If in JavaScript `a + b === c` and all three values are JS safe integers, then this accurately represents the mathematical sum of the mathematical numbers they represent." **§the-named-arithmetic-closure-discipline**. **§the-named-correctness-condition-for-arithmetic-IS-named-explicit**.

- **§the-named-bigint-IS-named-inherently-safe** (first-explicit-observation):

> The bigint datatype, by contrast, IS inherently safe. Every bigint `>= 0n` safely represents a natural number.

**§the-named-inherent-safety-property**. **§the-named-by-contrast-IS-named-comparative-discipline**: the README explicitly contrasts the two types' safety properties.

§the-named-zero-suffix-N-IS-named-bigint-literal: `0n` IS the bigint literal. (Distinct from cycle 310's named-deliberate-constructor-over-literal-discipline — the README uses the literal form because it doesn't run in Apps Script.) **§the-named-README-uses-literal-source-uses-constructor**.

- **§seven-named-input-examples-per-function** (first-explicit-observation):

```javascript
isNat(3); // true
isNat(3n); // true
isNat('3'); // false
isNat(2**70); // false
isNat(2n**70n); // true
isNat(-3n); // false
isNat(3.1); // false
```

(plus seven analogous Nat examples)

**§seven-named-input-examples-per-function**. **§the-named-examples-cover-named-edge-cases**: number-positive + bigint-positive + string + out-of-range-number + bigint-larger-than-safe-integer + negative-bigint + non-integer-float.

§the-named-example-discipline-IS-named-by-shape-coverage: each example demonstrates a *category* of input rather than redundant variants of the same category. **§the-named-shape-coverage-discipline**.

- **§the-named-API-typing-with-pipe-union** (first-explicit-observation):

```
isNat(allegedNum: any) => boolean
Nat(allegedNum: bigint | number) => bigint
```

**§the-named-README-IS-named-TypeScript-style-typed**: the README uses TypeScript-style function signatures. **§the-named-pipe-union-IS-named-TypeScript-shape**.

§the-named-isNat-IS-named-any-input-Nat-IS-named-narrowed-input: isNat accepts *any*; Nat accepts only *bigint | number*. **§the-named-predicate-IS-most-permissive-coercion-IS-narrowed**. **§the-named-type-narrowing-IS-named-input-precondition** (Nat's caller IS expected to have already narrowed the type to bigint | number; isNat does not have that assumption).

§the-named-asymmetric-API-typing: extends cycle 310's named-naming-discriminates-shape (is*-predicate + Capital*-coercion); cycle 311 names the type-level asymmetry (`any` for predicate vs `bigint | number` for coercion). **§two-cycles-with-named-asymmetric-naming-and-typing-discipline** (310 + 311).

- **§the-named-iff-discipline** (first-explicit-observation):

> returns `true` *iff* that input safely represents a natural number

**§the-named-mathematical-iff-IS-named-precise-equivalence**: "iff" (if-and-only-if) names *both-directions* logical equivalence. **§the-named-iff-IS-named-precise-mathematical-discipline**.

- **§the-named-type-tester-of-possible-representations-shape** (first-explicit-observation):

> To the extent that we consider this abstract notion of mathematical natural number a type, `isNat` IS a *type tester* of possible representations of this type.

**§the-named-multi-representation-type-tester**: a single abstract type (mathematical natural number) IS testable against multiple representations (bigint + JS number). **§the-named-abstract-type-multi-representation-discipline**. **§the-named-isNat-IS-a-multi-representation-tester**.

§the-named-to-the-extent-that-IS-named-cautious-framing: "To the extent that we consider this abstract notion ... a type" — the README acknowledges that "type" IS a loaded term. **§the-named-cautious-type-talk-discipline**.

- **§the-named-Validators-and-Coercers-section** (first-explicit-observation):

> Functions like `Nat` and the standard JavaScript `BigInt` can be classified _validators_ or _coercers_.

**§two-named-function-classifications**: validators + coercers. **§the-named-explicit-terminology-section**.

§the-named-validator-vs-coercer-precise-definitions:

> When a validator accepts---returns normally rather than throwing---the caller knows that their input argument IS as expected, and the output IS the same as the input. When a coercer accepts, the caller knows that the output IS as expected, but only knows that the input was one the coercer was willing to convert from.

**§the-named-input-knowledge-vs-output-knowledge-distinction**: validator gives caller knowledge about *input* (which was the same as output); coercer gives caller knowledge about *output* (whatever the input was, the output IS as expected). **§the-named-where-the-knowledge-lands-after-the-call-discipline**.

§the-named-BigInt-IS-named-coercer-example: "The `BigInt` function IS a coercer. It will even accept strings as input but its output IS always a bigint." **§the-named-built-in-coercer-example-IS-named-pedagogical**.

§the-named-Nat-IS-named-interesting-mixture: "`Nat` IS an interesting mixture. It IS a coercer at one level of abstraction, and a validator at another level of abstraction." **§the-named-cross-abstraction-level-function-discipline**. **§the-named-mixture-IS-named-non-binary**.

§two-named-abstraction-levels-in-the-discussion:
1. **Concrete JS data representations**: `Nat` IS a coercer (converts number → bigint).
2. **Mathematical number representation**: `Nat` IS a validator (input and output both safely represent the same mathematical natural number).

**§two-named-abstraction-levels**. **§the-named-validator-or-coercer-discipline-IS-level-relative**.

§the-named-on-success-the-output-IS-the-same-as-the-input-at-the-mathematical-level: "on success, the output IS the same as the input" — at the math level, the bigint-out and the number-in represent the same mathematical natural number. **§the-named-mathematical-identity-across-representations**.

- **§the-named-history-section** (first-explicit-observation):

> `Nat` comes from the Google Caja project, which tested whether a JS number was a primitive integer within the range of contiguously and unambiguously representable non-negative integers.

**§the-named-Caja-origin**: extends cycle 310's named-multi-org-multi-year-copyright-discipline (Google 2011 + Agoric 2018) with the named-project-origin (Caja). **§two-cycles-with-named-deep-provenance** (310 + 311). **§the-named-three-deep-provenance-chain**: Google Caja → @endo → garden library.

§the-named-tc39-notes-link-IS-named-historical-deliberation-citation: `https://github.com/rwaldron/tc39-notes/blob/master/es6/2013-07/july-25.md`. **§the-named-historical-TC39-discussion-link**. **§three-named-link-classes-now** across cycles 310 + 311: spec-authoritative (310 tc39.es) + esdiscuss-historical (310) + tc39-notes-deliberation (311).

- **§the-named-CircleCI-and-david-dm-badge-discipline** (first-explicit-observation):

```markdown
[![Build Status][circleci-svg]][circleci-url]
[![dependency status][deps-svg]][deps-url]
[![dev dependency status][dev-deps-svg]][dev-deps-url]
[![License][license-image]][license-url]
```

**§the-named-four-named-OSS-badges**: build-status + dependency-status + dev-dependency-status + license. **§the-named-reference-style-Markdown-links** (using `[label][ref]` + reference definitions at the bottom).

§the-named-reference-link-IS-named-DRY-shape: the badge text + link URLs are defined once at the bottom and referenced by name. **§the-named-DRY-link-discipline**. (Contrast with cycle 310's named-WET-discipline-for-self-contained-docstrings — the README chooses DRY for badges and links + WET for rationale; the policy IS content-class-dependent.)

§the-named-Apache-2.0-license-badge: confirms cycle 310's Apache 2.0 license header. **§two-cycles-with-named-Apache-2.0-license-confirmation** (310 source + 311 README).

- **§the-named-cycle-311-IS-the-companion-README-to-cycle-310-source-and-validators-and-coercers-section** (first-explicit-observation):

§two-cycles-with-named-source-and-README-pair-for-the-same-package (310 source + 311 README). **§the-named-source-and-README-pair-IS-named-canonical-coverage**: ingesting both the code AND the docs gives the cluster comprehensive coverage of the package's structure-and-rationale.

§the-named-source-and-README-pair-IS-named-cross-lane-balanced: cycle 310 IS chat-lane (source IS code); cycle 311 IS designs-lane (README IS docs). **§the-named-lane-discipline-respects-document-class**.

§the-named-stay-in-new-domain-after-pivot-discipline: cycle 309 named the cluster saturation; cycle 310 named the pivot; cycle 311 stays in the new domain to complete the package coverage. **§the-named-multi-cycle-stay-after-pivot-discipline**.

## Cross-cycle pattern accumulation

- **§two-cycles-with-named-source-and-README-pair-for-the-same-package**: 310 (src/index.js) + 311 (README.md).
- **§the-named-what-vs-why-split-across-two-cycles**: source-IS-what (cycle 310) + README-IS-why (cycle 311).
- **§the-named-stay-in-new-domain-after-pivot-discipline**: cycle 310 pivoted; cycle 311 stays in @endo/nat.
- **§two-cycles-with-named-deep-provenance**: cycle 310's named-multi-org-multi-year-copyright + cycle 311's named-Caja-origin. **§three-deep-provenance-chain**: Caja → @endo → garden.
- **§three-named-link-classes-now**: spec-authoritative + esdiscuss-historical + tc39-notes-deliberation (cycles 310 + 311 together).
- **§two-cycles-with-named-Apache-2.0-license-confirmation**: 310 + 311.
- **§two-cycles-with-named-asymmetric-naming-and-typing-discipline**: 310 (naming: is* + Capital*) + 311 (typing: any + bigint|number).
- **§the-named-lane-discipline-respects-document-class**: source = chat-lane; README = designs-lane.

## Notes

- Cycle 311 IS the first cycle to ingest a README *immediately after* its sibling source file (cycle 310). Most prior packages had their READMEs ingested first; cycle 310-311 inverted the order (source first, then README). **§the-named-source-first-then-README-ingest-order**: extends the cluster's flexibility about ingestion order.
- The named-Validators-and-Coercers-section IS structurally rich: it names a precise terminology AND it names that some functions (`Nat`) don't fit cleanly into either category at all abstraction levels. The "interesting mixture" framing IS rare in API documentation; most APIs are classified as one or the other.
- The named-skippable-marker-discipline (explicit "A skippable detail" label) IS a pedagogical pattern worth borrowing: the README acknowledges that not every reader needs every detail.
- The named-iff-discipline (using "iff" for if-and-only-if in API documentation) IS unusual; most documentation uses just "if" even when both directions hold. The explicit "iff" signals mathematical precision.
- The named-Caja-origin acknowledges a deep chain: Google Caja (Mark Miller's first secure-JavaScript project) → @endo (Agoric's continuation) → garden library (this cycle). **§the-named-deep-historical-chain**.
