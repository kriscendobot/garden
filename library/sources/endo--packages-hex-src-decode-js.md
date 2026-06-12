---
title: "@endo/hex src/decode.js — native fast path + polyfill diagnostic fallback; direct charcode arithmetic; completes first three-file pivot cluster"
source-slug: endo--packages-hex-src-decode-js
url: https://github.com/endojs/endo/blob/master/packages/hex/src/decode.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/hex/src/decode.js
total-lines: 112
ingest-cycle: 318
ingest-date: 2026-06-11
lane: chat
---

# `@endo/hex src/decode.js`

The 112-line decode.js completes a **three-file hex cluster** with cycle 314 (encode.js) and cycle 317 (README). **Ninth consecutive non-garden source after the pivot** (cycles 310-318). **§nine-cycles-with-named-pivot-domain-stay**. **§the-named-first-three-file-cluster-of-the-pivot** (hex: encode source + README + decode source).

## Key moves

- **§the-named-native-fast-path-polyfill-diagnostic-path** — when native `Uint8Array.fromHex` is available, dispatch tries it first; on any throw, re-runs `jsDecodeHex` to recover *precise offset information*. **Single most structurally interesting move**. First-explicit-observation.
- **§the-named-native-throw-doesn't-name-the-offset** — the rationale: native error messages are implementation-defined and do not report the failing offset.
- **§the-named-call-the-polyfill-expecting-it-to-throw** — the catch block calls jsDecodeHex *expecting it to throw*; §the-named-fallback-to-original-error-if-polyfill-disagrees if it doesn't.
- **§the-named-encode-decode-asymmetry-IS-named-input-trust-asymmetry** — encode takes trusted Uint8Array, no validation needed; decode takes user-string, diagnostic quality matters; the README's symmetric API hides this architectural asymmetry; §the-named-symmetric-API-asymmetric-implementations.
- **§the-named-cross-reference-rationale-to-sister-file** — file-top comment says "See `encodeHex` for the rationale"; §the-named-don't-repeat-rationale-cite-the-sibling.
- **§the-named-direct-charcode-arithmetic-not-lookup-table** with §the-named-two-justifications-one-decision (perf: 2.5-3x on V8 Node 22 for ~1 MiB inputs; Hardened-JS: no module-scope mutable data).
- **§the-named-bitwise-case-fold-trick** (`c | 0x20`) with §the-named-non-letters-still-fail-discipline (narrated in comment).
- **§the-named-sentinel-value-minus-one-for-nibble** — `let hi = -1; let lo = -1;` (nibbles are 0-15; -1 impossible).
- **§the-named-throw-includes-precise-failing-offset** (`i*2` or `i*2+1` depending on which nibble failed).
- **§the-named-odd-length-check-first** — cheap validation before per-character work.
- **§the-named-XS-engine-named** with §the-named-Moddable-IS-named-XS-vendor; §the-named-engine-specific-performance-disclaimer.
- **§the-named-comment-cites-named-benchmark-result** — V8 + Node 22 + ~1 MiB + 2.5-3x.
- **§the-named-Reflect.apply-with-explicit-thisArg** (`apply(nativeFromHex, Uint8Array, [string])`); static method needs explicit thisArg as constructor.
- **§the-named-js-prefix-discipline-for-polyfill-name** (jsDecodeHex mirrors jsEncodeHex).
- **§the-named-three-file-cluster-doc-impl-sibling-arc** — three reference axes: doc↔impl + impl↔sibling-impl + impl→doc.
- **§nine-cycles-with-named-pivot-domain-stay**, **§three-cycles-with-named-Stage-4-TC39-proposal-citation** (314 + 317 + 318), **§seven-cycles-with-named-Hardened-JS-discipline**, **§nine-cycles-with-named-harden-call-on-exports**.

## Section files

- [§the-named-native-fast-path-polyfill-diagnostic-path + §the-named-encode-decode-asymmetry-IS-named-input-trust-asymmetry + §the-named-bitwise-case-fold-trick + §the-named-sentinel-value-minus-one-for-nibble + 20+ more first-explicit-observations](../sections/endo--packages-hex-src-decode-js--native-fast-path-with-polyfill-diagnostic-fallback.md) — full 112-line source in scope.

## Ingest scope

Cycle 318 (chat-lane after cycle 317's designs-lane @endo/hex README.md). Full 112-line source in scope. Ninth consecutive @endo/* source; fourth package (hex). **First-explicit-observations (twenty-plus)** including §the-named-native-fast-path-polyfill-diagnostic-path, §the-named-encode-decode-asymmetry-IS-named-input-trust-asymmetry, §the-named-call-the-polyfill-expecting-it-to-throw, §the-named-native-throw-doesn't-name-the-offset, §the-named-cross-reference-rationale-to-sister-file, §the-named-direct-charcode-arithmetic-not-lookup-table, §the-named-two-justifications-one-decision, §the-named-bitwise-case-fold-trick, §the-named-sentinel-value-minus-one-for-nibble, §the-named-throw-includes-precise-failing-offset, §the-named-odd-length-check-first, §the-named-XS-engine-named, §the-named-Moddable-IS-named-XS-vendor, §the-named-comment-cites-named-benchmark-result, §the-named-Reflect.apply-with-explicit-thisArg, §the-named-three-file-cluster-doc-impl-sibling-arc, §the-named-symmetric-API-asymmetric-implementations, §the-named-pay-for-diagnostic-precision-in-the-time-it-takes-to-fail. Multi-cycle: §nine-cycles-with-named-pivot-domain-stay, §three-cycles-with-named-Stage-4-TC39-proposal-citation, §seven-cycles-with-named-Hardened-JS-discipline.
