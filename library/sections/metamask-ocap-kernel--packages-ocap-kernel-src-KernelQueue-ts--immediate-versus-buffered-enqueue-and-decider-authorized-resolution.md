---
title: Immediate-versus-buffered enqueue, reference-counting, and decider-authorized resolution
source: packages/ocap-kernel/src/KernelQueue.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelQueue.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelQueue.ts
source_line_range: "182-376"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: Vat-side effects are buffered until crank commit while remote effects are immediate; every enqueued reference is reference-counted; and only a promise's designated decider may resolve it.
source_authors: [Erik Marks, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-06-28
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. Comment-fragment ingest of the enqueue / flush / resolvePromises cluster in KernelQueue.ts; the decider check is a capability-security invariant. See [[ocap-kernel]].
---

## Abstract

The back half of `KernelQueue` is the message-and-resolution machinery, and it turns on three disciplines. First, an `immediate` flag (default `true`) decides whether an enqueue takes effect now or is **buffered for crank completion**: vat syscalls pass `immediate = false` so their notifications, sends, and kernel-subscription callbacks are deferred until `#flushCrankBuffer` runs on a successful crank, while remote message handling passes the default so effects are immediate. This flag is what makes a vat's outputs part of the crank's atomic commit. Second, **every reference placed on the queue is reference-counted**: `enqueueSend` increments the target, the result, and each argument slot (`queue|target`, `queue|result`, `queue|slot`); `enqueueNotify` increments the promise (`notify`); `resolvePromises` increments the resolved promise and its resolution slots (`resolve|kpid`, `resolve|slot`). Third, resolution is **decider-authorized**: `resolvePromises` refuses to resolve a promise that is not `'unresolved'` (`Fail` "was already resolved") and refuses any resolver that is not the promise's recorded `decider` (`Fail` "not permitted to resolve ... because its decider is ..." or "it has no decider"). The wake thunk from the run loop is fired here, by `#enqueueRun`, when the queue transitions from empty to length one.

## Body

### The immediate flag: buffer vat effects, apply remote effects now

`resolvePromises`, `enqueueSend`, and `enqueueNotify` all take an `immediate` flag that defaults to `true`. The `resolvePromises` comment states the contract:

> When immediate is false (for vat syscalls), notifications and kernel subscription callbacks are deferred until the crank buffer is flushed on successful crank completion. When immediate is true (for remote message handling), effects are immediate.

`enqueueSend` and `enqueueNotify` route accordingly:

```ts
if (immediate) {
  this.#enqueueRun(item);
} else {
  this.#kernelStore.bufferCrankOutput(item);
}
```

Buffered items are released only by `#flushCrankBuffer`, which moves them to the run queue and then invokes kernel subscriptions:

```ts
const items = this.#kernelStore.flushCrankBuffer();
for (const item of items) {
  this.#enqueueRun(item);
  if (item.type === 'notify') {
    // Invoke kernel subscription callback if any, reading resolution
    // data from the (now committed) promise state
    this.#invokeKernelSubscription(item.kpid);
  }
}
// Invoke kernel subscriptions for promises resolved during this crank
// that don't have kernel-level subscribers (e.g., promises from enqueueMessage)
for (const kpid of this.#resolvedWithKernelSubscription) {
  this.#invokeKernelSubscription(kpid);
}
```

The comment "reading resolution data from the (now committed) promise state" is the point: the callback fires only after the crank committed, so it observes committed state, never a value that a later rollback could undo.

### Reference-counting every enqueued reference

The queue is a GC root, so each reference it holds is counted with a tagged reason. `enqueueSend`:

```ts
this.#kernelStore.incrementRefCount(target, 'queue|target');
if (message.result) {
  this.#kernelStore.incrementRefCount(message.result, 'queue|result');
}
for (const slot of message.methargs.slots || []) {
  this.#kernelStore.incrementRefCount(slot, 'queue|slot');
}
```

`enqueueNotify` increments the notified promise (`'notify'`), and `resolvePromises` increments the resolved promise (`'resolve|kpid'`) and each slot carried in its resolution data (`'resolve|slot'`). These tagged increments pair with the per-crank `collectGarbage()` so the GC-action priority at the top of the next crank can reclaim anything no longer referenced.

### enqueueMessage: the kernel subscribing to its own send

`enqueueMessage` is how the kernel itself sends a message and awaits the result as a JS promise:

```ts
const result = this.#kernelStore.initKernelPromise()[0];
const { promise, resolve, reject } = makePromiseKit<CapData<KRef>>();
this.subscriptions.set(result, { resolve, reject });
this.enqueueSend(target, { methargs: kser([method, args]), result });
return promise;
```

It allocates a kernel promise for the result, registers a kernel subscription (the `subscriptions` map: "Message results that the kernel itself has subscribed to"), enqueues the send, and hands back a JS promise the caller can await. `#invokeKernelSubscription` later settles that JS promise from the committed kernel-promise state, rejecting if the kernel promise rejected and resolving otherwise.

### Decider-authorized resolution

`resolvePromises` enforces who may resolve a promise. This is the capability-security invariant of the cluster:

```ts
const promise = this.#kernelStore.getKernelPromise(kpid);
const { state, decider, subscribers } = promise;
if (state !== 'unresolved') {
  Fail`${kpid} was already resolved`;
}
if (decider !== endpointId) {
  const why = decider ? `its decider is ${decider}` : `it has no decider`;
  Fail`${endpointId} not permitted to resolve ${kpid} because ${why}`;
}
if (!subscribers) {
  throw Fail`${kpid} subscribers not set`;
}
```

Only the endpoint recorded as the promise's `decider` may resolve it, and only once. On a valid resolution the method enqueues a notification to every subscriber, enqueues any messages that had been queued against the now-resolved promise (`resolveKernelPromise` returns them), and either invokes the kernel subscription immediately or, when buffering, records the promise in `#resolvedWithKernelSubscription` for invocation at flush time.

### Firing the wake thunk on empty-to-non-empty transition

`#enqueueRun` is the producer side of the run loop's sleep/wake protocol:

```ts
this.#kernelStore.enqueueRun(item);
if (this.#kernelStore.runQueueLength() === 1 && this.#wakeUpTheRunQueue) {
  const wakeUpTheRunQueue = this.#wakeUpTheRunQueue;
  this.#wakeUpTheRunQueue = null;
  wakeUpTheRunQueue();
}
```

When an enqueue takes the queue from empty to length one and the loop is parked, it consumes the single-use thunk (nulling it first, satisfying the run loop's "cannot sleep again before the previous wake handler is consumed" guard) and wakes the loop.

## Lineage note

The `immediate` buffering flag and the decider-authorized resolution are both SwingSet-lineage. The decider check is the same capability-security rule Agoric's kernel and the broader ocap promise model enforce: a promise has exactly one party entitled to decide it, and the kernel rejects any other resolver by name. The garden reads this as a clean in-code statement of the invariant, not as code to import. See [[eventual-send]] for the promise-and-pipelining model and [[ocap-kernel]] for the lineage flag.

Source: [packages/ocap-kernel/src/KernelQueue.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelQueue.ts) (lines 182-376) at commit `d979a06`.
