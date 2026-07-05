---
title: "#routeMessage: the three-outcome route (splat / send / requeue) and promise-target resolution by kref scope"
source: packages/ocap-kernel/src/KernelRouter.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelRouter.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelRouter.ts
source_line_range: "112-194"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: "#routeMessage resolves a send item to one of three outcomes — splat (drop, null return, optionally rejecting the result promise), send (deliver to a specific object at a specific endpoint), or requeue (buffer back onto the run queue for an unresolved promise) — dispatching on whether the target is a promise-ref and, if so, on the promise's fulfilled/rejected/unresolved state."
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-05
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of KernelRouter's #routeMessage core demultiplexer. Thirteenth ocap-kernel ingest, fifth kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

`#routeMessage(item)` is the heart of the router: it takes a `send` run-queue item and computes its **destination route**, "consist[ing] of an endpointId and a destination object reference." Its JSDoc names exactly **three possible outcomes**, and the return type `MessageRoute` (`{ endpointId?; target } | null`) encodes all three: **splat** — drop the message, signalled by a `null` return (and, if the message carried a result promise, that promise is rejected with an error); **send** — deliver to a specific object at a specific endpoint, a full `{ endpointId, target }`; **requeue** — put the message back on the run queue for later delivery, signalled by a route that has a `target` but **no `endpointId`**. The routing decision turns on whether the message's `target` is a **promise-ref** (a `kp…` kref) or an **object-ref**: an object-ref routes straight to `routeAsSend`; a promise-ref dispatches on the kernel's model of that promise's `state` — **fulfilled** extracts the resolution's single object ref (and requeues if it is *itself* another promise, else sends), **rejected** splats with the promise's stored rejection value, **unresolved** requeues onto the promise so the message waits for resolution.

## Body

### The three outcomes, and how they are encoded

```ts
/**
 * Determine a message's destination route based on the target type and
 * state. In the most general case, this route consists of an endpointId and a
 * destination object reference.
 *
 * There are three possible outcomes:
 * - splat: message should be dropped (with optional error resolution),
 *   indicated by a null return value
 * - send: message should be delivered to a specific object at a specific endpoint
 * - requeue: message should be put back on the run queue for later delivery
 *   (for unresolved promises), indicated by absence of a target endpoint in the
 *   return value
 */
#routeMessage(item: RunQueueItemSend): MessageRoute {
```

The `MessageRoute` type — `{ endpointId?: EndpointId | 'kernel'; target: KRef } | null` — is a compact three-state signal, and the JSDoc is the key to reading it: `null` = splat, `{ endpointId, target }` = send, `{ target }` (no endpointId) = requeue. `#deliverSend` (the [deliver-send section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md)) then branches on precisely these three shapes.

### The three route-builder closures

`#routeMessage` opens by defining three local closures, one per outcome:

```ts
const routeAsSplat = (error?: CapData<KRef>): MessageRoute => {
  if (message.result && error) {
    // Use the current decider as the resolver. After a crank rollback,
    // the decider may have reverted to the sending vat rather than the
    // (now-terminated) target vat.
    const promise = this.#kernelStore.getKernelPromise(message.result);
    this.#kernelQueue.resolvePromises(promise?.decider, [
      [message.result, true, error],
    ]);
  }
  return null;
};
const routeAsSend = (targetObject: KRef): MessageRoute => {
  if (this.#kernelStore.isRevoked(targetObject)) {
    return routeAsSplat(
      makeKernelError('OBJECT_REVOKED', 'Target object has been revoked'),
    );
  }
  const endpointId = this.#kernelStore.getOwner(targetObject);
  if (!endpointId) {
    return routeAsSplat(
      makeKernelError(
        'OBJECT_DELETED',
        'Target object has no owner; it may have been deleted',
      ),
    );
  }
  return { endpointId, target: targetObject };
};
const routeAsRequeue = (targetObject: KRef): MessageRoute => {
  return { target: targetObject };
};
```

Three points of ocap-kernel design are visible here:

