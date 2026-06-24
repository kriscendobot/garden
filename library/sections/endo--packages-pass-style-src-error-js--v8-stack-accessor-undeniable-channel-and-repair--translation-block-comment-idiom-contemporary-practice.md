---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Undeniable capability channel | A channel that hardening / freezing cannot close because it is *in the getter*, not the mutable state. Distinct from regular capability-leakage which freeze closes. |
| Same-realm getter equality repair | Reference-identity check; if it matches the canonical, replace with a data property. Cheap. |
| `hardenIsNoop(harden)` gate for the repair | The repair is only needed under `hardenTaming: "unsafe"` — safe lockdown closes the channel by actual freeze. |
| Fail-loud on unexpected accessor | The `SES_UNEXPECTED_*` error-codes-with-documented-investigation idiom across the SES + Endo packages. |
| `// NOTE: Calls getter during harden, which seems dangerous` | The standard *acknowledge-the-hazard-then-bound-it* comment shape. |
| FF/SpiderMonkey / Moddable/XS / error-stack proposal | The block's comparison framing — name the safe engines explicitly so the V8-specific repair's necessity is clear. |
