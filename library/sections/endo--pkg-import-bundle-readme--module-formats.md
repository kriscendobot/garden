---
title: Module Formats (endoZipBase64, endoScript, getExport, nestedEvaluate, test)
source: packages/import-bundle/README.md
source_repo: endojs/endo
source_commit: 17ec018b
source_date: 2025-03-06
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles]
status: current
---

> Abstract: The 5 bundle formats import-bundle understands: endoZipBase64 (zip-encoded archive), endoScript (single-script encoding), getExport (legacy format), nestedEvaluate (Compartment-nested form), test (development helper). Each maps to a specific bundle-source output mode.

## Module Formats

The source can be bundled in a variety of "formats".

### endoZipBase64

By default, `bundleSource` uses a format named `endoZipBase64`, in which the
source modules and a "compartment map" are captured in a Zip file and base-64
encoded.
The compartment map describes how to construct a set of [Hardened
JavaScript](https://hardenedjs.org) compartments and how to load and link the
source modules between them.

### endoScript

The `endoScript` format captures the sources as a single JavaScript program
that completes with the entry module's namespace object.

### getExport

The `getExport` format captures the sources as a single CommonJS-style string,
and wrapped in a callable function that provides the `exports` and
`module.exports` context to which the exports can be attached.

### nestedEvaluate

More sophisticated than `getExport` is named `nestedEvaluate`.
In this mode, the source tree is converted into a table of evaluable strings,
one for each original module.
This table is then encoded and wrapped as before.
The evaluation process uses a separate evaluator call for each module,
providing an opportunity to attach a distinct `sourceMap` to each one.
This preserves relative filenames in subsequent debugging information and stack
traces.

To set a base prefix for these relative filenames, provide the `filePrefix`
option.

Note that the `nestedEvaluate` format receives a global endowment named
`require`, although it will only be called if the source tree imported one of
the few modules on the `bundle-source` "external" list.

### test

The `test` format is useful for mocking a bundle locally for a test and is
deliberately not serializable or passable.
Use this format in tests to avoid the need to generate a bundle from source,
providing instead just the exports you need returned by `importBundle`.

```js
import { importBundle, bundleTestExports } from '@endo/import-bundle';

test('who tests the tests', async t => {
  const bundle = bundleTestExports({ a: 10 });
  const namespace = await importBundle(bundle);
  t.is(namespace.a, 10);
  t.is(Object.prototype.toString.call(ns), '[object Module]');
});
```


Source: [packages/import-bundle/README.md](https://github.com/endojs/endo/blob/17ec018b/packages/import-bundle/README.md) at commit `17ec018b`.
