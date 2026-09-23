---
title: "The KernelRouter as the run-queue delivery demultiplexer: the deliver() dispatch over run-queue-item types and the promise-state-based delivery model"
source: packages/ocap-kernel/src/KernelRouter.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelRouter.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelRouter.ts
source_line_range: "25-110"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: KernelRouter is the object that routes a run-queue item to the correct endpoint — sending messages, resolving promises, and dropping imports — and its deliver() method dispatches on the run-queue-item type; the class JSDoc states the promise-state-based delivery model (unresolved → requeue, fulfilled → forward to resolution target, rejected → reject the message's result promise).
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-05
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the KernelRouter class comment + deliver() dispatch. Thirteenth ocap-kernel ingest, fifth kernel-internals comment-fragment (after KernelQueue.ts, Kernel.ts, VatHandle.ts, VatSupervisor.ts). See [[ocap-kernel]].
---

## Abstract

`packages/ocap-kernel/src/KernelRouter.ts` is the kernel's **message router** — "responsible for routing messages to the correct endpoint, including sending messages, resolving promises, and dropping imports." It is the object the `Kernel.ts` orchestrator and the `KernelQueue.ts` run loop lean on to turn one dequeued **run-queue item** into an actual delivery at a **vat** (or at the **kernel service** endpoint). Its single public method, `deliver(item)`, is a `switch` on the item's `type` that fans out to one private handler per kind: `send` → `#deliverSend`, `notify` → `#deliverNotify`, the three GC actions (`dropExports` / `retireExports` / `retireImports`) → `#deliverGCAction`, and `bringOutYourDead` → `#deliverBringOutYourDead`. The class's JSDoc states the **promise-state-based delivery model** that the `send` path implements: a message whose target is a *promise* is delivered per the kernel's model of that promise's state — **unresolved** ⇒ buffered on that promise's queue, **fulfilled** ⇒ forwarded to the resolution target, **rejected** ⇒ the message's own result promise is rejected with the target's rejection value. A `notify` item, symmetrically, updates the kernel's model of the notified promise, moves any messages that were buffered on it onto the run queue, and forwards the resolution to the promise's subscribers.

## Body

### The class and its five collaborators

```ts
/**
 * The KernelRouter is responsible for routing messages to the correct endpoint.
 *
 * This class is responsible for routing messages to the correct endpoint, including
 * sending messages, resolving promises, and dropping imports.
 */
export class KernelRouter {
  /** The kernel's store. */
  readonly #kernelStore: KernelStore;

  /** The kernel's queue. */
  readonly #kernelQueue: KernelQueue;

  /** A function that returns an endpoint handle for a given endpoint id. */
  readonly #getEndpoint: (endpointId: EndpointId) => EndpointHandle;

  /** A function that invokes a method on a kernel service. */
  readonly #invokeKernelService: (target: KRef, message: KernelMessage) => void;

  /** The logger, if any. */
  readonly #logger: Logger | undefined;
```

The router owns no state of its own; it is a pure function of five injected collaborators. Two are the kernel's own subsystems — the `#kernelStore` (the persistent object/promise/refcount database) and the `#kernelQueue` (the run loop that both feeds the router and receives its promise resolutions). The other two are **function** dependencies threaded down from the `Kernel` orchestrator rather than object references: `#getEndpoint(endpointId)` resolves a vat's id to its live [`EndpointHandle`](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--endpoint-handle-and-dual-rpc-wiring.md) (a `VatHandle`), and `#invokeKernelService(target, message)` is the escape hatch for messages addressed to the kernel itself rather than to a vat (the `KernelServiceManager` surface). Passing these two as closures — instead of the manager objects — keeps the router decoupled from *how* an endpoint or a service is looked up.

### deliver(): one dispatch per run-queue-item type

```ts
async deliver(item: RunQueueItem): Promise<CrankResult | undefined> {
  switch (item.type) {
    case 'send':
      return await this.#deliverSend(item);
    case 'notify':
      return await this.#deliverNotify(item);
    case 'dropExports':
    case 'retireExports':
    case 'retireImports':
      return await this.#deliverGCAction(item);
    case 'bringOutYourDead':
      return await this.#deliverBringOutYourDead(item);
    default:
      // @ts-expect-error Runtime does not respect "never".
      Fail`unsupported or unknown run queue item type ${item.type}`;
  }
  return undefined;
}
```

`deliver` is called once per **crank** by the run loop ([KernelQueue.ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md) `run()` dequeues the item and hands it here). Its return is a `CrankResult | undefined` — the delivery's outcome (an illegal-syscall verdict, a vat-requested exit, or a plain `didDelivery`) that the run loop uses to decide whether to commit or roll back the crank's store savepoint. The three GC-action cases collapse to one handler because `#deliverGCAction` derives the endpoint method name from the item's `type` string (see the GC section). The `default` arm is defense-in-depth: `Fail` throws on an item the TypeScript `never`-narrowing says is impossible, because "runtime does not respect never" — a malformed persisted run-queue entry must fail loudly, not fall through.

### The promise-state-based delivery model (the deliver JSDoc)

The class's most substantive comment is the `deliver` method's JSDoc, which states the delivery *semantics* the `#routeMessage` / `#deliverSend` / `#deliverNotify` code below enacts:

```
 * If the item being delivered is message whose target is a promise, it is
 * delivered based on the kernel's model of the promise's state:
 * - unresolved: it is put onto the queue that the kernel maintains for that promise
 * - fulfilled: it is forwarded to the promise resolution target
 * - rejected: the result promise of the message is in turn rejected according
 *   to the kernel's model of the promise's rejection value
 *
 * If the item being delivered is a notification, the kernel's model of the
 * state of the promise being notified is updated, and any queue items
 * enqueued for that promise are placed onto the run queue. The notification
 * is also forwarded to all of the promise's registered subscribers.
```

This is the router's contract in one paragraph. The **send** half is realized in `#routeMessage`'s three outcomes (the [route section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--route-message-splat-send-requeue.md)): *unresolved* becomes a **requeue** onto the promise's buffer, *fulfilled* becomes a **send** to the extracted resolution target, *rejected* becomes a **splat** that resolves the message's result promise with the rejection. The **notify** half is realized in [`#deliverNotify`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-notify-promise-resolution-and-gc-actions.md). The "any queue items enqueued for that promise are placed onto the run queue" clause describes work the router *triggers* but does not itself perform — the actual re-enqueue of buffered messages happens inside `KernelQueue.resolvePromises` when a promise is resolved (the [decider-authorized-resolution](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md) path); the JSDoc is describing the *aggregate* delivery model, correctly, from the router's vantage.

## Notice / drift check

The class JSDoc ("routing messages to the correct endpoint, including sending messages, resolving promises, and dropping imports") maps cleanly onto `deliver`'s four dispatch arms: *sending messages* = `send`, *resolving promises* = `notify`, *dropping imports* = the three GC actions, and `bringOutYourDead` is the reap sweep. The `deliver` JSDoc's promise-state trichotomy (unresolved/fulfilled/rejected) matches `#routeMessage`'s `switch (promise.state)` exactly. No comment-versus-code drift in this cluster. One accuracy note for the sibling-reader: the JSDoc's "any queue items enqueued for that promise are placed onto the run queue" is a true statement about the *notify* delivery's effect, but that re-enqueue is executed by `KernelQueue`, not by any line in `KernelRouter` — the comment describes the model, not this file's mechanics, and is not misleading. ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

The run-queue-item vocabulary (`send` / `notify` / `dropExports` / `retireExports` / `retireImports` / `bringOutYourDead`) and the promise-state delivery model are SwingSet-derived — the same run-queue-of-cranks shape Agoric's SwingSet kernel uses, and `bringOutYourDead` is SwingSet's reaping term verbatim. The garden's interest is comparative: Endo's daemon has no analogous centralized message router because its objects address each other over CapTP sessions rather than through one kernel-owned run queue; `KernelRouter` is where ocap-kernel concentrates the routing decision Endo distributes across CapTP endpoints. See [[ocap-kernel]], the run loop that feeds this router ([KernelQueue.ts forever-run-loop section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md)), and the kernel-guide's host-facing description of the same demultiplexing ([eventual-send-with-e](metamask-ocap-kernel--docs-kernel-guide-md--eventual-send-with-e.md)).

Source: [packages/ocap-kernel/src/KernelRouter.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelRouter.ts) (lines 25-110) at commit `d979a06`.
