---
title: The single most structurally interesting move
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
