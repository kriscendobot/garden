---
title: §Why endianness matters at this layer
source-slug: endo--packages-lp32-src-host-endian-js
source-url: https://github.com/endojs/endo/blob/master/packages/lp32/src/host-endian.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/lp32/src/host-endian.js
total-lines: 9
ingest-cycle: 243
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-lp32-src-host-endian-js--endianness-detection-via-typed-array-aliasing-and-module-load-evaluation-and-name-shifts-from-function-to-state
---

§The-lp32-package (length-prefix-32) reads and writes streams framed by 32-bit length prefixes. §When-reading-or-writing-a-32-bit-integer-into-or-out-of-a-byte-stream, §the-byte-order-must-be-known. §The-protocol-might-specify-network-byte-order (big-endian) and §the-host-might-be-little-endian, so §the-package-needs-to-know-whether-to-byte-swap.

§The-constant-IS-the-input-to-the-byte-swap-decision. §When-the-host-byte-order-is-known-at-module-load, §the-byte-swap-decision-can-be-baked-into-the-read/write-functions-not-decided-on-every-call. §Performance-by-construction: §the-typed-array-aliasing-runs-once + §every-subsequent-frame-uses-the-cached-result.
