---
kind: result
role: liaison
dispatch-root: dispatches/liaison--452fe8
cycle: 317
lane: designs
host: endolin
date: 2026-06-11
---

# Result — liaison cycle 317: @endo/hex README.md (designs-lane; eighth consecutive @endo/* source; delayed-pair shape established; supply-chain-attack threat-model framing introduced)

Cycle 317 ingest: **@endo/hex README.md** (60 lines) — the README companion to cycle 314's @endo/hex/src/encode.js. Designs-lane after cycle 316's chat-lane @endo/lp32 reader.js. **Eighth consecutive non-garden source after the pivot** (cycles 310-317). **Fourth package extends** — hex was cycle 314's package; cycle 317 retroactively pairs it.

## Single most structurally interesting move

**§the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden** — the README's closing line:

> In a post-lockdown environment, this module hardens its interfaces to reduce supply chain attack exposure.

This is the **first time in the seven-cycle pivot that hardening is framed as defense against a *named threat*** rather than as a prerequisite, environment requirement, or dependency:

- 310 (nat source): freeze used as a stand-in for harden under a named applicability condition — no threat named
- 312 (memoize source): harden imported canonically — no threat named
- 313 (memoize README): "intended for Hardened JavaScript" — named as *target environment*; no threat named
- 315 (lp32 README): Hardened-JavaScript section with "environment must be locked down" discipline — named as *environment requirement*; no threat named
- 316 (lp32 reader.js): `harden()` called twice — no threat named
- **317 (hex README): hardening *reduces supply chain attack exposure*** — named as *defense against named threat*

§the-named-shift-from-prerequisite-framing-to-threat-model-framing — first-explicit-observation. The naming alone shifts the conversation; the README does not elaborate on the attack mechanism, but **§the-named-supply-chain-attack-exposure** as a phrase concretizes the abstract "lockdown discipline" of prior cycles.

## Delayed pair: cycle 314 + cycle 317

Cycles 314 (@endo/hex source) and 317 (@endo/hex README) form a **delayed pair**: canonical src→README order, but with a three-cycle gap (315 lp32 README + 316 lp32 reader.js intervened). This is the **third pair shape** in the pivot, after:

- **Regular adjacent** (310-311 nat src→README, 312-313 memoize src→README)
- **Reverse adjacent** (315-316 lp32 README→src)
- **Delayed src→README** (314 + 317 hex)

§the-named-pair-shape-IS-named-cross-product-of-order-and-gap parameterizes these by (order × gap):

| Order | Gap | Cycles |
|---|---|---|
| src→README | adjacent | 310-311, 312-313 |
| README→src | adjacent | 315-316 |
| src→README | delayed | 314 + 317 |
| README→src | delayed | *not yet observed* |

**§four-shapes-of-pair-discipline** — the cross-product produces four shapes; three observed; one structurally possible (would arise if a README is ingested and the source arrives many cycles later).

## First-explicit-observations (twenty-plus)

- §the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden
- §the-named-shift-from-prerequisite-framing-to-threat-model-framing
- §the-named-ponyfill-IS-named-precise-over-polyfill
- §the-named-ponyfill-IS-named-SES-compatible
- §the-named-naming-IS-named-load-bearing-in-SES-context
- §the-named-terminology-IS-named-security-claim
- §the-named-separate-import-per-direction-discipline
- §the-named-entrain-IS-named-load-time-cost
- §the-named-default-to-narrow-import-with-broad-import-as-escape-hatch
- §the-named-tree-shaking-aware-discipline-without-requiring-tree-shaking
- §the-named-LICENSE-file-makes-README-License-section-optional
- §the-named-four-section-README-shape-as-new-data-point
- §the-named-README-shape-IS-named-tailored-to-package-depth
- §the-named-delayed-pair-shape
- §the-named-pair-shape-IS-named-cross-product-of-order-and-gap
- §the-named-dispatches-at-module-load-time
- §the-named-SES-locked-down-compartments-named-as-fallback-trigger
- §the-named-realm-removes-intrinsics-IS-named-SES-specific-failure-mode
- §the-named-throws-on-named-error-conditions
- §the-named-canonical-Uint8Array-example-shape
- §the-named-API-section-with-H3-subheadings-per-function
- §the-named-proposal-stage-citation-without-link

## Multi-cycle patterns extended

