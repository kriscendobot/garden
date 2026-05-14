---
title: Usage (Options + Example)
source: packages/evasive-transform/README.md
source_repo: endojs/endo
source_commit: a2c32ec9
source_date: 2026-02-25
source_authors: [Zbyszek Tenerowicz]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling]
status: current
---

> Abstract: Two H3 sub-sections consolidated: the options the transform takes and a worked example. The 'evasion' here is escaping identifier collisions and proto-chain visibility, not active anti-debug.

## Usage 

### Options

Both `evadeCensor` and `evadeCensorSync` accept a source string as the first argument and an options object as the second argument:

| Option | Type | Description |
|--------|------|-------------|
| `sourceUrl` | `string` | The URL or filename of the source file. Used for source map generation and error messages. |
| `sourceMap` | `string \| object` | Optional. An existing source map (as JSON string or object) to be updated with the transform's mappings. |
| `sourceType` | `'script' \| 'module'` | Optional. Specifies whether the source is a CommonJS script (`'script'`) or an ES module (`'module'`). When provided, it helps the parser handle the code correctly. |
| `elideComments` | `boolean` | Optional. If `true`, removes comment contents while preserving newlines. Defaults to `false`. |
| `onlyComments` | `boolean` | Optional. If `true`, limits transformation to comment contents only, leaving code unchanged. Defaults to `false`. |

### Example

See example below, or see the second test in [packages/compartment-mapper/test/evasive-transform.test.js](../compartment-mapper/test/evasive-transform.test.js) for a demonstration of its usage in compartment-mapper.


```js
// ESM example
import { evadeCensor } from '@endo/evasive-transform';
import fs from 'node:fs/promises';

/**
 * Imagine this file contains a comment like `@property {import('foo').Bar} bar`. SES will refuse to run this code.
 */
const source = await fs.readFile('./dist/index.js', 'utf8');
const sourceMap = await fs.readFile('./dist/index.js.map', 'utf8');
const sourceUrl = 'index.js'; // assuming the source map references index.js
// sourceType can be "script" (CJS) or "module" (ESM)
const sourceType = 'script';

const { code, map } = await evadeCensor(source, {
  sourceMap,
  sourceUrl,
  // always provide a sourceType, if known!
  sourceType,
  elideComments: true,
  onlyComments: true,
});

/**
 * The resulting file will now contain `@property {IMPORT('foo').Bar} bar`, which SES will allow (and TypeScript no longer understands, but that should be fine for the use-case). 
 * 
 * Note that this could be avoided entirely by stripping comments during, say, a bundling phase.
 */
await fs.writeFile('./dist/index.ses.js', code);
await fs.writeFile('./dist/index.ses.js.map', JSON.stringify(map));
```


Source: [packages/evasive-transform/README.md](https://github.com/endojs/endo/blob/a2c32ec9/packages/evasive-transform/README.md) at commit `a2c32ec9`.
