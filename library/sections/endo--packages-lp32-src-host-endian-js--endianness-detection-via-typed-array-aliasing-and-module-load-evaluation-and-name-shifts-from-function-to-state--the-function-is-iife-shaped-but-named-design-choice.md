---
title: §The function is IIFE-shaped-but-named — design choice
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
const isHostLittleEndian = () => { ... };
export const hostIsLittleEndian = isHostLittleEndian();
```

§The-canonical-IIFE-shape would be:

```js
export const hostIsLittleEndian = (() => { ... })();
```

§The-author-chose-the-named-form-over-the-IIFE-form. §The-named-form-makes-the-function-debuggable + §the-named-form-makes-the-stack-trace-meaningful-if-the-function-throws + §the-named-form-makes-the-function-testable-in-isolation (though this file doesn't export the function).

§When-an-IIFE-would-suffice-but-the-function's-purpose-is-named-able, §prefer-the-named-form-over-the-anonymous-IIFE + §the-name-IS-the-documentation. §Sibling-to-cycle-241's-`function postpone(...)`-debug-name-via-`function`-keyword-syntax — both designs give names to functions that didn't need them syntactically.