- §eight-cycles-with-named-pivot-domain-stay (310 + 311 + 312 + 313 + 314 + 315 + 316 + 317)
- §four-shapes-of-pair-discipline (three observed; one structurally possible)
- §six-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317)
- §three-cycles-with-named-name-parameter-IS-named-error-attribution (315 + 316 + 317)
- §two-cycles-with-named-Stage-4-TC39-proposal-citation (314 source + 317 README; doc/impl boundary)
- §two-cycles-with-named-lowercase-default-with-caller-uppercase-discipline (314 + 317; doc/impl boundary)
- §two-cycles-with-named-module-load-time-dispatch-naming (314 + 317; doc/impl boundary)
- §two-cycles-with-named-API-section-IS-named-formal-parameter-documentation (315 + 317)

## Tier-3 meta-patterns

- **§the-named-shift-from-prerequisite-framing-to-threat-model-framing** — the discourse moves from "X requires hardening" to "hardening defends against named-threat Y"
- **§the-named-pair-shape-IS-named-cross-product-of-order-and-gap** — pair shapes parameterized by (order × gap); cross-product produces 4 shapes; 3 observed
- **§the-named-ponyfill-IS-named-SES-compatible** — terminology choice signals security posture
- **§the-named-entrain-IS-named-load-time-cost** — single-word naming makes the per-import cost visible
- **§the-named-LICENSE-file-makes-README-License-section-optional** — when an authoritative artifact exists, README doesn't mirror it
- **§the-named-terminology-IS-named-security-claim** — the *name* (ponyfill, not polyfill) is the security claim

## Synthesis-target

Slot machine library **§`@game/encoding/README.md`** — bet-ID and hash encoder:

1. Call it a **ponyfill** (not polyfill) if it ships intrinsic-shaped functions without mutating globals; the word signals SES-compatibility.
2. Cite TC39 proposal and stage by *name as text* (not as link).
3. Frame Hardened-JS as defense against a *named threat* (e.g., "reduces exposure to bet-record-tampering attacks via prototype mutation") rather than as a prerequisite.
4. Separate-import-per-direction discipline: `import { encodeBetId } from '@game/encoding/encode.js'`; offer dual import as commented-out alternative with framing *"if you genuinely need to entrain both"*.
5. Omit the README License section; the LICENSE file is authoritative.
6. Four-section README shape acceptable for smaller packages (Install + Usage + API + Hardened-JavaScript); reserve six-section shape for larger packages.
7. Two mentions of any optional-name-for-error-attribution parameter — once in intro, once in API.
8. Lowercase canonical with caller-uppercase discipline noted in the encoder's API subsection.
9. API section with H3 subheading per exported function.
10. Canonical example with non-degenerate values (avoid 0x00/0xff; prefer multi-byte arbitrary sequences).
11. If a pair (source + README) is split across multiple ingest cycles, the second member explicitly repeats the first's identifying technique-names.

## Library state after cycle 317

- §library-reaches-829-sections from 367 source documents
- §one-hundred-and-fiftieth consecutive designs-chat alternation (cycles 166-250 + 252-317; 251 out-of-band)
- §eight-cycles-with-named-pivot-domain-stay (pivot productive at eight cycles)
- §four-shapes-of-pair-discipline established this cycle (three observed; one structurally possible)
- §six-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317)
- The 150th alternation tick lands on a milestone-shaped cycle that introduces a new threat-model framing — coincidence or rhythm? Track for future cycles whether milestone ticks consistently coincide with shape-introducing cycles.

## Next cycle pacing

Cycle 318 is chat-lane next. With four-shapes-of-pair-discipline established, candidate moves:

- **@endo/hex/src/decode.js** — would complete a *three-file* hex cluster (314 encode source + 317 README + 318 decode source); the README explicitly names `decodeHex` separately from `encodeHex`, so the source would have its own load-bearing observations (odd-length and bad-char rejection; case-insensitive parsing). Chat-lane fits.
- **@endo/lp32/writer.js** (49 lines) — would complete a *three-file* lp32 cluster (315 README + 316 reader + 318 writer); writer is smaller than reader (no buffering complications) but mirrors reader's two-layer-factory shape. Chat-lane fits.
- **@endo/stream/src/...** — chat-lane; would establish a fifth package in the pivot cluster (`@endo/stream` was cited from cycle 315's lp32 round-trip example as the cross-package composition partner).

@endo/hex decode.js is the more productive choice (closes hex into a complete three-file cluster — first such cluster of the pivot — and gives us a *fourth* doc/impl boundary cross-reference: hex encode (314 source) + hex README (317 doc) + hex decode (318 source); the decode source's error-condition implementation would technique-name the README's §the-named-throws-on-named-error-conditions). Picking freely but tracking for future work.
