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
title: §Three-class-decode-error (trailing garbage / missing padding / invalid char)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
// Invalid char (in main loop):
if (number === undefined) {
  throw Error(`Invalid base64 character ${string[i]} in string ${name}`);
}

// Missing padding:
throw Error(`Missing padding at offset ${i} of string ${name}`);

// Trailing garbage:
throw Error(
  `Base64 string has trailing garbage ${string.substr(i)} in string ${name}`,
);
```

§Three-distinct-error-shapes for three failure modes. §All-
embed-`name` for caller-context. §Compare-to-cycle-177-netstring/
reader.js' §four-pieces-of-context-per-error.

§Cycle-180-hex-package's §error-rewrapping-at-the-native-
boundary tries to preserve this shape when delegating to native
TC39 `fromHex`. §Base64-instead-uses-the-§polyfill-rerun
approach to get this exact shape from the polyfill itself.
