---
title: Synthesis-target
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

Slot machine library **§`@game/marshal/src/encodeToWireFormat.js`** — serialize game state to wire format:

1. **Reserved discriminator property name** (`@gameclass` or similar) with **Hilbert-Hotel collision handling** for natural game-records that happen to use the same property name.
2. **Canonical encoding via sorted property names** for cross-machine equality.
3. **Three encoder options with default rejectors** for the three pass-by-presence types your game uses (player-references + ongoing-bets + errors).
4. **encodeRecur callback parameter** so caller's custom encoders can recurse via the same function.
5. **Exhaustive switch on game-passStyleOf** matching the closed-set table from your `@game/pass-style/README`.
6. **IEEE-754 edge cases explicit** for any numeric game values (jackpot accumulators, RNG seeds).
7. **bigint encoded as digits string** for chip-counts that exceed safe-integer range.
8. **Error special case at root** for crash-reporting (capture diagnostics even from un-frozen errors).
9. **Recur name suffix** for the recursive helper; entry point handles root-level error special case.
10. **TODO for byteArray** if you haven't implemented binary support yet — explicit limit-naming.
11. **Object destructure at module load** for tamper-resistance (recurring discipline across the pivot).
12. **Format-evolution narrative**: if your library has an older wire format, keep both; document the coexistence.
