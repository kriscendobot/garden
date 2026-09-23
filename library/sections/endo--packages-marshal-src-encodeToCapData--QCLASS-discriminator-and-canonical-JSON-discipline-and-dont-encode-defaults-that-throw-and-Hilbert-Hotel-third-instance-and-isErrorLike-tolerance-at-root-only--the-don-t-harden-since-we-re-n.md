---
title: §The-don't-harden-since-we're-not-done-mutating-it (hilbert decode)
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
case 'hilbert': {
  const { original, rest } = jsonEncoded;
  hasOwn(jsonEncoded, 'original') ||
    Fail`Invalid Hilbert Hotel encoding ${jsonEncoded}`;
  // Don't harden since we're not done mutating it
  const result = { [QCLASS]: decodeFromCapData(original) };
  if (hasOwn(jsonEncoded, 'rest')) {
    // ... validate rest ...
    defineProperties(result, getOwnPropertyDescriptors(restObj));
  }
  return result;
}
```

§Named-comment §don't-harden-since-we're-not-done-mutating-it. §The-result-is-built-incrementally + §harden-too-early-would-prevent-defineProperties.

§Borrowable-pattern: §when-an-object-is-built-incrementally-with-defineProperties, §don't-harden-until-the-build-is-complete + §a-comment-makes-the-discipline-visible. §Otherwise-readers-might-add-harden-thinking-it's-safe.

§Sibling to cycle 219 @endo/ses-ava's §pre-lockdown-freeze-with-named-correctness-argument family — both designs §the-comment-IS-the-protocol-against-premature-hardening.

§Seven-cycles-now-using-freeze-or-don't-harden-with-named-correctness-argument: cycles 132 + 146 + 154 + 199 + 219 + 223 + 231.
