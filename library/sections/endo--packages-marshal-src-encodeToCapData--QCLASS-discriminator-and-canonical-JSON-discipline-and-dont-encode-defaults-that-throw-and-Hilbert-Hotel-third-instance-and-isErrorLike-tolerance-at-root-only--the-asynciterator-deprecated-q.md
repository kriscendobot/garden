---
title: §The-`@@asyncIterator` deprecated-qclass
source-slug: endo--packages-marshal-src-encodeToCapData
section-id: QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
status: shipping
ingest-cycle: 231
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-encodeToCapData--QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
---

```js
case '@@asyncIterator': {
  // Deprecated qclass. TODO make conditional
  // on environment variable. Eventually remove, but after confident
  // that there are no more supported senders.
  //
  return Symbol.asyncIterator;
}
```

§Deprecated-qclass-with-TODO-to-make-conditional-on-environment-variable + §named-removal-policy (only after confident no more supported senders).

§Borrowable-pattern: §three-phase-deprecation: (1) currently still accepted; (2) TODO make conditional on environment variable; (3) eventually remove. §The-deprecation-policy-is-explicit + §the-precondition-for-removal-is-named.

§Sibling to cycle 227 @endo/pass-style/string.js's §env-option-gated-strictness-with-named-three-phase-plan (default-disabled → default-enabled → switch-removed). §Cycle-227-is-the-mirror-image — cycle 227 phases in stricter behavior; cycle 231 phases out a deprecated feature. §Same-three-phase-shape-different-direction.
