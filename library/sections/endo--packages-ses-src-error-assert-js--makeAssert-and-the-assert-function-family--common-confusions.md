---
title: Common confusions
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

- **"`assert(cond, X\`msg\`)` and `cond || Fail\`msg\`` are different."** They are equivalent in success cases (both no-op on truthy cond). On failure: `assert(...)` evaluates the template before the call (slight perf cost on the cold path); `Fail\`...\`` invokes the template-tag only on failure. For hot paths, prefer `||`-Fail; for ordinary asserts, either works.
- **"`assert.equal` defaults to `RangeError` — that's wrong."** It is intentional. The standard's `RangeError` is for *out-of-range-of-an-expected-set-of-values*. assert.equal is *out-of-the-expected-set-of-one-value*. A catch clause can selectively handle `instanceof RangeError` for equality failures. The maintainer's choice surfaces type information at the throw.
- **"`assert.typeof(x, 42)` should throw earlier."** It does — via the recursive `typeof typename === 'string' || Fail\`...\`` line. The recursive assert catches the bad call before the meaningless `typeof x === 42` (which would always be `false` since `typeof` returns a string).
- **"`an()` is dead-code for English-only."** It produces grammatically-correct articles in *English*. The output is technically locale-specific, but the maintainer's choice was to keep error messages in English for diagnostic consistency across deployments. Localized error messages are out of scope.
- **"`X`, `q`, `b` are unreadable one-letter exports."** They are *intentional mnemonics* for high-frequency call-site idioms. A typical assert line reads `cond || Fail\`got ${q(x)} expected ${q(y)}\`` — using full names would make the call-site noisy. The README and JSDoc compensate with full documentation; the call-sites get terse.
- **"`makeAssert` re-exposing `optRaise` is a security hole."** It is — *if a malicious party can construct a custom assert and hand it to code that expects the canonical one*. The discipline: the canonical `assert` is the module's main export and is the one most code imports; custom asserts via `makeAssert` are *opt-in* and the caller chooses to trust their own raise hook.
- **"`deprecated.error = makeError` is dead code."** It is *deliberate backwards-compatibility*. Old code wrote `assert.error(X\`msg\`)` to build (not throw) an error; the canonical name is now `makeError` but the old name still works. The deprecated bag is for these graceful renames.
- **"`assertEqual = assert.equal` is just a perf hack."** It is — and *honestly named*. The comment says *Internal, to obviate polymorphic dispatch*. The maintainer didn't hide the optimization; they documented it. Reading the source one understands both *what the line does* and *why it exists*.
