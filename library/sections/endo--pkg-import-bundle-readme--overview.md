---
title: import-bundle (overview)
source: packages/import-bundle/README.md
source_repo: endojs/endo
source_commit: 17ec018b
source_date: 2025-03-06
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments]
status: current
---

> Abstract: @endo/import-bundle is the runtime bundle-loader. Takes a bundle string (produced by @endo/bundle-source or @endo/compartment-mapper) and evaluates it into Compartments, returning the entry point's namespace.

# import-bundle

`importBundle` is an async function that evaluates the bundles created by
`bundle-source`, turning them back into callable functions:

```js
const bundle = await bundleSource('path/to/bundle.js');
// 'bundle' is JSON-serializable
const options = {}; // filePrefix, endowments, other compartment options
const namespace = await importBundle(bundle);
const { default, namedExport1, namedExport2 } = namespace;
```

This must be run in a SES environment: you must install SES before importing
`@endo/import-bundle`.
The conventional way to do this is to import a module (e.g. `@endo/init`) which
does `import 'ses'; lockdown();`.

The bundle will be loaded into a new Compartment, which does not have access to
platform globals like `document` or `Fetch` or `require`.
The bundle is isolated to only having access to powerless JavaScript facilities
and whatever endowments you provide.

Each call to `importBundle` creates a new `Compartment`.
The globals of the new Compartment are frozen before any bundle code is
evaluated, to enforce ocap rules.


Source: [packages/import-bundle/README.md](https://github.com/endojs/endo/blob/17ec018b/packages/import-bundle/README.md) at commit `17ec018b`.
