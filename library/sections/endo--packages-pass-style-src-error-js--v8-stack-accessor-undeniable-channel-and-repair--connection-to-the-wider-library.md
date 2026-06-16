---
title: Connection to the wider library
source: packages/pass-style/src/error.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-08
source_authors: [Turadg Aleahmad and prior contributors]
source_lines: "77-153 (makeRepairError and repairError construction)"
topics: [hardened-javascript, pass-style, errors, capability-security]
status: current
notes: |
  The `makeRepairError` function is the package's response to a
  V8-specific (and Hermes / FaceBook-flavored) capability-leakage channel:
  Error instances have an own `stack` accessor property whose getter, if
  exposed unchanged on a frozen error, can be invoked by an attacker to
  *communicate arbitrary capabilities through the stack internal slot
  of arbitrary frozen objects*. The comment is unusual in naming the
  channel as *undeniable* — the getter is identical across all errors in
  the same realm, so an attacker who obtains one error's getter can read
  any other error's stack. The repair construction (lines 116-149) walks
  the same-realm-getter-equality observation that justifies replacing
  the getter with a data property containing the resolved stack string;
  and acknowledges the *call-getter-during-harden* hazard ("which seems
  dangerous; but we're only calling the problematic getter whose
  hazards we think we understand").
parent: endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair
---

This section is the **canonical worked example of repairing a realm-level capability-leakage channel by structural reference-equality**. Three threads:

1. **The same-realm-getter-equality structural property is a reusable repair pattern.** Any time a realm-internal accessor is shared across multiple instances, a single-step repair (capture the canonical getter; replace with a data property) suffices. The error.js block names the pattern in concrete terms.
2. **The fail-loud-when-environment-is-unexpected idiom is a defensive-consistency staple.** The `PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR` error and the link to a SES error-code document is the *boundary-confirmation* style that lets a developer investigate before silently broken behavior accumulates.
3. **The acknowledge-the-hazard-then-bound-it idiom is the standard form for *deliberate-controlled-risk* in defensively-consistent code.** The two-line NOTE-then-bound is the pattern.
