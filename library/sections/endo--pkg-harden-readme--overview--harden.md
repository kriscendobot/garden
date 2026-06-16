---
title: harden
source: packages/harden/README.md
source_repo: endojs/endo
source_commit: 20a61e3d
source_date: 2025-10-10
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
parent: endo--pkg-harden-readme--overview
---

Hardened modules are modules that make their interface resist tampering by
other modules that import them, making them less susceptible to supply chain
attack.
This includes hardening the exports and also the values they return or pass.
In [HardenedJS](https://hardenedjs.org), the global `harden` function
transitively freezes an object and all of the objects that are reachable by
walking chains of properties and prototypes.
All the primordials like `Array.prototype` and `Object` are frozen in
this environment, which gives your module a place to stand toward its own
defense.
Then, with [LavaMoat](https://github.com/lavamoat/lavamoat), each package
is credibly isolated and only receives the subset of globals and host modules
it needs to function.
That is, we can enforce [Principle of Least
Authority](https://en.wikipedia.org/wiki/Principle_of_least_privilege).
But, that leaves the module to use `harden` to freeze all its exports and
anything it returns that might be shared by other packages that use it.

In order to provide type information about the global `harden` in locked-down
HardenedJS, and also to make it possible for hardened modules to be used
outside HardenedJS, the `@endo/harden` package exports a `harden` function that
can be used either way.

```js
import { harden } from '@endo/harden';

export const myFunction = () => {};
harden(myFunction);
```

By avoiding the export of hoisted `function` and `var` declarations and by
immediately calling `harden` on any exposed function (or prototype thereof!) we
leave no window of opportunity for another module to alter our exports.
If a function's return value is meant to be shared by multiple parties (such
as memoized objects), a hardened module author should harden the value before
the function returns it (`return harden(value);`).

Source: [packages/harden/README.md](https://github.com/endojs/endo/blob/20a61e3d/packages/harden/README.md) at commit `20a61e3d`.
