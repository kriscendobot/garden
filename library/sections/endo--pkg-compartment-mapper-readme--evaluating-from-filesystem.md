---
title: Evaluating an application from a file system
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

> Abstract: How compartment-mapper resolves and evaluates a module graph rooted at a local file. Walks the import tree, builds Compartments per package, applies the language-specific source transforms, and invokes the entry point. The primary developer-facing flow for running an Endo application without bundling.

## Evaluating an application from a file system

The `importLocation` function evaluates a compartmentalized application off the
file system.
The `globals` are properties to add to the `globalThis` in the global scope
of the application's main package compartment.
The `modules` are built-in modules to grant the application's main package
compartment.

```js
import fs from "fs";
import { fileURLToPath } from "url";
import { importLocation } from "@endo/compartment-mapper";

// ...

const read = async location => fs.promises.readFile(fileURLToPath(location));

const { namespace: moduleExports } = await importLocation(
  read,
  moduleSpecifier,
  {
    globals: { console },
    modules: { fs },
  },
);
```

The compartment mapper does nothing to arrange for the realm to be frozen.
The application using the compartment mapper is responsible for applying the
[SES] shim (if necessary) and calling `lockdown` to freeze the realm (if
necessary).
The compartment mapper is also not coupled specifically to Node.js IO and does
not import any powerful modules like `fs`.
The caller must provide read powers in the first argument as either a ReadPowers
object or as a standalone `read` function. ReadPowers has optional functions
which can be used to unlock compatibility features. When `fileURLToPath` is
available, `__dirname` and `__filename` will be provided to CJS modules. When
`requireResolve` is available, it will be called whenever a CJS module calls
[`require.resolve()`].

```ts
type ReadPowers = {
  read: (location: string) => Promise<Uint8Array>,
  canonical: (location: string) => Promise<string>,
  computeSha512?: (bytes: Uint8Array) => string,
  fileURLToPath?: (location: string | URL) => string,
  pathToFileURL?: (path: string) => URL,
  requireResolve?: (
    fromLocation: string,
    specifier: string,
    options?: { paths?: string[] },
  ) => string
}
```

> [!NOTE]
> TODO: A future version will allow application authors to distribute their
> choices of globals and built-in modules to third-party packages within the
> application, as with [LavaMoat].

The `importLocation` function internally uses `loadLocation`.
Use `loadLocation` to defer execution or evaluate multiple times with varying
globals or modules in the same process.
`loadLocation` returns an Application object with an
`import({ globals?, modules? })` method.


Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
