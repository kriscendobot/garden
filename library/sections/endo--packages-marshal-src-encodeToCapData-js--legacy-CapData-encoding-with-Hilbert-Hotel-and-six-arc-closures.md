---
title: "@endo/marshal src/encodeToCapData.js — legacy CapData encoding format; QCLASS discriminator with Hilbert-Hotel collision-handling (closes cycle 148 arc); eleventh package; six citation-arc closures; new longest arc 259 cycles (cycle 69 → 328)"
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
---

# `@endo/marshal src/encodeToCapData.js` — legacy CapData; QCLASS Hilbert-Hotel; six arc closures

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

## The single most structurally interesting move

**§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — the QCLASS discriminator (`'@qclass'`) reserves a property name that can never appear in a natural copyRecord. But what if a *real* copyRecord legitimately has `@qclass` as a property name? The file (line 165-184) applies the **Hilbert-Hotel encoding**:

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
  // ... normal copyRecord encoding
}
```

The trick: when a copyRecord has its own `@qclass` property, wrap the whole thing in another QCLASS-discriminator (`'hilbert'`) that has *two* sub-properties: `original` (the natural value of `@qclass`) and `rest` (everything else). The decoder recognizes the `'hilbert'` discriminator and reconstructs the original copyRecord by un-shifting.

**§two-cycles-with-named-Hilbert-Hotel-encoding** — cycle 148 ingested @endo/pass-style/src/symbol.js which used the same Hilbert-Hotel technique to reserve `@@`-prefixed strings as well-known symbol names while still allowing `@@`-prefixed strings as registered symbol names. Cycle 328 applies it to QCLASS. Two distinct applications of the *same encoding technique* in two different files. First-explicit-observation as a tier-3 meta-pattern: **§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — when a reserved-discriminator collides with a natural value, shift everything by one level of indirection.

The name "Hilbert Hotel" comes from David Hilbert's thought experiment about a hotel with infinitely many rooms that can always accommodate one more guest by shifting all existing guests up by one. The encoding shifts the *meaning* up by one level when the *form* would otherwise collide.

## §the-named-CapData-vs-smallcaps-format-evolution

The file's existence alongside cycle 69's `encodeToSmallcaps.js` documents a **format-evolution narrative** in the @endo/marshal package:

- **CapData (this file, cycle 328)**: Legacy format. Each special value is wrapped in `{ '@qclass': '<discriminator>', ... }`. Verbose; every special value adds an object layer. Originally designed for compatibility with JSON-RPC-style wire formats.
- **Smallcaps (cycle 69)**: Newer format. Uses one-character prefixes (`!` for primitives, `+` for tagged, etc.) to mark special values inline within strings. Compact; doesn't require nested objects.

**§the-named-legacy-format-still-supported-discipline** — first-explicit-observation. The newer smallcaps format doesn't *replace* CapData; CapData is still maintained because existing serialized data uses it, and the format is part of the long-running protocol contract with downstream consumers (e.g., agoric-sdk). **§the-named-protocol-contract-IS-named-permanent-once-shipped**. First-explicit-observation. Sibling to cycle 326's **§the-named-deprecated-but-still-working** (which named soft-removal via @deprecated tag); this is *not-even-deprecated*, just *coexisting*.

## Other key moves

- **§the-named-QCLASS-special-property-name** (line 39) — `const QCLASS = '@qclass'; export { QCLASS };` — the reserved discriminator. The `@` prefix is structurally significant: JSON property names with `@` prefix are syntactically valid but conventionally reserved for meta-information. §the-named-at-prefix-IS-named-meta-prefix-discipline.

- **§the-named-canonical-encoding-via-sorted-property-names** (line 92-103, 188-191) — copyRecord property names are sorted before encoding so that `JSON.stringify(encode(v1)) === JSON.stringify(encode(v2))` whenever v1 and v2 are equivalent. The JSDoc states this canonicalness requirement explicitly. **§the-named-canonical-encoding-needed-for-equality** — first-explicit-observation. Determinism is required because the encoded form is used for cross-vat equality checks; non-determinism would break the protocol.

- **§the-named-three-encoder-options-with-default-rejectors** (line 60-79) — three optional encoder callbacks for `remotable` + `promise` + `error`. The defaults (`dontEncodeRemotableToCapData`, `dontEncodePromiseToCapData`, `dontEncodeErrorToCapData`) **reject by throwing**. Callers must explicitly opt in to encoding any of these. **§the-named-dontEncode-family-of-default-rejectors** — first-explicit-observation. The discipline forces consumers to *acknowledge* they handle pass-by-presence types; absence-of-opt-in is the safe default.

- **§the-named-encodeRecur-callback-parameter** — each encoder option takes `(value, encodeRecur)` so the custom encoder can recursively encode child values via the *same* recursive function. **§the-named-recursive-callback-injection** — the recursive function is *passed in* so the user-supplied encoder is part of the recursion, not separate from it. First-explicit-observation.

- **§the-named-switch-on-passStyleOf** (line 128-246) — exhaustive switch on the 13 pass-styles (matches cycle 325's table). 11 explicit cases + default that throws. **§the-named-exhaustive-switch-IS-named-passStyle-discipline**. First-explicit-observation. Closes citation arcs with cycles 71 (passStyleOf classifier) and 325 (pass-style table).

- **§the-named-special-case-NaN-Infinity-and-minus-Infinity** (line 140-149) — three special-case QCLASS-wrapped encodings for IEEE-754 values that have no JSON representation: `{ [QCLASS]: 'NaN' }`, `{ [QCLASS]: 'Infinity' }`, `{ [QCLASS]: '-Infinity' }`. Plus `-0` normalizes to `0`. **§the-named-IEEE-754-edge-cases-explicit-discipline**. First-explicit-observation.

- **§the-named-bigint-encoded-as-digits-string** (line 151-156) — `{ [QCLASS]: 'bigint', digits: String(passable) }` — bigints don't fit in JSON Number; encoded as a digits string. The named property `digits` makes the format self-documenting.

- **§the-named-symbol-encoded-via-passableSymbolForName** (line 157-164) — closes citation arc with cycle 148 symbol.js. The Hilbert-Hotel encoding from cycle 148 (for symbol names) is invoked here via `nameForPassableSymbol`; the QCLASS Hilbert-Hotel (for copyRecord property collision) is the *second* Hilbert-Hotel in the same file family.

- **§the-named-error-special-case-at-root-not-passable** (line 248-263) — at the top-level only, the encoder accepts errors that are *not* valid Passables (e.g., unfrozen errors): *"we're much more interested in reporting whatever diagnostic information they carry than we are about reporting problems encountered in reporting this information."* **§the-named-diagnostic-priority-over-strictness-at-root**. First-explicit-observation. Sibling to cycle 87's error.js *security-vs-diagnostic-preservation tension* observation; the encoder side of that tension.

- **§the-named-Recur-name-suffix-for-recursive-helper** — `encodeToCapDataRecur` is the recursive helper; `encodeToCapData` is the entry point with root-level error handling. **§the-named-two-layer-recursive-factory** with naming convention `*Recur` for the recursive interior. First-explicit-observation as a naming-convention discipline.

- **§the-named-byteArray-TODO** (line 196-199) — *"TODO implement"* for byteArray; cycle 314 hex / cycle 316 lp32 use byteArray as data; not yet supported in CapData. **§the-named-format-evolution-via-TODO** — the file lists what's-not-yet-supported as a TODO; readers can know the format's limits.

- **§the-named-eight-Object-destructure-at-module-load** (line 23-33) — `const { isArray } = Array; const { ownKeys } = Reflect; const { getOwnPropertyDescriptors, defineProperties, is, entries, fromEntries, freeze, hasOwn } = Object;` — **three** destructure clusters with a total of nine names. **§four-cycles-with-named-Object-destructure** (310 freeze + 322 five-name + 326 patterns-index + 328 nine-name). The pattern is now a clear *substrate-discipline* across the @endo packages. First-explicit-observation as a recurring discipline confirmed across four cycles.

## Patterns the cycle extends

- §nineteen-cycles-with-named-pivot-domain-stay (310-328)
- §eleven-named-packages-in-the-pivot-cluster (eleventh: marshal)
- §twenty-two-citation-arc-closures-in-pivot-now (added six in this cycle, matching cycle 325's record)
- §six-citation-arc-closures-in-cycle-328 (matches cycle 325's six)
- §two-cycles-with-named-Hilbert-Hotel-encoding (148 + 328)
- §four-cycles-with-named-Object-destructure (310 + 322 + 326 + 328)
- §the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close (NEW pivot-record; beats cycle 321 → 66 at 255 cycles)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags above marked first-explicit-observation. Highest-portability:

- **§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique**
- **§the-named-canonical-encoding-via-sorted-property-names** for cross-vat equality
- **§the-named-three-encoder-options-with-default-rejectors** with **§the-named-encodeRecur-callback-parameter**
- **§the-named-CapData-vs-smallcaps-format-evolution** with **§the-named-legacy-format-still-supported-discipline**
- **§the-named-IEEE-754-edge-cases-explicit-discipline** (NaN + Infinity + -Infinity + -0)
- **§the-named-bigint-encoded-as-digits-string** with named property
- **§the-named-error-special-case-at-root-not-passable** with diagnostic-priority discipline
- **§the-named-Recur-name-suffix-for-recursive-helper** as a naming convention

## Tier-2 borrowing (multi-cycle patterns extended)

- §nineteen-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §twenty-two-citation-arc-closures-in-pivot-now
- §two-cycles-with-named-Hilbert-Hotel-encoding (148 + 328)
- §four-cycles-with-named-Object-destructure (recurring discipline confirmed)
- §the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close (pivot-record)

## Tier-3 borrowing (meta-patterns)

- **§the-named-Hilbert-Hotel-encoding-as-canonical-discriminator-reservation-technique** — when a reserved-discriminator collides with a natural value, shift everything by one level of indirection (the same technique repeated in cycle 148 symbol-names and cycle 328 QCLASS)
- **§the-named-CapData-vs-smallcaps-format-evolution** with **§the-named-legacy-format-still-supported-discipline** — newer formats coexist with older ones; protocols are permanent once shipped
- **§the-named-protocol-contract-IS-named-permanent-once-shipped** — sibling to cycle 326's @deprecated-but-still-working; this is not-even-deprecated, just coexisting
- **§the-named-canonical-encoding-needed-for-equality** — when cross-vat equality matters, encoding must be deterministic; sorted property names are the canonical technique
- **§the-named-default-rejector-forces-explicit-opt-in** — three default-throwing encoders make pass-by-presence-handling explicit at the call site
- **§the-named-diagnostic-priority-over-strictness-at-root** — accept invalid Passables at the root (errors) for diagnostic purposes; reject them in the recursion

## Synthesis-target

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

## Library state after cycle 328

- §library-reaches-840-sections from 376 source documents
- §one-hundred-and-sixty-first consecutive designs-chat alternation
- §nineteen-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster (marshal added)
- §twenty-two-citation-arc-closures-in-pivot-now (six in this cycle)
- §the-named-citation-arc-from-cycle-69-takes-259-cycles-to-close (NEW longest arc; beats 321 → 66 at 255 cycles)
- §two-cycles-with-named-Hilbert-Hotel-encoding (148 + 328 — the same technique applied in two different contexts)
