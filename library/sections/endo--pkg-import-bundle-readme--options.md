---
title: Options
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

> Abstract: Configuration options for the loader: endowments, transforms, error policies. Mirrors the Compartment constructor's options but at the bundle-loading layer.

## Options

`importBundle()` takes an options bag and optional additional powers.

```js
const namespace = await importBundle(bundle, options, powers);
```

The most common option is `filePrefix`, which can be provided for
`nestedEvaluate`-format bundles.
This sets the source filename of the top-level module inside the bundle, as
used in debugging messages (like the stack traces displayed in errors).
The other modules will append a suffix to this filename, based upon their
location within the original source tree.

Another common option is `endowments`, which provides names that will be
available everywhere in the evaluated sources.
By default, the bundle will only get access to the standard JavaScript
primordials (`Array`, `Object`, `Map`, etc).
It will not get `document`, `window`, `Request`, `process`, `require`, or even
`console` unless you provide them as endowments, giving you full control over
what the loaded bundle can do.

The `bundle-source` tool has a small number of module names marked as
"external".
These modules are not bundled into the source (copied from the filesystem where
`bundleSource` was called).
Instead, the bundler injects a call to `require()` for each external module
that was imported from somewhere in original source graph.
This let the final evaluation environment control what these imports get,
rather than the original source tree.

To support these "external" imports, you will need to provide a `require`
endowment that can honor any such names.
In addition, the `nestedEvaluate` format always needs a `require` endowment
(although it will only be called if the original sources imported one of the
"external" names).

For debugging purposes, you should probably provide a `console` endowment.
See `makeConsole.js` in the SwingSet source tree for inspiration.

The rest of the `options` are passed through to the `Compartment` constructor,
which currently only accepts `transforms`.
For more information, see the `compartment-shim` docs in the SES repository.
Note that `transforms` is defined to be an array of objects which each have a
`rewrite` method.

Note that `sloppyGlobalsMode` is only accepted by the Compartment's `evaluate`
method, not the Compartment constructor itself, and thus cannot be supplied to
`importBundle`.
To use `sloppyGlobalsMode`, you will probably want to create a Compartment
directly (and not freeze its globals).


Source: [packages/import-bundle/README.md](https://github.com/endojs/endo/blob/17ec018b/packages/import-bundle/README.md) at commit `17ec018b`.
