---
title: The single most structurally interesting move
source: endo--packages-hex-README-md
url: https://github.com/endojs/endo/blob/master/packages/hex/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/hex/README.md
total-lines: 60
ingest-cycle: 317
ingest-date: 2026-06-11
lane: designs
section-tags:
  - the-named-ponyfill-IS-named-precise-over-polyfill
  - the-named-separate-import-per-direction-discipline
  - the-named-entrain-IS-named-load-time-cost
  - the-named-default-to-narrow-import-with-broad-import-as-escape-hatch
  - the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden
  - the-named-LICENSE-file-makes-README-License-section-optional
  - the-named-delayed-pair-shape
  - the-named-pair-shape-IS-named-cross-product-of-order-and-gap
  - eight-cycles-with-named-pivot-domain-stay
  - six-cycles-with-named-Hardened-JS-discipline
  - four-shapes-of-pair-discipline
  - the-named-shape-varies-by-package-content-extends
  - the-named-shorter-README-with-no-License-and-no-Overview-heading
  - the-named-four-section-README-shape-as-new-data-point
parent: endo--packages-hex-README-md--ponyfill-and-supply-chain-defense-and-delayed-pair-with-cycle-314
---

**§the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden** — the final line of the README (line 59-60):

> In a post-lockdown environment, this module hardens its interfaces to reduce supply chain attack exposure.

This is the **first time in the seven-cycle pivot that hardening is framed as defense against a *named threat*** rather than as a prerequisite or dependency. Compare:

- Cycle 310 (@endo/nat source): freeze used as a stand-in for harden under a named applicability condition (no threat named)
- Cycle 312 (@endo/memoize source): `import { harden } from '@endo/harden'` as canonical import (no threat named)
- Cycle 313 (@endo/memoize README): "@endo/memoize is intended for Hardened JavaScript" (named as *target environment*; no threat named)
- Cycle 315 (@endo/lp32 README): "Hardened JavaScript section" with "environment must be locked down" discipline (named as *environment requirement*; no threat named)
- Cycle 316 (@endo/lp32 reader.js): `harden()` called twice (no threat named)
- **Cycle 317 (@endo/hex README)**: hardening *reduces supply chain attack exposure* (named as *defense against named threat*)

§the-named-shift-from-prerequisite-framing-to-threat-model-framing — first-explicit-observation in library. **§the-named-supply-chain-attack-exposure** as a phrase concretizes the abstract "lockdown discipline" of prior cycles. The README does not elaborate on the attack mechanism (a supply-chain attack would, e.g., compromise a dependency that mutates `Uint8Array.prototype.toHex` after lockdown; hardened interfaces resist that redirection), but the *naming alone* shifts the conversation from prerequisite to defense.
