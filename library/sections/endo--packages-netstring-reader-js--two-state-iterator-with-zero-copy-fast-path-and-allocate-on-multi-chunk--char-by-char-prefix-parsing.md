---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_path: packages/netstring/reader.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mathieu Hofman (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 177
lane: chat
status: current
title: §Char-by-char prefix parsing
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
for await (const chunk of input) {
  let buffer = chunk;
  while (buffer.length) {
    if (lengthBuffer) {
      let i = 0;
      while (i < buffer.length) {
        const c = buffer[i];
        i += 1;
        if (c >= ZERO && c <= NINE) {
          lengthBuffer.push(c);
          ...
        } else if (c === COLON && lengthBuffer.length) {
          lengthBuffer.push(c);
          break;
        } else {
          throw Error(`Invalid netstring length prefix ...`);
        }
      }
      buffer = buffer.subarray(i);
      ...
    }
  }
}
```

§Three-character-cases: digit / COLON / anything-else.

§Digit-accumulates; §COLON-terminates; §anything-else-
throws. §Strict-validation at the character level.

§COLON-required-after-at-least-one-digit (`lengthBuffer.
length` check prevents empty-prefix). §Empty-length-prefix-
is-an-error.

§Constants-pre-computed: `COLON = ':'.charCodeAt(0)`,
`COMMA = ','.charCodeAt(0)`, `ZERO`/`NINE`. §Compile-time-
constants for §hot-path-byte-comparison.
