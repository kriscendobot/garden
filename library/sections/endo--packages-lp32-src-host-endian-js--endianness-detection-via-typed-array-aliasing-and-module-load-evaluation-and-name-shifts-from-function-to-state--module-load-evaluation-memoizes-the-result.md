---
title: §Module-load evaluation memoizes the result
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
export const hostIsLittleEndian = isHostLittleEndian();
```

§The-function-is-called-at-module-load-not-on-demand + §the-result-is-frozen-into-a-module-level-constant. §The-host's-byte-order-doesn't-change-between-loads-of-the-same-module + §so-the-one-time-evaluation-IS-the-correct-shape. §When-a-fact-about-the-host-platform-is-stable-for-the-lifetime-of-the-module, §evaluate-it-at-module-load-and-export-it-as-a-constant-not-as-a-function.

§Sibling-pattern-to-cycle-239's-GET_INTERFACE_GUARD-named-constant — both designs use §a-module-level-export-as-the-canonical-record-of-a-fact. §The-constant-IS-the-API + §the-API-doesn't-need-a-function-call-to-retrieve-the-fact.
