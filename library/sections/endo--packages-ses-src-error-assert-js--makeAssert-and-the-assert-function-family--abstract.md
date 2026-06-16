---
title: Abstract
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson]
source_lines: "479-604 (makeAssert + fail + Fail + assert + equal + assertTypeof + assertString + assertion bundles + module-level exports)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The *user-facing surface* of SES's assert module. The §makeAssert
  factory takes an optional `optRaise` callback that escalates-then-
  throws (used by `assertChecker` patterns where the caller wants to
  log or break before the throw propagates), and an `unredacted` flag
  that selects between `redactedDetails` and `unredactedDetails`. The
  produced `assert` function is callable as `assert(cond, X\`msg\`)`
  using the standard *||-fail* short-circuit idiom; carries `equal`,
  `typeof`, `string`, `fail`, `note`, `details`, `Fail`, `quote`,
  `bare`, `makeError`, `makeAssert` as methods; and is frozen via
  `assign(assert, ...) && freeze(...)`. The §Fail template-tag
  shortcut is the maintainer's preferred *one-line-throwing-
  template-literal* idiom — `x === 5 \|\| Fail\`got ${x}\`` reads as
  prose-with-substitution. The module's last action is `export const
  assert = makeAssert()` — the canonical pre-built assert that the
  rest of the codebase imports.
parent: endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family
---

The §makeAssert factory (lines 484-584) takes two optional parameters: `optRaise` (a callback invoked on the error *before* it is thrown — typically used for `console.error`-style escalation, breakpoints, or causal-console flushing) and `unredacted` (a flag that selects `unredactedDetails` for the `details` bound inside this assert's templates). The §fail function builds an error via `makeError`, calls `optRaise(reason)` if provided, then throws the error. The §Fail template tag is the *one-line-throwing-template-literal* shortcut: `cond || Fail\`got ${value}\`` reads as `cond, or fail with this prose-with-substitution`. The §base assert function uses the standard JavaScript *||-fail* short-circuit idiom: `condition || fail(...)`. The §assert.equal function uses `Object.is`-style equality (imported as `is`) and defaults `RangeError` as the constructor (consistent with the standard's *out-of-range numeric values throw RangeError* discipline, generalized to *not-the-expected-value*). The §assertTypeof function dispatches on `typeof specimen === typename` and uses the §an(typename) article-agreement helper (imported from a sibling module) to render *must be a string* / *must be an object* / *must be an undefined*. The §assertString is a one-line convenience shortcut: `assertTypeof(specimen, 'string', optDetails)`. The §finalizing pattern: `assign(assert, {...assertionFunctions, ...assertionUtilities, ...deprecated})` and `freeze(finishedAssert)`. The §module-level `assert = makeAssert()` produces *the canonical assert* that the rest of @endo imports; the assert re-exports `X` (`= redactedDetails`), `q` (`= quote`), `b` (`= bare`), `annotateError` (`= note`), `assertEqual` (`= assert.equal`), and `makeError` for non-`assert.foo`-style consumers.
