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
title: §Comma-separator-validation
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
if (buffer[remainingDataLength] !== COMMA) {
  throw Error(
    `Invalid netstring separator "${String.fromCharCode(
      buffer[remainingDataLength],
    )} at offset ${offset} of ${name}`,
  );
}
```

§COMMA-after-data-is-required-and-checked. §The-comma-is-
the-message-boundary-marker.

§If-COMMA-missing: §error-with-the-actual-byte-shown.
§Helpful-diagnostic.

§Why-the-comma: §netstring-spec-requires-it; §it's-the-
sanity-check that the length prefix was honest. §If-length-
was-wrong-the-comma-won't-be-at-the-expected-offset.
