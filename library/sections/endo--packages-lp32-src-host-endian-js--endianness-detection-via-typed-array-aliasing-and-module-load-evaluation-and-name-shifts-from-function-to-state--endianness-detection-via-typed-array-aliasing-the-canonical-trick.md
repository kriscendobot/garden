---
title: §Endianness-detection-via-typed-array-aliasing — the canonical trick
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

```js
const isHostLittleEndian = () => {
  const array8 = new Uint8Array([1, 0]);
  const array16 = new Uint16Array(array8.buffer);
  return array16[0] === 1;
};
```

§The-`Uint8Array`-shares-buffer-with-`Uint16Array`-via-the-`.buffer`-property + §same-memory-different-view. §The-Uint8Array-stores-the-two-bytes [1, 0] + §when-read-as-Uint16: §little-endian-platforms-give-1 (LSB first: 0x0001) + §big-endian-platforms-give-256 (MSB first: 0x0100).

§The-typed-array-aliasing-IS-the-detection-mechanism. §When-the-host-platform's-byte-order-must-be-known-at-runtime, §write-known-bytes-via-one-view-and-read-them-via-another-view + §the-discrepancy-IS-the-evidence. §No-NodeJS-API-call-required + §no-`os.endianness()`-import + §the-detection-is-pure-JavaScript-language-feature-only.

§Sibling-pattern-to-cycle-241's-`new Promise((resolve, reject) => { ... })`-resolve-callback-captured-via-closure — both patterns use a §JavaScript-language-feature-to-extract-a-fact-not-available-via-the-feature's-stated-purpose. §The-canonical-tricks-are-load-bearing.
