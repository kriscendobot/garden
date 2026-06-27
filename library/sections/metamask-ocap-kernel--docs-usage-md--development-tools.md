---
title: Development Tools
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [tooling, testing]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. Net-new operational/testing surface omitted by the kernel guide.
---

## Abstract

The ocap-kernel project ships three developer-facing tool families. **API documentation** is TypeDoc-generated from source comments — `yarn build:docs` (all packages) or `yarn workspace @metamask/ocap-kernel build:docs` (one package), output to each package's `docs/` directory, viewed by opening `index.html`; the guide also points contributors at `*.test.ts` files as usage examples. **CLI tools** come from `@metamask/kernel-cli`: `yarn ocap bundle ./path/to/vat.js` (bundle a vat) and `yarn ocap serve ./path/to/bundles` (local dev server). **Testing** uses Vitest, with a worked example that spins up a kernel via `makeKernel({ port, resetStorage: true, dbFilename: ':memory:' })`, launches a vat, queues a message, and asserts on the deserialized result. **Debugging** advice: verbose logging via `vatPowers.stdout()`, the `getStatus()` API for live state, and direct database inspection via `kernelDatabase.executeQuery('SELECT * FROM kv')`.

## Body

### API documentation

The project uses TypeDoc to generate API documentation from source-code comments:

```bash
yarn build:docs                                   # all packages
yarn workspace @metamask/ocap-kernel build:docs   # one package
```

Output lands in each package's `docs/` directory; open `index.html` to view. The guide notes the TypeDoc output currently has to be built locally, and recommends checking the test files (`*.test.ts`) for usage examples.

### CLI tools

The `@metamask/kernel-cli` package provides tools for working with vat bundles:

```bash
yarn ocap bundle ./path/to/vat.js     # bundle a vat file
yarn ocap serve ./path/to/bundles     # local dev server for testing
```

### Testing

For testing vats and kernel integration, the project uses Vitest. The kernel is created in-process with an in-memory database:

```typescript
import { makeKernel } from '@metamask/kernel-node-runtime';
import { MessageChannel } from 'node:worker_threads';
import { describe, it, expect } from 'vitest';

describe('My vat tests', () => {
  it('should process messages correctly', async () => {
    const { port1: kernelPort } = new MessageChannel();
    const kernel = await makeKernel({
      port: kernelPort,
      resetStorage: true,
      dbFilename: ':memory:',
    });

    const vatId = await kernel.launchVat({
      bundleSpec: 'file:///path/to/test-vat.bundle',
      parameters: { testMode: true },
    });

    const rootRef = kernel.getRootObject(vatId);
    const result = await kernel.queueMessage(rootRef, 'testMethod', ['test arg']);

    expect(result).toStrictEqual(expectedResult);
  });
});
```

### Debugging

1. Enable verbose logging in vats using `vatPowers.stdout()`.
2. Use the status API to check state: `const status = await kernel.getStatus()`.
3. For persistent-data issues, examine the database directly: `kernelDatabase.executeQuery('SELECT * FROM kv')`.

### Lineage note

`dbFilename: ':memory:'` for an in-process test kernel, and `executeQuery('SELECT * FROM kv')` against the kernel store, both show ocap-kernel's persistence is **SQLite all the way down** (a key-value table `kv` over SQLite, wasm in the browser per [setting-up-the-kernel](metamask-ocap-kernel--docs-usage-md--setting-up-the-kernel.md)). This is the same SQLite substrate the [ken-protocol-assessment](../sources/metamask-ocap-kernel--docs-ken-protocol-assessment-md.md) names for savepoint-wrapped crank recovery. Endo's daemon testing follows a comparable in-memory-store shape but over its formula graph rather than a flat `kv` table. The `ocap serve` dev server is the operator counterpart of Endo's `endo` CLI surface ([[bundles]], tooling).

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
