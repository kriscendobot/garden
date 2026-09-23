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
title: Host-endian length-prefix framing as same-host IPC discipline with single-buffer copyWithin shift
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

> §Chat-lane after cycle 178's designs-lane. §Endo-source-
> comment-fragment genre. §Direct-sibling to cycle 177's
> netstring/reader.js — same problem (length-prefixed message
> framing as async iterators), different encoding choices.

`packages/lp32/reader.js` (82 lines) + `packages/lp32/writer.js`
(49 lines) + `packages/lp32/src/host-endian.js` (9 lines)
implement the binary message framing protocol used by
**[WebExtension Native Messaging][native]**. Each message is
prefixed with a 32-bit unsigned integer length in **host byte
order**, followed by the payload of that length.

[native]: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging

§The-single-most-structurally-interesting-move is §host-byte-
order-as-deliberate-IPC-marker: the protocol target is
**same-host** (browser extension ↔ native helper via stdio
pipes), so endianness is moot, and using host byte order
avoids per-message byte-swapping on every modern (little-
endian) platform. §Compare-to-network-protocols, which must
choose an endianness (almost always big-endian / network
byte order); §compare-to-netstring (cycle 177), which uses
ASCII-decimal length and is endian-free by construction.
