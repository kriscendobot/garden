---
title: "@endo/nat src/index.js — Nat: predicate + coercion pair for non-negative integers; §the-named-isNat-predicate-and-Nat-coercion-pair; §two-named-canonical-BigInt-constants (ZERO_N + ONE_N); §the-named-DUPLICATED-RATIONALE-COMMENT (verbatim JSDoc above both constants); §the-named-freeze-as-harden-stand-in; §the-named-conditional-applicability-discipline (Apps Script compat only for @endo/marshal + @endo/ocapn); §two-named-Nat-input-types (non-negative bigint OR non-negative-safe-integer number); §four-named-error-paths; §the-named-multi-org-multi-year-copyright-discipline; §the-named-deliberate-pivot-IS-named-refresh-of-pattern-surface (first non-garden source after cycle 280)"
section-slug: endo--packages-nat-src-index-js--Nat-predicate-and-coercion-pair-and-named-BigInt-constants
source-slug: endo--packages-nat-src-index-js
url: https://github.com/endojs/endo/blob/master/packages/nat/src/index.js
authors: [Endo project (Google 2011 + Agoric 2018; collective)]
repo: endojs/endo
path: packages/nat/src/index.js
total-lines: 119
ingest-cycle: 310
ingest-date: 2026-06-11
lane: chat
scope: full
---

# `@endo/nat src/index.js` (Nat predicate + coercion pair)

A 119-line foundational utility module — the named-natural-number-validation-and-coercion pair for `@endo` and Agoric. Two named exports (`isNat` predicate + `Nat` coercion) plus two named BigInt constants (`ZERO_N` + `ONE_N`). The first non-garden source ingested after cycle 280 (twenty-nine cycles of foundation-utility + garden-meta + other material; the most recent fourteen were the garden-meta cluster). **§the-named-deliberate-pivot-IS-named-refresh-of-pattern-surface** per cycle 309's named-cluster-IS-fourteen-cycles-and-the-named-pattern-of-pattern-has-saturated.

## Key moves

- **§the-named-isNat-predicate-and-Nat-coercion-pair** (first-explicit-observation):

```javascript
export const isNat = allegedNum => {
  if (typeof allegedNum === 'bigint') {
    return allegedNum >= 0;
  }
  if (typeof allegedNum !== 'number') {
    return false;
  }
  return Number.isSafeInteger(allegedNum) && allegedNum >= 0;
};

export const Nat = allegedNum => {
  // ... throws TypeError or RangeError; returns bigint
};
```

**§the-named-predicate-and-coercion-pair-shape**: a `boolean`-returning predicate (`isNat`) alongside a coerce-or-throw function (`Nat`). The pair allows callers to either *test* before acting or *demand* with throw-on-fail. **§the-named-pair-IS-named-non-throwing-and-throwing-variants**.

§the-named-asymmetric-naming-isNat-vs-Nat: predicate name uses lowercase `is` prefix per JavaScript convention; coercion uses capitalized identifier (TypeScript-style constructor-equivalent). **§the-named-naming-discriminates-shape**: `is*` → predicate; `Capital*` → coercion. **§the-named-JS-naming-conventions-IS-named-distinguishing-shape**.

- **§two-named-Nat-input-types** (first-explicit-observation):

> To qualify `allegedNum` must either be a non-negative `bigint`, or a non-negative `number` representing an integer within range of integers safely representable in floating point.

**§two-named-acceptable-input-types**: `bigint` (arbitrary precision; check `>= 0`) + `number` (must be `Number.isSafeInteger` AND `>= 0`). **§the-named-type-union-with-named-per-branch-validation**.

§the-named-Number.isSafeInteger-IS-named-the-named-floating-point-safety-criterion: "safely representable in floating point". **§the-named-IEEE-754-precision-limit-IS-named-explicit**.

§the-named-natural-number-definition-IS-named-non-negative-integer: "non-negative integers". **§the-named-zero-IS-included-in-Nat** (non-negative, not strictly positive).

§the-named-coercion-produces-bigint-uniformly: `Nat` returns a `bigint` regardless of input type. Even when input IS a `number`, the output IS `BigInt(allegedNum)`. **§the-named-unified-output-type-discipline**. **§the-named-bigint-IS-the-named-canonical-Nat-representation**.

- **§two-named-canonical-BigInt-constants** (first-explicit-observation):

```javascript
export const ZERO_N = BigInt(0);
export const ONE_N = BigInt(1);
```

