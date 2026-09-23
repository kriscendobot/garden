---
title: §The-dont-encode-defaults-that-throw
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
const dontEncodeRemotableToCapData = rem => Fail`remotable unexpected: ${rem}`;
const dontEncodePromiseToCapData = prom => Fail`promise unexpected: ${prom}`;
const dontEncodeErrorToCapData = err => Fail`error object unexpected: ${err}`;
```

§Three-named-default-handlers-that-throw. §Borrowable-pattern: §the-default-is-rejection-not-silent-acceptance — §if-the-caller-doesn't-provide-an-encoder-for-a-class, §the-encoder-rejects-rather-than-encoding-null. §The-caller-must-explicitly-opt-in-to-encoding-remotables-or-promises-or-errors.

§Borrowable-pattern: §strict-by-default-with-opt-in-extension. §Sibling to cycle 226 endoclaw-cluster's §two-facet-control-pair — both designs §the-default-is-the-safe-shape.

§Three-cycles-on-strict-by-default-with-opt-in-extension:
- Cycle 226 endoclaw-cluster: two-facet-control-pair (capability granted only via host).
- Cycle 230 endor-npm-registry-proxy: intentionally-omitted-pre/post-install-scripts (default rejection).
- Cycle 231 encodeToCapData: dont-encode-defaults-that-throw.

§The-discipline: §don't-silently-accept-what-you-don't-know-how-to-handle.
