---
kind: result
role: liaison
dispatch-root: dispatches/liaison--20dc0c
cycle: 328
lane: chat
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 328: @endo/marshal src/encodeToCapData.js (chat-lane; eleventh package; six arc closures; new longest pivot arc 259 cycles; Hilbert-Hotel encoding as transferable technique)

Cycle 328 ingest: **@endo/marshal src/encodeToCapData.js** (443 lines) — legacy CapData encoding format. Chat-lane after cycle 327's designs-lane. **Nineteenth consecutive non-garden source after the pivot** (cycles 310-328). **§nineteen-cycles-with-named-pivot-domain-stay**. **Eleventh package added to pivot cluster** (marshal; previously in library via cycles 69 + 74 + 81 + 84-85 + 144 + 160).

## Six citation arcs close — new longest pivot arc

| Closes arc with | Arc length | How |
|---|---|---|
| Cycle 69 (encodeToSmallcaps.js) | **259 cycles** | Sister legacy-vs-newer format pair; **NEW PIVOT-RECORD longest arc** (beats cycle 321 → 66 at 255 cycles) |
| Cycle 71 (passStyleOf.js) | 257 cycles | Used in switch statement |
| Cycle 74 (marshal.js) | 254 cycles | File-top comment: *"leaves it to caller (marshal.js)"* |
| Cycle 81 (encodePassable.js) | 247 cycles | File-top comment: *"based on encodePassable.js"* |
| Cycle 148 (symbol.js) | 180 cycles | Hilbert-Hotel encoding technique transferred |
| Cycle 325 (pass-style README) | 3 cycles | Closes "Serialization: marshal" role-label arc |

**§six-citation-arc-closures-in-cycle-328** — matches cycle 325's record. **§twenty-two-citation-arc-closures-in-pivot-now** (16 + 6).

## Single most structurally interesting move

**§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — when the QCLASS discriminator `'@qclass'` collides with a real copyRecord property named `@qclass`, the encoder wraps the whole thing in another QCLASS-discriminator (`'hilbert'`) with sub-properties `original` and `rest`:

```js
case 'copyRecord': {
  if (hasOwn(passable, QCLASS)) {
    // Hilbert hotel
    const { [QCLASS]: qclassValue, ...rest } = passable;
    const result = {
      [QCLASS]: 'hilbert',
      original: encodeToCapDataRecur(qclassValue),
    };
    if (ownKeys(rest).length >= 1) {
      result.rest = encodeToCapDataRecur(freeze(rest));
    }
    return result;
  }
  // normal copyRecord encoding
}
```

This is the **SAME technique** as cycle 148 @endo/pass-style/src/symbol.js (which reserved `@@`-prefix for well-known symbol names while still allowing `@@`-prefixed strings as registered symbol names). The Mark-Miller-named "Hilbert Hotel" encoding — after David Hilbert's hotel-with-infinite-rooms thought experiment — appears in TWO distinct contexts in @endo:

- **Cycle 148**: Reserve `@@` prefix for well-known symbols → shift natural `@@`-prefixed registered symbol names by adding another `@@`
- **Cycle 328**: Reserve `@qclass` for special encoding → shift natural copyRecord property collision by wrapping in `{ [QCLASS]: 'hilbert', original, rest }`

**§two-cycles-with-named-Hilbert-Hotel-encoding** (148 + 328) — first-explicit-observation as a *tier-3 transferable technique*. The meta-pattern: when a reserved discriminator collides with a natural value, shift the meaning up by one level of indirection. Applicable to ANY encoding-collision problem.

## §the-named-CapData-vs-smallcaps-format-evolution

The file's existence alongside cycle 69's `encodeToSmallcaps.js` documents a *format-evolution narrative*:

- **CapData** (this cycle): Legacy format. Special values wrapped in `{ '@qclass': '<discriminator>', ... }`. Verbose; nested objects.
- **Smallcaps** (cycle 69): Newer format. One-character prefixes mark special values inline within strings. Compact.

**§the-named-legacy-format-still-supported-discipline** — CapData isn't replaced; it coexists because existing serialized data uses it and the format is part of a long-running protocol contract with downstream consumers (e.g., agoric-sdk). **§the-named-protocol-contract-IS-named-permanent-once-shipped** — sibling to cycle 326's @deprecated-but-still-working (soft removal); this is **NOT-EVEN-deprecated** (still equal-citizen). First-explicit-observation.

## Other notable observations