**§the-named-canonical-zero-and-one-BigInt-exports**. **§the-named-N-suffix-IS-named-BigInt-marker**: `ZERO_N` + `ONE_N` use `_N` suffix to mark BigInt-ness. **§the-named-suffix-IS-named-typographic-type-marker**.

§the-named-BigInt-constructor-instead-of-literal: `BigInt(0)` not `0n`. **§the-named-deliberate-constructor-over-literal-discipline** — the docstring names the reason (Google Apps Script parser limitation).

- **§the-named-DUPLICATED-RATIONALE-COMMENT** (first-explicit-observation):

The same 14-line JSDoc block appears **verbatim** above both `ZERO_N` (lines 18-32) and `ONE_N` (lines 34-48). **§the-named-deliberate-DRY-violation-for-named-self-contained-documentation**: each export's rationale stands alone, even at the cost of textual duplication. **§the-named-WET-discipline-for-self-contained-docstrings** (Write Everything Twice rather than referencing).

§the-named-WET-IS-named-deliberate-choice: extends the conventional DRY discipline with a named-exception. **§the-named-rationale-IS-attached-not-referenced**.

§the-named-redundancy-IS-named-self-contained-readability: a reader landing on `ONE_N` doesn't need to scroll back to find the rationale for `ZERO_N` — it's right there. **§the-named-cursor-location-IS-named-immediate-comprehension-context**.

- **§the-named-extensive-rationale-comment-on-BigInt-literal-syntax** (first-explicit-observation):

> Regarding Google Apps Script limitations, [URL]:
> > Literal syntax limitation: The shortcut syntax for `BigInt` literals (e.g., `10n`) is not supported by the script editor's parser, and will cause a syntax error. You must use the `BigInt()` constructor with a string argument instead (e.g., `BigInt("10"))`.
> Actually, when a number is accurate, we can use that instead of a string.
>
> Endo is not in general trying for compat with Apps Script. But packages that will have minimal dependencies after adapting to https://github.com/endojs/endo/pull/3008 might, such as `@endo/marshal` and `@endo/ocapn`.

**§the-named-conditional-applicability-discipline**: Endo IS NOT in general trying for Apps Script compat; BUT some packages (`@endo/marshal` + `@endo/ocapn`) will have minimal dependencies after PR 3008 and might be deployable to Apps Script. **§the-named-scoped-compatibility-discipline**: the workaround IS in `@endo/nat` because nat IS a leaf dependency.

§the-named-fact-from-the-field-with-named-URL-citation: the JSDoc cites a specific Google search URL with the answer. **§the-named-citation-of-the-named-discovery-context**.

§the-named-actually-not-strict-applicability: "Actually, when a number IS accurate, we can use that instead of a string." — names a relaxation of the cited constraint. **§the-named-relaxation-with-named-condition**.

§the-named-named-PR-3008-IS-the-named-anticipated-migration-target: the comment cites a future PR by number. **§the-named-PR-as-named-future-state-anchor**.

§three-named-affected-packages: `@endo/marshal` + `@endo/ocapn` (oblique) + `@endo/nat` (this file). **§three-named-Apps-Script-target-packages**.

- **§the-named-freeze-as-harden-stand-in-comment** (first-explicit-observation):

> Use as a standin for `harden` until https://github.com/endojs/endo/pull/3008. Since we're only using it on unadorned arrow functions, `freeze` in this case IS actually equivalent to `harden`.

**§the-named-freeze-equals-harden-for-arrow-functions**: explicit named condition under which the substitution IS safe. **§the-named-substitution-with-named-applicability-condition**. **§the-named-harden-substitution-discipline**.

§the-named-unadorned-arrow-functions-IS-named-no-prototype-no-properties: arrow functions don't have a `.prototype`; without explicit property additions, `freeze` and `harden` produce the same observable result on the function itself. **§the-named-arrow-functions-IS-the-named-harden-equivalent-class**.

§the-named-named-PR-3008-extends: the same PR cited as the named-anticipated-migration-target above IS also the named-eventual-replacement-anchor here. **§two-named-PR-3008-references-in-the-same-file**.

- **§the-named-Object-method-destructuring-discipline** (first-explicit-observation):

```javascript
const { freeze } = Object;
```

**§the-named-destructure-from-Object-into-named-local-binding**. Captures `Object.freeze` at module-load time, before any potential SES tampering or `Object` mutation. **§the-named-capture-at-module-load-discipline**. Extends cycle 281-era patterns about named-intrinsic-binding.

