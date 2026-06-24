---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `condition || fail(...)` | The standard *||-fail* short-circuit idiom; truthy means assertion holds. |
| `cond || Fail\`got ${value}\`` | The one-line-throwing-template-literal shortcut; reads as prose-with-substitution. |
| `Don't freeze or export assert until we add methods.` | The *augment-then-freeze* discipline; mutate the base, attach methods, freeze the composite. |
| `Object.is` (imported as `is`) | The value-equality semantics that differs from `===` on NaN and ±0. |
| `errConstructor || RangeError` (default for assert.equal) | The honest-type-information discipline; RangeError signals *not-the-expected-value*. |
| `typeof typename === 'string' \|\| Fail\`...\`` | The recursive-assertion idiom; assert.typeof asserts its own typename argument. |
| `an(typename)` article-agreement | The *a-vs-an-article-by-first-phoneme* helper; produces grammatically correct *a string* / *an object*. |
| `bare(typeWithDeterminer)` | Use bare for the type-phrase since it matches `canBeBare` regex; render verbatim without JSON-quoting. |
| `X`, `q`, `b` re-exports | One-letter mnemonics for high-frequency call-site idioms; substitute readability for length. |
| `Internal, to obviate polymorphic dispatch` | The honest-perf-optimization comment; direct binding avoids `.equal` property lookup in hot paths. |
| `assign(assert, {...funcs, ...utilities, ...deprecated})` | The *new-canonical-over-deprecated* spread-order discipline; later spreads win on key collision. |
