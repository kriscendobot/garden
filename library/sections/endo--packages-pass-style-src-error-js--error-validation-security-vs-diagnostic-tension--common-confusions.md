---
title: Common confusions
source: packages/pass-style/src/error.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-08
source_authors: [Turadg Aleahmad and prior contributors]
source_lines: "184-362 (isErrorLike + confirmRecursivelyPassableErrorPropertyDesc + confirmRecursivelyPassableError + ErrorHelper)"
topics: [hardened-javascript, pass-style, errors, capability-security]
status: current
notes: |
  The block-level rationale for `isErrorLike` (lines 213-225) sets the
  *security-vs-diagnostic-preservation* tension that drives the rest of
  the file: prefer to let an error continue to function as a diagnostic
  even when it is not fully passable, by attaching the validity
  complaints as *notes* on the error rather than swallowing the
  original diagnostic. The implementation then enforces a strict
  four-property own-data-property allowlist (`message`, `stack`,
  `cause`, `errors`) via `confirmRecursivelyPassableErrorPropertyDesc`,
  with `cause` recursing as a single passable error and `errors`
  recursing as a copyArray-of-passable-errors. A subtle
  passStyleOf-side-effect under unsafe-hardenTaming is noted: invoking
  `confirmRecursivelyPassableError` *alters* the candidate by calling
  the stack-accessor repair from the previous section.
parent: endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension
---

- **"A malformed error is invalid."** Not in this package's framing. A malformed error is *passable by itself but not as part of a passable structure*. It can be the top-level error in a marshal report; it cannot be embedded in a CopyRecord's `value` slot. The two-tier passability is the explicit resolution.
- **"The four-property allowlist is restrictive — what about subclasses with extra properties?"** The allowlist is *intentionally* restrictive. A subclass with extra own properties either (a) needs the subclass to be registered as an error constructor in `errorConstructors` AND its properties need to be in the per-property switch, OR (b) the subclass author must use `cause` to wrap a base-error and put the extra information in the `cause` chain. The strict allowlist prevents extra properties from leaking authority across a marshal boundary.
- **"The `passStyleOf` side-effect is a bug."** It is a *deliberate, scoped, disclaimed* violation. Under safe lockdown, no side effect occurs. Under unsafe-hardenTaming, the side effect is to make the error *more* passable than it would otherwise be (by converting an accessor to a data property), so the caller's invariants are preserved. The disclaimer is the contract; the configuration is the scope.
- **"`AggregateError` is just another error class."** Construction-parameter-wise, it is not: `new AggregateError([errors], message)` vs `new Error(message)`. The `getErrorConstructor` disclaimer is the explicit warning; `makeError` is the consumer-side abstraction that encapsulates the difference.
- **"`isErrorLike` is too lenient."** It is *intentionally* lenient. The whole rationale block is the explanation: a less lenient `isErrorLike` would throw away diagnostic information; the strict validation is in `assertError` (or `confirmRecursivelyPassableError(_, Fail)`). The two functions are *complementary*, not redundant.
- **"The TODO about SES whitelist coordination is a defect."** It is a *recorded coupling*. The maintenance hazard is real (adding a new error class requires updating both `errorConstructors` in error.js and the SES whitelist), but the TODO is the documented record of the coupling rather than an attempt to eliminate it.
