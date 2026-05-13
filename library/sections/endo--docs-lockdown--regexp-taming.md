---
title: regExpTaming Options
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

> Abstract: Controls RegExp.prototype.compile (which can violate frozen-instance invariants and corrupt Proxy guarantees). Safe (default): delete the method. Unsafe: preserve for compatibility at the price of some risk. Legacy RegExp static methods (RegExp.lastMatch and friends) are removed under all settings because they are an unsafe global overt-communications channel.

## `regExpTaming` Options

**Background**: In standard plain JavaScript, the builtin
`RegExp.prototype.compile` method may violate the object invariants of frozen
`RegExp` instances. This violates assumptions elsewhere, and so can be
used to corrupt other guarantees. For example, the JavaScript `Proxy`
abstraction preserves the object invariants only if its target does. It was
designed under the assumption that these invariants are never broken. If a
non-conforming object is available, it can be used to construct a proxy
object that is also non-conforming.

```js
lockdown(); // regExpTaming defaults to 'safe'
// or
lockdown({ regExpTaming: 'safe' }); // Delete RegExp.prototype.compile
// vs
lockdown({ regExpTaming: 'unsafe' }); // Preserve RegExp.prototype.compile
```

If `lockdown` does not receive a `regExpTaming` option, it will respect
`process.env.LOCKDOWN_REGEXP_TAMING`.

```console
LOCKDOWN_REGEXP_TAMING=safe
LOCKDOWN_REGEXP_TAMING=unsafe
```

The `regExpTaming` default `'safe'` setting deletes this dangerous method. The
`'unafe'` setting preserves it for maximal compatibility at the price of some
risk.

**Background**: In de facto plain JavaScript, the legacy `RegExp` static
methods like `RegExp.lastMatch` are an unsafe global
[overt communications channel](https://papers.agoric.com/taxonomy-of-security-issues/).
They reveal on the `RegExp` constructor information derived from the last match
made by any `RegExp` instance&mdash;a bizarre form of non-local causality.
These static methods are currently part of de facto
JavaScript but not yet part of the standard. The
[Legacy RegExp static methods](https://github.com/tc39/proposal-regexp-legacy-features)
proposal would standardize them as *normative optional* and deletable, meaning
   * A conforming JavaScript engine may omit them
   * A shim may delete them and have the resulting state still conform
     to the specification of an initial JavaScript state.

All these legacy `RegExp` static methods are currently removed under all
settings of the `regExpTaming` option.
So far this has not caused any compatibility problems.
If it does, then we may decide to support them, but *only* under the
`'unsafe'` setting and *only* on the `RegExp`  constructor of the start
compartment. The `RegExp` constructor shared by other compartments will remain
safe and powerless.


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
