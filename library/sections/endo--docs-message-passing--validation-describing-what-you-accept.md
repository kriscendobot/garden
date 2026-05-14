---
title: Validation: Describing What You Accept
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns, marshal]
status: current
---

> Abstract: How patterns lets a receiver describe the shape of expected inputs. Covers the M.* namespace at a tutorial pace: primitive matchers, container matchers, interface guards. The defensive-programming layer between marshal's transport and the application's logic.

## Validation: Describing What You Accept

Now we can pass objects between vats, but how do we ensure received data is
well-formed?
The **@endo/patterns** package provides pattern matching to validate passable
data and describe behavioral contracts.

### The M Namespace

The `M` namespace offers matchers for all pass styles:

```javascript
import { M, matches, mustMatch } from '@endo/patterns';

// Primitive matchers
M.any();         // Matches any passable
M.number();      // Matches any number
M.string();      // Matches any string
M.boolean();     // Matches any boolean

// Constrained matchers
M.gte(0);        // Matches numbers >= 0
M.string({ maxSize: 100 });  // Matches strings up to 100 chars
M.nat();         // Matches non-negative bigints

// Container matchers
M.array();       // Matches any copyArray
M.record();      // Matches any copyRecord
M.arrayOf(M.number());  // Matches arrays of numbers only
M.recordOf(M.string(), M.number());  // Matches {string: number} records

// Logical operators
M.and(M.number(), M.gte(0));  // Matches non-negative numbers
M.or(M.string(), M.number());  // Matches strings or numbers
M.opt(M.string());  // Matches undefined or string (optional)
```

### Pattern Matching in Practice

The `matches()` function tests if a value matches a pattern:

```javascript
import { M, matches, mustMatch } from '@endo/patterns';

const pattern = M.and(M.number(), M.gte(0), M.lte(100));

matches(50, pattern);    // true
matches(-10, pattern);   // false
matches('50', pattern);  // false

// mustMatch() throws with a descriptive error
mustMatch(42, M.string());
// throws: "number 42 - Must be a string"
```

### Structured Pattern Matching

For more complex validation, `M.splitRecord()` allows you to specify required
properties, optional properties, and a pattern for any remaining properties:

```javascript
import { M, mustMatch } from '@endo/patterns';

// Define a pattern with required and optional properties
const UserPattern = M.splitRecord(
  { name: M.string() },                     // required properties
  { age: M.number(), email: M.string() },   // optional properties
  M.string()                                 // rest properties must be strings
);

// Valid: has required 'name'
const user1 = harden({ name: 'Alice' });
mustMatch(user1, UserPattern);  // passes

// Valid: has required and optional properties
const user2 = harden({ name: 'Bob', age: 30 });
mustMatch(user2, UserPattern);  // passes

// Valid: has required, optional, and extra properties
const user3 = harden({ name: 'Carol', age: 25, bio: 'Engineer' });
mustMatch(user3, UserPattern);  // passes (bio matches rest pattern)

// Invalid: missing required 'name'
const user4 = harden({ age: 30 });
mustMatch(user4, UserPattern);  // throws: missing required property 'name'

// Invalid: rest property is not a string
const user5 = harden({ name: 'Dave', score: 100 });
mustMatch(user5, UserPattern);  // throws: rest property 'score' must be string
```

This pattern is particularly useful for validating configuration objects,
method arguments, and data structures where you want to enforce required fields
while allowing optional extensions.

### Copy Collections

Patterns introduces three passable collection types built on `makeTagged()`:

#### CopySet

A set of unique Keys (primitives or remotables):

```javascript
import { makeCopySet } from '@endo/patterns';

const colors = makeCopySet(['red', 'blue', 'green']);
// Elements are sorted and deduplicated
// Can contain strings, numbers, remotables, etc.

// Pattern for sets
const ColorSet = M.setOf(M.string());
mustMatch(colors, ColorSet);  // passes
```

#### CopyBag

A multiset (elements with counts):

```javascript
import { makeCopyBag } from '@endo/patterns';

const inventory = makeCopyBag([
  ['apples', 5n],
  ['oranges', 3n]
]);

const InventoryPattern = M.bagOf(M.string(), M.bigint());
mustMatch(inventory, InventoryPattern);
```

#### CopyMap

A map from Keys to passable values:

```javascript
import { makeCopyMap } from '@endo/patterns';

// Map user IDs to balances
const balances = makeCopyMap([
  ['alice', 100],
  ['bob', 50]
]);

const BalancesPattern = M.mapOf(M.string(), M.number());
mustMatch(balances, BalancesPattern);
```

**Why not use plain objects or arrays?**
CopyMap/CopySet/CopyBag support efficient key comparison using `compareKeys()`,
enable partial ordering for subset relationships, and are explicitly designed
as passable data structures.

### Interface Guards: The Bridge to Exo

Patterns can also describe behavioral contracts through `InterfaceGuards`:

```javascript
import { M } from '@endo/patterns';

const CounterI = M.interface('Counter', {
  // Method signature: call with number, returns number
  increment: M.call(M.number()).returns(M.number()),

  // Method with no arguments
  getValue: M.call().returns(M.number()),

  // Method with optional arguments
  reset: M.call().optional(M.number()).returns()
});
```

This describes a contract: the Counter interface has three methods with
specific argument and return types.
But how do we enforce this contract automatically?

**Key Insight**: Patterns describe what we expect, but don't enforce it by
themselves.
We need a way to wrap objects so they validate inputs against patterns before
executing methods.
Enter **exo**.


Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
