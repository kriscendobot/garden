---
title: "`@endo/marshal src/encodeToCapData.js` — legacy CapData; QCLASS Hilbert-Hotel; six arc closures"
source: endo--packages-marshal-src-encodeToCapData-js
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
ingest-cycle: 328
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique
  - the-named-QCLASS-special-property-name
  - the-named-canonical-encoding-via-sorted-property-names
  - the-named-canonical-encoding-needed-for-equality
  - the-named-three-encoder-options-with-default-rejectors
  - the-named-dontEncode-family-of-default-rejectors
  - the-named-encodeRecur-callback-parameter
  - the-named-switch-on-passStyleOf
  - the-named-special-case-NaN-Infinity-and-minus-Infinity
  - the-named-bigint-encoded-as-digits-string
  - the-named-symbol-encoded-via-passableSymbolForName
  - the-named-error-special-case-at-root-not-passable
  - the-named-Recur-name-suffix-for-recursive-helper
  - the-named-byteArray-TODO
  - the-named-CapData-vs-smallcaps-format-evolution
  - nineteen-cycles-with-named-pivot-domain-stay
  - eleven-named-packages-in-the-pivot-cluster
  - twenty-two-citation-arc-closures-in-pivot-now
  - six-citation-arc-closures-in-cycle-328
  - the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close
  - two-cycles-with-named-Hilbert-Hotel-encoding
  - four-cycles-with-named-Object-destructure
parent: endo--packages-marshal-src-encodeToCapData-js--legacy-CapData-encoding-with-Hilbert-Hotel-and-six-arc-closures
---

The 443-line encodeToCapData.js implements the *legacy CapData* serialization format for @endo/marshal. Cycle 328 is **chat-lane after cycle 327's designs-lane @endo/patterns README**. **Nineteenth consecutive non-garden source after the pivot** (cycles 310-328). **§nineteen-cycles-with-named-pivot-domain-stay**. **Eleventh package added to pivot cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + patterns + **marshal**) — @endo/marshal was already extensively in library via cycles 69 + 74 + 81 + 84-85 + 144 + 160 (six prior comment-fragment ingests).

Cycle 328 closes **six citation arcs** — matching cycle 325's record:

| Closes arc with | Arc length | How |
|---|---|---|
| Cycle 69 (encodeToSmallcaps.js) | **259 cycles** | This file IS the legacy-format counterpart to smallcaps; **NEW LONGEST citation arc in the pivot** (beats cycle 321 → 66 at 255 cycles) |
| Cycle 71 (passStyleOf.js) | 257 cycles | Used in the central switch statement; second-longest closure |
| Cycle 74 (marshal.js) | 254 cycles | File-top comment: *"leaves it to the caller (marshal.js) to stringify it"* |
| Cycle 81 (encodePassable.js) | 247 cycles | File-top comment: *"This module is based on the encodePassable.js"* |
| Cycle 148 (symbol.js Hilbert-Hotel) | 180 cycles | Same Hilbert-Hotel encoding technique applied to QCLASS collision |
| Cycle 325 (pass-style README) | 3 cycles | Closes the "Serialization: marshal" role-label arc |

**§six-citation-arc-closures-in-cycle-328**. **§twenty-two-citation-arc-closures-in-pivot-now** (16 + 6). **§the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close** as a **new pivot-record**.
