---
title: Pattern Matching
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

> Abstract: Two functions for applying patterns: matches(specimen, pattern) returns boolean (non-throwing); mustMatch(specimen, pattern, label?) throws with a useful diagnostic message on failure. Use matches() in fast-path predicates; use mustMatch() at boundaries where failure should propagate as an error with context.

## Pattern Matching

### matches(specimen, pattern)

Returns `true` if the specimen matches the pattern, `false` otherwise:

```javascript
import { M, matches } from '@endo/patterns';

matches(42, M.number());                    // true
matches('hello', M.number());               // false
matches([1, 2, 3], M.arrayOf(M.number())); // true
```

### mustMatch(specimen, pattern, label?)

Throws with a descriptive error if the specimen doesn't match:

```javascript
import { mustMatch } from '@endo/patterns';

mustMatch(42, M.string());
// throws: "number 42 - Must be a string"

mustMatch(-5, M.and(M.number(), M.gte(0)), 'count');
// throws: "count: number -5 - Must be >= 0"
```

The error messages are designed to help you understand exactly what was wrong
with the data.


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
