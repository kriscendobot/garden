---
title: "§The-implementation-restriction: promise-vs-remotable"
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
decodeRemotableFromCapData === decodePromiseFromCapData ||
  Fail`An implementation restriction for now: If either decodeRemotableFromCapData or decodePromiseFromCapData is provided, both must be provided and they must be the same: ${q(
    decodeRemotableFromCapData,
  )} vs ${q(decodePromiseFromCapData)}`;
```

§Implementation-restriction-named-as-such + §rationale-comment-with-issue-link:

> The current encoding does not give the decoder enough into to distinguish whether a slot represents a promise or a remotable. As an implementation restriction until this is fixed, if either is provided, both must be provided and they must be the same.
> See https://github.com/Agoric/agoric-sdk/issues/4334

§Borrowable-pattern: §implementation-restriction-with-explicit-failure-mode + §named-issue-tracker-link-as-source-of-future-work. §The-issue-IS-the-roadmap-entry; §the-comment-points-to-it.

§Sibling to cycle 228 daemon-os-sandbox-plugin's §Roadmap-calibration-via-git-blame — both designs §reference-external-tracking-as-the-source-of-truth-for-future-work.
