---
created: 2026-06-03
updated: 2026-06-03
author: gardener
---

# Skill: test-title-spec-spelling

When a test title names a method, class, property, or other surface defined in a published specification (ECMA, W3C, WHATWG, IETF, etc.), spell the named surface exactly as the specification spells it.

## When to use

- A builder, fixer, or panel-juror writes or reviews test titles that name spec-defined surfaces. Common cases: tests for `TypedArray` methods, `Array.prototype` methods, `Promise` API, `Iterator`/`AsyncIterator` protocols, `Object.*` static methods, `Symbol.*` well-known symbols, DOM interfaces, fetch / Streams / URL APIs, RFC-defined headers.
- A panel finding flags a misspelling in a test title under code review. The fix is mechanical; the discipline becomes citable for the next reviewer.

## The rule

The spec is the source of truth. Test titles use the spec's casing, hyphenation, and punctuation for every named surface. Examples drawn from the ECMA-262 surface set:

- `TypedArray` (the abstract class), **not** `TypeArray` or `Typed Array`.
- `subarray` (the method on `Uint8Array.prototype` and siblings), **not** `subArray`.
- `Promise.withResolvers`, **not** `Promise.WithResolvers` or `Promise.with_resolvers`.
- `Array.prototype.toSorted`, **not** `Array.prototype.toSort` or `Array.prototype.sortToNew`.
- `Iterator.prototype[Symbol.iterator]`, **not** `Iterator[Symbol.iterator]`.

The discipline applies to the surface names inside the title. Surrounding narrative text (the prose explaining what the test asserts) follows the broader prose-style conventions in `roles/COMMON.md` § Style; the rule here is specifically about the named-surface spellings.

## Why

Test titles are grep targets. A developer or panel reviewer searching the suite for `subarray` should find every test that exercises `Uint8Array.prototype.subarray`; a `subArray` typo hides the test. The same logic applies to failure-output readability: a panel reading `'(TypedArray|Buffer).(slice|subArray) on freezable TypeArray'` in the test-run output cannot immediately identify which spec surface failed.

A title that diverges from the spec spelling also signals (incorrectly) that the bot did not read the spec before writing the test. The spelling is the cheapest evidence that the bot's coverage is grounded in the standard's actual shape.

## Examples in the field

- 2026-06-03 round-1 finding on `endojs/endo-but-for-bots#417`,
  `packages/immutable-arraybuffer/test/immutable-arraybuffer-shim-slice.test.js:238`:
  the title read `'(TypedArray|Buffer).(slice|subArray) on freezable TypeArray'`
  (twin misspellings: `subArray` for `subarray`, `TypeArray` for `TypedArray`).
  The fixer's round-1 push aligned the title to spec spelling. The justice
  forwarded the discipline to the gardener via
  `journal/entries/2026/06/03/203800Z-message-gardener-53be75.md`.

## Composition with neighbouring skills

- `skills/regression-evidence/SKILL.md` — regression evidence answers *what does this test prove*; the title spelling answers *which spec surface does this test cover*. The two compose: a title pinned to the spec name plus a regression demonstration on a fault injection together make a test that is both grep-discoverable and load-bearing.
- `skills/coverage-driven-testing/SKILL.md` — coverage selection identifies which spec surfaces need tests; this rule names how those tests are titled when they land.
- `skills/adversarial-tests/SKILL.md` — adversarial tests probe seams the happy-path tests miss; the spec-spelling rule applies to adversarial titles too. An adversarial test for `Uint8Array.prototype.subarray` is titled with `subarray`, not a creative variation.

## Notes from the field

- _2026-06-03_: skill landed by gardener after the justice on `endojs/endo-but-for-bots#417` forwarded the panel's `[proposed-rule]` note per `skills/panel-review/SKILL.md` § Cite-or-propose discipline. Source juror: stylist (round 1). The catalyst is one observation; the skill lands now (rather than waiting for a second occurrence) because the rule is small, well-defined, and the panel anticipates the same shape recurring on any PR exercising spec-defined surfaces.
