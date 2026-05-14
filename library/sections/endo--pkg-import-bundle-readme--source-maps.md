---
title: Source maps
source: packages/import-bundle/README.md
source_repo: endojs/endo
source_commit: 17ec018b
source_date: 2025-03-06
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling]
status: current
---

> Abstract: Source-map handling at load time: how bundled-evaluated code references original source locations for error stacks and debuggers.

## Source maps

For an Endo (zip, base64) bundle, `bundleSource` will add source maps to a
per-user cache so they can be debugged if imported on the same host.
To use this facility, pass a `computeSourceMapLocation` capability into
`powers`.

```js
import 'ses';
import bundleSource from '@endo/bundle-source';
import { importBundle } from '@endo/import-bundle';
import { computeSourceMapLocation } from '@endo/import-bundle/source-map-node.js';

lockdown();
const bundle = await bundleSource('debugme.js');
await importBundle(
  bundle,
  { endowments: { console } },
  { computeSourceMapLocation },
);
```

Use `node --inspect-brk` and `debugger` statements.

Source: [packages/import-bundle/README.md](https://github.com/endojs/endo/blob/17ec018b/packages/import-bundle/README.md) at commit `17ec018b`.
