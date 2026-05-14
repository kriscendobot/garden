---
title: Using SES with your code
source: docs/reference.md
source_repo: endojs/endo
source_commit: bffadcab8a39be8529406b22574e25cf64dec755
source_date: 2026-04-26
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, getting-started]
status: current
---

> Abstract: How to add SES to an existing JS project: install the @endo/lockdown package, call lockdown() once at program start before any other module loads, then proceed normally. Covers package-import vs bundler-shim choices, plus pitfalls (lockdown before Date/Math touches, no Compartment creation before lockdown).

## Using SES with your code

The SES shim transforms ordinary JavaScript environments into HardenedJS environments.

On Node.js you can import or require `ses` in either CommonJS or ECMAScript
modules, then call `lockdown()`. This is a *shim*. It mutates the environment
in place so any code running after the shim can assume it’s running in a
HardenedJS environment. This includes the globals `lockdown()`, `harden()`,
`Compartment`, and so on. For example:

```js
require("ses");
lockdown();
```

Or:

```js
import 'ses';
lockdown();
```

To ensure a module runs in a HardenedJS environment, wrap the above code in a
`ses-lockdown.js` module and import it:

```js
import './non-ses-code-before-lockdown.js';
import './ses-lockdown.js'; // calls lockdown.
import './ses-code-after-lockdown.js';
```

The Endo project includes packages that do just this:
- `@endo/lockdown` calls lockdown and threads certain environment options.
- `@endo/init` also sets up [eventual
  send](../packages/eventual-send/README.md) and a more completed Endo
  environment.

To use SES as a script on the web, use the UMD build.

```js
<script src="node_modules/ses/dist/ses.umd.min.js">
```

To run shims after `ses` repairs the intrinsics but before `ses` hardens the
intrinsics, calling `lockdown(options)` is equivalent to running
`repairIntrinsics(options)` then `hardenIntrinsics()` and vetted shims can run
in between.

```js
import './non-ses-code-before-lockdown.js';
import './ses-repair-intrinsics.js'; // calls repairIntrinsics.
import './vetted-shim.js';
import './ses-harden-intrinsics.js'; // calls hardenIntrinsics.
import './ses-code-after-lockdown.js';
```

SES is vulnerable to any code that runs before hardening intrinsics.
All such code, including vetted shims, must receive careful review to ensure it
preserves the invariants of the OCap security model.


Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md) at commit `bffadcab`.
