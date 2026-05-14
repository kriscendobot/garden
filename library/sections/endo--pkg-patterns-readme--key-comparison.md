---
title: Key Comparison
source: packages/patterns/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns]
status: current
---

> Abstract: keyEQ(key1, key2) compares two keys for equality; compareKeys(key1, key2) returns -1/0/+1 for a total order on keys. Used by Copy Collections to maintain consistent iteration order across realms. Both honor the key, pattern, and passable hierarchy (a key is a pattern with no holes; a passable is a key if it has a total order).

## Key Comparison

Keys can be compared for equality and ordering:

### keyEQ(key1, key2)

Tests if two Keys are equal using distributed equality semantics:

```javascript
import { keyEQ } from '@endo/patterns';

keyEQ('hello', 'hello');        // true
keyEQ(42, 42);                  // true
keyEQ([1, 2], [1, 2]);          // true (compares content)

const r1 = Far('Obj', {});
const r2 = Far('Obj', {});
keyEQ(r1, r1);                  // true (same remotable)
keyEQ(r1, r2);                  // false (different remotables)
```

### compareKeys(key1, key2)

Returns a comparison result implementing a **partial order**:
- `0`: Keys are equal
- `-1`: key1 < key2
- `1`: key1 > key2
- `NaN`: Keys are incomparable

```javascript
import { compareKeys, keyLT, keyGT } from '@endo/patterns';

compareKeys('a', 'b');          // -1
compareKeys(5, 5);              // 0
compareKeys(10, 3);             // 1

// Convenience functions
keyLT('a', 'b');                // true
keyGT(10, 3);                   // true

// Incomparable keys
const r1 = Far('A', {});
const r2 = Far('B', {});
compareKeys(r1, r2);            // NaN (different remotables)
```

**Why partial order?**
Not all Keys can be compared.
For example, different remotables have no defined ordering, and CopySets use
subset relationships.


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
