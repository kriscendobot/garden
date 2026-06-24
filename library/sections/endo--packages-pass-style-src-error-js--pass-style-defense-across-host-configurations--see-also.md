---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate this block defends across; *frozen intrinsics + lockdown* is what Configuration 2 relies on.
- [[pass-style]] (topic) — the package that owns this file; the error.js module is the error-validation surface.
- [[capability-security]] (topic) — three host-configurations is a capability-security catalog; the multi-guest-unsafe configuration is explicitly out of scope.
- [[errors]] (topic) — the broader Endo error-handling surface; this section is the *passable-error-defense* corner.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` — the next section: the V8-specific stack accessor + capability-leakage channel + repair.
- `endo--packages-pass-style-src-error-js--error-validation-security-vs-diagnostic-tension` — the third section: isErrorLike vs assertError + the four-property allowlist.
- [[principle-of-least-authority]] — the *do not run guest code in the Start Compartment* claim is a POLA enforcement at the application architecture layer.
