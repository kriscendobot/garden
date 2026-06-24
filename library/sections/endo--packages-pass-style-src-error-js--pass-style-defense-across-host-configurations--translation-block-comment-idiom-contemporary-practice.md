---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Start Compartment vs guest compartment vs unsafe-shared compartment | The three regimes of SES adoption. *Run guest code only in dedicated compartments*. |
| Belt-and-suspenders idiom | Redundant defensive checks (e.g. `passStyleOf` + `assertPassable`) — neither alone is wrong, but both together close composition gaps. |
| `null.null` for syntax-constructed TypeError | The general pattern: get a realm intrinsic by triggering the language to construct it. Used elsewhere to get realm-intrinsic `%FunctionPrototype%`, `%Promise%`, etc. via syntax. |
| "we have similar code in SES" | The SES + pass-style boot-order contract: SES initializes first; thereafter pass-style and marshal rely on SES's frozen intrinsics. |
| "on our overalls" | Self-aware naming of *gratuitous* safety measures. The package author signals this is *more* than belt-and-suspenders. |
