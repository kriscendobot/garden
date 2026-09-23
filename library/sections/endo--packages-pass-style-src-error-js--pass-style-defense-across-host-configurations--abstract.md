---
title: Abstract
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

The opening JSDoc comment on `makeTypeError` (lines 23-65 of `packages/pass-style/src/error.js`) is the package's explicit statement of *what pass-style must defend against, across which host configurations, and with what assumptions about SES*. The block enumerates three configurations: (1) **Start Compartment** — the primary realm into which host module systems load pass-style; here SES provides *no assurances* about guest programs co-executing safely with the host, so the security obligation is *do not run guest code here*; (2) **Guest compartment with frozen globalThis** — the typical `importBundle` configuration where every Node.js package runs in a dedicated compartment with a *gratuitiously frozen* globalThis, so `globalThis.Error` and `globalThis.TypeError` correspond to the realm's intrinsics (either because the Compartment arranged the freeze, or because the pass-style package provides no code that mutates the compartment's globalThis); (3) **Multi-guest shared compartment with unfrozen globalThis** — *incoherent and provides no assurance of mutual safety between those guests*; *no code, much less Pass-style, should be run in such a compartment*. Even in the two safe configurations, the block notes that pass-style relies on `globalThis.Error` and `globalThis.TypeError` bindings — but then constructs `makeTypeError` to return a TypeError instance *guaranteed* to be an instance of the realm intrinsic *by dint of construction from language syntax* (via the `null.null` trick). The rationale closes with the *belt-and-suspenders* idiom — *gratuitous or redundant safety measures; in this case, we wear both belt and suspenders on our overalls*. The pre-SES boot-order disclaimer is the other load-bearing piece: *we have similar code in SES that stands on the irreducible risk that an attacker may run before SES, so the application must either ensure that SES initializes first or that all prior code is benign*.
