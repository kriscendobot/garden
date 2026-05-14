---
title: Pass Styles
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

> Abstract: The complete enumeration of pass styles. Primitive styles (string, number, bigint, boolean, undefined, null, symbol) match their JS counterparts with restrictions (symbols must be well-known or registered). Container styles (copyArray, copyRecord, tagged) compose other passable values. Special styles: error (the only mutable-state-bearing pass-by-copy type), promise (pass-by-presence in concept; resolves to its eventual value), remotable (pass-by-presence for capability-bearing objects).

## Pass Styles

| Pass Style | Category | Description | Examples |
|------------|----------|-------------|----------|
| `'null'` | Primitive | The null value | `null` |
| `'undefined'` | Primitive | The undefined value | `undefined` |
| `'boolean'` | Primitive | Boolean primitives | `true`, `false` |
| `'number'` | Primitive | IEEE 754 floats | `42`, `3.14`, `NaN`, `Infinity` |
| `'bigint'` | Primitive | Arbitrary-precision integers | `123n`, `-456n` |
| `'string'` | Primitive | Well-formed strings | `'hello'`, `''` |
| `'symbol'` | Primitive | Registered/well-known symbols | `Symbol.iterator` |
| `'copyArray'` | Pass-by-copy | Frozen arrays of passables | `harden([1, 2, 3])` |
| `'copyRecord'` | Pass-by-copy | Frozen plain objects | `harden({ x: 10 })` |
| `'remotable'` | Pass-by-presence | Far objects & remote presences | `Far('Counter', {...})` |
| `'tagged'` | Extension | Domain-specific types | `makeTagged('copySet', [...])` |
| `'error'` | Pass-by-presence | Error objects | `harden(Error('failed'))` |
| `'promise'` | Pass-by-presence | Promise objects | `Promise.resolve(42)` |


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
