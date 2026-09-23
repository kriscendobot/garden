---
title: §The-`ibid`-removed-but-still-rejected case
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
// @ts-expect-error This is the error case we're testing for
case 'ibid': {
  throw Fail`The capData protocol no longer supports ${q(QCLASS)} ${q(
    qclass,
  )}`;
}
```

§A-former-qclass-now-explicitly-rejected-with-named-message. §Borrowable-pattern: §don't-silently-ignore-removed-protocol-features + §explicit-rejection-with-named-error + §the-protocol-IS-versioned-by-which-qclasses-it-accepts.

§The-`@ts-expect-error` comment names §this-is-the-error-case-we're-testing-for — §the-TypeScript-compiler-rejection-IS-the-test-coverage-hint.

§Borrowable-pattern: §use-@ts-expect-error-as-a-marker-for-error-cases-that-must-throw. §When-the-compiler-says-this-can't-happen + §the-code-handles-the-case-anyway-via-Fail, §the-`@ts-expect-error`-acknowledges-the-tension.
