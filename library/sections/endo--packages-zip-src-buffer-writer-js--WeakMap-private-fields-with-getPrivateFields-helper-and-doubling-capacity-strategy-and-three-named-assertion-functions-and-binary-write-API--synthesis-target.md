---
title: Synthesis target
section-slug: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
source-slug: endo--packages-zip-src-buffer-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-writer.js
total-lines: 188
ingest-cycle: 290
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
---

Slot machine library `@game/replay/src/buffer-writer.js`: WeakMap-private-fields with `getPrivateFields(self)` helper + `'GameWriter fields are not initialized'` defensive throw + `assertNatNumber` (Number.isSafeInteger + non-negative) + five-field private record (length + index + bytes + data + capacity) + doubling-capacity-strategy with while-loop for grow-to-fit + getter-and-setter-pair where setter delegates to `seek(index)` + `ensureCanSeek` and `ensureCanWrite` as named pre-conditions with composition + `Math.max(fields.index, fields.length)` watermark update + DataView's `setUint8/16/32` for binary primitives + optional `littleEndian` parameter + `subarray()` returning a view + `slice()` returning a copy + `copyWithin` for internal byte copy + 16-byte default initial capacity + Uint8Array + DataView pair viewing same buffer + no-`harden`-on-private-fields + Error class for runtime-state failures + TypeError class for input-validation failures.
