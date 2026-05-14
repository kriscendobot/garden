---
title: Type Guards
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

> Abstract: TypeScript type guards exported by the package: assertPassable, assertPureData, isPureData, etc. The pure-data variants are stricter than passable: they exclude remotables and promises (only pure values, no capability identity). Useful in serializers and predicate contexts where capability semantics would be wrong.

## Type Guards

The package provides type guards for common pass styles:

```javascript
import {
  isRecord, assertRecord,
  isCopyArray, assertCopyArray,
  isRemotable, assertRemotable,
  isAtom, assertAtom
} from '@endo/pass-style';

// Boolean checks
if (isRecord(value)) {
  // value is a CopyRecord
}

// Assertions (throw if false)
assertRemotable(obj);
// obj is guaranteed to be a remotable
```


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
