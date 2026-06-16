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
title: §Sibling-comparison-with-netstring (cycle 177)
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

| Property                  | netstring (cycle 177)             | lp32 (cycle 179)                |
|---------------------------|-----------------------------------|---------------------------------|
| Length encoding           | ASCII decimal + colon             | uint32 binary                   |
| Length size               | Variable (1–N digits + `:` + `,`) | Fixed 4 bytes                   |
| Endianness                | Irrelevant (ASCII text)           | Host byte order                 |
| Self-describing on wire   | Yes (visible in hex dump)         | No (need parser)                |
| Sanity terminator         | Trailing `,`                      | None                            |
| Use case                  | CapTP-over-anything; daemon socket| WebExtension native messaging   |
| State machine             | Explicit two-state iterator       | Implicit (length always at +0)  |
| Allocation strategy       | Two buffers; subarray fast-path   | Single growing buffer; slice    |
| Default `maxMessageLength`| 1 MiB                             | 1 MiB                           |

§Same-shape-different-encoding. §Both-are-makeReader+makeWriter
pairs. §Both-target-Reader<Uint8Array,void>-from-@endo/stream
(cycle 171). §Both-are-hardened. §Difference-is-the-wire-format-
and-the-runtime-properties-that-flow-from-it.
