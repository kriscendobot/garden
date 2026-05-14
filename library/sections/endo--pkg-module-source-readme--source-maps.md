---
title: Source maps
source: packages/module-source/README.md
source_repo: endojs/endo
source_commit: 53e5109e
source_date: 2024-05-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling]
status: current
---

> Abstract: ModuleSource carries source-map data alongside the source text so Compartments can produce useful stack traces against the original source.

## Source maps

The `ModuleSource` is a shim for what we hope to eventually call a native
`ModuleSource` constructor.
However, in the absence of a native `ModuleSource`, this produces a
serializable object that emulates the behavior of `ModuleSource` in conjunction
with the `Compartment` constructor from `ses`.
A detail that leaks from the implementation is that the constructor rewrites
the source, from an ESM `[[Module]]` grammar construction to a `[[Program]]`
construction suitable for confining with the compartment's confined evaluator.

This transform attempts to be unobtrusive, but currently causes some alignment
changes due to (hopefully temporary) limitations to the underlying code
generator.
In the interim, generating a source map can help.

The `ModuleSource` constructor accepts non-standards-track
`sourceMapHook` and `sourceMapUrl` options.

Previously, the sole option was a `string` argument for the `sourceUrl`, such
that this would be appended to the generated source.
This change allows for the old or new usage:

```js
new ModuleSource(source, sourceUrl);
// or
new ModuleSource(source, { sourceUrl, sourceMapUrl, sourceMapHook });
```

The `sourceMapUrl` is necessary for generating a source map.
The URL will appear only in the generated source map, so a fully qualified
source map URL is safe and allows for continuity if the map is generated and
debugged on the same host.
This is important because Endo captures precompiled Static Module Records in
bundles, excluding source maps, such that a relative path is not useful.

The `sourceMapHook` will receive a string source map and a details bag
including:

- `source`
- `sourceUrl`
- `sourceMapUrl`

Such that the receiver can store the source map somewhere as a side-effect.

Note: the `sourceMapHook` is synchronous and returns `void`.
Exceptions thrown by the hook will propagate up through the constructor.  If
the hook returns a promise, it will be dropped and rejections will go uncaught.
If the hook must do async work, these should be queued up as a job that the
caller can later await.


Source: [packages/module-source/README.md](https://github.com/endojs/endo/blob/53e5109e/packages/module-source/README.md) at commit `53e5109e`.
