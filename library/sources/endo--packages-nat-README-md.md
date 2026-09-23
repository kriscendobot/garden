---
title: "@endo/nat README.md — companion README to cycle 310's source ingest; mathematical-vs-JS numbers + Validators-and-Coercers terminology"
source-slug: endo--packages-nat-README-md
url: https://github.com/endojs/endo/blob/master/packages/nat/README.md
authors: [Endo project (Google Caja origin + Agoric maintainership; collective)]
repo: endojs/endo
path: packages/nat/README.md
total-lines: 116
ingest-cycle: 311
ingest-date: 2026-06-11
lane: designs
---

# `@endo/nat README.md`

A 116-line README for `@endo/nat`. **The companion README to cycle 310's source ingest**. §two-cycles-with-named-source-and-README-pair-for-the-same-package (310 source + 311 README). §the-named-what-vs-why-split-across-two-cycles: source carries the *what* (implementation); README carries the *why* (mathematical motivation + Validators-and-Coercers classification + Caja provenance).

## Key moves

- **§the-named-source-and-README-pair-across-two-cycles** — cycle 310 src + cycle 311 README cover the whole package; §the-named-stay-in-new-domain-after-pivot-discipline (cycle 309 named saturation + cycle 310 pivoted + cycle 311 stays).
- **§the-named-distinction-between-mathematical-numbers-and-JS-numbers** — §two-named-JS-numeric-types (IEEE 754 + bigints); §three-named-NaN-and-infinity-exclusions; §the-named-vocabulary-discipline-explicit ("we'll always say 'mathematical number' when that's what we mean"); §the-named-because-the-language-overloads-the-term-we-distinguish-explicitly.
- **§the-named-mathematical-natural-numbers-IS-named-non-negative-integers** — §three-named-representation-tiers (bigints-all + JS-numbers-some + JS-numbers-safely-smaller-set); §the-named-memory-bound-vs-precision-bound-distinction.
- **§the-named-skippable-detail-about-floating-point** — §the-named-skippable-marker-discipline (explicit depth marker); §the-named-pedagogical-discipline-of-naming-depth; §the-named-2-to-the-70-plus-1-equals-2-to-the-70-example (worked-example-IS-named-evidentiary); §the-named-safe-integer-range-IS-named-concrete-bounds (-(2**53-1) to 2**53-1); §the-named-2-to-53-minus-1-IS-named-IEEE-754-max-safe-integer; §the-named-no-other-integers-coerce-to-any-of-these; §the-named-additive-correctness-property (arithmetic closure within safe-integer range).
- **§the-named-bigint-IS-named-inherently-safe** — §the-named-inherent-safety-property; §the-named-by-contrast-IS-named-comparative-discipline; §the-named-zero-suffix-N-IS-named-bigint-literal; §the-named-README-uses-literal-source-uses-constructor (the README uses `0n`; cycle 310's source uses `BigInt(0)` for Apps Script compat).
- **§seven-named-input-examples-per-function** — each example covers a named edge case (number-positive + bigint-positive + string + out-of-range-number + bigint-larger-than-safe-integer + negative-bigint + non-integer-float); §the-named-shape-coverage-discipline.
- **§the-named-API-typing-with-pipe-union** — `isNat(allegedNum: any) => boolean` + `Nat(allegedNum: bigint | number) => bigint`; §the-named-README-IS-named-TypeScript-style-typed; §the-named-pipe-union-IS-named-TypeScript-shape; §the-named-asymmetric-API-typing (any for predicate vs bigint|number for coercion); §two-cycles-with-named-asymmetric-naming-and-typing-discipline (310 naming + 311 typing).
- **§the-named-iff-discipline** — §the-named-mathematical-iff-IS-named-precise-equivalence; §the-named-iff-IS-named-precise-mathematical-discipline.
- **§the-named-type-tester-of-possible-representations-shape** — isNat IS a type tester of possible representations; §the-named-multi-representation-type-tester; §the-named-abstract-type-multi-representation-discipline; §the-named-cautious-type-talk-discipline ("To the extent that we consider this abstract notion ... a type").
- **§the-named-Validators-and-Coercers-section** — §two-named-function-classifications (validators + coercers); §the-named-explicit-terminology-section; §the-named-validator-vs-coercer-precise-definitions (validator-IS-input-knowledge + coercer-IS-output-knowledge); §the-named-input-knowledge-vs-output-knowledge-distinction; §the-named-where-the-knowledge-lands-after-the-call-discipline; §the-named-BigInt-IS-named-coercer-example.
- **§the-named-Nat-IS-named-interesting-mixture** — coercer at one abstraction level + validator at another; §the-named-cross-abstraction-level-function-discipline; §the-named-mixture-IS-named-non-binary; §two-named-abstraction-levels (concrete JS data representations + mathematical number representation); §the-named-validator-or-coercer-discipline-IS-level-relative; §the-named-mathematical-identity-across-representations.
- **§the-named-history-section** — `Nat` from Google Caja project; §the-named-Caja-origin; §two-cycles-with-named-deep-provenance (310 + 311); §three-deep-provenance-chain (Caja → @endo → garden library); §the-named-tc39-notes-link-IS-named-historical-deliberation-citation; §three-named-link-classes-now (spec-authoritative + esdiscuss-historical + tc39-notes-deliberation across cycles 310 + 311).
- **§the-named-CircleCI-and-david-dm-badge-discipline** — §the-named-four-named-OSS-badges (build-status + dependency-status + dev-dependency-status + license); §the-named-reference-style-Markdown-links; §the-named-DRY-link-discipline (badges/links use reference-style for DRY); contrast with cycle 310's named-WET-discipline-for-self-contained-docstrings (policy IS content-class-dependent); §two-cycles-with-named-Apache-2.0-license-confirmation (310 + 311).
- **§the-named-cycle-311-IS-the-companion-README-to-cycle-310-source-and-validators-and-coercers-section** — §the-named-source-and-README-pair-IS-named-canonical-coverage; §the-named-lane-discipline-respects-document-class (source = chat-lane; README = designs-lane); §the-named-stay-in-new-domain-after-pivot-discipline (cycles 309 saturation + 310 pivot + 311 stay).

## Section files

- [§two-cycles-with-named-source-and-README-pair-for-the-same-package + §the-named-distinction-between-mathematical-numbers-and-JS-numbers + §the-named-Validators-and-Coercers-section + §the-named-Nat-IS-named-interesting-mixture + §the-named-Caja-origin + 20+ more first-explicit-observations](../sections/endo--packages-nat-README-md--companion-README-to-cycle-310-source-and-validators-and-coercers-section.md) — full 116-line README in scope.

## Ingest scope

Cycle 311 (designs-lane after cycle 310's chat-lane `@endo/nat src/index.js`). Full 116-line README in scope. The first cycle to ingest a README *immediately after* its sibling source file (cycle 310 source + cycle 311 README; **§the-named-source-first-then-README-ingest-order**). **First-explicit-observations (twenty-plus)** at full scope, including: §the-named-source-and-README-pair-across-two-cycles, §the-named-distinction-between-mathematical-numbers-and-JS-numbers with §three-named-NaN-and-infinity-exclusions, §the-named-skippable-detail-about-floating-point with §the-named-skippable-marker-discipline, §the-named-safe-integer-range-IS-named-concrete-bounds, §the-named-bigint-IS-named-inherently-safe, §seven-named-input-examples-per-function, §the-named-API-typing-with-pipe-union with §the-named-asymmetric-API-typing, §the-named-iff-discipline, §the-named-type-tester-of-possible-representations-shape, §the-named-Validators-and-Coercers-section with §the-named-Nat-IS-named-interesting-mixture across §two-named-abstraction-levels, §the-named-history-section with §the-named-Caja-origin, §the-named-CircleCI-and-david-dm-badge-discipline.
