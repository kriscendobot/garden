---
title: Synthesis-target
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
