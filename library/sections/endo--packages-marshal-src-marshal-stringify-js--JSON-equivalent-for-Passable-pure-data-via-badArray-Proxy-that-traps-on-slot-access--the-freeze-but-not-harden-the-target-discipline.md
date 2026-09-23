---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §freeze-but-not-harden-the-target discipline
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

```js
const arrayTarget = freeze([]);
const badArray = new Proxy(arrayTarget, badArrayHandler);
```

The §stabilize-discipline carries over from cycle 146
(eventual-send/src/E.js) and cycle 154 (captp/src/trap.js):

> *`freeze` but not `harden` the proxy target so it remains
> trapping. Thus, it should not be shared outside this module.*

The §verbatim-comment-shared-across-derived-files pattern
(named in cycle 154): the same JSDoc word-for-word appears in
three @endo files — cycle 146 / cycle 154 / this file. All
three cite the same `preparing-for-stabilize.md` rationale.

The §trapping-proxy-needs-non-hardened-target invariant: a
hardened target may trigger V8 Proxy short-circuits that
bypass meta-traps. The badArray's *entire job* is to trap on
every access; a hardened target would defeat its purpose.