- **`routeAsSplat` rejects the caller's result promise, not silently.** A dropped message is not a silent no-op when the sender is waiting on a result: it rejects `message.result` with the supplied `CapData` error, so the caller sees a rejection rather than a hang. The comment explains the subtlety of *whose* authority resolves it: it uses **the promise's current `decider`** as the resolver, because "after a crank rollback, the decider may have reverted to the sending vat rather than the (now-terminated) target vat." The `decider` is the ocap-kernel authority-to-resolve concept (see the [decider-authorized-resolution section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md)); reaching for it here keeps resolution authority correct even across a rollback.
- **`routeAsSend` is where two capability-security checks live.** Before returning a live route it consults the store twice: `isRevoked(targetObject)` splats a **revoked** object with `OBJECT_REVOKED` (ocap-kernel's first-class revocation, enacted at the routing boundary), and `getOwner(targetObject)` splats an owner-less object with `OBJECT_DELETED`. Only an object that is neither revoked nor deleted yields a `{ endpointId, target }` send route.
- **`routeAsRequeue` carries only the target.** No endpoint — that absence *is* the requeue signal.

### Promise-target resolution by kref scope

The routing decision itself:

```ts
if (isPromiseRef(target)) {
  const promise = this.#kernelStore.getKernelPromise(target);
  switch (promise.state) {
    case 'fulfilled': {
      if (promise.value) {
        const targetObject = extractSingleRef(promise.value);
        if (targetObject) {
          if (isPromiseRef(targetObject)) {
            return routeAsRequeue(targetObject);
          }
          return routeAsSend(targetObject);
        }
      }
      return routeAsSplat(
        makeKernelError(
          'BAD_PROMISE_RESOLUTION',
          'Promise fulfilled but did not contain an object reference',
        ),
      );
    }
    case 'rejected':
      return routeAsSplat(promise.value);
    case 'unresolved':
      return routeAsRequeue(target);
    default:
      throw Fail`unknown promise state ${promise.state}`;
  }
} else {
  return routeAsSend(target);
}
```

The demultiplexing is by **kref scope** — `isPromiseRef(target)` distinguishes a promise kref (`kp…`) from an object kref (`ko…`), the four-scope reference discipline the [[ocap-kernel]] concept flags as its sharpest divergence from Endo:

- **Object-ref target** → `routeAsSend` directly.
- **Promise-ref, `fulfilled`** → `extractSingleRef` the resolution value. If it is *itself another promise* → `routeAsRequeue` (chase the chain on a later crank); if it is an object → `routeAsSend`; if the fulfilled promise held no object ref at all → splat with `BAD_PROMISE_RESOLUTION`.
- **Promise-ref, `rejected`** → `routeAsSplat(promise.value)`, forwarding the promise's *own* stored rejection value as the message-result rejection (this is the deliver-JSDoc's "the result promise of the message is in turn rejected according to the kernel's model of the promise's rejection value").
- **Promise-ref, `unresolved`** → `routeAsRequeue(target)`, buffering the message on the promise itself so it waits for a future resolution.
- **Any other `state`** → `Fail`, the loud fail on a corrupt persisted promise record.

## Notice / drift check

The JSDoc's three-outcome enumeration (splat/send/requeue) matches the three closures and the `MessageRoute` shape one-to-one, and its "absence of a target endpoint in the return value" description of requeue matches `routeAsRequeue` returning `{ target }` with no `endpointId`. The `routeAsSplat` decider comment accurately describes the post-rollback decider-reversion it guards against. The fulfilled/rejected/unresolved switch matches the deliver-method JSDoc's promise-state trichotomy. No comment-versus-code drift in this cluster.

## Lineage note

Promise-target routing — buffering a message on an unresolved promise and forwarding it once the promise fulfils to an object — is the kernel-side mechanism under `@endo/eventual-send`'s promise pipelining: the *same* `E(E(x).foo()).bar()` chaining that Endo resolves through handled-promise forwarding, ocap-kernel resolves through this `fulfilled → extractSingleRef → requeue-if-promise-else-send` loop over persistent kernel promises. See [[promise-pipelining]], [[ocap-kernel]], and the buffered-enqueue counterpart in [KernelQueue.ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md).

Source: [packages/ocap-kernel/src/KernelRouter.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelRouter.ts) (lines 112-194) at commit `d979a06`.
