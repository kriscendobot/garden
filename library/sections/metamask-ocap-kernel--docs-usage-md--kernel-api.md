---
title: Kernel API (operational)
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [daemon]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. Soft-flag cross-source overlap with the kernel guide's kernel-api (model-level) — this is the operator-level call surface (subcluster lifecycle, queueMessage/kunser, remote comms, status, debugging methods).
---

## Abstract

The usage guide's Kernel API section is the **operator call surface**: subcluster lifecycle (`launchSubcluster(config)` → `{ subclusterId, rootKref, bootstrapResult }`, `reloadSubcluster`, `terminateSubcluster`); message sending (`getRootObject(vatId)` to get a target ref, `queueMessage(target, method, args)`, then `kunser(result)` to deserialize the marshalled reply); per-vat management (`pingVat`, `terminateVat`, `restartVat`); peer-to-peer **remote communications** via `initRemoteComms({ relays })` over libp2p relay servers (multiaddrs that include the relay's peer ID; browsers support only `/ws` transports), with status under `getStatus().remoteComms`; state/configuration queries (`getStatus`, `getSubclusters`, `getSubcluster`, `isVatInSubcluster`, `getSubclusterVats`); and a clearly-fenced **testing/debugging-only** group (`pinVatRoot`/`unpinVatRoot`, `clearStorage`, `reset`, `terminateAllVats`, `reload`, `collectGarbage`). The mnemonic identity API (`Kernel.make({ mnemonic })`, `generateMnemonic`, `isValidMnemonic`) appears here too; its detail is the dedicated [identity-backup-recovery](../sources/metamask-ocap-kernel--docs-identity-backup-recovery-md.md) source.

## Body

### Launching vats and clusters

```typescript
// Individual vat launching is not directly exposed; launch a cluster:
const result = await kernel.launchSubcluster(clusterConfig);
const newSubcluster = await kernel.reloadSubcluster(subclusterId); // terminates + restarts all its vats
await kernel.terminateSubcluster(subclusterId);
```

### Sending messages

```typescript
const target = kernelStore.getRootObject(vatId); // a vat's root Ref by vatId
const result = await kernel.queueMessage(target, 'greet', []);

import { kunser } from '@metamask/ocap-kernel';
const parsedResult = kunser(result); // deserialize the marshalled reply
```

### Vat management

```typescript
await kernel.pingVat(vatId);
await kernel.terminateVat(vatId);
await kernel.restartVat(vatId);
```

### Remote communications

`initRemoteComms` enables peer-to-peer communication between kernels using libp2p relay servers, working across machines and through NATs/firewalls:

```typescript
const relays = ['/ip4/127.0.0.1/tcp/9001/ws/p2p/12D3KooWJBDqsyHQF2MWiCdU4kdqx4zTsSTLRdShg7Ui6CRWB4uc'];
await kernel.initRemoteComms({ relays });
```

Relay addresses must be libp2p multiaddrs that include the relay server's peer ID; browser environments support only WebSocket (`/ws`) transports. After initialization, status is reported by `getStatus()`:

```typescript
const status = await kernel.getStatus();
// status.remoteComms: { isInitialized: true, peerId: '12D3KooW...' } or { isInitialized: false }
```

### Identity (mnemonic)

The kernel supports BIP39 mnemonics for backing up and recovering kernel identity (peer ID) across devices. The call shape is `generateMnemonic()` / `isValidMnemonic(...)` from `@metamask/ocap-kernel` and `Kernel.make(platformServices, db, { mnemonic })` (with `resetStorage: true` when recovering on a new device). Generate and display the mnemonic *before* initializing. Full procedures, scenarios, and security best practices are in the dedicated [identity-backup-recovery](../sources/metamask-ocap-kernel--docs-identity-backup-recovery-md.md) source.

### State and configuration

```typescript
const status = await kernel.getStatus();
// { vats: [{ id, config, subclusterId }], subclusters: [{ id, config, vats }], remoteComms: {...} }

const subclusters = kernel.getSubclusters();
const subcluster = kernel.getSubcluster(subclusterId);
const isInSubcluster = kernel.isVatInSubcluster(vatId, subclusterId);
const vatIds = kernel.getSubclusterVats(subclusterId);
```

### Testing and debugging methods (only)

The guide marks these as intended for testing and debugging purposes only:

```typescript
await kernel.pinVatRoot(vatId);    // prevent GC
await kernel.unpinVatRoot(vatId);  // allow GC
await kernel.clearStorage();
await kernel.reset();              // stop all vats, reset state
await kernel.terminateAllVats();
await kernel.reload();             // reload last launched subcluster config
kernel.collectGarbage();
```

### Lineage note

This call surface overlaps the kernel guide's model-level [kernel-api](metamask-ocap-kernel--docs-kernel-guide-md--kernel-api.md) (soft-flag cross-source overlap, not contradiction): the guide frames *why* the kernel owns these verbs, the usage guide gives the *operator's* call sequence including `queueMessage` + `kunser` and the libp2p remote-comms wiring. `kunser` is ocap-kernel's unmarshal step — the sibling of Endo's `@endo/marshal` `unserialize` ([[marshal]]); the kernel marshals cross-vat replies and the operator deserializes them at the host boundary. The pin/unpin debugging verbs are the operator handle on the kernel's three-independent-GC-systems discipline recorded in the [glossary](../sources/metamask-ocap-kernel--docs-glossary-md.md).

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
