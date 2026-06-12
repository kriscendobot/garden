---
title: "@endo/hex src/decode.js — native fast path + polyfill diagnostic fallback; direct charcode arithmetic with bitwise case fold; first three-file pivot cluster"
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
---

# `@endo/hex src/decode.js` — native fast path + polyfill diagnostic fallback

The 112-line decode.js completes a **three-file hex cluster** with cycle 314 (encode.js, source, 60 lines) and cycle 317 (README, 60 lines). Cycle 318 is **chat-lane after cycle 317's designs-lane**. **Ninth consecutive non-garden source after the pivot** (cycles 310-318). **§nine-cycles-with-named-pivot-domain-stay**. **§the-named-first-three-file-cluster-of-the-pivot** (hex: encode source + README + decode source). Fourth package; no new package added.

## The single most structurally interesting move

**§the-named-native-fast-path-polyfill-diagnostic-path** — the exported `decodeHex` chooses architecture based on a *failure-mode property* rather than a speed-vs-correctness tradeoff:

```js
export const decodeHex =
  nativeFromHex !== undefined
    ? (string, name = '<unknown>') => {
        try {
          return apply(nativeFromHex, Uint8Array, [string]);
        } catch (err) {
          // Prefer the polyfill's precise offset diagnostic on any
          // native throw; jsDecodeHex is expected to reject anything
          // native rejected.  If it does not, fall back to propagating
          // the caught native error.
          jsDecodeHex(string, name);
          throw err;
        }
      }
    : jsDecodeHex;
```

When the native intrinsic is available, the dispatched function tries native *first* (fast path), and on *any* throw re-runs `jsDecodeHex` against the same input to produce a diagnostic with *precise offset information*. The comment names the spec-level deficiency: **§the-named-native-throw-doesn't-name-the-offset** — *"native error messages are implementation-defined and do not report the failing offset"*. The polyfill's error message includes the exact byte offset where decoding failed; the native intrinsic's doesn't.

This is a **two-phase function**: phase 1 is fast and correctness-preserving; phase 2 is slow and diagnostic-precision-preserving. The cost is a *double-decode on failure paths* — the work is wasted — but failures are exceptional and diagnostic precision is paid for in the time it takes to fail. **§the-named-pay-for-diagnostic-precision-in-the-time-it-takes-to-fail**.

There's a third subtlety in **§the-named-call-the-polyfill-expecting-it-to-throw**: the catch block calls `jsDecodeHex(string, name)` *expecting it to throw*. The semicolon-then-`throw err` after it is the **§the-named-fallback-to-original-error-if-polyfill-disagrees** — if the polyfill *does not* throw (unexpected: the native and polyfill disagree about validity), the original native error is propagated. The polyfill is treated as the diagnostic oracle, *not* as the authoritative validator. §First-explicit-observation in library.

## The asymmetry with cycle 314 encode.js

Compare cycle 314's `encodeHex`: it dispatches native-or-polyfill at module load and *stays* with the choice. There's no try/catch fallback. Why?

**§the-named-encode-decode-asymmetry-IS-named-input-trust-asymmetry**: `encodeHex` takes a `Uint8Array` (trusted-shape input from a JS caller; no validation needed; failures are rare). `decodeHex` takes a `string` (user-provided; could contain anything; diagnostic quality matters on failure). The README's symmetric API (`encodeHex` / `decodeHex`) hides this architectural asymmetry. The two source files share *most* of their idioms (module-load native capture; Reflect.apply for tamper resistance; harden on exports) but differ on this one axis because their *failure modes* differ.

§the-named-symmetric-API-asymmetric-implementations — a transferable pattern: when two functions appear symmetric at the API level, ask whether their *failure modes* are also symmetric; if not, the implementations will be too. First-explicit-observation in library.

## Key moves

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

## Three-file hex cluster: the doc/impl cross-reference arc closes

Cycle 314 (encode source) + cycle 317 (README) + cycle 318 (decode source) form the **first three-file cluster of the pivot**. Cross-references:

- README (cycle 317) cites *both* source files via API section headings (`encodeHex` and `decodeHex` H3 subheadings)
- README (cycle 317) names the technique §the-named-dispatches-at-module-load-time which both sources implement
- README (cycle 317) names §the-named-throws-on-named-error-conditions; cycle 318's decode.js *implements* the throws (odd-length + precise-offset on bad char)
- Cycle 318 decode.js cites cycle 314 encode.js explicitly via "See `encodeHex` for the rationale" (the Reflect.apply rationale)
- Cycle 314 encode.js and cycle 318 decode.js share the file-level eslint-disable, the harden import, the Reflect.apply destructure, the cast-to-any, the typeof-function check, the typeof type-inheritance, and the two-harden-calls discipline — *§the-named-sibling-file-shape-shared*

