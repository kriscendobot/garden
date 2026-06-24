---
title: makeTagged(tag, payload)
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

> Abstract: Constructs a tagged value: a hardened pair of (tag, payload) where tag is a string and payload is any passable. Used for application-defined virtual data types (CopySet, CopyMap, etc.) that marshal serializes as composites. Distinct from raw copyRecord because the tag is metadata about how to interpret the payload.

### makeTagged(tag, payload)

Creates a CopyTagged object, the extension point for domain-specific data
types.

```javascript
import { makeTagged } from '@endo/pass-style';

const tagged = makeTagged('customType', { data: 42 });
passStyleOf(tagged);  // 'tagged'
```

Tagged objects are used internally by [@endo/patterns](../patterns/README.md)
to implement CopySet, CopyBag, and CopyMap.


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
