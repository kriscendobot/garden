---
title: Common confusions
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

- **"`undeniable` means inevitable."** Not in the comment's usage. *Undeniable* means: *cannot be closed by freeze / harden alone*. The repair *is* a denial; it's just that freeze / harden is insufficient on its own. The repair plus freeze together close the channel.
- **"V8 should fix this."** That is a separate engine-level concern. The pass-style package's responsibility is to defend against the current V8 behavior; if V8 changes to inherit the accessor from `Error.prototype` (like FF/SpiderMonkey), the `hardenIsNoop` gate would have to be refined, but the safety claim of pass-style still holds during the transition.
- **"The repair is incomplete because it doesn't repair other accessor properties."** The repair targets *only* the `stack` accessor because that is the specific channel V8 creates. Other accessor properties on errors (if any) are caught by the broader `confirmRecursivelyPassableErrorPropertyDesc` validation in the next section.
- **"Calling a getter during `defineProperty` is a runtime panic."** Calling *any* getter during a synchronous operation that holds a "weave-in-progress" invariant can be dangerous. The block's NOTE acknowledges this; the bound is that the getter being called is *the realm-internal V8 stack getter*, whose behavior is bounded by the engine's stack-frame internal slots (and is *not* user code, by definition of "realm-internal"). Other getters would not pass the reference-identity check.
- **"The proposal-error-capturestacktrace link is just a hint."** It is the formal *forward-compatibility-watch*: the proposal would standardize V8-style own-stack-accessors across engines, and the pass-style repair would need to extend if the proposal lands. Worth tracking for any future SES + pass-style + harden compatibility sweep.