**§the-named-three-file-cluster-doc-impl-sibling-arc** — the cluster contains three reference axes: doc↔impl (README↔each source), impl↔sibling-impl (encode↔decode), and impl→doc (each source cites the README's named promises). First-explicit-observation as a structural pattern.

## Patterns the cycle extends

- §nine-cycles-with-named-pivot-domain-stay (310-318)
- §three-cycles-with-named-Stage-4-TC39-proposal-citation (314 + 317 + 318)
- §two-cycles-with-named-Reflect.apply-captured-at-module-load (314 + 318)
- §two-cycles-with-named-eslint-disable-no-bitwise (314 + 318)
- §two-cycles-with-named-cast-to-any-to-access-non-spec-prop (314 + 318)
- §two-cycles-with-named-feature-detection-via-typeof-function (314 + 318)
- §two-cycles-with-named-typeof-IS-named-type-inheritance-via-JSDoc (314 + 318)
- §two-cycles-with-named-defensive-binding-via-destructuring (Reflect; 314 + 318)
- §two-cycles-with-named-two-harden-calls-on-exports (314 + 318)
- §two-cycles-with-named-js-prefix-discipline-for-polyfill-name (314 + 318)
- §seven-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317 + 318)
- §nine-cycles-with-named-harden-call-on-exports
- §four-shapes-of-pair-discipline (unchanged; cycle 318 falls inside the three-file cluster and is the second member of a *different* pair shape if we count encode+decode as a sibling-impl pair, but that's a *cluster* pattern, not a pair shape)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. The strongest portable observations: the native-fast-path-polyfill-diagnostic-path architecture; the encode/decode asymmetry framed as input-trust asymmetry; the direct-charcode-arithmetic with double justification (perf + Hardened-JS); the call-the-polyfill-expecting-it-to-throw discipline.

## Tier-2 borrowing (multi-cycle patterns extended)

- §nine-cycles-with-named-pivot-domain-stay (310-318)
- §first-three-file-cluster-of-the-pivot (314 + 317 + 318)
- §the-named-three-file-cluster-doc-impl-sibling-arc (three reference axes: doc↔impl + impl↔sibling-impl + impl→doc)
- §three-cycles-with-named-Stage-4-TC39-proposal-citation
- §seven-cycles-with-named-Hardened-JS-discipline
- §nine-cycles-with-named-harden-call-on-exports

## Tier-3 borrowing (meta-patterns)

- **§the-named-symmetric-API-asymmetric-implementations** — when two functions appear symmetric at the API level, ask whether their failure modes are symmetric; if not, the implementations will be too
- **§the-named-pay-for-diagnostic-precision-in-the-time-it-takes-to-fail** — the cost of better error messages is paid only when errors happen; the happy path stays fast
- **§the-named-call-the-polyfill-expecting-it-to-throw** — using a known-stricter implementation as a diagnostic oracle without ceding authority to it (the original error is the fallback)
- **§the-named-two-justifications-one-decision** — perf + Hardened-JS both motivate the no-lookup-table choice; one technique satisfies two constraints
- **§the-named-cross-reference-rationale-to-sister-file** — don't repeat rationale across sibling files; cite the sibling instead

## Synthesis-target

Slot machine library **§`@game/encoding/src/decode.js`** — bet-ID decoder (mirror of cycle 314's synthesis-target `encode.js`):

1. Cite the sibling file (`encode.js`) for the rationale of any shared idiom (`See encode-bet-id.js for the rationale`).
2. Direct character-code arithmetic instead of a lookup table; cite the engine + version + speedup + input size in a comment.
3. Bitwise case-fold trick (`c | 0x20`) with explicit defense narrated in comment ("non-letters with that bit set still fail the range check").
4. Sentinel value (`-1` or any out-of-range value) for "no valid nibble found", checked at the end.
5. Throw includes the precise failing offset (which character of the input string failed).
6. Cheap-validation-first discipline: reject obviously-invalid shapes (odd-length, wrong total length) before per-character work.
7. Native fast path + polyfill diagnostic path: if a native fast decoder exists, dispatch to it for the happy path; on any throw, re-run the polyfill to recover precise diagnostics.
8. Call-the-polyfill-expecting-it-to-throw: treat the polyfill as a diagnostic oracle, not as an authoritative validator; fall back to the original native error if the polyfill disagrees.
9. Two-justifications-one-decision: defend the no-lookup-table choice on *both* performance and Hardened-JS (no module-scope mutable data) grounds.
10. Symmetric API + asymmetric implementations: if `encode-bet-id` and `decode-bet-id` have different input-trust postures (e.g., encode takes trusted bytes, decode takes user strings), the implementations may differ on this exact axis even though the API surface looks symmetric.
