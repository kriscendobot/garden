---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-symmetric-API-asymmetric-implementations** — when two functions appear symmetric at the API level, ask whether their failure modes are symmetric; if not, the implementations will be too
- **§the-named-pay-for-diagnostic-precision-in-the-time-it-takes-to-fail** — the cost of better error messages is paid only when errors happen; the happy path stays fast
- **§the-named-call-the-polyfill-expecting-it-to-throw** — using a known-stricter implementation as a diagnostic oracle without ceding authority to it (the original error is the fallback)
- **§the-named-two-justifications-one-decision** — perf + Hardened-JS both motivate the no-lookup-table choice; one technique satisfies two constraints
- **§the-named-cross-reference-rationale-to-sister-file** — don't repeat rationale across sibling files; cite the sibling instead
