---
title: §QCLASS-as-special-property-name
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
const QCLASS = '@qclass';
export { QCLASS };
```

§Single-named-discriminator-string-used-throughout-the-wire-format. §Borrowable-pattern: §pick-a-special-property-name-that-couldn't-collide-with-user-data + §export-it-as-a-named-constant + §use-it-consistently.

§The-`@qclass`-prefix is §JSON-illegal-for-user-data-keys (`@` is permitted but uncommon and conventionally reserved); §the-Hilbert-Hotel-encoding rescues data that does collide.

§Sibling to cycle 217 @endo/errors' §`__HIDE_`-prefix-protocol and cycle 219 @endo/ses-ava's §registered-symbol-on-globalThis — §three-cycles-on-protocol-via-name-prefix.
