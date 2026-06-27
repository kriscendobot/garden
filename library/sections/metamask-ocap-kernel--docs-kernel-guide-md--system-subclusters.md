---
title: System Subclusters
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]].
---

## Abstract

**System subclusters** are subclusters declared at kernel startup (`Kernel.make({ systemSubclusters: [...] })`) with four special properties: they may access `systemOnly` services (like the kernel facet), they persist across kernel restarts (the kernel restores them automatically), they are identified by a unique *name* (not just an id), and the host can retrieve their bootstrap root kref via `kernel.getSystemSubclusterRoot(name)`. Their gateway to privileged operations is the **kernel facet** — a built-in `systemOnly` service exposing the kernel's own control surface to system vats: `getStatus`, `getSubclusters`/`getSubcluster`, `launchSubcluster`/`terminateSubcluster`, `getSystemSubclusterRoot`, `queueMessage`, `getPresence`, `pingVat`, `reset`, `ping`. The kernel facet is how a privileged in-vat controller drives the kernel reflexively — the same operations the host application has, handed to a system vat as a capability. This is privilege-by-declaration: authority is conferred by being declared a system subcluster at startup, not acquired dynamically.

## Body

System subclusters are declared at kernel startup and have special properties:

- They can access `systemOnly` services (like the kernel facet).
- They persist across kernel restarts — the kernel restores them automatically.
- They are identified by a unique name (not just a subcluster ID).
- The host application can retrieve the bootstrap root kref via `kernel.getSystemSubclusterRoot(name)`.

### Declaring a system subcluster

```ts
const kernel = await Kernel.make(platformServices, kernelDatabase, {
  systemSubclusters: [
    {
      name: 'my-system-subcluster',
      config: {
        bootstrap: 'controllerVat',
        services: ['kernelFacet', 'myHostService'],
        vats: {
          controllerVat: {
            sourceSpec: './controller-vat.ts',
            parameters: { name: 'controller' },
          },
        },
      },
    },
  ],
});
```

### The kernel facet

The **kernel facet** is a built-in `systemOnly` service that gives system vats access to privileged kernel operations:

| Method | Description |
| --- | --- |
| `getStatus()` | Get kernel status |
| `getSubclusters()` | List all subclusters |
| `getSubcluster(id)` | Get a specific subcluster |
| `launchSubcluster(config)` | Launch a new subcluster |
| `terminateSubcluster(id)` | Terminate a subcluster |
| `getSystemSubclusterRoot(name)` | Get a system subcluster's root kref |
| `queueMessage(target, method, args)` | Send a message to any kernel object |
| `getPresence(kref, iface?)` | Convert a kref to a presence |
| `pingVat(vatId)` | Ping a vat |
| `reset()` | Reset the kernel (debugging) |
| `ping()` | Returns `'pong'` |

Usage from a system vat:

```ts
import { E } from '@endo/eventual-send';

// In bootstrap:
const kernelFacet = services.kernelFacet;

// Later:
const status = await E(kernelFacet).getStatus();
const { subclusterId } = await E(kernelFacet).launchSubcluster(config);
await E(kernelFacet).terminateSubcluster(subclusterId);
```

## Lineage note

The kernel facet — a privileged service exposing the kernel's control surface to a system vat — is structurally a *reflexive host capability*: the host's own powers, handed back into the ocap graph as an exo a system vat may invoke. Endo's nearest analog is the daemon's *Familiar* / host powers a privileged guest can hold, but Endo confers them as capabilities through the formula graph rather than through a named `systemOnly` service tier gated at subcluster declaration. The "privilege survives restart, keyed by name" property aligns with Endo's persistence-by-formula-identity but is here scoped to the subcluster, not the individual object.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
