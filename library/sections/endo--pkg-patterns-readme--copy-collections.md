---
title: Copy Collections
source: packages/patterns/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns, pass-style]
status: current
---

> Abstract: Three passable collection types beyond plain copyArray/copyRecord: CopySet (unordered set of keys), CopyBag (multiset; keys with counts), CopyMap (key-to-value mapping). Each is a tagged value (see makeTagged from pass-style) and patterns provides M.set(), M.bag(), M.map() constructors plus comparison and iteration helpers. Used when applications need richer-than-array structure with consistent ordering across realms.

## Copy Collections

Patterns introduces three passable collection types built on `makeTagged()`:

### CopySet

A set of unique Keys (primitives or remotables):

```javascript
import { makeCopySet } from '@endo/patterns';

const colors = makeCopySet(['red', 'blue', 'green']);

// Elements are sorted in rank order
// Duplicates are removed
// Can be passed between vats

// Pattern for sets
const ColorSet = M.setOf(M.string());
mustMatch(colors, ColorSet);  // passes
```

**Why not use JavaScript Set?**
JavaScript Sets aren't passable.
CopySet is frozen, comparable via `keyEQ`, and can be efficiently serialized.

### CopyBag

A multiset (elements with counts):

```javascript
import { makeCopyBag } from '@endo/patterns';

const inventory = makeCopyBag([
  ['apples', 5n],
  ['oranges', 3n],
  ['apples', 2n]   // counts are combined
]);

// Result: [['apples', 7n], ['oranges', 3n]]

const InventoryPattern = M.bagOf(M.string(), M.bigint());
mustMatch(inventory, InventoryPattern);
```

### CopyMap

A map from Keys to Passable values:

```javascript
import { makeCopyMap } from '@endo/patterns';

const balances = makeCopyMap([
  ['alice', 100],
  ['bob', 50]
]);

// Keys are sorted in rank order
// Can use any Key as a key (not just strings!)

const remotableKey = Far('Key', {});
const map = makeCopyMap([[remotableKey, 'value']]);

const BalancesPattern = M.mapOf(M.string(), M.number());
mustMatch(balances, BalancesPattern);
```

**Why not use plain objects?**
CopyMap supports:
- Any Key as a key (objects, remotables, not just strings)
- Efficient key comparison using `compareKeys()`
- Subset relationships for partial ordering


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
