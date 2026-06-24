---
title: isPassable(value)
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

> Abstract: Non-throwing variant of passStyleOf: returns true if the value would be classified as passable, false otherwise. Used in defensive contexts (input validation, fast paths) where the caller does not want to wrap passStyleOf in a try/catch.

### isPassable(value)

Boolean test for passability.
Returns `true` if the value is passable, `false` otherwise.

```javascript
import { isPassable } from '@endo/pass-style';

isPassable(42);                // true
isPassable(harden([1, 2]));    // true
isPassable({ x: 1 });          // false - not frozen
isPassable(harden({ x: 1 }));  // true
```

Use `isPassable()` when you want a boolean result.
Use `passStyleOf()` when you need the specific pass style or want detailed
error messages.


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
