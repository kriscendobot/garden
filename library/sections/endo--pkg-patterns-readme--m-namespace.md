---
title: The M Namespace
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

> Abstract: The M namespace enumerates the pattern constructors: Primitive Matchers (M.string, M.number, M.bigint, etc.), Container Matchers (M.array, M.record, M.set, etc.), Structured Matchers (M.recordOf, M.arrayOf, etc.), Logical Operators (M.and, M.or, M.not), Comparison Matchers (M.gte, M.lt, etc.), and Special Matchers (M.remotable, M.promise, M.any). Each section enumerates the constructors with brief signatures and use cases.

## The M Namespace

The `M` object provides methods for creating pattern matchers organized into
several categories:

### Primitive Matchers

Match specific JavaScript types:

```javascript
M.any()           // Matches any passable
M.undefined()     // Matches undefined
M.null()          // Matches null
M.boolean()       // Matches true or false
M.number()        // Matches any number (including NaN, Infinity)
M.bigint()        // Matches any bigint
M.string()        // Matches any string
M.symbol()        // Matches registered/well-known symbols

// Constrained primitives
M.nat()           // Non-negative bigint
M.gte(5)          // Number >= 5
M.lte(100)        // Number <= 100
```

### Container Matchers

Match copyArray, copyRecord, and other structures:

```javascript
M.array()         // Any CopyArray
M.record()        // Any CopyRecord
M.set()           // Any CopySet
M.bag()           // Any CopyBag
M.map()           // Any CopyMap

// With constraints
M.array({ maxSize: 10 })          // Array with at most 10 elements
M.string({ maxSize: 100 })        // String with at most 100 characters

// Structured content
M.arrayOf(M.number())             // Array of numbers only
M.recordOf(M.string(), M.number()) // Record with string keys, number values
M.setOf(M.string())               // Set of strings only
```

### Structured Matchers

Match specific shapes:

```javascript
// Split patterns: required, optional, rest
M.splitArray(
  [M.string(), M.number()],      // required elements
  [M.boolean()],                  // optional elements
  M.any()                         // rest elements
)

M.splitRecord(
  { name: M.string() },           // required properties
  { age: M.number() },            // optional properties
  M.any()                         // rest properties
)

// Partial matches
M.partial({ name: M.string() })  // Has at least 'name' property

// Split auto-detects array vs record
M.split({ x: M.number() }, M.any())
```

### Logical Operators

Combine matchers:

```javascript
M.and(M.number(), M.gte(0), M.lte(100))   // 0 <= n <= 100
M.or(M.string(), M.number())               // String or number
M.not(M.undefined())                       // Anything except undefined
M.opt(M.string())                          // undefined or string (optional)
```

### Comparison Matchers

Match values relative to a key:

```javascript
M.eq('hello')     // Equal to 'hello'
M.neq(0)          // Not equal to 0
M.lt(10)          // Less than 10
M.lte(100)        // Less than or equal to 100
M.gte(0)          // Greater than or equal to 0
M.gt(-1)          // Greater than -1
```

### Special Matchers

```javascript
M.remotable()           // Any remotable object
M.remotable('Counter')  // Remotable with specific label
M.error()               // Any error
M.promise()             // Any promise
M.eref(M.number())      // Number or promise for number (eventual reference)
M.kind('copyArray')     // Specific pass style
M.pattern()             // Any valid pattern
M.key()                 // Any valid Key
M.scalar()              // Any primitive or remotable
```


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
