---
title: The `makeAssert` factory that takes an optional `optRaise` callback (the *escalate-before-throw* hook) and an `unredacted` flag and produces a complete assert function family; the `fail` function that builds an error via `makeError`, optionally raises it through `optRaise`, then throws; the `Fail` template tag that is the *one-line-throwing-template-literal* shortcut (`x === 5 \|\| Fail\`got ${x}\``); the base `assert(condition, optDetails, errConstructor, options)` that short-circuits on truthy via the *||-fail* idiom; the `assert.equal` function paired with `Object.is`-style equality, defaulting `RangeError` for type-coherence with the spec's Range-Error-for-numeric-out-of-bounds discipline; the `assertTypeof` function that uses the `an(typename)` article-agreement helper to render `must be a string` / `must be an object`; the `assert.string` convenience shortcut; the assignment-and-freeze finishing pattern (`assign(assert, ...assertionFunctions, ...assertionUtilities, ...deprecated)`); the module-level `export const assert = makeAssert()`; the re-exports (`X`, `q`, `b`, `annotateError`, `assertEqual`, `makeError`) that name the assert surface for non-`assert.foo`-style consumers
source: packages/ses/src/error/assert.js
source_repo: endojs/endo
source_branch: master
source_commit: bfa149b4f18c6ad1cf1fed3e91cbaddf1e61b39d
source_date: 2026-06-23
source_authors: [Richard Gibson]
source_lines: "508-633 (makeAssert + fail + Fail + assert + equal + assertTypeof + assertString + assertion bundles + module-level exports)"
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family--abstract.md)
- [Body](endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family--see-also.md)
- [Common confusions](endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family--common-confusions.md)
