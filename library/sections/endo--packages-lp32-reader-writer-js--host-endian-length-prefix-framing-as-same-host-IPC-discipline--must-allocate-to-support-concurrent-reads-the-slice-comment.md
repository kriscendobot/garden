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
title: §"Must allocate to support concurrent reads" — the slice comment
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

```js
// Must allocate to support concurrent reads.
yield array8.slice(4, envelopeLength);
```

§This-comment-is-the-key-correctness-property. §`slice` (not
`subarray`) copies the bytes; the yielded `Uint8Array` is
independent of `array8`.

§Why-must-it-be-independent? §Because-the-caller-of-the-async-
iterator may hold the yielded message **while another message
is being decoded into `array8`**. §If-we-yielded-a-subarray
view, the next `copyWithin` would corrupt the caller's data.

§Compare-to-cycle-177-netstring which has §zero-copy-fast-path
when a message fits in a single chunk — netstring can yield a
subarray of the *chunk* (which is owned by the upstream
reader's chunk lifecycle, separate from the framing decoder's
buffer). §lp32-cannot-take-that-shortcut because it always
copies chunks into its own buffer first.

§The-tradeoff-is-explicit: §netstring-optimizes-for-the-common-
case (single-chunk message, no copy); §lp32-pays-the-copy-cost
unconditionally for simpler buffer management.

§Cycle-130-message-breakpoints had a similar §correctness-
property-encoded-as-a-comment (the breakpoint must run
between turns, not within); §cycle-179-lp32-encodes the
concurrent-reads invariant the same way.
