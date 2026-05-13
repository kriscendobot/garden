---
title: domainTaming Options
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

> Abstract: Controls Node.js's deprecated domain module. Default: safe (remove the domain mechanism). Unsafe: leave in place.

## `domainTaming` Options

The deprecated Node.js `domain` module adds `domain` properties to callbacks
and promises.
These `domain` properties allow communication between client programs that
`lockdown` otherwise isolates.

To disable this safety feature, call `lockdown` with `domainTaming` set to
`'unsafe'` explicitly.

```js
lockdown(); // domainTaming defaults to 'safe'
// or
lockdown({ domainTaming: 'safe' }); // bans the unsafe Node.js `domain` module
// vs
lockdown({ domainTaming: 'unsafe' }); // allows the unsafe `domain` module
```

The `domainTaming` option, when set to `'safe'`, protects programs
by detecting whether the `'domain'` module has been initialized, and by laying
a trap that prevents it from initializing later.

The `domain` module adds a `domain` object to the `process` global object,
so it's possible to detect without consulting the module system.
Defining a non-configurable `domain` property on the `process` object
causes any later attempt to initialize domains to fail loudly.

Unfortunately, some modules ultimately depend on the `domain` module,
even when they do not actively use its features.
To run multi-tenant applications safely, these dependencies must be carefully
fixed or avoided.


Source: [docs/lockdown.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/lockdown.md) at commit `fe81477b`.
