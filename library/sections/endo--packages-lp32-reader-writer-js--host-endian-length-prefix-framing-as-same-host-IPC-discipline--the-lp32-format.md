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
title: §The-lp32-format
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

```
[ length: uint32 host-byte-order ][ payload: length bytes ]
```

§Example a 5-byte message `hello` on a little-endian host:

```
[0x05, 0x00, 0x00, 0x00][h, e, l, l, o]
```

§No-framing-overhead-beyond-4-bytes. §No-sanity-terminator.
§No-self-description.
