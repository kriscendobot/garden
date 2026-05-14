---
title: HandledPromise
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
notes: HandledPromise is CapTP's plug-in point for promise references; the marshal counterpart is convertValToSlot / convertSlotToVal (endo--pkg-marshal-readme--convert-val-slot). A CapTP implementation co-installs both when bridging marshal + eventual-send to a wire protocol.
---

> Abstract: The underlying primitive: a HandledPromise is a promise with a handler that decides how E()/E.get()/E.sendOnly() are dispatched. The eventual-send shim implements HandledPromise; CapTP and other transports plug their own handler implementations in to make E() work across the wire.

## HandledPromise

Under the hood, `E()` uses `HandledPromise`, a Promise subclass that supports
handler-based dispatch:

```javascript
import { HandledPromise } from '@endo/eventual-send';

// HandledPromise extends native Promise
const hp = new HandledPromise((resolve, reject, resolveWithPresence) => {
  // Three ways to settle the promise
  resolve(value);           // Normal resolution
  reject(reason);           // Rejection
  resolveWithPresence(h);   // Resolve with a remote presence
}, handler);

// Handler intercepts operations
const handler = {
  get(target, prop) { /* ... */ },
  applyMethod(target, verb, args) { /* ... */ }
};
```

**Most users don't need to use HandledPromise directly.**
The `E()` proxy provides the ergonomic interface.


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
