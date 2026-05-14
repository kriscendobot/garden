---
title: State Management
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, persistence]
status: current
---

> Abstract: How state is provided and accessed across the three forms: makeExo has no state (this.state is empty); defineExoClass provides state from init() to each method via this.state; defineExoClassKit provides one state from init() shared across all facets in the cohort. State is mutable; the framework does not freeze it.

## State Management

Each exo pattern handles state differently:

### makeExo

No built-in state management.
Use closure variables:

```javascript
let count = 0;

const counter = makeExo('Counter', CounterI, {
  increment() {
    count += 1;
    return count;
  }
});
```

### defineExoClass

`this.state` is per-instance:

```javascript
const makeCounter = defineExoClass(
  'Counter',
  CounterI,
  (initial) => ({ count: initial }),  // state for this instance
  {
    increment() {
      this.state.count += 1;  // each instance has separate state
      return this.state.count;
    }
  }
);
```

### defineExoClassKit

`this.state` is shared across all facets:

```javascript
const makeKit = defineExoClassKit(
  'Kit',
  { facet1: I1, facet2: I2 },
  () => ({ sharedData: [] }),  // shared by both facets
  {
    facet1: {
      add(item) {
        this.state.sharedData.push(item);  // modifies shared state
      }
    },
    facet2: {
      getAll() {
        return this.state.sharedData;  // reads shared state
      }
    }
  }
);
```


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
