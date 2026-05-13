---
title: legacyRegeneratorRuntimeTaming Options
source: docs/lockdown.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: Controls regenerator-runtime (Babel's transpiler output for generator functions). Default: safe (apply the taming). Option: unsafe-ignore (skip the taming, accepting the resulting attack surface).

## `legacyRegeneratorRuntimeTaming` Options

`regenerator-runtime` is a widely used package in the ecosystem.
It is used to support generators and async functions transpiled to ES5.

The option `legacyRegeneratorRuntimeTaming` is to fix `regenerator-runtime`
from 0.10.5 to 0.13.7.

The `legacyRegeneratorRuntimeTaming` option, when set to `'safe'`, it does nothing.

When set to `'unsafe-ignore'`, it converts `Iterator.prototype[Symbol.iterator]` to
a getter/setter that ignores all assignments to it.

```js
lockdown(); // legacyRegeneratorRuntimeTaming defaults to 'safe'
// or
lockdown({ legacyRegeneratorRuntimeTaming: 'safe' }); // do nothing
// vs
lockdown({ legacyRegeneratorRuntimeTaming: 'unsafe-ignore' }); // try fix compatibility with regenerator-runtime
Iterator.prototype[Symbol.iterator] = function() { return this } // this assignment fails without throwing with unsafe-ignore
```


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
