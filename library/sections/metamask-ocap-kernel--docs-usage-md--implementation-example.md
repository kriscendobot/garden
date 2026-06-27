---
title: Implementation Example (browser and Node.js)
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [getting-started, daemon]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. The complete end-to-end worked initialization, the operational capstone of the usage guide.
---

## Abstract

The usage guide closes with two complete worked examples — browser and Node.js — that initialize the kernel and launch a cluster, making concrete the claim that the init-then-launch pattern is consistent across platforms and the only real differences are the initialization dependencies. The **browser** path builds `PlatformServicesClient.make(globalThis)` + `makeSQLKernelDatabase` (wasm), calls `Kernel.make(...)`, then loads a `ClusterConfig` with `fetchValidatedJson(url, ClusterConfigStruct)` and `launchSubcluster`. The **Node.js** path builds a `MessageChannel` port and `makeKernel({ port, workerFilePath, resetStorage, dbFilename: ':memory:' })`, reads the cluster config from disk and validates it with `ClusterConfigStruct.check(JSON.parse(...))`, then `launchSubcluster`. Both use `@metamask/superstruct`-style runtime validation (`ClusterConfigStruct`) on the config before launch.

## Body

This is a complete example of implementing the OCAP Kernel in both environments.

### Browser implementation

```typescript
import { Kernel, ClusterConfigStruct } from '@metamask/ocap-kernel';
import { makeSQLKernelDatabase } from '@metamask/kernel-store/sqlite/wasm';
import { fetchValidatedJson } from '@metamask/kernel-utils';
import { PlatformServicesClient } from '@metamask/kernel-browser-runtime';

async function initBrowserKernel() {
  const platformServices = await PlatformServicesClient.make(globalThis);
  const kernelDatabase = await makeSQLKernelDatabase({ dbFilename: 'store.db' });
  return await Kernel.make(platformServices, kernelDatabase, {
    resetStorage: true, // for development
  });
}

async function run() {
  const kernel = await initBrowserKernel();
  const clusterConfig = await fetchValidatedJson(
    'path/to/cluster-config.json',
    ClusterConfigStruct,
  );
  const result = await kernel.launchSubcluster(clusterConfig);
  console.log(`Subcluster launched: ${JSON.stringify(result)}`);
}
```

### Node.js implementation

```typescript
import { makeKernel } from '@metamask/kernel-node-runtime';
import { ClusterConfigStruct } from '@metamask/ocap-kernel';
import { MessageChannel } from 'node:worker_threads';
import fs from 'node:fs/promises';

async function initNodeKernel() {
  const { port1: kernelPort } = new MessageChannel();
  return await makeKernel({
    port: kernelPort,
    workerFilePath: './path/to/vat-worker.js',
    resetStorage: true,        // for development
    dbFilename: ':memory:',    // in-memory database for testing
  });
}

async function run() {
  const kernel = await initNodeKernel();
  const configRaw = await fs.readFile('./path/to/cluster-config.json', 'utf8');
  const clusterConfig = ClusterConfigStruct.check(JSON.parse(configRaw));
  const result = await kernel.launchSubcluster(clusterConfig);
  console.log(`Subcluster launched: ${JSON.stringify(result)}`);
}

run().catch(console.error);
```

The guide notes this initialize-then-launch pattern is consistent across both environments; the differences are confined to the initialization steps and dependencies.

### Lineage note

Both examples validate the cluster config at runtime before launch (`fetchValidatedJson(url, ClusterConfigStruct)` in the browser; `ClusterConfigStruct.check(JSON.parse(...))` in Node.js). `ClusterConfigStruct` is a `@metamask/superstruct` runtime type — ocap-kernel validates untrusted config at the host boundary, a discipline analogous to Endo's pass-style / `@endo/patterns` shape-checking of incoming data ([[marshal]], patterns). The browser-vs-Node difference being *only* the init dependencies (wasm SQLite + `PlatformServicesClient` vs `MessageChannel` + `makeKernel`) is the payoff of the injected-`platformServices`/`kernelDatabase` seam recorded in [setting-up-the-kernel](metamask-ocap-kernel--docs-usage-md--setting-up-the-kernel.md).

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
