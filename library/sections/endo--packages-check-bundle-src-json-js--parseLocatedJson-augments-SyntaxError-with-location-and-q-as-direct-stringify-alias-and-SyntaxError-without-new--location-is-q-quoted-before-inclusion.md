---
title: §Location is q-quoted before inclusion
source-slug: endo--packages-check-bundle-src-json-js
source-url: https://github.com/endojs/endo/blob/master/packages/check-bundle/src/json.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/check-bundle/src/json.js
total-lines: 22
ingest-cycle: 247
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new
---

```js
`Cannot parse JSON from ${q(location)}, ${error}`
```

§The-location-string-is-q-quoted-before-being-included-in-the-error-message. §`q(location)`-produces-the-JSON-encoded-form (with surrounding quotes + escaped special characters). §When-a-location-might-contain-special-characters (spaces, quotes, control chars), §JSON-encode-it-for-safe-inclusion-in-the-error-message.

§Sibling-pattern-to-cycle-237's-`q({ a, b })` for-structured-value-in-error-message — §two-cycles-with-q-applied-to-error-message-context. §Cycle-237-q's-a-structured-object; §cycle-247-q's-a-string-for-safe-quoting. §Two-different-uses-of-q-in-error-messages.

§Three-cycles-with-q-in-error-message-context if we count cycle 240's q-from-`@endo/errors` (which is the `q` template-tag, a different shape but same name). §The-name-`q`-is-recurring-with-three-different-call-shapes (single-letter-function-from-JSON + bare-template-tag-from-endo-errors + alias-to-JSON.stringify).
