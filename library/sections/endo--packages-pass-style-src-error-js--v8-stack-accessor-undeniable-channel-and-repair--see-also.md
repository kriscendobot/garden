---
title: See also
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

- [[hardened-javascript]] (topic) — the substrate; under safe lockdown, the repair is unnecessary.
- [[pass-style]] (topic) — the package; this block sits within the pass-style error-validation surface.
- [[errors]] (topic) — error handling; the stack-accessor channel is an error-handling capability-leak.
- [[capability-security]] (topic) — the "undeniable channel" framing is the explicit capability-security threat.
- `endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations` — the prior section: the three host configurations under which this repair is or isn't necessary.
- `endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension` — the next section: the property-validation that ultimately invokes the repair as a side-effect under unsafe-hardenTaming.
- `endo--packages-marshal-src-marshal-js--error-diagnostic-priority` — adjacent comment-fragment: why the stack is deliberately not put on the wire (the marshal side of the same security concern).
- [[principle-of-least-authority]] — the channel violates POLA: a frozen error leaks more authority than the sender intended.
