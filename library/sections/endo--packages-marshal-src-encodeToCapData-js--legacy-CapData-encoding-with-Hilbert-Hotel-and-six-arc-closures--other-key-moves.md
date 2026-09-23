---
title: Other key moves
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
