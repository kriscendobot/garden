---
title: Evaluating an application from an archive
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments]
status: current
parent: endo--pkg-compartment-mapper-readme--evaluating-from-archive
---

Use `importArchive` to run an application from an archive.
Note the similarity to `importLocation`.

```js
import fs from "fs";
import { fileURLToPath } from "url";
import { importArchive } from "@endo/compartment-mapper";

// ...

const read = async location => fs.promises.readFile(fileURLToPath(location));

const { namespace: moduleExports } = await importArchive(
  read,
  archiveLocation,
  {
    globals: { console },
    modules: { fs },
  },
);
```

The `importArchive` function internally composes `loadArchive` and
`parseArchive`.
Use `loadArchive` to defer execution or run multiple times with varying
globals or modules in the same process.
Use `parseArchive` to construct a runner from the bytes of an archive.
`loadArchive` and `parseArchive` return an Application object with an
`import({ globals?, modules? })` method.

`loadArchive` and `parseArchive` do not run the archived application,
so they can be used to safely check its hash.

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