§the-named-prevents-late-binding-attack: a captured `freeze` reference can't be redirected by a later `Object.freeze = someOtherFn`. **§the-named-defensive-binding-discipline**.

- **§four-named-error-paths-in-Nat** (first-explicit-observation):

```javascript
export const Nat = allegedNum => {
  if (typeof allegedNum === 'bigint') {
    if (allegedNum < ZERO_N) {
      throw RangeError(`${allegedNum} is negative`);
    }
    return allegedNum;
  }

  if (typeof allegedNum === 'number') {
    if (!Number.isSafeInteger(allegedNum)) {
      throw RangeError(`${allegedNum} is not a safe integer`);
    }
    if (allegedNum < 0) {
      throw RangeError(`${allegedNum} is negative`);
    }
    return BigInt(allegedNum);
  }

  throw TypeError(
    `${allegedNum} is a ${typeof allegedNum} but must be a bigint or a number`,
  );
};
```

**§four-named-error-paths**:
1. `bigint && < ZERO_N` → `RangeError("X is negative")`
2. `number && !isSafeInteger` → `RangeError("X is not a safe integer")`
3. `number && < 0` → `RangeError("X is negative")`
4. neither `bigint` nor `number` → `TypeError("X is a Y but must be a bigint or a number")`

**§two-named-error-classes-with-named-distinct-causes**: `RangeError` (in-domain but wrong magnitude/representation) + `TypeError` (wrong shape entirely). **§the-named-error-class-discriminates-cause**.

§the-named-error-message-IS-named-interpolation-with-typeof: `${allegedNum} is a ${typeof allegedNum}` — names both the value and the type in the error message. **§the-named-value-and-type-in-error-discipline**.

§the-named-fall-through-throw-IS-named-final-statement: the `TypeError` throw IS NOT inside an `else` block; it follows the two `if` branches' early returns. **§the-named-fall-through-throw-discipline**: an unconditional throw at the bottom of a function IS the equivalent of `default:` in a switch.

§the-named-redundant-message-distinct-error: paths 1 and 3 both throw `"... IS negative"` but with distinct types (bigint vs number). **§the-named-same-message-distinct-input-class** — the type difference IS implicit in the value's repr.

- **§the-named-explicit-freeze-call-on-each-export** (first-explicit-observation):

```javascript
export const isNat = allegedNum => { ... };
freeze(isNat);

export const Nat = allegedNum => { ... };
freeze(Nat);
```

**§the-named-freeze-after-export-discipline**: each exported arrow function IS frozen immediately after definition. **§the-named-export-and-freeze-pair-discipline**.

§the-named-arrow-function-IS-named-frozen-explicitly: by default, arrow functions are not frozen. The explicit `freeze` call IS the named-harden-equivalent-for-unadorned-arrows.

- **§the-named-allegedNum-IS-named-parameter-name** (first-explicit-observation): "alleged" prefix names the named-not-yet-validated nature of the input. **§the-named-alleged-prefix-discipline**: the parameter name itself documents that the value's shape IS not yet confirmed.

§the-named-naming-IS-named-pre-validation-marker: extends a JavaScript convention where `alleged*` parameters require validation before use. **§the-named-defensive-naming-discipline**.

- **§the-named-`@param {unknown}`-IS-named-most-permissive-input-type** (first-explicit-observation):

```javascript
/**
 * @param {unknown} allegedNum
 * @returns {boolean}
 */
```

**§the-named-unknown-vs-any-discrimination**: `unknown` requires the function to validate before use (TypeScript narrowing); `any` allows the value to be used without validation. The Nat predicate uses `unknown` because it IS the validator. **§the-named-validator-takes-unknown-discipline**.

- **§the-named-`@ts-check`-directive** (first-explicit-observation):

```javascript
// @ts-check
```

**§the-named-`@ts-check`-IS-named-explicit-JSDoc-type-check-enable**: enables TypeScript checking in a JS file via JSDoc. **§the-named-JSDoc-IS-named-type-source**. No separate `.d.ts` file; types live in JSDoc.

§the-named-no-d-ts-file-discipline: cycle 282+ ingests of the zip cluster also showed `@ts-check`; cycle 310 extends the named-`@ts-check`-discipline to another @endo package. **§multi-cycle-pattern-`@ts-check`-discipline** (cycle 282 + ... + 310).

- **§the-named-multi-org-multi-year-copyright-discipline** (first-explicit-observation):

```javascript
// Copyright (C) 2011 Google Inc.
// Copyright (C) 2018 Agoric
```

