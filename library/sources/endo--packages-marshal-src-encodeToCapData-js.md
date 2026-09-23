---
title: "@endo/marshal src/encodeToCapData.js — legacy CapData format; QCLASS Hilbert-Hotel collision-handling; eleventh package; six citation-arc closures; new longest arc 259 cycles (cycle 69 → 328)"
source-slug: endo--packages-marshal-src-encodeToCapData-js
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
ingest-cycle: 328
ingest-date: 2026-06-15
lane: chat
---

# `@endo/marshal src/encodeToCapData.js`

The 443-line legacy CapData encoder. **Nineteenth consecutive non-garden source after the pivot** (cycles 310-328). **Eleventh package added to pivot cluster** (marshal; previously in library via cycles 69 + 74 + 81 + 84-85 + 144 + 160).

Closes **six citation arcs in one cycle** (matching cycle 325's record):
- Cycle 69 (encodeToSmallcaps.js) — **259 cycles** — **NEW pivot-record longest arc** (beats cycle 321→66 at 255 cycles)
- Cycle 71 (passStyleOf.js) — 257 cycles
- Cycle 74 (marshal.js) — 254 cycles
- Cycle 81 (encodePassable.js) — 247 cycles
- Cycle 148 (symbol.js Hilbert-Hotel) — 180 cycles
- Cycle 325 (pass-style README's Serialization role-label) — 3 cycles

**§twenty-two-citation-arc-closures-in-pivot-now** (16 + 6).

## Key moves

- **§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — QCLASS discriminator collision-handling (line 165-184); same technique as cycle 148 symbol.js applied to QCLASS. **Single most structurally interesting move**. §two-cycles-with-named-Hilbert-Hotel-encoding (148 + 328); first-explicit-observation as a tier-3 transferable technique.
- **§the-named-CapData-vs-smallcaps-format-evolution** — this file is the *legacy* format; cycle 69's encodeToSmallcaps.js is the newer format; both coexist. §the-named-legacy-format-still-supported-discipline; §the-named-protocol-contract-IS-named-permanent-once-shipped (sibling to cycle 326's @deprecated-but-still-working; this is NOT-EVEN-deprecated).
- **§the-named-QCLASS-special-property-name** — `'@qclass'` reserved discriminator; §the-named-at-prefix-IS-named-meta-prefix-discipline.
- **§the-named-canonical-encoding-via-sorted-property-names** for cross-vat equality; §the-named-canonical-encoding-needed-for-equality (non-determinism would break the protocol).
- **§the-named-three-encoder-options-with-default-rejectors** — `encodeRemotableToCapData` + `encodePromiseToCapData` + `encodeErrorToCapData` all default to throwing; §the-named-dontEncode-family-of-default-rejectors (forces explicit opt-in).
- **§the-named-encodeRecur-callback-parameter** — each encoder takes `(value, encodeRecur)` for recursive composition; §the-named-recursive-callback-injection.
- **§the-named-switch-on-passStyleOf** — exhaustive switch on 13 pass-styles; closes cycle 71 and cycle 325 arcs.
- **§the-named-special-case-NaN-Infinity-and-minus-Infinity** — QCLASS-wrapped IEEE-754 edge cases; §the-named-IEEE-754-edge-cases-explicit-discipline; -0 normalizes to 0.
- **§the-named-bigint-encoded-as-digits-string** — `{ [QCLASS]: 'bigint', digits: String(passable) }`.
- **§the-named-symbol-encoded-via-passableSymbolForName** — closes cycle 148 arc by USING the Hilbert-Hotel encoded symbol names.
- **§the-named-error-special-case-at-root-not-passable** — accept unfrozen errors at root for diagnostic priority; §the-named-diagnostic-priority-over-strictness-at-root (sibling to cycle 87 error.js observation).
- **§the-named-Recur-name-suffix-for-recursive-helper** — `encodeToCapDataRecur` recursive interior + `encodeToCapData` entry point with root error handling.
- **§the-named-byteArray-TODO** — explicit limit-naming for what's not-yet-supported.
- **§the-named-Object-destructure-at-module-load** — three destructure clusters (Array + Reflect + Object) with nine names; §four-cycles-with-named-Object-destructure (310 + 322 + 326 + 328) — recurring substrate-discipline confirmed.
- **§nineteen-cycles-with-named-pivot-domain-stay**, **§eleven-named-packages-in-the-pivot-cluster**, **§twenty-two-citation-arc-closures-in-pivot-now**, **§six-citation-arc-closures-in-cycle-328**.

## Section files

- [§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique + §the-named-QCLASS-special-property-name + §the-named-CapData-vs-smallcaps-format-evolution + 20+ more first-explicit-observations](../sections/endo--packages-marshal-src-encodeToCapData-js--legacy-CapData-encoding-with-Hilbert-Hotel-and-six-arc-closures.md) — full 443-line source in scope.

## Ingest scope

Cycle 328 (chat-lane after cycle 327's designs-lane @endo/patterns README). Full 443-line source in scope. Nineteenth consecutive @endo/* source; **eleventh package** in pivot cluster. Closes **six citation arcs** including NEW PIVOT-RECORD longest arc (cycle 69 → 328 = 259 cycles, beating cycle 321 → 66 at 255). **First-explicit-observations** including §the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique, §the-named-CapData-vs-smallcaps-format-evolution, §the-named-legacy-format-still-supported-discipline, §the-named-protocol-contract-IS-named-permanent-once-shipped, §the-named-QCLASS-special-property-name, §the-named-canonical-encoding-via-sorted-property-names, §the-named-canonical-encoding-needed-for-equality, §the-named-three-encoder-options-with-default-rejectors, §the-named-dontEncode-family-of-default-rejectors, §the-named-encodeRecur-callback-parameter, §the-named-switch-on-passStyleOf, §the-named-special-case-NaN-Infinity-and-minus-Infinity, §the-named-IEEE-754-edge-cases-explicit-discipline, §the-named-bigint-encoded-as-digits-string, §the-named-error-special-case-at-root-not-passable, §the-named-diagnostic-priority-over-strictness-at-root, §the-named-Recur-name-suffix-for-recursive-helper, §the-named-byteArray-TODO, §the-named-at-prefix-IS-named-meta-prefix-discipline. Multi-cycle: §nineteen-cycles-with-named-pivot-domain-stay, §eleven-named-packages-in-the-pivot-cluster, §twenty-two-citation-arc-closures-in-pivot-now, §six-citation-arc-closures-in-cycle-328, §two-cycles-with-named-Hilbert-Hotel-encoding (148 + 328), §four-cycles-with-named-Object-destructure (310 + 322 + 326 + 328), §the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close (NEW pivot-record).
