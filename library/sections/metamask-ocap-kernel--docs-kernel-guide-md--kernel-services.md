---
title: Kernel Services
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

A **kernel service** is a JavaScript object registered with the kernel (`kernel.registerKernelServiceObject(name, obj, options?)`) that vats invoke via `E()` exactly like any other remote object — but it runs in the **kernel's own context**, with full access to the host application's APIs, rather than inside a vat. Services may be marked `{ systemOnly: true }`, restricting them to system subclusters. A subcluster requests services by name in its config's `services` array; the kernel validates that every requested service exists and is accessible *before* launching the subcluster, throwing on failure. Mechanically, when a vat calls `E(service).method(args)` the vat issues a **syscall**, the kernel's **router** recognizes the target kref as a service (not a vat), the **KernelServiceManager** deserializes and calls the method directly, and the result resolves as a kernel promise delivered back as a notification — transparent to the vat, which sees a normal `E()` call. Kernel services are the kernel-context capability-injection point: the controlled bridge by which confined vats reach host authority.

## Body

A kernel service is a JavaScript object registered with the kernel. Vats interact with it via `E()` just like any other remote object, but it runs in the kernel's own context (not in a vat).

### Registering a service (host application side)

```ts
import { makeDefaultExo } from '@metamask/kernel-utils/exo';

const myService = makeDefaultExo('myService', {
  async doSomething(arg: string): Promise<string> {
    // This runs in the kernel's context, not in a vat.
    // You have full access to the host application's APIs here.
    return `result: ${arg}`;
  },
});

// Register before launching subclusters that need it
kernel.registerKernelServiceObject('myService', myService);
```

### Registering a system-only service

```ts
kernel.registerKernelServiceObject('privilegedService', serviceObj, {
  systemOnly: true,
});
```

System-only services can only be accessed by system subclusters. Regular subclusters that request them get an error at launch time.

### Requesting services in a cluster config

```ts
const config: ClusterConfig = {
  bootstrap: 'myVat',
  services: ['myService', 'kernelFacet'],
  vats: {
    myVat: { sourceSpec: './my-vat.ts' },
  },
};
```

The kernel validates that all requested services exist (and are accessible) before launching the subcluster. If validation fails, the launch throws.

### Using a service from vat code

```ts
import { E } from '@endo/eventual-send';

export function buildRootObject(_vatPowers, _params, baggage) {
  let myService;
  return makeDefaultExo('root', {
    async bootstrap(_vats, services) {
      myService = services.myService;
      baggage.init('myService', myService); // persist for restarts
    },
    async doWork() {
      const result = await E(myService).doSomething('hello');
      console.log(result); // "result: hello"
    },
  });
}
```

### How service invocation works (overview)

When a vat calls `E(service).method(args)`:

1. The vat issues a **syscall** sending a message to the service's kref.
2. The kernel's **router** recognizes the target as a kernel service (not a vat).
3. The **KernelServiceManager** deserializes the message and calls the method on the service object directly.
4. The result (or error) is resolved as a kernel promise, which is delivered back to the vat as a notification.

This is transparent to the vat — it just looks like a normal `E()` call.

## Lineage note

Kernel services are the rough analog of Endo's *host methods* / *powers* — the controlled surface through which a confined guest reaches host authority. The divergence is structural: ocap-kernel registers services *by name on the kernel* and validates access at subcluster launch (a name-resolution + access-check step), whereas Endo hands powers directly as capabilities through the formula graph with no separate name registry. Note the asymmetry recorded in ocap-kernel's glossary: kernel services run in kernel context and (per glossary) cannot themselves return exos — an architectural constraint Endo does not impose on host methods.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
