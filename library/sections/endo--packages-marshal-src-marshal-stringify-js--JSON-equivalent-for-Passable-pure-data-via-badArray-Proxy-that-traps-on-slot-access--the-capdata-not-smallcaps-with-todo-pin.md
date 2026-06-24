---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §capdata-not-smallcaps with §TODO-pin
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

```js
serializeBodyFormat: 'capdata',
// TODO fix tests to works with smallcaps.
```

The §legacy-format-pinned-with-TODO discipline. Cycle 69's
smallcaps is the *newer* body format; cycle 74 (marshal.js)
documents the *capdata vs smallcaps* dual-format. This file
*pins to capdata* because tests rely on the older string
format.

The §upgrade-blocked-on-test-rewrite observation: the
substantive blocker is *test brittleness* on string-literal
expectations — the smallcaps body format produces different
strings for the same input. Migrating means rewriting tests
that string-literally match expected bodies.

The §honest-TODO-not-silent-pin discipline: the choice is
*visible* in the source with a comment that names the
upgrade-blocker.
