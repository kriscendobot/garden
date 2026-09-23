---
title: "@endo/hex README.md — ponyfill terminology; supply-chain-attack-exposure threat model; delayed pair with cycle 314"
source-slug: endo--packages-hex-README-md
url: https://github.com/endojs/endo/blob/master/packages/hex/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/hex/README.md
total-lines: 60
ingest-cycle: 317
ingest-date: 2026-06-11
lane: designs
---

# `@endo/hex README.md`

The 60-line README for `@endo/hex` — the hex-encoding ponyfill whose source `encode.js` was ingested in cycle 314. **Eighth consecutive non-garden source after the pivot** (cycles 310-317). **§eight-cycles-with-named-pivot-domain-stay**. **§the-named-delayed-pair-shape** — cycle 314 (hex source) + cycle 317 (hex README) form a *delayed* pair (canonical src→README order but with a three-cycle gap), the third pair shape after adjacent-regular (310-311, 312-313) and adjacent-reverse (315-316).

## Key moves

- **§the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden** — first time in the pivot that hardening is framed as defense against a *named threat* rather than prerequisite/dependency/environment. **Single most structurally interesting move**. First-explicit-observation.
- **§the-named-ponyfill-IS-named-precise-over-polyfill** — README uses *ponyfill* (no-global-mutation) not *polyfill*; §the-named-ponyfill-IS-named-SES-compatible (post-lockdown forbids global mutation); §the-named-naming-IS-named-load-bearing-in-SES-context.
- **§the-named-separate-import-per-direction-discipline** — canonical example imports `encodeHex` from `@endo/hex/encode.js` and `decodeHex` from `@endo/hex/decode.js` *separately*; dual import from `@endo/hex` framed as commented-out alternative "if you genuinely need to entrain both implementations"; §the-named-entrain-IS-named-load-time-cost; §the-named-default-to-narrow-import-with-broad-import-as-escape-hatch.
- **§the-named-LICENSE-file-makes-README-License-section-optional** — hex README omits License section (LICENSE file at `packages/hex/LICENSE` is authoritative); §the-named-four-section-README-shape-as-new-data-point (Install + Usage + API + Hardened-JavaScript; no Overview heading, no License).
- **§the-named-delayed-pair-shape** — third pair shape after adjacent-regular and adjacent-reverse; §four-shapes-of-pair-discipline; §the-named-pair-shape-IS-named-cross-product-of-order-and-gap.
- **§the-named-dispatches-at-module-load-time** — README technique-names cycle 314's source-side §the-named-pre-lockdown-binding-capture; §two-cycles-with-named-module-load-time-dispatch-naming.
- **§the-named-SES-locked-down-compartments-named-as-fallback-trigger** — fallthrough to portable pure-JS triggered by SES realm removing intrinsics; first-explicit-observation.
- **§the-named-name-parameter-as-error-attribution-discipline** mentioned *twice* in the README (intro + API); §three-cycles-with-named-name-parameter-IS-named-error-attribution (315 + 316 + 317).
- **§the-named-throws-on-named-error-conditions** (odd-length strings + chars outside `[0-9a-fA-F]`).
- **§the-named-lowercase-default-with-caller-uppercase-discipline** — README repeats cycle 314's source-side observation; §two-cycles-with-named-lowercase-default-with-caller-uppercase-discipline.
- **§the-named-canonical-Uint8Array-example-shape** — `[0xb0, 0xb5, 0xc4, 0xfe]` round-trip via symmetric encode/decode; §the-named-non-degenerate-example-values.
- **§eight-cycles-with-named-pivot-domain-stay**, **§six-cycles-with-named-Hardened-JS-discipline**, **§four-shapes-of-pair-discipline** (three observed; one structurally possible).

## Section files

- [§the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden + §the-named-ponyfill-IS-named-precise-over-polyfill + §the-named-separate-import-per-direction-discipline + §the-named-delayed-pair-shape + 20+ more first-explicit-observations](../sections/endo--packages-hex-README-md--ponyfill-and-supply-chain-defense-and-delayed-pair-with-cycle-314.md) — full 60-line README in scope.

## Ingest scope

Cycle 317 (designs-lane after cycle 316's chat-lane @endo/lp32 reader.js). Full 60-line README in scope. Eighth consecutive @endo/* source; fourth package (same as cycle 314). **First-explicit-observations (twenty-plus)** including §the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden, §the-named-ponyfill-IS-named-precise-over-polyfill, §the-named-separate-import-per-direction-discipline, §the-named-entrain-IS-named-load-time-cost, §the-named-LICENSE-file-makes-README-License-section-optional, §the-named-delayed-pair-shape, §the-named-pair-shape-IS-named-cross-product-of-order-and-gap, §the-named-SES-locked-down-compartments-named-as-fallback-trigger, §the-named-shift-from-prerequisite-framing-to-threat-model-framing. Multi-cycle: §eight-cycles-with-named-pivot-domain-stay, §four-shapes-of-pair-discipline, §six-cycles-with-named-Hardened-JS-discipline, §three-cycles-with-named-name-parameter-IS-named-error-attribution.
