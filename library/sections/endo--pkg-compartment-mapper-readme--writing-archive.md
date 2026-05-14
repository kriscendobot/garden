---
title: Writing an application archive
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments]
status: current
---

> Abstract: How to serialize a module graph into a self-contained archive: capture the import graph, sources, and metadata needed to evaluate the application elsewhere. The archive format is the basis for distributing capability-confined applications without depending on the source filesystem at runtime.

## Writing an application archive

Use `writeArchive` to capture an application in an archival format.
Archives are `zip` files with a `compartment-map.json` manifest file.

```js
import fs from "fs";
import { fileURLToPath } from "url";
import { writeArchive } from "@endo/compartment-mapper";

const read = async location => fs.promises.readFile(fileURLToPath(location));
const write = async (location, content) =>
  fs.promises.writeFile(fileURLToPath(location), content);

const moduleSpecifier = new URL('app.js', import.meta.url).toString();
const archiveLocation = new URL('app.zip', import.meta.url).toString();

// Write to `archiveLocation`.
await writeArchive(write, read, archiveLocation, moduleSpecifier);
```

The `writeArchive` function internally uses `makeArchive`.
Using `makeArchive` directly gives you the archive bytes.


Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
