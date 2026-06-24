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
title: §Host-byte-order-as-deliberate-choice (the file-header comment)
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

```js
// @ts-check
// DataView does not default to host byte order like TypedArrays, so we must
// pass an explicit endianness argument.
```

§This-comment-justifies-the-existence-of-host-endian-js.
§Without-DataView-quirk-the-file-could-have-just-used-
Uint32Array-typed-views which are implicitly host-endian.
§But-DataView-defaults-to-big-endian (network byte order)
unless you pass the `littleEndian` boolean explicitly. §So-
the-code-needs-to-detect-host-endianness-at-load-time-and-
pass-it-to-every-getUint32/setUint32-call.

§Cycle-152-pass-style/symbol.js had a similar §runtime-probe
pattern (`Symbol.for('@@asyncIterator')` to detect SES
environment); §cycle-179-host-endian.js is the §runtime-
endianness-probe.

§The-probe (`packages/lp32/src/host-endian.js`, 9 lines):

```js
const isHostLittleEndian = () => {
  const array8 = new Uint8Array([1, 0]);
  const array16 = new Uint16Array(array8.buffer);
  return array16[0] === 1;
};

export const hostIsLittleEndian = isHostLittleEndian();
```

§Module-load-time-probe. §Write-1-then-0-as-bytes; §read-as-
uint16; §if-uint16-equals-1-then-low-byte-came-first → little-
endian. §Stored-as-a-constant-bound-at-module-init-not-
recomputed-per-message.

§Why-not-just-pick-an-endianness? §Because-the-protocol-is-
WebExtension-native-messaging, where both sides run on the
same physical machine, and Chrome/Firefox use **host** byte
order for the length prefix (so the native helper can use
the host's natural uint32 ops). §Endo's-implementation-must-
match-the-host-OS-the-browser-is-running-on.
