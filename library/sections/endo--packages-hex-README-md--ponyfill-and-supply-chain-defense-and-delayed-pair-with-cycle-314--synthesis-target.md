---
title: Synthesis-target
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

Slot machine library **§`@game/encoding/README.md`** — bet-ID and hash encoder:

1. Call it a **ponyfill** (not polyfill) if it ships intrinsic-shaped functions without mutating globals; the word signals SES-compatibility.
2. Cite the TC39 proposal and stage by name (as text, not as link) if implementing a TC39-tracked intrinsic.
3. Frame Hardened-JS as defense against a *named threat* (e.g., "reduces exposure to bet-record-tampering attacks via prototype mutation") rather than as a prerequisite.
4. Separate-import-per-direction discipline: `import { encodeBetId } from '@game/encoding/encode.js'` rather than `import { encodeBetId, decodeBetId } from '@game/encoding'`; offer the broad import as commented-out alternative with framing *"if you genuinely need to entrain both"*.
5. Omit the README License section; the LICENSE file is authoritative.
6. Four-section README shape acceptable for smaller packages (Install + Usage + API + Hardened-JavaScript); reserve six-section shape for larger packages.
7. Two mentions of any optional-name-for-error-attribution parameter — once in intro, once in API.
8. Lowercase canonical with caller-uppercase discipline noted in the encoder's API subsection.
9. API section with H3 subheading per exported function.
10. Canonical example with non-degenerate values (avoid 0x00/0xff and round numbers; prefer multi-byte arbitrary sequences like `0xb0 0xb5 0xc4 0xfe`).
11. If a pair (source + README) is split across multiple ingest cycles, the second member explicitly references the first by its identifying technique-names (e.g., README repeats §the-named-module-load-time-dispatch language used in source comments).
