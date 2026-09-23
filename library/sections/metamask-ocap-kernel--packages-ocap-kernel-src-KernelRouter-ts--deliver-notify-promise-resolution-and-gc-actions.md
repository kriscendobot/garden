---
title: "#deliverNotify and the GC deliveries: c-list-gated promise-resolution notification with kpid retirement, and the derived-method-name dropExports/retireExports/retireImports/bringOutYourDead deliveries"
source: packages/ocap-kernel/src/KernelRouter.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelRouter.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelRouter.ts
source_line_range: "343-436"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: "#deliverNotify delivers a promise resolution to an endpoint — asserting the target is a resolved kernel promise, short-circuiting when the endpoint has no c-list entry or nothing to retire, translating the resolutions to eref scope, and decrementing refcounts for the retired and notified promises; the three GC actions share #deliverGCAction which derives the endpoint method name (deliverDropExports/…) from the item type, and #deliverBringOutYourDead calls the reaping sweep."
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-05
ingested_by: scholar
topics: [eventual-send, persistence]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of KernelRouter's #deliverNotify + #deliverGCAction + #deliverBringOutYourDead. Thirteenth ocap-kernel ingest, fifth kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

The remaining `deliver` arms handle **promise-resolution notifications** and **garbage-collection actions**. `#deliverNotify(item)` delivers the news that a kernel promise resolved to one subscribing endpoint: it asserts the notified `kpid` is a *resolved* kernel promise (`Fail` on an unresolved one), then applies two idempotence short-circuits — if the endpoint has **no c-list entry** for the promise (`krefToEref` returns nothing) or there are **no kpids to retire** (`getKpidsToRetire` returns empty), the notification is already done, so it returns early. Otherwise it builds a `VatOneResolution[]` by translating each retired promise's ref, rejected-flag, and value down to the endpoint's **eref** scope, decrementing the refcount of each *transitively-retired* promise (all but the notified one), delivers the batch via `endpoint.deliverNotify`, and finally decrements the notified promise's own refcount. The three **GC actions** (`dropExports` / `retireExports` / `retireImports`) collapse into `#deliverGCAction`, which **derives the endpoint method name from the item's `type`** (`deliverDropExports`, etc.) and forwards the still-live erefs. `#deliverBringOutYourDead` calls the endpoint's `deliverBringOutYourDead()` reap sweep.

## Body

### #deliverNotify: resolved-promise assertion and the two idempotence short-circuits

```ts
async #deliverNotify(item: RunQueueItemNotify): Promise<CrankResult> {
  const { endpointId, kpid } = item;
  const { context, isPromise } = parseRef(kpid);
  assert(context === 'kernel' && isPromise, `${kpid} is not a kernel promise`);
  // ...
  const promise = this.#kernelStore.getKernelPromise(kpid);
  const { state, value } = promise;
  assert(value, `no value for promise ${kpid}`);
  if (state === 'unresolved') {
    Fail`notification on unresolved promise ${kpid}`;
  }
  if (!this.#kernelStore.krefToEref(endpointId, kpid)) {
    // no c-list entry, already done
    return { didDelivery: endpointId };
  }
  const targets = this.#kernelStore.getKpidsToRetire(kpid, value);
  if (targets.length === 0) {
    // no kpids to retire, already done
    return { didDelivery: endpointId };
  }
```

A notify item names an `endpointId` (the subscriber to inform) and a `kpid` (the resolved promise). The method first *validates the shape*: `parseRef(kpid)` must say this is a **kernel-context promise ref** (the assertion `context === 'kernel' && isPromise`), the promise must have a `value`, and it must not be `unresolved` (delivering a notification about an unresolved promise is a `Fail`-level invariant violation). Then two **already-done** short-circuits, each returning a bare `{ didDelivery: endpointId }`:

- **No c-list entry** (`!krefToEref(endpointId, kpid)`): this endpoint has no local name for the promise — it was already retired from the endpoint's clist — so there is nothing to notify.
- **Nothing to retire** (`getKpidsToRetire` returns `[]`): the resolution transitively retires a set of kpids; if that set is empty the work was already done.

Both guards make notify **idempotent** — the same resolution can be re-driven (e.g. after a crank rollback re-enqueues the notify) without double-delivery.

### Building the eref-scoped resolution batch and the retire-refcount discipline

