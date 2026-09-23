---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Two-tier passability (isErrorLike + assertError) | A *positive spec* for *can-be-used-as-top-level-report* and a *strict spec* for *embedded-in-structure*. The two-tier pattern lets diagnostic and structural validation coexist. |
| Attach validity complaints as notes | Use `@endo/errors`'s note-attachment machinery rather than throwing; preserve the original diagnostic. |
| Four-property allowlist + recursive descent | The standard passable-validation discipline; analogous to copyRecord's enumerable-string-keys + recursive-passable-value rule. |
| Error-constructor registry + AggregateError-non-uniformity disclaimer | The error-class enumeration is the SES whitelist; AggregateError's construction-parameter divergence is captured in `makeError`. |
| passStyleOf side-effect under unsafe-hardenTaming | A deliberately-accepted defensive-consistency violation, scoped to a specific lockdown configuration. The disclaimer is the contract. |
| TODO: Maintenance hazard: Coordinate with the list of errors in the SES whilelist | The known cross-package coupling that the file's maintainer must remember when adding new error classes. |
