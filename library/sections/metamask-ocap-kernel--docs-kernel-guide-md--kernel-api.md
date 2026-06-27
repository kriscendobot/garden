---
title: The Kernel API
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [daemon]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]].
---

## Abstract

The host application instantiates the kernel with `Kernel.make(platformServices, kernelDatabase, options)` and drives it through a small imperative surface: `registerKernelServiceObject` (register a service vats can call), `launchSubcluster` / `terminateSubcluster` (vat-group lifecycle), `queueMessage(target, method, args)` (send a message to a kref), `getStatus`, `revoke` / `isRevoked` (capability revocation), `getPresence` (kref → slot value), and `stop` / `reset`. Notably the kernel takes a `platformServices` argument and a `kernelDatabase` argument at construction — persistence and platform IO are injected, not assumed, which is how the same kernel core runs on Node.js and in the browser. This is the *host-application* control surface; vat code never holds the `Kernel` instance, only references obtained through bootstrap.

## Body

The kernel is instantiated by the host application via `Kernel.make()`:

```ts
import { Kernel } from '@metamask/ocap-kernel';

const kernel = await Kernel.make(platformServices, kernelDatabase, {
  logger,
  systemSubclusters: [{ name: 'my-system', config: clusterConfig }],
});
```

### Key methods on the Kernel instance

| Method | Description |
| --- | --- |
| `registerKernelServiceObject(name, object, options?)` | Register a kernel service that vats can call via `E()`. |
| `launchSubcluster(config)` | Launch a new subcluster of vats. Returns `{ subclusterId, rootKref, bootstrapResult }`. |
| `terminateSubcluster(subclusterId)` | Terminate a subcluster and all its vats. |
| `queueMessage(target, method, args)` | Send a message to a kernel object (identified by kref). |
| `getStatus()` | Get current kernel status (vats, subclusters, remote comms state). |
| `revoke(kref)` | Revoke an object. Any future `E()` calls to it will fail. |
| `isRevoked(kref)` | Check if an object has been revoked. |
| `getPresence(kref, iface?)` | Convert a kref string to a slot value (presence) for use in messages. |
| `stop()` | Gracefully stop the kernel. |
| `reset()` | Stop all vats and reset kernel state (debugging only). |

The `revoke(kref)` / `isRevoked(kref)` pair is the explicit kernel-level revocation API — a notable divergence from Endo, where revocation is achieved through caretaker / membrane patterns ([[revocation-by-withdrawal]]) rather than a first-class kernel verb. See the Revocation section under this source.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
