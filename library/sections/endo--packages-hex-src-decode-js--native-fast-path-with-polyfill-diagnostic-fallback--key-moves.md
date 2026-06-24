---
title: Key moves
source: endo--packages-hex-src-decode-js
url: https://github.com/endojs/endo/blob/master/packages/hex/src/decode.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/hex/src/decode.js
total-lines: 112
ingest-cycle: 318
ingest-date: 2026-06-11
lane: chat
section-tags:
  - the-named-native-fast-path-polyfill-diagnostic-path
  - the-named-call-the-polyfill-expecting-it-to-throw
  - the-named-fallback-to-original-error-if-polyfill-disagrees
  - the-named-native-throw-doesn't-name-the-offset
  - the-named-encode-decode-asymmetry-IS-named-input-trust-asymmetry
  - the-named-cross-reference-rationale-to-sister-file
  - the-named-direct-charcode-arithmetic-not-lookup-table
  - the-named-bitwise-case-fold-trick
  - the-named-no-module-scope-mutable-data-discipline
  - the-named-sentinel-value-minus-one-for-nibble
  - the-named-throw-includes-precise-failing-offset
  - the-named-XS-engine-named
  - the-named-comment-cites-named-benchmark-result
  - the-named-first-three-file-cluster-of-the-pivot
  - nine-cycles-with-named-pivot-domain-stay
  - three-cycles-with-named-Stage-4-TC39-proposal-citation
  - two-cycles-with-named-Reflect.apply-captured-at-module-load
  - two-cycles-with-named-eslint-disable-no-bitwise
  - two-cycles-with-named-cast-to-any-to-access-non-spec-prop
  - seven-cycles-with-named-Hardened-JS-discipline
parent: endo--packages-hex-src-decode-js--native-fast-path-with-polyfill-diagnostic-fallback
---

- **§the-named-cross-reference-rationale-to-sister-file** (line 5-7) — the file's top-of-file comment says *"Capture `Reflect.apply` once at module load, before any consumer can tamper with `Function.prototype.call`. See `encodeHex` for the rationale."* §the-named-See-sister-file-for-rationale; §the-named-don't-repeat-rationale-cite-the-sibling; §the-named-cross-file-references-are-named-citations; §two-cycles-with-named-Reflect.apply-captured-at-module-load (314 encode + 318 decode).

- **§the-named-direct-charcode-arithmetic-not-lookup-table** (line 19-26) — the comment explicitly says the decoder *"Computes nibble values directly from character codes rather than indexing a lookup table."* with two justifications:
  1. **§the-named-comment-cites-named-benchmark-result**: *"On V8 (Node 22), this is roughly 2.5 to 3 times faster than the table-based decoder for ~1 MiB inputs"*. §the-named-cite-the-engine-and-version (V8 + Node 22); §the-named-cite-the-input-size (~1 MiB); §the-named-cite-the-speedup-ratio (2.5 to 3 times). First-explicit-observation.
  2. **§the-named-no-module-scope-mutable-data-discipline**: *"avoids any module-scope mutable data"* — the no-lookup-table choice is *also* defended on Hardened-JS grounds. A lookup table at module scope would be either mutable (hazard) or frozen (overhead). Direct arithmetic avoids the choice entirely. §the-named-two-justifications-one-decision; first-explicit-observation.

