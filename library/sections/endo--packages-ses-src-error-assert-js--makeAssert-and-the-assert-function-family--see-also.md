---
title: See also
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
parent: endo--packages-ses-src-error-assert-js--makeAssert-and-the-assert-function-family
---

- [[hardened-javascript]] (topic) — the SES substrate; this assert module's exports are imported by every @endo and SES module.
- [[errors]] (topic) — the broader SES error-handling system; this section is the user-facing surface that builds and throws the errors.
- `endo--packages-ses-src-error-assert-js--declassifiers-quote-bare-and-redacted-vs-unredacted-details` — the redaction-discipline section; the `details`/`quote`/`bare`/`Fail` primitives this section composes.
- `endo--packages-ses-src-error-assert-js--logArgs-makeError-sanitizeError-tagError-and-loggedErrorHandler` — the rendering-machinery section; `makeError` and `note` that this section's `fail` and `Fail` produce errors through.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the causal-console that renders errors; an `optRaise` callback can be wired to flush to the console before throw.
- `endo--packages-pass-style-src-error-js--*` (cycle 87) — pass-style's error-validation surface; errors thrown by `fail` flow through pass-style on cross-compartment passage.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — produces causal annotations; the `note` re-exported here as `annotateError` is the surface that track-turns annotates through.
