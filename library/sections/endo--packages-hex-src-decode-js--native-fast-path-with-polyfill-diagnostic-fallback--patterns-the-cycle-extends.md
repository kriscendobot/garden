---
title: Patterns the cycle extends
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
