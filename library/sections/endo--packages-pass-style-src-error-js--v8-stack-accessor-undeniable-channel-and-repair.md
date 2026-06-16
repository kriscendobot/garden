---
title: The V8-specific own-stack-accessor as an undeniable capability-leakage channel through frozen-object stack internal slots; the same-realm-getter-equality structural property that justifies a repair; the captureStackTrace proposal's forward-compatibility concern; the call-getter-during-harden hazard that the repair accepts
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair--abstract.md)
- [Body](endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair--body.md)
- [Connection to the wider library](endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair--see-also.md)
- [Common confusions](endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair--common-confusions.md)
