---
title: §The-explicit-BEWARE-comment for the slot-decode
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
case 'slot': {
  // See note above about how the current encoding cannot reliably
  // distinguish which we should call, so in the non-default case
  // both must be the same and it doesn't matter which we call.
  const decoded = decodeRemotableFromCapData(
    jsonEncoded,
    decodeFromCapData,
  );
  // BEWARE: capdata does not check that `decoded` is
  // a promise or a remotable, since that would break some
  // capdata clients. We are deprecating capdata, and these clients
  // will need to update before switching to smallcaps.
  return decoded;
}
```

§Explicit-BEWARE-comment that names the §known-vulnerability + §the-deprecation-rationale-for-not-fixing-it-immediately. §Borrowable-pattern: §when-a-design-has-a-known-vulnerability-that-can't-be-fixed-yet, §a-BEWARE-comment-with-the-reason-and-future-plan.

§Sibling to cycle 224 daemon-web-gateway's §Caveat-emptor-disclosure — both designs §honest-acknowledgment-of-named-trade-off + §named-future-path.

§Four-cycles-on-honest-acknowledgment-of-architectural-asymmetry now (cycles 220 + 224 + 229 + 231).
