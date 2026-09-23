---
title: Eventual Send with E()
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [eventual-send]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel reuses @endo/eventual-send directly. See [[ocap-kernel]].
---

## Abstract

ocap-kernel uses **`E()` from `@endo/eventual-send`** — the *same* Endo package, not a reimplementation — as the only way to send messages to objects in other vats or to kernel services. `E(target).method(args)` always returns a promise; it works on remote references, on local objects (queuing the call to the next microtask), and on promises that resolve to objects (`E(promise).method()` waits, then sends). Direct method calls on remote references (`remoteObject.method()`) do not work. This is the single clearest point of *shared substrate* between ocap-kernel and Endo: where the kernel/vat model and revocation API diverge, eventual-send is literally imported from `@endo/eventual-send`, so the [[eventual-send]] and [[promise-pipelining]] semantics the library already documents apply unchanged.

## Body

`E()` from `@endo/eventual-send` is the standard way to send messages to remote objects (objects in other vats or kernel services). It returns a promise for the result.

```ts
import { E } from '@endo/eventual-send';

// Basic call — always returns a promise
const result = await E(remoteObject).methodName(arg1, arg2);

// Fire-and-forget (don't await)
E(remoteObject).notifyOfSomething(data);

// Error handling
try {
  await E(remoteObject).riskyMethod();
} catch (error) {
  console.error('Remote call failed:', error);
}
```

**Rules:**

- Always use `E()` when calling methods on objects from other vats or kernel services.
- `E()` can also be used on local objects — it just queues the call for the next microtask.
- `E()` can be used on promises that resolve to objects: `E(promise).method()` will wait for the promise to resolve, then send the message.
- Never call methods directly on remote references (e.g., `remoteObject.method()` won't work).

## Lineage note

This is **shared code, not a parallel** — `@endo/eventual-send` is the same `HandledPromise`-backed shim the library documents under [[eventual-send]]. The guide stops at the usage surface and does not restate pipelining (`E(x).a().b()` shipping in one round trip), but because the underlying package is identical, the library's deeper sections on the forwarding-forest and `dispatchToHandler` apply to ocap-kernel verbatim. The one ocap-kernel-specific wrinkle is the *target*: an `E()` target may be an in-vat exo, a cross-vat presence (kref-backed), or a kernel service — the kernel's router demultiplexes on the target kref's scope.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
