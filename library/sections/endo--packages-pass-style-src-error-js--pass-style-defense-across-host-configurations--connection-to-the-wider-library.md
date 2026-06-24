---
title: Connection to the wider library
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
parent: endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations
---

This section is the **canonical worked example of *capability-security reasoning across multiple host configurations*** at the source-code-comment level. Three threads to highlight:

1. **The three-configuration enumeration is reusable.** Any pass-style-adjacent module (marshal, captp, harden) faces the same Start-Compartment / guest-with-frozen-globalThis / multi-guest-unsafe trichotomy. The block's *explicit negative spec for Configuration 3* is the canonical pattern for ruling out unsafe configurations.

2. **The belt-and-suspenders idiom is the literal name of a defensive-consistency discipline.** The Hardened JavaScript stack uses redundant safety mechanisms throughout — frozen intrinsics + `harden` + Compartment isolation; `passStyleOf` + `assertPassable` + `confirmRecursivelyPassable`; `harden` + `hideAndHardenFunction`. The error.js block names the discipline explicitly.

3. **The `null.null` syntax-based-construction trick generalizes.** Any time a defensively-consistent module needs an instance of a built-in type *guaranteed* to be the realm intrinsic, the pattern is *trigger the language to construct it via syntax*. This avoids any globalThis lookup. The marshal package uses similar language-level construction for built-in passable shapes.