```ts
const resolutions: VatOneResolution[] = [];
for (const toResolve of targets) {
  const tPromise = this.#kernelStore.getKernelPromise(toResolve);
  if (tPromise.state === 'unresolved') {
    Fail`target promise ${toResolve} is unresolved`;
  }
  if (!tPromise.value) {
    throw Fail`target promise ${toResolve} has no value`;
  }
  resolutions.push([
    this.#kernelStore.translateRefKtoE(endpointId, toResolve, true),
    tPromise.state === 'rejected',
    this.#kernelStore.translateCapDataKtoE(endpointId, tPromise.value),
  ]);
  // decrement refcount for the promise being notified
  if (toResolve !== kpid) {
    this.#kernelStore.decrementRefCount(toResolve, 'deliver|notify|slot');
  }
}
const endpoint = this.#getEndpoint(endpointId);
const crankResult = await endpoint.deliverNotify(resolutions);
// Decrement reference count for processed 'notify' item
this.#kernelStore.decrementRefCount(kpid, 'deliver|notify');
return crankResult;
```

Each retired promise becomes one `VatOneResolution` tuple — `[eref, isRejected, erefValue]` — with **both** the promise ref and its `CapData` value translated to the endpoint's eref scope (`translateRefKtoE` / `translateCapDataKtoE`); the middle element is the boolean `rejected` flag. A resolution batch can retire *several* promises at once (a promise that resolves to another already-resolved promise retires both), which is why `getKpidsToRetire` returns a set and the loop builds an array. The **refcount discipline** is precise: each transitively-retired promise other than the head is decremented under `deliver|notify|slot` inside the loop, and the *notified* promise `kpid` itself is decremented under `deliver|notify` **once, after** `deliverNotify` returns — the `if (toResolve !== kpid)` guard is what keeps the head from being double-decremented (once in the loop and once at the tail).

### The GC actions: one handler, method name derived from the item type

```ts
async #deliverGCAction(item: RunQueueItemGCAction): Promise<CrankResult> {
  const { type, endpointId, krefs } = item;
  const endpoint = this.#getEndpoint(endpointId);
  const erefs = this.#kernelStore.krefsToExistingErefs(endpointId, krefs);
  const method =
    `deliver${(type[0] as string).toUpperCase()}${type.slice(1)}` as
      | 'deliverDropExports'
      | 'deliverRetireExports'
      | 'deliverRetireImports';
  const crankResult = await endpoint[method](erefs);
  return crankResult;
}
```

The three GC-action run-queue types (`dropExports`, `retireExports`, `retireImports`) share one handler because the endpoint method name is a **mechanical transform of the type string**: capitalise the first letter and prefix `deliver`, giving `deliverDropExports` / `deliverRetireExports` / `deliverRetireImports` (the `as`-union tells TypeScript the derived string is one of exactly those three). The krefs are mapped to **existing** erefs (`krefsToExistingErefs` — only those the endpoint still has a c-list entry for, since a GC action may name refs already dropped) before forwarding. This is ocap-kernel's distributed-GC delivery leg: the kernel's refcount collector decides *which* refs a vat should drop/retire, and the router carries that instruction to the vat.

### bringOutYourDead: the reap sweep

```ts
async #deliverBringOutYourDead(
  item: RunQueueItemBringOutYourDead,
): Promise<CrankResult | undefined> {
  const { endpointId } = item;
  const endpoint = this.#getEndpoint(endpointId);
  const crankResult = await endpoint.deliverBringOutYourDead();
  return crankResult;
}
```

The simplest arm: forward the SwingSet-named `bringOutYourDead` reap request to the endpoint, which runs its vat-local finalizer sweep and reports back which imports it has dropped. This is the vat-side trigger of the three-independent-GC-domains model the [[ocap-kernel]] glossary describes.

## Notice / drift check

The inline comments each match their code: "no c-list entry, already done" over the `krefToEref` guard, "no kpids to retire, already done" over the empty-`targets` guard, "decrement refcount for the promise being notified" over the in-loop slot decrement, and "Decrement reference count for processed 'notify' item" over the tail decrement. The GC-action method-name derivation matches the three-way `as`-union. No comment-versus-code drift in this cluster. (A minor readability note for a sibling reader, not drift: the in-loop comment says "the promise being notified," but the loop actually decrements each *transitively-retired target* promise, guarding *out* the notified `kpid` — the tail decrement is the one for the notified promise; the comment is slightly loose but the code is correct.) ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

`bringOutYourDead`, `dropExports`/`retireExports`/`retireImports`, and the `VatOneResolution` tuple shape are SwingSet/liveslots vocabulary imported verbatim (`VatOneResolution` from `@agoric/swingset-liveslots`). The garden's comparative interest is the *centralisation*: ocap-kernel resolves and notifies promises through one kernel-owned router with explicit kref→eref translation and refcount decrements, where Endo's daemon propagates resolutions across CapTP sessions and reclaims via formula-graph reachability. See [[ocap-kernel]], the run-loop reaping cadence ([KernelQueue.ts forever-run-loop section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md)), and the glossary's three-GC-domains description ([docs-glossary-md source](../sources/metamask-ocap-kernel--docs-glossary-md.md)).

Source: [packages/ocap-kernel/src/KernelRouter.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelRouter.ts) (lines 343-436) at commit `d979a06`.
