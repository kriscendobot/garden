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
title: §Bit-register-quantum-accumulator (the JS fallback algorithm)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
export const jsEncodeBase64 = data => {
  let string = '';
  let register = 0;
  let quantum = 0;

  for (let i = 0; i < data.length; i += 1) {
    const b = data[i];
    register = (register << 8) | b;
    quantum += 8;
    if (quantum === 24) {
      string +=
        alphabet64[(register >>> 18) & 0x3f] +
        alphabet64[(register >>> 12) & 0x3f] +
        alphabet64[(register >>> 6) & 0x3f] +
        alphabet64[(register >>> 0) & 0x3f];
      register = 0;
      quantum = 0;
    }
  }
```

§Two-variable-state-machine: `register` (32-bit accumulator) +
`quantum` (bits accumulated, 0–24).

§The-algorithm-per-byte: shift 8 bits in from the right; when
quantum reaches 24 (= 3 bytes = 4 base64 chars), emit four
6-bit slices and reset.

§Bit-arithmetic: `(register >>> 18) & 0x3f` extracts the
topmost 6 bits as a 0–63 index into `alphabet64`.

§Compare-to-cycle-180-hex-package's-§byte-wise-nibble-lookup:

```js
// (hex)
const b = bytes[i];
string += alphabet[b >>> 4] + alphabet[b & 0x0f];
```

§Hex-has-no-bit-accumulator-because byte boundaries align with
character boundaries (1 byte = 2 hex chars = 8 bits). §Base64-
needs-one-because 1 base64 char = 6 bits, not aligned with bytes.

§The-comment-explains-the-string-concatenation-choice:

```js
// A cursory benchmark shows that string concatenation is about 25% faster
// than building an array and joining it in v8, in 2020, for strings of about
// 100 long.
```

§Benchmarked-decision-not-style-preference. §Cycle-180-hex
uses the same string-concatenation idiom; §the-discipline-
ported-cleanly.
