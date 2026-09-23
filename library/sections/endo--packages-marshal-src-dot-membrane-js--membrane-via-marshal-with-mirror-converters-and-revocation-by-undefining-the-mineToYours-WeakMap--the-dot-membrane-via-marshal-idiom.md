---
section: membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
source: endo--packages-marshal-src-dot-membrane-js
topics: [marshal, capability-security]
status: current
title: The §dot-membrane-via-marshal idiom
parent: endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap
---

The §opening imports are the most structurally interesting line:

```js
import { makeMarshal } from './marshal.js';
```

A membrane built on top of *the serialization layer*. The
§serialize-and-then-unserialize-in-the-other-direction pattern
is the *bridge*: any value `mine` on this side becomes `yours`
on the other side via:

1. Serialize `mine` (using *this* converter's `convertMineToYours`
   for capability references)
2. Unserialize the result (using the *mirror* converter's
   `convertYoursToMine` for capability references)

Capability references survive *both* operations because each
converter's `convertSlotToVal` (the unserialize callback) is the
*other* converter's `convertYoursToMine`. The two converters
form a *pair* that maps capabilities through the membrane in
both directions.
