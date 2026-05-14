---
title: ModuleSource (overview)
source: packages/module-source/README.md
source_repo: endojs/endo
source_commit: 53e5109e
source_date: 2024-05-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments]
status: current
---

> Abstract: @endo/module-source provides the ModuleSource constructor: a representation of a JavaScript module's source for use in Compartments. Used by compartment-mapper and import-bundle when assembling module graphs.

# ModuleSource

This package provides a ponyfill for the `ModuleSource` constructor, suitable
for use in the SES shim's module descriptors.
The module source accepts a JavaScript module and converts it into
a form that SES can use to emulate and confine JavaScript modules (ESMs, the
`mjs` file format) with compartments.

```js
import 'ses';
import { ModuleSource } from '@endo/module-source';

const c1 = new Compartment({}, {}, {
  name: "first compartment",
  resolveHook: (moduleSpecifier, moduleReferrer) => {
    return resolve(moduleSpecifier, moduleReferrer);
  },
  importHook: async moduleSpecifier => {
    const moduleLocation = locate(moduleSpecifier);
    const moduleText = await retrieve(moduleLocation);
    return new ModuleSource(moduleText, moduleLocation);
  },
});
```


Source: [packages/module-source/README.md](https://github.com/endojs/endo/blob/53e5109e/packages/module-source/README.md) at commit `53e5109e`.
