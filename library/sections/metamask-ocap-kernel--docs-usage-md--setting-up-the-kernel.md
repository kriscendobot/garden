---
title: Setting Up the Kernel
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
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. Operational setup surface omitted by the kernel guide.
---

## Abstract

Instantiating the kernel needs exactly two injected dependencies: a **platform services implementation** (browser or Node.js) and a **kernel database** for state persistence. In the browser, the host calls `PlatformServicesClient.make(globalThis)` and `makeSQLKernelDatabase` (the `sqlite/wasm` build), then `Kernel.make(platformServices, kernelDatabase, { resetStorage })`. In Node.js the host either uses the convenience `makeKernel({ port, workerFilePath, resetStorage, dbFilename })` from `@metamask/kernel-node-runtime`, or wires the same parts manually with `NodejsPlatformServices` and the `sqlite/nodejs` database build. Browser kernel *workers* that need peer-to-peer comms are configured separately by encoding `RemoteCommsOptions` into the worker URL's query string (`createCommsQueryString` / `getCommsParamsFromCurrentLocation`) and calling `kernel.initRemoteComms(options)` inside the worker. This is the dependency-injection seam that lets one kernel core run on both platforms.

## Body

To initialize the OCAP Kernel you need a platform services implementation (browser or Node.js) and a kernel database for state persistence.

### Browser environment

```typescript
import { Kernel } from '@metamask/ocap-kernel';
import { makeSQLKernelDatabase } from '@metamask/kernel-store/sqlite/wasm';
import { PlatformServicesClient } from '@metamask/kernel-browser-runtime';

const platformServices = await PlatformServicesClient.make(globalThis);
const kernelDatabase = await makeSQLKernelDatabase({ dbFilename: 'store.db' });

// Ready to use immediately
const kernel = await Kernel.make(platformServices, kernelDatabase, {
  resetStorage: false, // true to reset storage on startup
});
```

#### Configuring remote comms for workers

When creating kernel workers with relay and other remote-comms options, use the utilities from `@metamask/kernel-browser-runtime`. `createCommsQueryString` returns a `URLSearchParams` built from a `RemoteCommsOptions` object (relay multiaddrs, `allowedWsHosts`, `maxQueue`, `directListenAddresses`, …); the worker reads them back with `getCommsParamsFromCurrentLocation`:

```typescript
import {
  createCommsQueryString,
  getCommsParamsFromCurrentLocation,
} from '@metamask/kernel-browser-runtime';

const commsParams = {
  relays: ['/ip4/127.0.0.1/tcp/9001/ws/p2p/12D3KooWJBDqsyHQF2MWiCdU4kdqx4zTsSTLRdShg7Ui6CRWB4uc'],
  allowedWsHosts: ['localhost'],
};

const workerUrlParams = createCommsQueryString(commsParams);
workerUrlParams.set('reset-storage', 'false');
const workerUrl = new URL('kernel-worker.js', import.meta.url);
workerUrl.search = workerUrlParams.toString();
const worker = new Worker(workerUrl, { type: 'module' });

// Inside the worker:
const options = getCommsParamsFromCurrentLocation();
await kernel.initRemoteComms(options);
```

### Node.js environment

The convenience path uses `makeKernel` from `@metamask/kernel-node-runtime`, driven by a `MessageChannel` port:

```typescript
import { makeKernel } from '@metamask/kernel-node-runtime';
import { MessageChannel } from 'node:worker_threads';

const { port1: kernelPort } = new MessageChannel();
const kernel = await makeKernel({
  port: kernelPort,
  workerFilePath: './path/to/vat-worker.js', // optional
  resetStorage: false,                       // optional
  dbFilename: 'store.db',                     // optional
});
```

The manual path wires the same parts directly with `NodejsPlatformServices` and the `sqlite/nodejs` database build, then calls the same `Kernel.make(platformServices, kernelDatabase, { resetStorage })` as the browser.

### Lineage note

The two-argument `Kernel.make(platformServices, kernelDatabase, options)` shape — platform IO and persistence both **injected at construction** — is the operator-side view of the same dependency-injection discipline the kernel guide records ([kernel-api](metamask-ocap-kernel--docs-kernel-guide-md--kernel-api.md)). It is directly comparable to Endo's daemon, which likewise abstracts platform paths (`@endo/where`) and a content store behind injected interfaces so the same core runs across platforms. ocap-kernel's `makeSQLKernelDatabase` (SQLite, wasm in the browser) is the persistence substrate; Endo's daemon uses its formula graph + content-addressed store ([[formula-graph]]).

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