**§two-named-copyright-attributions**: Google (2011) + Agoric (2018). **§the-named-2011-to-2018-copyright-gap-IS-named-historical-evidence**. **§the-named-seven-year-provenance-gap**.

§the-named-multi-org-provenance-IS-named-historical-evidence: the file's lineage spans two organizations across seven years. **§the-named-deep-provenance-IS-named-foundation-utility-marker**: foundational primitives often have deep cross-organizational lineage.

§the-named-Apache-2.0-license-header: standard Apache 2.0 boilerplate. **§the-named-license-header-IS-named-OSS-discipline**.

- **§the-named-tc39-spec-citation-IS-named-authoritative-link** (first-explicit-observation): the JSDoc cites `https://tc39.es/ecma262/#sec-number.issafeinteger`. **§the-named-cite-the-spec-anchor**. **§the-named-spec-link-IS-named-authoritative-reference**.

§the-named-esdiscuss-archive-citation-IS-named-historical-discussion: the JSDoc cites `https://esdiscuss.org/topic/more-numeric-constants-please-especially-epsilon`. **§the-named-cite-the-historical-discussion**. **§the-named-two-named-link-classes**: spec (current authoritative) + esdiscuss (historical deliberation).

- **§the-named-cycle-310-pivots-from-garden-cluster-to-foundation-utility** (first-explicit-observation): the first non-garden source after cycle 280 (cycle 281 was designs/driver.md inaugurating the 14-cycle garden meta-cluster; cycles 281-309 were the cluster). **§the-named-first-pivot-after-fourteen-cycle-cluster**.

§the-named-pattern-surface-refreshes: cycle 310's section enumerates fresh patterns (JavaScript-validation patterns + naming conventions + multi-org provenance + spec-citation discipline + freeze/harden substitution) rather than the deeply-recursive garden-self-reference patterns. **§the-named-refresh-IS-named-deliberate-anti-saturation**.

§the-named-foundation-utility-shape: `@endo/nat` IS the named-foundation-utility-shape — a 119-line leaf-dependency providing a single named-pair of named-validator-and-coercion. **§the-named-leaf-dependency-discipline**.

## Cross-cycle pattern accumulation

- **§the-named-deliberate-pivot-after-cluster-saturation**: cycle 309 named the cluster's saturation; cycle 310 pivots. **§the-named-cluster-saturation-and-pivot-pair** (309 + 310).
- **§the-named-foundation-utility-shape**: leaf-dependency + 119-line + predicate-and-coercion-pair + canonical-BigInt-constants.
- **§the-named-WET-discipline-for-self-contained-docstrings**: the duplicated rationale comment IS deliberately WET rather than DRY for readability.
- **§the-named-multi-org-multi-year-copyright-discipline**: 2011 Google + 2018 Agoric.
- **§the-named-conditional-applicability-discipline**: Apps Script compat IS scoped to `@endo/marshal` + `@endo/ocapn` (oblique reference).
- **§the-named-freeze-as-harden-stand-in**: explicit substitution under the named-applicability-condition (unadorned arrow functions only).
- **§multi-cycle-pattern-`@ts-check`-discipline**: extends from the zip cluster cycles into cycle 310.

## Notes

- Cycle 310 IS the **first chat-lane non-garden source** after twenty-nine prior cycles of either garden-meta or chat-lane other sources (cycle 280's source was the last non-garden chat-lane; cycles 282-296 were the zip cluster; cycle 298 was scripts; cycles 300-309 were garden meta).
- The named-pivot IS deliberate per cycle 309's named-cluster-IS-fourteen-cycles-and-the-named-pattern-of-pattern-has-saturated note. The pattern surface IS refreshed.
- `@endo/nat` IS one of the smallest @endo packages by line count (~120 lines). Its size belies its centrality: most arithmetic-handling @endo code defers to `Nat` for non-negative-integer validation.
- The named-WET-discipline-for-self-contained-docstrings IS distinct from cycle 305's named-cite-don't-copy-discipline (cycle 308). Cycle 305 (sections cite skills) + cycle 308 (role files cite skills) used cite-don't-copy; cycle 310 (module-level constants) deliberately copies the rationale verbatim. **§two-named-content-policies-by-document-level**: cite at document/role/skill level; copy at code-comment level. The distinction tracks how the reader reaches the content (top-down traversal favors cite; in-place reading favors copy).
- The named-conditional-applicability-discipline (Apps Script compat scoped to specific packages) IS a structural pattern worth borrowing for any library that has optional downstream constraints.
