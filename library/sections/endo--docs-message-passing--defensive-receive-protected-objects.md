---
title: Defensive Receive: Protected Objects
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, exo, patterns]
status: current
---

> Abstract: The longest section. How to build receiving objects that protect themselves: Exo classes with method guards, multi-facet kits for attenuation, defensive-copy patterns, the trust boundary between in-band and out-of-band code. The applied capability-security material.

## Defensive Receive: Protected Objects

**Exos** introduce interface guards for remotable objects.
At this point, you should forget about the `Far` stepping-stone and always
immediately reach or exos.
The **@endo/exo** package turns defensive programming from a manual discipline
into an automatic guarantee.

### The Exo Concept

An exo is a remotable object protected by an InterfaceGuard.
When a method is called, the guard validates arguments against their patterns
before the method executes:

```javascript
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';

const CounterI = M.interface('Counter', {
  increment: M.call(M.number()).returns(M.number())
});

let count = 0;

const counter = makeExo('Counter', CounterI, {
  increment(n) {
    // By the time we reach here, n is guaranteed to be a number
    count += n;
    return count;
  }
});

// Valid call
counter.increment(5);  // returns 5

// Invalid call - caught by guard
counter.increment('5');
// throws: "(Counter).increment(string \"5\") - Must be a number"
```

The guard provides the first layer of defense against malformed and malicious
input.
Your method implementation can focus on business logic, not type-checking.

### Three Patterns for Creating Exos

Exo provides three patterns depending on your needs:

#### Pattern 1: makeExo (Single Instance)

Use when you need one instance with no state management:

```javascript
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';

const GreeterI = M.interface('Greeter', {
  greet: M.call(M.string()).returns(M.string())
});

const greeter = makeExo('Greeter', GreeterI, {
  greet(name) {
    return `Hello, ${name}!`;
  }
});
```

#### Pattern 2: defineExoClass (Multiple Instances with State)

Use when you need multiple instances, each with their own state:

```javascript
import { defineExoClass } from '@endo/exo';
import { M } from '@endo/patterns';

const CounterI = M.interface('Counter', {
  increment: M.call().optional(M.number()).returns(M.number()),
  getValue: M.call().returns(M.number())
});

const makeCounter = defineExoClass(
  'Counter',
  CounterI,

  // init function: creates initial state
  (initialValue = 0) => ({ count: initialValue }),

  // methods: have access to this.state and this.self
  {
    increment(delta = 1) {
      const { state } = this;
      state.count += delta;
      return state.count;
    },
    getValue() {
      return this.state.count;
    }
  }
);

const counter1 = makeCounter(0);
const counter2 = makeCounter(100);

counter1.increment();  // 1
counter2.increment();  // 101
```

#### Pattern 3: defineExoClassKit (Multiple Facets with Shared State)

Use when you need multiple related objects (facets) sharing the same state.
This is the cornerstone of the principle of least authority: give each client
only the facet they need.

```javascript
import { defineExoClassKit } from '@endo/exo';
import { M } from '@endo/patterns';

const CounterI = {
  up: M.interface('UpCounter', {
    increment: M.call(M.number()).returns(M.number())
  }),
  down: M.interface('DownCounter', {
    decrement: M.call(M.number()).returns(M.number())
  }),
  reader: M.interface('CounterReader', {
    getValue: M.call().returns(M.number())
  })
};

const makeCounterKit = defineExoClassKit(
  'Counter',
  CounterI,

  // init: shared state across all facets
  (initialValue = 0) => ({ count: initialValue }),

  // methods: one object per facet
  {
    up: {
      increment(delta) {
        this.state.count += delta;
        return this.state.count;
      }
    },
    down: {
      decrement(delta) {
        this.state.count -= delta;
        return this.state.count;
      }
    },
    reader: {
      getValue() {
        return this.state.count;
      }
    }
  }
);

const { up, down, reader } = makeCounterKit(50);

// Give clients only the facets they need
// incrementer only gets `up`, decrementer only gets `down`
// but both affect the same shared state
up.increment(10);    // 60
down.decrement(5);   // 55
reader.getValue();   // 55
```

### Async Methods with M.callWhen()

For methods that await promises, use `M.callWhen()` to mark them as
asynchronous:

```javascript
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';
import { E } from '@endo/eventual-send';

const FetcherI = M.interface('Fetcher', {
  // Async method: awaits the url argument, returns promise
  fetch: M.callWhen(M.string()).returns(M.string())
});

const fetcher = makeExo('Fetcher', FetcherI, {
  async fetch(url) {
    // url is validated, then awaited if it's a promise
    const response = await E(httpClient).get(url);
    return response.text();
  }
});
```

The `M.callWhen()` guard:
1. Validates the argument pattern
2. Awaits the argument if it's a promise
3. Then calls the method with the resolved value

### State Management

Each exo pattern handles state differently:

- **makeExo**: No state management (uses closure variables)
- **defineExoClass**: `this.state` is per-instance, `this.self` is the exo
  itself
- **defineExoClassKit**: `this.state` shared across facets, `this.facets`
  contains all facets

```javascript
const makeWallet = defineExoClass(
  'Wallet',
  WalletI,
  (initialBalance) => ({ balance: initialBalance }),
  {
    deposit(amount) {
      // Access state
      this.state.balance += amount;

      // Return self for chaining
      return this.self;
    },
    withdraw(amount) {
      if (amount > this.state.balance) {
        throw Error('Insufficient funds');
      }
      this.state.balance -= amount;
      return amount;
    }
  }
);
```

### Introspection with GET_INTERFACE_GUARD

Every exo has a special meta-method to retrieve its interface:

```javascript
import { GET_INTERFACE_GUARD } from '@endo/exo';
import { getInterfaceMethodKeys } from '@endo/patterns';

const counter = makeCounter();

// Get the interface guard
const guard = counter[GET_INTERFACE_GUARD]();

// Inspect available methods
const methods = getInterfaceMethodKeys(guard);
console.log(methods);  // ['increment', 'getValue']
```

This enables runtime introspection and dynamic client generation.

**Key Insight**: Exos provide safe "receive" semantics - when messages arrive
at an exo, the InterfaceGuard validates inputs before execution.
But we still need a uniform way to send messages, whether the exo is local or
remote.
That's where eventual-send comes in.


Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
