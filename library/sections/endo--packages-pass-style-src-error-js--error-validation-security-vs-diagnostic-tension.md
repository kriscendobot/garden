---
title: The security-vs-diagnostic-preservation tension in passable-error validation (isErrorLike lets malformed errors stay diagnostic; assertError attaches the validity complaints as notes); the four-property allowlist (message, stack, cause, errors) with the recursive-passable-error rules for cause and errors; the passStyleOf side-effect under unsafe-hardenTaming
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension--abstract.md)
- [Body](endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension--body.md)
- [Connection to the wider library](endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension--see-also.md)
- [Common confusions](endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension--common-confusions.md)
