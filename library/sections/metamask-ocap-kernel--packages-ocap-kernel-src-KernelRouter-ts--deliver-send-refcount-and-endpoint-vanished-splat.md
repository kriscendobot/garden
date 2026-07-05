---
title: "#deliverSend: refcount bookkeeping on every exit path, the endpoint-vanished-is-a-splat catch, kref↔eref translation, and the kernel-service branch"
source: packages/ocap-kernel/src/KernelRouter.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelRouter.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelRouter.ts
source_line_range: "196-341"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: "#deliverSend enacts the route: on a splat it decrements the refcount of target, result, and every arg slot; a vanished endpoint (a caught #getEndpoint throw) is treated as a splat with ENDPOINT_UNREACHABLE; a live endpoint gets a kref→eref-translated target and message via deliverMessage (a delivery throw rejects the result with DELIVERY_FAILED without crashing the queue); an endpointId of 'kernel' routes to #invokeKernelService; a routeless requeue enqueues the message on the promise."
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-05
ingested_by: scholar
topics: [capability-security, persistence]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of KernelRouter's #deliverSend + #deliverKernelServiceMessage. Thirteenth ocap-kernel ingest, fifth kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

`#deliverSend(item)` turns a `send` item's `#routeMessage` result into an actual delivery, and its density is in the **reference-count bookkeeping it performs on every exit path** and its **three failure modes that all degrade to a splat**. On a splat route (`null`), it decrements the refcount of the target, the message's result promise, and *every argument slot* — the messages's held references are being dropped, so their counts must fall. On a live send route, it may hit an endpoint that **vanished** between routing and delivery (a `#getEndpoint` throw, e.g. the vat terminated but its ownership entries were not yet swept): that is caught and treated as a splat, rejecting the result with `ENDPOINT_UNREACHABLE` and decrementing the same references. For a surviving endpoint it sets the result promise's **decider** to the target endpoint, translates the kernel-scoped target and message down to the endpoint's **eref** scope (`translateRefKtoE` / `translateMessageKtoE`), and calls `endpoint.deliverMessage`; a *delivery* throw (e.g. a full remote queue) rejects the result with `DELIVERY_FAILED` but is deliberately **not** allowed to crash the run loop. The `endpointId === 'kernel'` case routes to `#deliverKernelServiceMessage` → `#invokeKernelService` (the [[ocap-kernel]] kernel-service surface). A **requeue** route (no `endpointId`) instead enqueues the message onto the promise via `enqueuePromiseMessage`.

## Body

### The splat path: refcount cleanup for a dropped message

```ts
async #deliverSend(item: RunQueueItemSend): Promise<CrankResult | undefined> {
  const route = this.#routeMessage(item);
  let crankResult: CrankResult | undefined;

  // Message went splat
  if (!route) {
    this.#kernelStore.decrementRefCount(item.target, 'deliver|splat|target');
    if (item.message.result) {
      this.#kernelStore.decrementRefCount(
        item.message.result,
        'deliver|splat|result',
      );
    }
    for (const slot of item.message.methargs.slots) {
      this.#kernelStore.decrementRefCount(slot, 'deliver|splat|slot');
    }
    this.#logger?.log(
      `@@@@ message went splat ${item.target}<-${JSON.stringify(item.message)}`,
    );
    return crankResult;
  }
```

A **splat** (the `null` route from [`#routeMessage`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--route-message-splat-send-requeue.md)) drops the message, so every reference the message was keeping alive must be released: the **target** kref, the **result** promise kref (if any), and each **slot** in the marshalled `methargs`. The string tags (`'deliver|splat|target'` etc.) are the store's refcount-audit labels — ocap-kernel threads a provenance string through each `decrementRefCount` so the GC log records *why* a count fell. Note that `#routeMessage` already resolved the result promise (with the rejection error) before returning `null`; `#deliverSend` here handles only the *refcount* consequence of the drop.

### The endpoint-vanished catch: a routing/delivery race that degrades to a splat

```ts
if (!isKernelServiceMessage) {
  try {
    endpoint = this.#getEndpoint(endpointId);
  } catch {
    // TODO: Narrow this catch to the expected error type (e.g.,
    // VatNotFoundError) so that unexpected errors are not silently
    // swallowed and deliverable messages are not incorrectly discarded.
    // Endpoint vanished (e.g., vat terminated but ownership entries not
    // yet cleaned up). Treat the same as a splat.
    if (message.result) {
      const promise = this.#kernelStore.getKernelPromise(message.result);
      this.#kernelQueue.resolvePromises(promise.decider, [
        [
          message.result,
          true,
          makeKernelError(
            'ENDPOINT_UNREACHABLE',
            'Target endpoint is unreachable (terminated or disconnected)',
          ),
        ],
      ]);
      this.#kernelStore.decrementRefCount(message.result, 'deliver|splat|result');
    }
    this.#kernelStore.decrementRefCount(target, 'deliver|splat|target');
    for (const slot of message.methargs.slots) {
      this.#kernelStore.decrementRefCount(slot, 'deliver|splat|slot');
    }
    this.#logger?.log(
      `@@@@ message went splat (endpoint gone) ${target}<-${JSON.stringify(message)}`,
    );
    return crankResult;
  }
}
```

Even though `routeAsSend` verified the object had an owner, the owner endpoint can disappear between routing and delivery (the comment: "vat terminated but ownership entries not yet cleaned up"). `#getEndpoint` throws in that window, and the router treats it as a late splat: reject the result with `ENDPOINT_UNREACHABLE`, decrement the same references as a normal splat. This branch also carries a candid `TODO` acknowledging a **real limitation**: the bare `catch` swallows *any* throw, so an unexpected internal error would be misclassified as an endpoint-gone splat and a deliverable message silently discarded. It is not comment-versus-code drift — the code does exactly what the comment says — but it is a self-flagged sharp edge worth surfacing to a sibling reader.

