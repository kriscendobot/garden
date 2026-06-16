---
title: See also
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

- [[hardened-javascript]] (topic) — SES is the substrate; the SES whitelist coordination is a maintenance hazard the comment flags.
- [[pass-style]] (topic) — the package; the error validation is one of many per-pass-style validations.
- [[errors]] (topic) — error handling; this block is the *passable-error* corner.
- [[marshal]] (topic) — marshal consumes `ErrorHelper.confirmCanBeValid` and `ErrorHelper.assertRestValid` at the wire-boundary.
- [[capability-security]] (topic) — the diagnostic-preservation discipline is a capability-security trade-off: do not weaken diagnostics by being overzealous about structural-validity.
- `endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations` — the first section: the host-configuration regimes this validation runs under.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` — the second section: the repair that this section invokes as a side-effect under unsafe-hardenTaming.
- `endo--packages-marshal-src-marshal-js--error-diagnostic-priority` — adjacent comment-fragment: why marshal deliberately does not put the stack on the wire (the structural complement to the validity-as-notes discipline).
