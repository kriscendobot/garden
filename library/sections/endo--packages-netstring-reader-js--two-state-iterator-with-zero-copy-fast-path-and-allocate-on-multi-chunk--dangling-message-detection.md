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
title: §Dangling-message detection
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
if (!lengthBuffer) {
  throw Error(`Unexpected dangling message at offset ${offset} of ${name}`);
}
```

§At-EOF-of-input-stream: §if-still-in-waiting-for-data-
state-throw.

§Half-a-message-is-an-error. §Sender-must-flush-complete-
messages.

§Cycle-149's-error-path-cannot-depend-on-error-path has a
sibling discipline: §the-error-message-is-helpful-when-
the-protocol-is-broken (offset + name).