### Decider assignment and kref→eref translation for a live endpoint

```ts
if (endpoint || isKernelServiceMessage) {
  if (message.result) {
    this.#kernelStore.setPromiseDecider(message.result, endpointId);
    this.#kernelStore.decrementRefCount(message.result, 'deliver|send|result');
  }
}
if (endpoint) {
  const eid = endpointId as EndpointId;
  const endpointTarget = this.#kernelStore.translateRefKtoE(eid, target, false);
  const endpointMessage = this.#kernelStore.translateMessageKtoE(eid, message);
  try {
    crankResult = await endpoint.deliverMessage(endpointTarget, endpointMessage);
  } catch (error) {
    // Delivery failed (e.g., remote queue full). Reject the kernel promise
    // so the caller knows the message wasn't delivered.
    this.#logger?.error(`Delivery to ${endpointId} failed:`, error);
    if (message.result) {
      const detail = error instanceof Error ? error.message : String(error);
      this.#kernelQueue.resolvePromises(endpointId, [
        [message.result, true, makeKernelError('DELIVERY_FAILED', detail)],
      ]);
    }
    // Continue processing other messages - don't let one failure crash the queue
  }
}
```

Two ocap-kernel mechanisms are in this block:

- **The result promise's decider becomes the target endpoint.** `setPromiseDecider(message.result, endpointId)` hands the *authority to resolve* the caller's result promise to the endpoint the message is being delivered to — the vat that receives the message is now the one entitled to resolve its result. (For a `'kernel'`-addressed message the decider is likewise set to `'kernel'`.)
- **kref → eref translation.** The kernel names objects in the global **kref** scope; a vat sees only its own **eref** (vref∪rref) scope. `translateRefKtoE(eid, target, false)` and `translateMessageKtoE(eid, message)` project the target and the whole marshalled message down into the endpoint's local c-list namespace before `deliverMessage`. This is the four-scope reference discipline in action at the delivery boundary — the [[ocap-kernel]] concept's kref/vref/rref/eref split is *why* a translation step exists here that Endo's single-formula-scope model does not need.
- **A delivery throw does not crash the queue.** If `deliverMessage` throws (the comment's example: "remote queue full"), the result is rejected with `DELIVERY_FAILED` carrying the error detail, and the loop deliberately continues — "don't let one failure crash the queue." This is the crank-level fault isolation: a single undeliverable message rejects its caller rather than aborting the whole run.

After a successful (or swallowed-failure) delivery, the target kref and each arg slot are refcount-decremented under the `deliver|send|…` labels — the send-path counterpart of the splat cleanup.

### The kernel-service branch and the requeue tail

```ts
} else if (isKernelServiceMessage) {
  crankResult = this.#deliverKernelServiceMessage(target, message);
} else {
  Fail`no owner for kernel object ${target}`;
}
// ...
} else {
  this.#kernelStore.enqueuePromiseMessage(target, message);
}
```

```ts
#deliverKernelServiceMessage(target: KRef, message: KernelMessage): CrankResult {
  this.#invokeKernelService(target, message);
  return { didDelivery: 'kernel' };
}
```

When the route's `endpointId` is the sentinel `'kernel'` (`isKernelServiceMessage`), the message is not for a vat at all — it is for a **kernel service object**, so it bypasses endpoint translation entirely and goes to `#invokeKernelService`, returning a `{ didDelivery: 'kernel' }` crank result. This is the router's edge onto the `KernelServiceManager` surface the [[ocap-kernel]] kernel-guide describes (services registered by name, run in kernel context). Finally, the outermost `else` — reached when the route had a `target` but **no `endpointId`** (a **requeue**) — calls `enqueuePromiseMessage(target, message)`, buffering the message on the unresolved promise so it will be re-delivered when the promise resolves.

## Notice / drift check

Each comment matches its code: the "message went splat" logs sit on the two splat paths; the endpoint-vanished comment correctly describes the terminated-vat race and honestly flags (in the `TODO`) that the bare `catch` is over-broad; the `DELIVERY_FAILED` comment matches the reject-and-continue behaviour; the "don't let one failure crash the queue" comment matches the empty `catch` tail. No comment-versus-code contradiction in this cluster. The one item worth a sibling reader's attention is the acknowledged `TODO`: the code is correct *as documented*, but the maintainers themselves note the catch should be narrowed to `VatNotFoundError` so unexpected errors are not misfiled as endpoint-gone splats — a latent-bug flag the authors already carry, not a drift finding. ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

kref↔eref translation at the delivery boundary is the SwingSet **c-list** mechanism (kernel-object-table ↔ per-vat clist), and the refcount-on-every-exit-path discipline is SwingSet's reference-counting GC. The garden's comparative interest: Endo's CapTP does the equivalent import/export table translation per-session rather than through one central kernel store, and Endo's persistence is by formula-graph traversal rather than by kernel-owned refcounts. See [[ocap-kernel]], the store-backed refcount substrate ([kernel-store README](metamask-ocap-kernel--packages-kernel-store-readme--storage-abstractions-and-implementations-package-purpose.md)), and the decider-authority concept this file assigns per delivery ([KernelQueue.ts decider-authorized resolution](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md)).

Source: [packages/ocap-kernel/src/KernelRouter.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelRouter.ts) (lines 196-341) at commit `d979a06`.
