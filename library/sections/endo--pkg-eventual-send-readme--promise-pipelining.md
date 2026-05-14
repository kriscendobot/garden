---
title: Promise Pipelining
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

> Abstract: When messages cross a network boundary via E(), the comm layer can pipeline subsequent E() calls against the not-yet-resolved promise without a full round-trip. E.g., E(E(remote).getX()).method() sends both calls in one trip, with the second message addressed at the resolution-of-getX as a promise reference. Critical for performance over high-latency links.

## Promise Pipelining

One of the most powerful features is **promise pipelining**: the ability to
send messages to promises before they resolve.

```javascript
import { E } from '@endo/eventual-send';

// All of these send immediately - no waiting!
const mintP = E(bootstrap).getMint();
const purseP = E(mintP).makePurse();
const paymentP = E(purseP).withdraw(100);
await E(receiverPurse).deposit(100, paymentP);

// Only wait at the end for the final result
```

Without pipelining, you'd need to await each step:

```javascript
// Without pipelining: 4 round trips
const mint = await bootstrap.getMint();        // wait
const purse = await mint.makePurse();          // wait
const payment = await purse.withdraw(100);     // wait
await receiverPurse.deposit(100, payment);     // wait

// With pipelining: messages sent immediately, only wait at end
```

This can **dramatically reduce latency** in distributed systems by eliminating
round trips.

**How it works:**
- Messages to unresolved promises are queued
- When the promise resolves, queued messages are delivered in order
- Each message returns a new promise that resolves when the operation completes


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