- §the-named-QCLASS-special-property-name (`'@qclass'`); §the-named-at-prefix-IS-named-meta-prefix-discipline
- §the-named-canonical-encoding-via-sorted-property-names for cross-vat equality; §the-named-canonical-encoding-needed-for-equality
- §the-named-three-encoder-options-with-default-rejectors (dontEncode* family forces explicit opt-in)
- §the-named-encodeRecur-callback-parameter for recursive composition
- §the-named-switch-on-passStyleOf exhaustive switch on 13 pass-styles (closes cycle 71 + 325 arcs)
- §the-named-special-case-NaN-Infinity-and-minus-Infinity with §the-named-IEEE-754-edge-cases-explicit-discipline
- §the-named-bigint-encoded-as-digits-string
- §the-named-error-special-case-at-root-not-passable with §the-named-diagnostic-priority-over-strictness-at-root
- §the-named-Recur-name-suffix-for-recursive-helper as naming convention
- §the-named-byteArray-TODO as explicit limit-naming
- **§four-cycles-with-named-Object-destructure** (310 freeze + 322 five-name + 326 patterns + 328 nine-name) — recurring substrate-discipline confirmed across four cycles

## Multi-cycle patterns extended

- §nineteen-cycles-with-named-pivot-domain-stay (310-328)
- §eleven-named-packages-in-the-pivot-cluster (marshal added)
- §twenty-two-citation-arc-closures-in-pivot-now (six in this cycle)
- §six-citation-arc-closures-in-cycle-328 (matches cycle 325 record)
- §two-cycles-with-named-Hilbert-Hotel-encoding (148 + 328)
- §four-cycles-with-named-Object-destructure (310 + 322 + 326 + 328)
- §the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close (**NEW pivot-record** longest arc)

## Tier-3 meta-patterns

- **§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — when a reserved-discriminator collides with a natural value, shift everything by one level of indirection (the same technique applied in cycle 148 symbol-names and cycle 328 QCLASS)
- **§the-named-CapData-vs-smallcaps-format-evolution** with **§the-named-legacy-format-still-supported-discipline** — newer formats coexist with older ones; protocols are permanent once shipped
- **§the-named-protocol-contract-IS-named-permanent-once-shipped** — sibling to @deprecated-but-still-working but stronger (not-even-deprecated)
- **§the-named-canonical-encoding-needed-for-equality** — when cross-vat equality matters, encoding must be deterministic
- **§the-named-default-rejector-forces-explicit-opt-in** — three default-throwing encoders make pass-by-presence-handling explicit at the call site
- **§the-named-diagnostic-priority-over-strictness-at-root** — accept invalid Passables at the root (errors) for diagnostic purposes

## Synthesis-target

Slot machine library **§`@game/marshal/src/encodeToWireFormat.js`** — serialize game state:

1. Reserved discriminator property name with **Hilbert-Hotel collision handling**
2. Canonical encoding via sorted property names for cross-machine equality
3. Three encoder options with default rejectors for pass-by-presence types
4. encodeRecur callback parameter for recursive composition
5. Exhaustive switch on game-passStyleOf matching closed-set table
6. IEEE-754 edge cases explicit (NaN + Infinity + -Infinity + -0 → 0)
7. bigint encoded as digits string for arbitrary-precision counts
8. Error special case at root for crash-reporting
9. Recur naming convention for recursive helper
10. TODO for unsupported types as explicit limit-naming
11. Object destructure at module load for tamper-resistance (recurring substrate discipline)
12. Format-evolution narrative if older format exists; coexistence over replacement

## Library state after cycle 328

- §library-reaches-840-sections from 376 source documents
- §one-hundred-and-sixty-first consecutive designs-chat alternation
- §nineteen-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §twenty-two-citation-arc-closures-in-pivot-now
- §the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close (new pivot-record longest arc)
- §two-cycles-with-named-Hilbert-Hotel-encoding (technique confirmed transferable)
- §four-cycles-with-named-Object-destructure (substrate discipline confirmed)

## Next cycle pacing

Cycle 329 is designs-lane next. Candidate moves:

- **@endo/marshal README.md** — designs-lane; would form an immediate adjacent-reverse pair with cycle 328 (source → README, mirroring lp32 315-316 and patterns 326-327). Most natural pairing.
- **@endo/promise-kit README.md or source** — would introduce a twelfth package; cycle 152 ingested memo-race.js from promise-kit.
- **@endo/common README.md or source** — would introduce a twelfth package; cycle 326 patterns/index.js cited @endo/common for deprecated re-exports.
- **@endo/exo README.md** — designs-lane; companion to cycle 322's exo-makers.js.

@endo/marshal README is the most productive (adjacent-reverse pair with cycle 328; would likely close cycle 325's "Serialization" role-label arc explicitly via marshal README's reciprocal citation of pass-style as "Foundation"). Picking freely but tracking for future work.
