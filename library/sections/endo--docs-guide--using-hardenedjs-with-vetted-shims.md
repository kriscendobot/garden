---
title: Using HardenedJS with vetted shims
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, tooling]
status: current
---

> Abstract: How to use HardenedJS in environments where the SES shim cannot run directly (older bundlers, browsers without ES2020+, or constrained sandboxes). Covers the vetted-shim pattern: a pre-locked-down JS bundle that consumers can use without calling lockdown() themselves. Distinct from the standard install path.

## Using HardenedJS with vetted shims

Some modules depend on language features that may not be present in the
underlying platform.
Some of these shims will compose poorly with `lockdown()`.
Lockdown will remove any property it finds on a shared intrinsic (like
`Array.prototype`) that it does not recognize and then freeze all the shared
intrinsics and all the objects transitively reachable through own properties
and prototypes.

So, if a shim adds `Array.prototype.collate`, running that shim before calling
`lockdown()` will have no net effect and running this shim after calling
`lockdown()` will throw an exception when attempting to assign or define that
property.

Lockdown consists of two phases: Repair Intrinsics and Harden Intrinsics.
A shim can run between these phases and its effects will persist.
The following programs are equivalent:

```js
lockdown(options);
```

And,

```js
repairIntrinsics(options);
hardenIntrinsics();
```

And, an application that choses to call these also has the option of running
shims between the two phases.

```js
import './non-ses-code-before-lockdown.js';
import './ses-repair-intrinsics.js'; // calls repairIntrinsics.
import './vetted-shim.js';
import './ses-harden-intrinsics.js'; // calls hardenIntrinsics.
import './ses-code-after-lockdown.js';
```

However, any such shim must preserve the qualities of Lockdown:
all reachable objects in an empty compartment must be hardened and must not
provide a way for isolated parties to communicate.
So, application authors are responsible for ensuring these shims maintain their
application’s integrity invariants.


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
