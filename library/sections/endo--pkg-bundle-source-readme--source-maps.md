---
title: Source maps
source: packages/bundle-source/README.md
source_repo: endojs/endo
source_commit: 1af1999ec5a7b77f39a1044073ed545ff526c90b
source_date: 2025-08-02
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling]
status: current
---

> Abstract: How bundle-source produces source maps for debugged-bundled-output mapping. The source maps allow stack traces in bundled code to refer back to the original source files.

## Source maps

With the default `moduleFormat` of "endoZipBase64", the bundler can generate
source maps but does not include them in the bundle itself.
Use the `cacheSourceMaps` option to render source maps into a per-user per-host
cache.

The `@endo/import-bundle` utility can add references to these generated
source maps when it unpacks a bundle, provided a suitable
`computeSourceMapLocation` power, like the one provided by
`@endo/import-bundle/source-map-node.js`.

```js
import 'ses';
import { importBundle } from '@endo/import-bundle';
import { computeSourceMapLocation } from '@endo/import-bundle/source-map-node.js';
await importBundle(
  bundle,
  { endowments: { console } },
  { computeSourceMapLocation },
);
```

Use the `@endo/cli` to find your cache.

```console
> yarn add -D @endo/cli
> yarn endo where cache
```

Use the `XDG_CACHE_HOME` environment variable to override the default location
of caches in general.
The caches will be in `endo/source-map` and `endo/source-map-track`.
The former is a content-address-store keyed on the SHA-512 of each bundled
module file.
The latter is a location-address-store keyed on the SHA-512 of the fully
qualified path of the module source, indicating the last known bundle hash.
The bundler uses the tracker to ensure that the cache only contains one source
map for every physical module.
It is not yet quite clever enough to collect source maps for sources that do
not exist.


Source: [packages/bundle-source/README.md](https://github.com/endojs/endo/blob/1af1999ec5a7b77f39a1044073ed545ff526c90b/packages/bundle-source/README.md) at commit `1af1999e`.
