---
source: packages/base64/src/{encode,decode,common}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_path: packages/base64/src/encode.js, packages/base64/src/decode.js, packages/base64/src/common.js, packages/base64/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
status: current
title: §common.js — monodu64 + alphabet64 + padding
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
const { freeze } = Object;

export const padding = '=';

export const alphabet64 =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

export const monodu64 = {};
for (let i = 0; i < alphabet64.length; i += 1) {
  const c = alphabet64[i];
  monodu64[c] = i;
}
freeze(monodu64);
```

§The-naming-comment explains `monodu64`:

> If an alphabet is named for the Greek letters alpha and beta,
> then clearly a monodu is named for the corresponding Greek
> numbers mono and duo.

§Etymology-as-comment. §The-name-monodu evokes §alphabet-of-
numerals; §the-table-maps-character-to-its-numeric-value (the
inverse of `alphabet64`).

§Module-load-time-construction: the for-loop populates `monodu64`
once at import; §`freeze`-pins-the-table after construction.

§Compare-to-cycle-180-hex-package's-§module-load-time-alphabet-
constant pattern with `hexAlphabetLower` / `hexAlphabetUpper`
— hex doesn't need the reverse table because hex digits can be
decoded by formula (`hexDigitValue(charCode)`); §base64-needs-a-
lookup-table because the alphabet is non-contiguous (`A-Z` then
`a-z` then `0-9` then `+/`).

§Same-discipline-different-implementation: both freeze constants
at module-init.
