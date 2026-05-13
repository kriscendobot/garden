---
title: localeTaming Options
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

> Abstract: Controls locale-sensitive primordial methods (toLocaleString, toLocaleLowerCase, localeCompare, etc.). Safe (default): alias to non-locale equivalents (eliminates fingerprinting and live locale-change non-determinism). Unsafe: preserve original locale-dependent behavior for compatibility.

## `localeTaming` Options

**Background**: In standard plain JavaScript, the builtin methods with
 "`Locale`" or "`locale`" in their name&mdash;`toLocaleString`,
`toLocaleDateString`, `toLocaleTimeString`, `toLocaleLowerCase`,
`toLocaleUpperCase`, and `localeCompare`&mdash;have a global behavior that is
not fully determined by the language spec, but rather varies with location and
culture, which is their point. However, by placing this information of shared
primordial prototypes, it cannot differ per comparment, and so one compartment
cannot virtualize the locale for code running in another compartment. Worse, on
some engines the behavior of these methods may change at runtime as the machine
is "moved" between different locales,
i.e., if the operating system's locale is reconfigured while JavaScript
code is running.

```js
lockdown(); // localeTaming defaults to 'safe'
// or
lockdown({ localeTaming: 'safe' }); // Alias toLocaleString to toString, etc
// vs
lockdown({ localeTaming: 'unsafe' }); // Allow locale-specific behavior
```

If `lockdown` does not receive a `localeTaming` option, it will respect
`process.env.LOCKDOWN_LOCALE_TAMING`.

```console
LOCKDOWN_LOCALE_TAMING=safe
LOCKDOWN_LOCALE_TAMING=unsafe
```

The `localeTaming` default `'safe'` option replaces each of these methods with
the corresponding non-locale-specific method. `Object.prototype.toLocaleString`
becomes just another name for `Object.prototype.toString`. The `'unsafe'`
setting preserves the original behavior for maximal compatibility at the price
of reproducibility and fingerprinting. Aside from fingerprinting, the risk that
this slow non-determinism opens a
[communications channel](https://agoric.com/taxonomy-of-security-issues/)
is negligible.


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
