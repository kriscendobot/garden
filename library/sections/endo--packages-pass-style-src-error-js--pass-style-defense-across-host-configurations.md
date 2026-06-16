---
title: Pass-style's defense across host configurations (Start Compartment, guest compartment with frozen globalThis, multi-guest unsafe shared compartment); the makeTypeError belt-and-suspenders idiom for a guaranteed-realm-intrinsic TypeError instance
source: packages/pass-style/src/error.js
source_repo: endojs/endo
source_branch: master
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
source_date: 2026-04-08
source_authors: [Turadg Aleahmad and prior contributors]
source_lines: "23-77 (makeTypeError header JSDoc + makeTypeError implementation)"
topics: [hardened-javascript, pass-style, errors, capability-security]
status: current
notes: |
  The opening rationale block of `packages/pass-style/src/error.js` is a
  capability-security worked example: a single function (`makeTypeError`)
  whose existence is justified by an explicit enumeration of three
  host-configuration regimes (Start Compartment / guest compartment with
  frozen globalThis / multi-guest unsafe shared compartment) and a
  *belt-and-suspenders* construction (the `null.null` trick) that
  guarantees the returned TypeError is the realm intrinsic by dint of
  construction from language syntax rather than by reading
  `globalThis.TypeError`. Three sub-claims worth quoting verbatim
  ("we wear both belt and suspenders *on our overalls*"; "running
  multiple guests in a single compartment with an unfrozen globalThis is
  incoherent and provides no assurance of mutual safety"; "the host
  must either ensure that SES initializes first or that all prior code
  is benign") sit in this block.
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations--abstract.md)
- [Body](endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations--body.md)
- [Connection to the wider library](endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations--see-also.md)
- [Common confusions](endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations--common-confusions.md)
