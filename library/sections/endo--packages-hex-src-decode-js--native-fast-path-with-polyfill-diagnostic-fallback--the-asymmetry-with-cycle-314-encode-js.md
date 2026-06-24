---
title: The asymmetry with cycle 314 encode.js
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

Compare cycle 314's `encodeHex`: it dispatches native-or-polyfill at module load and *stays* with the choice. There's no try/catch fallback. Why?

**§the-named-encode-decode-asymmetry-IS-named-input-trust-asymmetry**: `encodeHex` takes a `Uint8Array` (trusted-shape input from a JS caller; no validation needed; failures are rare). `decodeHex` takes a `string` (user-provided; could contain anything; diagnostic quality matters on failure). The README's symmetric API (`encodeHex` / `decodeHex`) hides this architectural asymmetry. The two source files share *most* of their idioms (module-load native capture; Reflect.apply for tamper resistance; harden on exports) but differ on this one axis because their *failure modes* differ.

§the-named-symmetric-API-asymmetric-implementations — a transferable pattern: when two functions appear symmetric at the API level, ask whether their *failure modes* are also symmetric; if not, the implementations will be too. First-explicit-observation in library.
