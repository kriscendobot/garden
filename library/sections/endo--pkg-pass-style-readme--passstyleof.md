---
title: passStyleOf(value)
source: packages/pass-style/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
---

> Abstract: Returns the pass-style of the input value as a string (one of the enumerated styles). Throws if the value is not passable (e.g., a non-hardened object, a non-Far'd remotable, a non-well-known symbol). The primary discriminator any marshal-adjacent code uses.

## Core Functions

### passStyleOf(value)

Classifies a value's pass style.
Throws if the value is not passable.

```javascript
import { passStyleOf } from '@endo/pass-style';

passStyleOf(42);                    // 'number'
passStyleOf(harden([1, 2]));        // 'copyArray'
passStyleOf(harden({ x: 1 }));      // 'copyRecord'
passStyleOf(Promise.resolve());     // 'promise'

// Throws for non-passable values
passStyleOf({ x: 1 });  // Error: not frozen
```


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
