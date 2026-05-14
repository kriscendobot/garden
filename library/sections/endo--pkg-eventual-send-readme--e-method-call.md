---
title: E(target).method(...args)
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, captp]
status: current
---

> Abstract: The primary eventual-send operation: E(target).method(args) eventually sends a method-call message to target. If target is local, calls happen in a future turn; if remote, calls are pipelined across the comm boundary. Returns a promise for the eventual return value.

## Core API

### E(target).method(...args)

Eventual send: invoke a method, returning a promise for the result.

```javascript
import { E } from '@endo/eventual-send';

const counter = makeCounter(10);

// Send message, get promise
const resultP = E(counter).increment(5);
const result = await resultP;  // 15

// Works even if counter is a promise
const counterP = Promise.resolve(counter);
const result2 = await E(counterP).increment(3);  // 18
```

**Key property:** Works uniformly whether the target is:
- A local object
- A local promise for an object
- A remote presence in another vat
- A promise for a remote presence

All calls return promises, even for local objects, ensuring consistent async
behavior throughout your codebase.


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
