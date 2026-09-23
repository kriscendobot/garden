---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §re-export-E-from-captp convenience
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

```js
import { E, makeCapTP } from './captp.js';
// ...
export { E };
```

The §re-export-E-from-captp convenience: callers `import
{ makeLoopback, E }` from one file rather than two. The §single-
entry-point-for-test-fixtures pattern.
