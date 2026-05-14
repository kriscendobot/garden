---
title: @endo/bundle-source (overview)
source: packages/bundle-source/README.md
source_repo: endojs/endo
source_commit: 1af1999ec5a7b77f39a1044073ed545ff526c90b
source_date: 2025-08-02
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles]
status: current
---

> Abstract: @endo/bundle-source bundles a JavaScript module graph into a single archive string, suitable for serialization as part of a passable. 6 H2 sub-sections cover the bundler's behavior: package.json conditions, comment elision, TypeScript type erasure, source maps, the moduleFormat negotiation, and the endoScript-specific module format.

# Bundle Source

This package creates source bundles from ES Modules, compatible with Endo
applications, Agoric contracts, and SwingSet vats.

To bundle a program that enters at `program.js` from the command line, use the
`bundle-source` tool:

```console
> yarn bundle-source --cache-json bundles program.js program
```

To do the same programmatically:

```js
import 'ses';
import bundleSource from '@endo/bundle-source';
import url from 'url';

const sourceBundleURL = new URL('program.js', import.meta.url);
const sourceBundlePath = url.fileURLToPath(sourceBundleURL);
const sourceBundleP = bundleSource(sourceBundlePath);
```

…to get a promise for a source bundle, that resolves after reading the
named sources and bundling them into a form that vats can load, as indicated
by the `moduleFormat` below.

The resulting bundle is suitable for use with `@endo/import-bundle`.
The default format is of a bundle is "endoZipBase64".


Source: [packages/bundle-source/README.md](https://github.com/endojs/endo/blob/1af1999ec5a7b77f39a1044073ed545ff526c90b/packages/bundle-source/README.md) at commit `1af1999e`.
