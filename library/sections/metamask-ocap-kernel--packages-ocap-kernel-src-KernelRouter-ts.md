---
title: "KernelRouter.ts (MetaMask/ocap-kernel) — the run-queue delivery demultiplexer: deliver() dispatch, the three-outcome #routeMessage, refcount-bookkeeping #deliverSend, and the c-list-gated #deliverNotify + GC deliveries"
source: packages/ocap-kernel/src/KernelRouter.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelRouter.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelRouter.ts
source_line_range: "1-437"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: KernelRouter is the object that routes a dequeued run-queue item to the correct endpoint — a deliver() dispatch over item types, a #routeMessage that resolves a send to splat/send/requeue by kref scope and promise state, a #deliverSend that does refcount bookkeeping on every exit and degrades a vanished endpoint or a failed delivery to a splat, and a #deliverNotify plus GC-action deliveries that carry promise resolutions and drop/retire instructions to a vat with kref→eref translation.
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-05
ingested_by: scholar
topics: [eventual-send, capability-security, persistence]
status: current
kind: index
section_count: 4
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Fifth kernel-internals comment-fragment ingest from the cycle-161 overview plan (after KernelQueue.ts, Kernel.ts, VatHandle.ts, and VatSupervisor.ts); the message router the Kernel.ts orchestrator's #getEndpoint/deliver and the KernelQueue run loop lean on, and the routing leg the VatHandle/VatSupervisor endpoint pair sits at the ends of. See [[ocap-kernel]] concept for the lineage flag.
---

## Abstract

`packages/ocap-kernel/src/KernelRouter.ts` is the kernel's **message router** — the object "responsible for routing messages to the correct endpoint, including sending messages, resolving promises, and dropping imports." It is the demultiplexer the [`Kernel.ts`](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts.md) orchestrator (via `#getEndpoint` and `deliver`) and the [`KernelQueue.ts`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts.md) run loop lean on to turn one dequeued **run-queue item** into a delivery at a vat endpoint (a [`VatHandle`](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts.md)) or at the kernel-service surface. The file's substance splits into four comment clusters the section files below curate.

First, the **router and its promise-state delivery model**: a stateless class over five injected collaborators (kernel store, kernel queue, `#getEndpoint`, `#invokeKernelService`, logger) whose single public `deliver(item)` is a `switch` on the item type fanning out to one handler per kind (`send` / `notify` / the three GC actions / `bringOutYourDead`), and whose JSDoc states the promise-state trichotomy — unresolved ⇒ requeue, fulfilled ⇒ forward to resolution target, rejected ⇒ reject the message's result promise. Second, **`#routeMessage`'s three outcomes**: `splat` (drop, `null` return, optionally rejecting the result with the current *decider* as resolver), `send` (`{ endpointId, target }`, gated by `isRevoked` and `getOwner` checks), and `requeue` (`{ target }`, no endpoint) — dispatched by **kref scope** (object-ref vs promise-ref) and, for a promise, by its fulfilled/rejected/unresolved state. Third, **`#deliverSend`'s bookkeeping and failure degradation**: refcount decrements on every exit path (target, result, each arg slot, with provenance tags), a vanished endpoint (`#getEndpoint` throw) degraded to an `ENDPOINT_UNREACHABLE` splat, decider assignment plus **kref→eref translation** of target and message before `deliverMessage`, a delivery throw rejected as `DELIVERY_FAILED` without crashing the queue, and the `endpointId === 'kernel'` branch to `#invokeKernelService`. Fourth, **`#deliverNotify` and the GC deliveries**: a c-list-gated, idempotent promise-resolution notification that translates a retire-set to eref-scoped `VatOneResolution` tuples and decrements refcounts precisely, plus `#deliverGCAction` (deriving `deliverDropExports`/`deliverRetireExports`/`deliverRetireImports` from the item type) and the `bringOutYourDead` reap sweep.

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo and Agoric work, never imports its code. It is the **fifth** kernel-internals comment-fragment ingest (after `KernelQueue.ts`, `Kernel.ts`, `VatHandle.ts`, and `VatSupervisor.ts`); where those describe the run loop, the orchestrator, and the two ends of the kernel↔vat duplex link, `KernelRouter` is the routing decision *between* them — the object that decides, per dequeued item, which endpoint (or which promise buffer, or the kernel service) a message goes to.

## Sections

- [The KernelRouter as the run-queue delivery demultiplexer: the deliver() dispatch over run-queue-item types and the promise-state-based delivery model](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--router-and-promise-state-delivery-model.md)
- [#routeMessage: the three-outcome route (splat / send / requeue) and promise-target resolution by kref scope](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--route-message-splat-send-requeue.md)
- [#deliverSend: refcount bookkeeping on every exit path, the endpoint-vanished-is-a-splat catch, kref↔eref translation, and the kernel-service branch](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md)
- [#deliverNotify and the GC deliveries: c-list-gated promise-resolution notification with kpid retirement, and the derived-method-name GC/bringOutYourDead deliveries](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-notify-promise-resolution-and-gc-actions.md)

## See also

- Source index: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts](../sources/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md)
- Synthesizing concept: [[ocap-kernel]]
- The run loop that dequeues the items this router delivers: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts.md), and its [forever-run-loop section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md); the decider authority `#routeMessage`/`#deliverSend` reach for lives in its [decider-authorized-resolution section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md)
- The orchestrator that constructs this router and supplies `#getEndpoint`/`deliver`: [metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts.md)
- The vat endpoint this router delivers *to* (the other side of `deliverMessage`/`deliverNotify`): [metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts.md), whose [delivery surface section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--delivery-surface-and-kv-commit-on-success.md) is the receiving end of these calls, and the in-vat mirror [VatSupervisor.ts](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts.md)
- The host-facing description of the same kref-scope demultiplexing: [metamask-ocap-kernel--docs-kernel-guide-md--eventual-send-with-e](metamask-ocap-kernel--docs-kernel-guide-md--eventual-send-with-e.md)

Source: [packages/ocap-kernel/src/KernelRouter.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelRouter.ts) at commit `d979a06`.
