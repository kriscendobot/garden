---
title: Eventual Send: Async Messaging
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, captp]
status: current
---

> Abstract: How to use E() and E.when in practice: messaging local or remote objects uniformly, the turn model, error propagation through promises, pipelining for round-trip elimination. Composes with the prior sections to form the application-facing message-passing surface.

## Eventual Send: Async Messaging

The **@endo/eventual-send** package provides the `E()` proxy for asynchronous
message passing.
Whether an object is in the same vat, a different vat, or across a network,
`E()` provides a uniform API that always returns promises.

### The E Proxy

The `E()` function creates a proxy that intercepts method calls and property
access:

```javascript
import { E } from '@endo/eventual-send';

// Local exo object
const counter = makeCounter(0);

// Eventual send: invoke method, get promise
const resultP = E(counter).increment(5);

// resultP is a promise, even though counter is local
const result = await resultP;  // 5
```

Even for local objects, `E()` introduces asynchrony by deferring the method
call to the next turn of the event loop.
This provides:
- **Consistent async behavior** whether local or remote
- **Message ordering** per target object
- **Turn-based execution** for better reasoning about concurrency

### The Four Operations

#### E(target).method(...args)

Eventual send: invoke a method, returning a promise for the result.

```javascript
const counter = makeCounter(10);

// Send message, get promise
const result = await E(counter).increment(5);
console.log(result);  // 15

// Works even if counter is a promise
const counterP = Promise.resolve(counter);
const result2 = await E(counterP).increment(3);  // 18
```

#### E.get(target).property

Eventual get: retrieve a property, returning a promise for its value.

```javascript
const config = harden({
  timeout: 5000,
  retries: 3
});

const timeoutP = E.get(config).timeout;
const timeout = await timeoutP;  // 5000
```

#### E.sendOnly(target).method(...args)

Fire-and-forget: send message without waiting for result.
Returns `undefined` immediately, providing an optimization when you don't need
the result.

```javascript
const logger = makeLogger();

// Send log message, don't wait for result
E.sendOnly(logger).log('Event occurred');
// Returns immediately, logging happens eventually
```

#### E.when(promiseOrValue, onFulfilled, onRejected)

Shorthand for promise handling with turn tracking:

```javascript
E.when(
  E(counter).getValue(),
  value => console.log('Value:', value),
  error => console.error('Error:', error)
);
```

### Promise Pipelining

One of the most powerful features of eventual-send is **promise pipelining**:
the ability to send messages to promises before they resolve.

```javascript
import { E } from '@endo/eventual-send';

// mintP is a promise for a mint
const mintP = E(bootstrap).getMint();

// We can send messages to mintP immediately
// Don't need to await it first!
const purseP = E(mintP).makePurse();

// Chain more messages
const balanceP = E(purseP).getBalance();

// All messages are sent immediately
// They execute in order when each promise resolves
const balance = await balanceP;
```

Without pipelining, you'd need to await each step:

```javascript
// Without pipelining: 3 round trips
const mint = await bootstrap.getMint();     // wait
const purse = await mint.makePurse();       // wait
const balance = await purse.getBalance();   // wait

// With pipelining: messages sent immediately
const balance = await E(E(E(bootstrap).getMint()).makePurse()).getBalance();
// Only wait at the end
```

This can dramatically reduce latency in distributed systems.

### Why Eventual Send?

Eventual send provides four key benefits:

1. **Uniform API**: Same code works whether target is local or remote
2. **Message Ordering**: Messages to the same target execute in send order
3. **Pipeline Optimization**: Reduce round trips in distributed systems
4. **Future-Proof**: Local code works when migrated to distributed setup

```javascript
// This code works unchanged whether counter is:
// - A local exo object
// - A local promise for an exo
// - A remote presence in another vat
// - A remote presence on another machine
const result = await E(counter).increment(5);
```

### E() with Exos: A Perfect Match

Exos are the ideal targets for eventual send:

```javascript
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';
import { E } from '@endo/eventual-send';

const CounterI = M.interface('Counter', {
  increment: M.call(M.number()).returns(M.number())
});

const counter = makeExo('Counter', CounterI, {
  increment(n) {
    return count += n;
  }
});

// E() provides async wrapper
const resultP = E(counter).increment(5);

// The InterfaceGuard validates n is a number
// Even if counter is remote, validation happens on receive
```

Even for local exos, using `E()` provides benefits:
- **Consistent async behavior** in your codebase
- **Turn-based execution** prevents reentrancy bugs
- **Error isolation** via promise rejection
- **Future-proof** code that works when distributed

**Key Insight**: We now have all the pieces: passable data (pass-style),
validation (patterns), defensive objects (exo), and async communication
(eventual-send).
Let's put them all together in a complete example.


Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
