---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §errorTagging-off configuration
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

```js
{ errorTagging: 'off', ... }
```

The §errorTagging-off mode is the §no-error-correlation-id
configuration. Cycle 74's marshal.js documents the
errorTagging discipline — *errorIdNum* for cross-side
diagnostic correlation. This file *turns it off*.

Why? Because the §pure-data-version-of-marshal use case is
*round-trip identity*. The stringify-then-parse cycle should
yield *the same logical value*, not *a logically-equivalent
value with a new error-correlation tag*. Cycle 74's
errorTagging exists to correlate errors *across CapTP*; here
there's no CapTP.
