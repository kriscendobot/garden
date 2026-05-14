---
title: Using HardenedJS with your code
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, getting-started]
status: current
notes: Overlaps with endo--docs-reference--using-ses-with-your-code and endo--docs-get-started--installing. Different shapes (guide vs reference vs tutorial); kept as-is.
---

> Abstract: Practical onboarding for adding HardenedJS to a JS project. Overlaps with docs/reference.md's section of the same title and docs/get-started.md's installing/first-steps sections; this version is guide-shaped (more background, more explanation) where the others are reference-shaped or tutorial-shaped.

## Using HardenedJS with your code

The Lockdown function transforms ordinary JavaScript environments into Hardened
JavaScript environments.

On Node.js you can import or require `ses` in either CommonJS or ECMAScript
modules, then call `lockdown()`. This is a *shim*. It mutates the environment
in place so any code running after the shim can assume it’s running in a hardened
environment. This includes the globals `lockdown()`, `harden()`, `Compartment`,
and so on. For example:
```js
require("ses");
lockdown();
```
Or:
```js
import 'ses';
lockdown();
```

To ensure a module runs in a hardened environment, wrap the above code in a `ses-lockdown.js` module and import it:
```js
import './non-ses-code-before-lockdown.js';
import './ses-lockdown.js'; // calls lockdown.
import './ses-code-after-lockdown.js';
```
To use SES as a script on the web, use the UMD build.
```js
<script src="node_modules/ses/dist/ses.umd.min.js">
```


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
