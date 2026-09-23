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
title: §The-canonical-decoder for §netstring-protocol-family
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

§Netstring-is-the-substrate. Used by:

| Cycle | Use |
|-------|-----|
| 49 (daemon-locator-reference) | ENDO_SOCK_PATH speaks netstring-framed CapTP |
| 141 (daemon-cas-management) | Envelope-bus framing |
| 174 (gateway-package) | ocapn-tcp-syrups-framing dependency |
| 176 (daemon-endor-architecture) | `socket.rs` client bridging (Rust) |

§This-file-is-the-JS-implementation. §The-Rust-supervisor-
has-its-own-implementation but speaks the same wire.

§Same-protocol-different-substrate (cycle 176 sibling
observation about CBOR envelopes).
