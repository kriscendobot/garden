---
title: Abstract
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

The `makeRepairError` function (lines 77-153 of `packages/pass-style/src/error.js`) is the pass-style package's defense against a V8-specific capability-leakage channel. The vulnerability: V8 (and Hermes-style imitators) attach an *own* stack accessor property to each Error instance, and that accessor's getter — *identical across all errors in the same realm* — could be invoked by an attacker to communicate arbitrary capabilities through the *stack internal slot of arbitrary frozen objects*. The comment names this *an undeniable channel*. The structural insight the repair relies on: *within the same realm, all Error own-stack-accessor properties have the same getter and the same setter*. So the repair can be cheaply applied (test getter-identity by reference; replace with a data property if it matches) without any indeterminism. The repair runs *only* under certain configurations — specifically, only when `hardenIsNoop(harden)` returns true (i.e. the lockdown's `hardenTaming: "unsafe"` setting is active, or an equivalent fake non-actually-freezing harden is in place); under safe lockdown, harden actually freezes errors and the channel is closed by that freeze. The comment also walks the engine comparison: FF/SpiderMonkey, Moddable/XS, and the error-stack proposal all inherit a stack accessor property from `Error.prototype` rather than carrying an own accessor on each instance, so they need no heroics. The block flags forward-compatibility concern about the `captureStackTrace` proposal — once standardized, more cases will arise where error objects have own stack getters that need to be considered. The repair itself accepts a hazard explicitly: *NOTE: Calls getter during harden, which seems dangerous. But we're only calling the problematic getter whose hazards we think we understand.* Two further safety conditions guard the repair: the accessor must be `configurable` (else the repair cannot replace it, but then the error will not be judged passable anyway, *avoiding a safety problem*); and an *unexpected*-accessor case (one that differs from what we expect) throws `PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR` and points to a SES error-code document for investigation.
