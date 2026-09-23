---
title: §The-eleven-cases of the encode-switch
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

```
case 'null' | 'boolean' | 'string': pass through to JSON
case 'undefined': { [QCLASS]: 'undefined' }
case 'number': three special cases (NaN, Infinity, -Infinity) + -0 → 0 + pass through
case 'bigint': { [QCLASS]: 'bigint', digits: String(passable) }
case 'symbol': { [QCLASS]: 'symbol', name }
case 'copyRecord': hilbert check + sort keys + recurse
case 'copyArray': passable.map(encodeToCapDataRecur)
case 'byteArray': TODO Fail not yet implemented
case 'tagged': { [QCLASS]: 'tagged', tag, payload: recurse(payload) }
case 'remotable': encodeRemotableToCapData callback + validate result has slot
case 'promise': encodePromiseToCapData callback + validate result has slot
case 'error': encodeErrorToCapData callback + validate result has error
default: throw TypeError on unrecognized passStyle
```

§Eleven-named-cases. §Borrowable-pattern: §switch-on-the-typed-discriminator + §validate-each-callback's-return-shape. §The-callback-returns-an-Encoding + §the-encoder-validates-its-shape-via-`qclassMatches`. §Defense-in-depth-against-callback-misbehavior.

§The-`-0`-special-case: §`return is(passable, -0) ? 0 : passable;`. §Borrowable-pattern: §normalize-`-0`-to-`0`-because-JSON-doesn't-distinguish-them-anyway + §canonical-encoding-requires-they-encode-the-same.
