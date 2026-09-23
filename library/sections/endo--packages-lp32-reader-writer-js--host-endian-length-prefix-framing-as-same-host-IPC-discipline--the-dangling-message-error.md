---
source: packages/lp32/{reader,writer}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/lp32
source_path: packages/lp32/reader.js, packages/lp32/writer.js, packages/lp32/src/host-endian.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - captp
genre: §endo-source-comment-fragment
cycle: 179
lane: chat
status: current
title: §The-dangling-message-error
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

```js
if (length > 0) {
  throw Error(
    `Unexpected dangling message of length ${length} at offset ${offset} of ${name}`,
  );
}
```

§After-the-input-stream-ends, if there are bytes left in the
buffer, throw. §This-catches-truncated-streams: the sender
sent a 4-byte length prefix promising N more bytes, but the
stream ended with fewer than N delivered.

§Compare-to-cycle-177-netstring which has a different end-of-
stream behavior (returns gracefully when in waiting-for-length
state with no bytes buffered). §lp32's-rule-is-stricter: any
residual bytes are an error.

§The-error-message-includes-`offset`: the cumulative bytes
successfully consumed before the dangling bytes appeared.
§This-is-the-only-use-of-`offset`-in-the-decoder — it exists
solely to make the error message diagnostic-useful.
