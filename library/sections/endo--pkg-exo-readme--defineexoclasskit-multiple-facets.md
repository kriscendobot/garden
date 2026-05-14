---
title: defineExoClassKit: Multiple Facets with Shared State
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, capability-security]
status: current
---

> Abstract: defineExoClassKit(tag, facetsGuards, init, facetsMethods) returns a maker for a cohort of facets. Each call to the maker invokes init() once, then constructs N facets (one per facet name) sharing that state. this.facets gives access to all facets in the cohort; there is no this.self (cohort has no single self). The canonical pattern for attenuator-style capability splits.

### defineExoClassKit: Multiple Facets with Shared State

Use when you need multiple related objects (facets) that share the same state.
This is the key pattern for **least authority**: give each client only the
facet they need.

```javascript
import { defineExoClassKit } from '@endo/exo';
import { M } from '@endo/patterns';

const CounterKitI = {
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
  CounterKitI,

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

// Give different facets to different clients
// incrementer only gets `up`, decrementer only gets `down`
// Everyone can have `reader`, it's read-only
up.increment(10);    // 60
down.decrement(5);   // 55
reader.getValue();   // 55
```

**When to use:**
- Need to separate capabilities (least authority)
- Multiple related objects that share state
- Example: public/private interfaces, admin/user facets, mint/purse/payment
  patterns

**Context access:**
- `this.state` - Shared state across all facets
- `this.facets` - Object containing all facets (for inter-facet communication)


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
