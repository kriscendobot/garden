---
title: Pass-by-Copy vs Pass-by-Presence
source: packages/pass-style/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal, capability-security]
status: current
---

> Abstract: The high-level distinction marshal enforces. Pass-by-copy (copyArray, copyRecord, tagged, primitives, errors): contents serialize and the receiver reconstructs an equivalent value. Pass-by-presence (remotable, promise): only an identity reference crosses; the receiver gets a proxy that forwards method calls back to the sender. The choice determines whether the value preserves identity across the boundary or only data.

## Pass-by-Copy vs Pass-by-Presence

### Pass-by-Copy

The value itself is copied when passed.
Changes to the original don't affect copies.

**Use for:** Immutable data, configurations, messages, small structures

**Pass styles:** primitives, copyArray, copyRecord, tagged

```javascript
const config = harden({
  timeout: 5000,
  retries: 3
});

// When passed, config is copied
// The recipient gets a separate copy
```

### Pass-by-reference

A reference is passed.
The object remains in its original location.

**Use for:** Objects with behavior, mutable state, capabilities, large objects

**Pass styles:** remotable, promise, error

```javascript
const service = Far('Service', {
  getData() { return data; }
});

// When passed, only a reference is passed
// Method calls are forwarded to the original object
```


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
