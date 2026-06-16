---
title: Connection to the wider library
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

This section is the **canonical *factory-produces-callable-with-methods-frozen* worked example**. Three threads:

1. **The `makeAssert` factory with `optRaise` parameter** is reusable for any *substrate-callback-before-trip* pattern. The error is built, the substrate is given a chance to observe/escalate, then the trip happens. Test frameworks, debuggers, and causal-console flushing all use this hook.

2. **The `Fail` template-tag idiom** is the canonical *one-line-throwing-template-literal* shortcut. The `cond || Fail\`...\`` pattern reads as prose-with-substitution and short-circuits the template-tag cost on the happy path.

3. **The three-bag assertionFunctions / assertionUtilities / deprecated structure** is the canonical *evolve-without-breaking-callers* discipline. New canonical names go in the first two bags; old names live in `deprecated` so existing code keeps working.

The §makeAssert design also embodies the *factory-vs-canonical-instance* split: the canonical `assert` (zero-config) is exported as the standard import; the factory `makeAssert` is exposed for niche use cases (custom raise, unredacted mode).
