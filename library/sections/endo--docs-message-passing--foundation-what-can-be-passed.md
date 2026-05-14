---
title: Foundation: What Can Be Passed?
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
---

> Abstract: Establishes the pass-style classification at a tutorial level: what types of values cross a message boundary, the pass-by-copy vs pass-by-presence distinction, and how marshal serializes each kind. The foundational read for understanding what messages can carry.

## Foundation: What Can Be Passed?

Before we can send messages between isolated compartments, we need to
understand what data can safely cross boundaries.
The **@endo/pass-style** package defines the `Passable` type and classifies
values according to their `PassStyle`.

**What is a vat?**
Throughout this guide, we use the term **vat** to refer to an isolated unit of
computation—an idealization of a worker, in the same sense as a Turing Machine
as an idealization of computation.
A vat has its own heap, stack, and event queue.
It communicates with other vats exclusively through asynchronous message
passing, with no shared memory concurrency.
Events run serially to completion: each event begins with an empty stack and a
guarantee that no other code that shares mutable state will be interleaved
during its execution.
This model achieves parallelism through multiple vats and achieves performance
by transferring ownership of memory (such as ArrayBuffers) between vats when
necessary.
Otherwise, this model abandons some opportunities to improve performance and,
in exchange, obviates any possiblity of deadlock, even in composition of many,
independently designed compoennts, utterly unaware of each other's
synchronization models.
This is the linchpin of fearless cooperation among components in a
loosely-coordinated, distributed, multi-agent system, which is to say, any
system at sufficient scale.

### The Pass Styles Taxonomy

Every passable value falls into one of eight categories:

| Pass Style | Description | Examples |
|------------|-------------|----------|
| `'null'` | The null value | `null` |
| `'undefined'` | The undefined value | `undefined` |
| `'boolean'` | Boolean primitives | `true`, `false` |
| `'number'` | IEEE 754 floats | `42`, `3.14`, `NaN`, `Infinity` |
| `'bigint'` | Arbitrary integers | `123n`, `-456n` |
| `'string'` | Well-formed strings | `'hello'`, `''` |
| `'symbol'` | Registered/well-known symbols | `Symbol.iterator` |
| `'copyArray'` | Frozen arrays of passables | `harden([1, 2, 3])` |
| `'copyRecord'` | Frozen plain objects | `harden({ x: 10 })` |
| `'remotable'` | Far objects & presences | `Far('Counter', {...})` |
| `'tagged'` | Extension point for domain types | `makeTagged('copySet', [...])` |
| `'error'` | Error objects | `harden(Error('failed'))` |
| `'promise'` | Promise objects | `Promise.resolve(42)` |

The key distinction is between **pass-by-copy** (the value itself is copied)
and **pass-by-reference**:

- **Pass-by-copy**: Primitives, copyArray, copyRecord, tagged.
- **Pass-by-reference**: Remotables, promises

### Core Functions

The `@endo/pass-style` package provides core functions for inspecting
the pass-style of a value.

```javascript
import { passStyleOf, isPassable, Far, makeTagged, passableSymbolForName } from '@endo/pass-style';

// Classify a value's pass style
passStyleOf(42);  // 'number'
passStyleOf(harden([1, 2]));  // 'copyArray'
passStyleOf(Promise.resolve());  // 'promise'

// Check if a value is passable
isPassable({ x: 1 });  // false (not frozen)
isPassable(harden({ x: 1 }));  // true

// Create passable symbols
const mySymbol = passableSymbolForName('mySymbol');
passStyleOf(mySymbol);  // 'symbol'
```

It also provides a `Far` utility function for making "remotables", values that
can receive messages, which we use in this example to demonstrate
`passStyleOf`, but note that it provides no protection against invalid argument
patterns, which we will remedy with `makeExo` and type guards farther along.

```javascript
// Create a remotable object
const counter = Far('Counter', {
  increment(n) { return n + 1; },
  getValue() { return 42; }
});
passStyleOf(counter);  // 'remotable'
```

### What Makes Something Passable?

A value is passable if it meets these requirements:

1. **Primitives** are always passable
2. **Objects must be transitively frozen** via `harden()`
3. **No cyclic references** in pass-by-copy structures
4. **Strings and symbol names must be well-formed Unicode text** (no unpaired
   surrogates)
5. **Symbols must tentatively be created using `passableSymbolForName()`** from
   `@endo/pass-style`.

```javascript
// This is passable - frozen array of primitives
const data = harden([1, 2, 3]);

// This is NOT passable - not frozen
const mutable = [1, 2, 3];
passStyleOf(mutable);  // throws Error

// This is NOT passable - cyclic reference
const cyclic = harden([]);
cyclic.push(cyclic);
passStyleOf(cyclic);  // throws Error
```

### Creating Remotable Objects

The `Far()` function creates remotable objects that can be passed by reference:

```javascript
import { Far } from '@endo/pass-style';

const makeCounter = (initialValue = 0) => {
  let count = initialValue;

  return Far('Counter', {
    increment() {
      count += 1;
      return count;
    },
    getValue() {
      return count;
    }
  });
};

const counter = makeCounter(5);
// This counter is a remotable - it can be passed as a reference
// but its internal state (count) remains private
```

**Key Insight**: Far objects provide encapsulation and can be passed across
boundaries, but they don't validate their inputs.
If `increment()` expects a number but receives a string, it won't detect the
error until the method executes.
This is where patterns come in.


Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
