---
title: Common confusions
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

- **"Why not just use `globalThis.TypeError` directly?"** Configuration 2 says we *can* — but the `makeTypeError` belt-and-suspenders construction is one extra layer of defense. If a future pass-style refactor accidentally introduces code that mutates globalThis (or runs in a Compartment whose creator did not freeze it), `makeTypeError` continues to return a realm-intrinsic TypeError. The redundancy has explicit value.
- **"The `null.null` line is unreachable."** From a runtime perspective, the second `throw TypeError('obligatory')` is unreachable — the `null.null` line throws first. But the static type-flow analyzer needs the second `throw` to prove the function does not return `undefined`. The comment `// To convince the type flow inferrence.` makes the apparent dead-code intentional.
- **"Configuration 1 is unsafe — pass-style is broken there."** Not quite. The block says pass-style does not *promise* safety in Configuration 1 — but pass-style's *internal* code can still be loaded and run in the Start Compartment; what is unsafe is *running guest code* in the Start Compartment. The Start Compartment is for the *host*, which has all the ambient authority anyway; pass-style is content to load there for the host's use.
- **"What about `Realm`-API-style alternatives?"** Out of scope for this block. SES + Compartment + `harden` is the contemporary realization; the block does not engage with the older Realm API proposal.
- **"`gratuitiously` is a typo for `gratuitously`."** Yes, present in the source. The library preserves it verbatim from the source.
