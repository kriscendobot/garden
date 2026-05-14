---
title: Passable Values
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

> Abstract: Enumerates which JS values are passable: primitives (with the symbol restrictions), frozen empty objects, hardened copyArrays, hardened copyRecords, hardened taggeds, frozen errors (with restricted property sets), Far-built remotables, and promises. Non-passable: unfrozen objects, regular functions, exotic objects, host objects, weakly-rooted references.

## Passable Values

A value is passable if it meets these requirements:

1. **Primitives** are always passable (except unregistered symbols)
2. **Objects must be frozen** via `harden()` from `@endo/pass-style` or `ses`
3. **No cyclic references** in pass-by-copy structures (copyArray, copyRecord,
   tagged)
4. **Strings must be well-formed** (no unpaired surrogates)
5. **Symbols must tentatively be created using `passableSymbolForName()`** from
   `@endo/pass-style`.

```javascript
// Passable - frozen array of primitives
const data = harden([1, 2, 3]);

// NOT passable - not frozen
const mutable = [1, 2, 3];

// NOT passable - cyclic reference
const cyclic = harden([]);
cyclic.push(cyclic);
```


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
