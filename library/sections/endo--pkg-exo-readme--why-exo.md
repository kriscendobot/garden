---
title: Why Exo?
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

> Abstract: Motivates Exo over Far() alone: declarative method guards from the patterns package enforce shape at the boundary; ThisType<>-shaped state makes encapsulation explicit; multi-facet kits express the common attenuator pattern (public read-only facet + admin write facet sharing state) cleanly. Replaces ad-hoc Far + closure patterns with a typed, introspectable surface.

## Why Exo?

Far objects are remotable but don't validate inputs.
Exos add automatic validation:

```javascript
import { Far } from '@endo/pass-style';
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';

// Far object - no validation
let count = 0;
const counter1 = Far('Counter', {
  increment(n) {
    count += n;  // What if n is not a number? undefined? a string?
    return count;
  }
});

// Exo - automatic validation
const CounterI = M.interface('Counter', {
  increment: M.call(M.number()).returns(M.number())
});

const counter2 = makeExo('Counter', CounterI, {
  increment(n) {
    count += n;  // n is guaranteed to be a number by the guard
    return count;
  }
});

counter2.increment(5);      // OK
counter2.increment('5');    // throws: Must be a number
```

The InterfaceGuard validates arguments **before** the method executes,
catching errors at the boundary rather than deep in your logic.


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
