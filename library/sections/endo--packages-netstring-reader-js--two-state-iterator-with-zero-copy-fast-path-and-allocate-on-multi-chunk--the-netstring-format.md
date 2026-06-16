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
title: §The-netstring-format
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

§Netstring = §length-decimal-prefix + §colon + §data-bytes
+ §comma:

```
13:hello world!,
9:goodbye!!,
```

§Self-delimiting-binary-protocol. §No-escaping-needed:
length is known before data; comma is a sanity check.

§Cycle-167-where/index.js named netstring's role: §the-
daemon's-CLI-socket-speaks-netstring-framed-CapTP. §This-
file-is-the-decoder-of-that-framing.

§Cycle-141-daemon-cas-management uses netstring for
envelope-bus framing. §Cycle-176-daemon-endor-architecture
uses the same in `socket.rs` (Rust implementation of the
same protocol).
