---
title: defineExoClass: Multiple Instances with State
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo]
status: current
---

> Abstract: defineExoClass(tag, methodsGuard, init, methods) returns a maker function. Each call to the maker invokes init() to produce a fresh state record, then constructs a remotable closing over that state. this.self is the exo; this.state is the init() result; methods may mutate state. The standard form for classes with per-instance state.

### defineExoClass: Multiple Instances with State

Use when you need multiple exo instances, each with their own state:

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

  // init function: creates initial state for each instance
  (initialValue = 0) => ({ count: initialValue }),

  // methods: have access to this.state and this.self
  {
    increment(delta = 1) {
      this.state.count += delta;
      return this.state.count;
    },
    getValue() {
      return this.state.count;
    }
  }
);

const counter1 = makeCounter(0);
const counter2 = makeCounter(100);

counter1.increment();  // 1
counter2.increment();  // 101 (separate state)
```

**When to use:**
- Need multiple independent instances
- Each instance has its own state

**State access:**
- `this.state` - The instance's state object
- `this.self` - Reference to the exo itself (for return values or callbacks)


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
