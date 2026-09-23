---
title: "@endo/nat src/index.js — Nat predicate-and-coercion pair for non-negative integers"
source-slug: endo--packages-nat-src-index-js
url: https://github.com/endojs/endo/blob/master/packages/nat/src/index.js
authors: [Endo project (Google 2011 + Agoric 2018; collective)]
repo: endojs/endo
path: packages/nat/src/index.js
total-lines: 119
ingest-cycle: 310
ingest-date: 2026-06-11
lane: chat
---

# `@endo/nat src/index.js`

A 119-line foundational utility module — the named-natural-number-validation-and-coercion pair for `@endo` and Agoric. Two named exports (`isNat` predicate + `Nat` coercion) plus two named BigInt constants (`ZERO_N` + `ONE_N`). **The first non-garden chat-lane source after twenty-nine cycles** (the zip cluster 282-296 + scripts 298 + garden meta 300-309). **§the-named-deliberate-pivot-IS-named-refresh-of-pattern-surface** per cycle 309's named-cluster-saturation note.

## Key moves

- **§the-named-isNat-predicate-and-Nat-coercion-pair** — §the-named-predicate-and-coercion-pair-shape; §the-named-asymmetric-naming-isNat-vs-Nat (`is*` predicate + `Capital*` coercion); §the-named-naming-discriminates-shape.
- **§two-named-Nat-input-types** — non-negative bigint OR non-negative-safe-integer number; §the-named-type-union-with-named-per-branch-validation; §the-named-Number.isSafeInteger-IS-named-floating-point-safety-criterion; §the-named-coercion-produces-bigint-uniformly; §the-named-bigint-IS-the-named-canonical-Nat-representation; §the-named-zero-IS-included-in-Nat (non-negative not strictly positive).
- **§two-named-canonical-BigInt-constants** (`ZERO_N` + `ONE_N`); §the-named-N-suffix-IS-named-BigInt-marker; §the-named-deliberate-constructor-over-literal-discipline (`BigInt(0)` not `0n`).
- **§the-named-DUPLICATED-RATIONALE-COMMENT** — verbatim 14-line JSDoc above both ZERO_N and ONE_N; §the-named-deliberate-DRY-violation-for-named-self-contained-documentation; §the-named-WET-discipline-for-self-contained-docstrings; §the-named-rationale-IS-attached-not-referenced; §the-named-cursor-location-IS-named-immediate-comprehension-context.
- **§the-named-extensive-rationale-comment-on-BigInt-literal-syntax** — Google Apps Script parser limitation; §the-named-conditional-applicability-discipline (Apps Script compat only for `@endo/marshal` + `@endo/ocapn` per future PR 3008); §the-named-scoped-compatibility-discipline; §the-named-citation-of-the-named-discovery-context; §the-named-relaxation-with-named-condition ("when a number IS accurate"); §the-named-PR-as-named-future-state-anchor.
- **§the-named-freeze-as-harden-stand-in-comment** — until PR 3008; §the-named-freeze-equals-harden-for-arrow-functions; §the-named-substitution-with-named-applicability-condition; §the-named-arrow-functions-IS-the-named-harden-equivalent-class; §two-named-PR-3008-references-in-the-same-file.
- **§the-named-Object-method-destructuring-discipline** — `const { freeze } = Object;`; §the-named-capture-at-module-load-discipline; §the-named-prevents-late-binding-attack; §the-named-defensive-binding-discipline.
- **§four-named-error-paths-in-Nat** (bigint-negative + number-not-safe-integer + number-negative + neither); §two-named-error-classes-with-named-distinct-causes (RangeError + TypeError); §the-named-error-class-discriminates-cause; §the-named-value-and-type-in-error-discipline; §the-named-fall-through-throw-discipline.
- **§the-named-explicit-freeze-call-on-each-export** — `freeze(isNat)` + `freeze(Nat)`; §the-named-freeze-after-export-discipline; §the-named-export-and-freeze-pair-discipline.
- **§the-named-allegedNum-IS-named-parameter-name** — §the-named-alleged-prefix-discipline; §the-named-defensive-naming-discipline.
- **§the-named-`@param {unknown}`-IS-named-most-permissive-input-type** — §the-named-unknown-vs-any-discrimination; §the-named-validator-takes-unknown-discipline.
- **§the-named-`@ts-check`-directive** — §the-named-JSDoc-IS-named-type-source; §multi-cycle-pattern-`@ts-check`-discipline.
- **§the-named-multi-org-multi-year-copyright-discipline** — Google 2011 + Agoric 2018; §the-named-2011-to-2018-copyright-gap; §the-named-seven-year-provenance-gap; §the-named-deep-provenance-IS-named-foundation-utility-marker.
- **§the-named-tc39-spec-citation-IS-named-authoritative-link** — §the-named-cite-the-spec-anchor; §two-named-link-classes (spec authoritative + esdiscuss historical).
- **§the-named-cycle-310-pivots-from-garden-cluster-to-foundation-utility** — §the-named-first-pivot-after-fourteen-cycle-cluster; §the-named-pattern-surface-refreshes; §the-named-foundation-utility-shape; §the-named-leaf-dependency-discipline.

## Section files

- [§the-named-Nat-predicate-and-coercion-pair + §two-named-canonical-BigInt-constants + §the-named-DUPLICATED-RATIONALE-COMMENT + §the-named-freeze-as-harden-stand-in + §the-named-conditional-applicability-discipline + §four-named-error-paths + 25+ more first-explicit-observations](../sections/endo--packages-nat-src-index-js--Nat-predicate-and-coercion-pair-and-named-BigInt-constants.md) — full 119-line module in scope.

## Ingest scope

Cycle 310 (chat-lane after cycle 309's designs-lane garden designs/README.md). Full 119-line module in scope. The first non-garden chat-lane source after twenty-nine prior cycles. **First-explicit-observations (thirty-plus)** at full scope, including: §the-named-isNat-predicate-and-Nat-coercion-pair (the named-pair shape), §two-named-canonical-BigInt-constants with §the-named-N-suffix-marker, §the-named-DUPLICATED-RATIONALE-COMMENT (deliberate WET discipline), §the-named-extensive-rationale-comment-on-BigInt-literal-syntax with §the-named-conditional-applicability-discipline (Apps Script compat scoped to specific downstream packages), §the-named-freeze-as-harden-stand-in with §the-named-arrow-functions-IS-named-harden-equivalent-class, §the-named-Object-method-destructuring-discipline (defensive binding), §four-named-error-paths-in-Nat with §two-named-error-classes-with-named-distinct-causes, §the-named-explicit-freeze-call-on-each-export, §the-named-allegedNum-IS-named-parameter-name (alleged-prefix-discipline), §the-named-`@param {unknown}` validator-takes-unknown-discipline, §the-named-multi-org-multi-year-copyright-discipline (Google 2011 + Agoric 2018), §the-named-cycle-310-pivots-from-garden-cluster-to-foundation-utility.
