---
title: Interface Guards
source: packages/patterns/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns, exo]
status: current
---

> Abstract: Interface guards declare the shape of an Exo class's methods: argument types per method, return type, async behavior. Built via M.interface(name, methodGuards) where each methodGuard is M.call(...args).returns(ret) or similar. Exo uses interface guards both at construction time (the methodsGuard parameter) and at message-arrival time (validating inbound arguments before dispatching to the method body). Integration with Exo: every Exo class declares one or more interface guards as part of its definition.

## Interface Guards

InterfaceGuards describe behavioral contracts for objects, particularly useful
with [@endo/exo](../exo/README.md):

### Creating Interface Guards

```javascript
import { M } from '@endo/patterns';

const CounterI = M.interface('Counter', {
  // Synchronous method
  increment: M.call(M.number()).returns(M.number()),

  // Method with optional arguments
  reset: M.call().optional(M.number()).returns(),

  // Method with rest arguments
  add: M.call(M.number()).rest(M.number()).returns(M.number()),

  // Async method (awaits arguments)
  asyncOp: M.callWhen(M.string()).returns(M.string())
});
```

### Method Guard Structure

```javascript
// Basic call: call(required args...)
M.call(M.string(), M.number())

// With optional args
M.call(M.string()).optional(M.number())

// With rest args
M.call(M.string()).rest(M.any())

// Specify return type
M.call(M.string()).returns(M.number())

// Async method (awaits promise args)
M.callWhen(M.remotable()).returns(M.string())
```

### Integration with Exo

InterfaceGuards are enforced automatically by exos:

```javascript
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';

const CounterI = M.interface('Counter', {
  increment: M.call(M.number()).returns(M.number())
});

const counter = makeExo('Counter', CounterI, {
  increment(n) {
    // n is guaranteed to be a number by the guard
    return count += n;
  }
});

counter.increment(5);      // OK
counter.increment('5');    // throws: Must be a number
```

This is the foundation of defensive programming in Endo: guards validate inputs
automatically, so your methods can focus on business logic.


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
