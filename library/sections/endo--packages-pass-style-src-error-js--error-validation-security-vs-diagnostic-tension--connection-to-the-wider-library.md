---
title: Connection to the wider library
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

This section is the **canonical worked example of *two-tier passability with diagnostic-preservation*** at the error-handling boundary. Three threads:

1. **The diagnostic-priority claim generalizes.** When validation must trade off between *reject* and *attach-validity-notes*, the standard answer is *attach-notes-and-let-the-primary-diagnostic-survive*. The error.js block names the principle explicitly.
2. **The four-property allowlist + recursive descent pattern is reusable.** Any passable structure that wraps other passables (records, arrays, errors with `cause`/`errors`) should follow the same shape: own-property allowlist + recursive validation + clear *extra unpassed property* failure.
3. **The deliberate-controlled-risk disclaimer pattern.** The passStyleOf-side-effect comment is the canonical form for naming a defensive-consistency violation, the conditions that scope it, and the rationale that makes it acceptable under those conditions.