- **§the-named-XS-engine-named** (line 22-26) — *"On XS the polyfill is unavoidably slow regardless of approach"* + *"XS consumers should always reach the native `Uint8Array.fromHex` intrinsic dispatched below as soon as Moddable ships it."* §the-named-XS-IS-named-named-engine; §the-named-Moddable-IS-named-XS-vendor; §the-named-engine-specific-performance-disclaimer; first-explicit-observation in library. The comment names a *future* dependency (XS's eventual native shipment) without making the code wait for it.

- **§the-named-bitwise-case-fold-trick** (line 44-46, 51, 58) — `(c | 0x20)` folds upper- onto lowercase via the *single-bit difference between ASCII upper and lower*. ASCII `'A'` is `0x41`; `'a'` is `0x61`; the difference is `0x20`. ORing in `0x20` lowercases any letter that wasn't already lowercase. *With explicit comment* that non-letters with that bit set still fail the range check: *"non-letters with that bit set still fail the (97..102) range check below."* §the-named-OR-0x20-IS-named-canonical-ASCII-lowercase-fold; §the-named-non-letters-still-fail-discipline; §the-named-bitwise-trick-with-defense-narrated; first-explicit-observation.

- **§the-named-sentinel-value-minus-one-for-nibble** (line 47, 54, 61) — `let hi = -1;` and `let lo = -1;` initialize to a sentinel that is *impossible for a real nibble* (nibbles are 0-15). The final `if (hi < 0 || lo < 0) throw` is the validation gate. §the-named-impossible-value-IS-named-sentinel; §the-named-out-of-range-sentinel-discipline; first-explicit-observation.

- **§the-named-throw-includes-precise-failing-offset** (line 61-67) — `Invalid hex character at offset ${hi < 0 ? i * 2 : i * 2 + 1} of string ${name}` — the throw message reports *which* nibble failed (the high or the low) by choosing `i * 2` (high) or `i * 2 + 1` (low). §the-named-precise-offset-IS-named-cite-the-failing-nibble; the polyfill's commitment to precise diagnostics is what makes the native-fast-path-polyfill-diagnostic-path architecture work. First-explicit-observation.

- **§the-named-odd-length-check-first** (line 33-37) — before the per-character loop, the function rejects odd-length input with a specific error: *"Hex string must have an even length, got ${string.length} in string ${name}"*. §the-named-cheapest-validation-first-discipline; §the-named-fail-loud-on-shape-before-content; first-explicit-observation.

- **§the-named-js-prefix-discipline-for-polyfill-name** — `jsDecodeHex` named symmetric to cycle 314's `jsEncodeHex`. The `js` prefix marks the pure-JavaScript polyfill; the unprefixed name (`decodeHex`) is the dispatched export. §the-named-naming-convention-marks-the-pure-JS-implementation; §two-cycles-with-named-js-prefix-discipline-for-polyfill-name (314 + 318).

- **§the-named-Reflect.apply-captured-at-module-load** (line 8) — `const { apply } = Reflect;` — cycle 314's pattern repeated. §two-cycles-with-named-Reflect.apply-captured-at-module-load (314 + 318); §two-cycles-with-named-defensive-binding-via-destructuring (314 + 318 — both use Reflect destructure).

- **§the-named-Reflect.apply-with-explicit-thisArg** (line 101) — `apply(nativeFromHex, Uint8Array, [string])` — third argument is `Uint8Array` (the constructor) because `fromHex` is a static method that expects `this` to be the typed-array constructor. §the-named-static-method-needs-explicit-thisArg-as-constructor; first-explicit-observation.

- **§the-named-cast-to-any-to-access-non-spec-prop** (line 78) — `const fromHex = /** @type {any} */ (Uint8Array).fromHex;` — cycle 314's pattern. §two-cycles-with-named-cast-to-any-to-access-non-spec-prop (314 + 318).

- **§the-named-typeof-check-IS-named-tri-state-handling** (line 79-82) — `typeof fromHex === 'function' ? (...) : undefined` — three-way handling: function (assign), other defined values (undefined fallback), undefined (already undefined). §two-cycles-with-named-feature-detection-via-typeof-function (314 + 318).

- **§the-named-encodeHex-typed-as-typeof-jsEncodeHex** (line 95) — `@type {typeof jsDecodeHex}` — cycle 314's pattern. §two-cycles-with-named-typeof-IS-named-type-inheritance-via-JSDoc (314 + 318).

- **§the-named-Stage-4-TC39-proposal-citation** (line 12-13, 89-90) — *"proposal-arraybuffer-base64"* + *"stage-4 TC39 proposal-arraybuffer-base64"*. §three-cycles-with-named-Stage-4-TC39-proposal-citation (314 source + 317 README + 318 source).

- **§the-named-eslint-disable-no-bitwise** (line 1) — `/* eslint no-bitwise: ["off"] */` — cycle 314 pattern. §two-cycles-with-named-eslint-disable-no-bitwise (314 + 318); §the-named-deliberate-eslint-disable.

- **§two-named-harden-calls-on-exports** — `harden(jsDecodeHex)` + `harden(decodeHex)`. §two-cycles-with-named-two-harden-calls-on-exports (314 + 318); §nine-cycles-with-named-harden-call-on-exports.
