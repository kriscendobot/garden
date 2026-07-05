---
source: packages/ocap-kernel/src/KernelRouter.ts
source_kind: comment-fragment
source_repo: MetaMask/ocap-kernel
source_path: packages/ocap-kernel/src/KernelRouter.ts
source_line_range: "1-437"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
comment_subject: KernelRouter is the kernel's run-queue delivery demultiplexer — a deliver() dispatch over run-queue-item types, a #routeMessage that resolves a send to splat/send/requeue by kref scope and promise state, a #deliverSend that does refcount bookkeeping on every exit and degrades a vanished endpoint or failed delivery to a splat with kref→eref translation, and a #deliverNotify plus GC-action deliveries that carry promise resolutions and drop/retire instructions to a vat.
source_date: 2026-04-07
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-05
ingested_by: scholar
section_count: 4
status: current
notes: |
  Thirteenth ocap-kernel ingest and the FIFTH kernel-internals comment-fragment
  source (after KernelQueue.ts, Kernel.ts, VatHandle.ts, and VatSupervisor.ts).
  KernelRouter is the message router the Kernel.ts orchestrator (via #getEndpoint
  and deliver) and the KernelQueue run loop lean on: it turns one dequeued
  run-queue item into a delivery at a vat endpoint (a VatHandle) or at the
  kernel-service surface. It is the routing decision that sits between the run
  loop (KernelQueue) and the two ends of the kernel↔vat duplex link
  (VatHandle / VatSupervisor). 437 lines, JSDoc-dense (~104 comment-lines). Its
  longform comments yield four coherent argument clusters: the router and its
  promise-state delivery model (a stateless class over five injected
  collaborators; deliver() dispatches on run-queue-item type; the class JSDoc
  states the unresolved⇒requeue / fulfilled⇒forward / rejected⇒reject
  trichotomy); the three-outcome #routeMessage (splat/send/requeue encoded in the
  MessageRoute type, dispatched by kref scope and promise state, with the current
  decider used as resolver on a splat and isRevoked/getOwner capability checks on
  a send); the refcount-bookkeeping #deliverSend (decrements on every exit path
  with provenance tags; a vanished #getEndpoint degraded to an ENDPOINT_UNREACHABLE
  splat with a self-flagged over-broad-catch TODO; decider assignment + kref→eref
  translation before deliverMessage; a delivery throw rejected as DELIVERY_FAILED
  without crashing the queue; the endpointId==='kernel' branch to
  #invokeKernelService); and the c-list-gated #deliverNotify plus GC deliveries
  (idempotent short-circuits on missing c-list entry or empty retire-set;
  eref-scoped VatOneResolution tuples with precise per-promise refcount decrements;
  #deliverGCAction derives deliverDropExports/deliverRetireExports/
  deliverRetireImports from the item type; #deliverBringOutYourDead reaps).
  SwingSet-lineage; reference-not-substrate stance. Idempotency anchor is
  source_commit (file-path-specific sha d979a06). No comment-versus-code drift
  found in any of the four clusters; two honest non-drift observations recorded:
  the endpoint-vanished bare catch carries the maintainers' own TODO that it
  should be narrowed to VatNotFoundError (a self-flagged latent bug, not a
  contradiction), and one #deliverNotify inline comment ("the promise being
  notified") is slightly loose about which promise is decremented in-loop vs at
  the tail (the code is correct). Remaining kernel-internals files from the
  cycle-161 plan (KernelServiceManager.ts, streams/BaseDuplexStream.ts,
  kernel-utils/exo.ts) stay queued under the follow-on plan job
  scholar-ingest-ocap-kernel-comment-fragments-5.
---

> Abstract: `packages/ocap-kernel/src/KernelRouter.ts` is the kernel's **message
> router** — "responsible for routing messages to the correct endpoint,
> including sending messages, resolving promises, and dropping imports." It is
> the demultiplexer the `Kernel.ts` orchestrator (via `#getEndpoint` and
> `deliver`) and the `KernelQueue.ts` run loop lean on to turn one dequeued
> **run-queue item** into a delivery at a vat endpoint (a `VatHandle`) or at the
> kernel-service surface. The file splits into four comment clusters. The
> **router and its promise-state delivery model**: a stateless class over five
> injected collaborators whose single public `deliver(item)` is a `switch` on the
> item type fanning out to one handler per kind, and whose JSDoc states the
> promise-state trichotomy (unresolved ⇒ requeue, fulfilled ⇒ forward to the
> resolution target, rejected ⇒ reject the message's result promise).
> **`#routeMessage`'s three outcomes**: `splat` (drop, `null` return, optionally
> rejecting the result with the current *decider* as resolver), `send`
> (`{ endpointId, target }`, gated by `isRevoked` and `getOwner`), and `requeue`
> (`{ target }`, no endpoint) — dispatched by **kref scope** and, for a promise,
> by its fulfilled/rejected/unresolved state. **`#deliverSend`'s bookkeeping and
> failure degradation**: refcount decrements on every exit path (with provenance
> tags), a vanished endpoint degraded to an `ENDPOINT_UNREACHABLE` splat, decider
> assignment plus **kref→eref translation** before `deliverMessage`, a delivery
> throw rejected as `DELIVERY_FAILED` without crashing the queue, and the
> `endpointId === 'kernel'` branch to `#invokeKernelService`. **`#deliverNotify`
> and the GC deliveries**: a c-list-gated, idempotent promise-resolution
> notification that translates a retire-set to eref-scoped `VatOneResolution`
> tuples and decrements refcounts precisely, plus `#deliverGCAction` (deriving the
> `deliver…` method name from the item type) and the `bringOutYourDead` reap
> sweep.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [router-and-promise-state-delivery-model](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--router-and-promise-state-delivery-model.md) | eventual-send, capability-security | current |
| [route-message-splat-send-requeue](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--route-message-splat-send-requeue.md) | eventual-send, capability-security | current |
| [deliver-send-refcount-and-endpoint-vanished-splat](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md) | capability-security, persistence | current |
| [deliver-notify-promise-resolution-and-gc-actions](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-notify-promise-resolution-and-gc-actions.md) | eventual-send, persistence | current |

Parent index section file: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md).

## Provenance

- Fetched 2026-07-05 from the local bare clone `worktrees/metamask-ocap-kernel.git` at `main` HEAD `a3eff0efb`; the file's own path-specific commit is `d979a06325666af32ca7f68b13e9c85486d89ab5` (last touched 2026-04-07 by #917, "branded kernel identifiers with runtime validation").
- Authors over the file's history: Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar (`git log` over the path).
- 437 lines, JSDoc-dense (~104 comment-lines); the four sections map to lines 25-110 (class + `deliver` dispatch + promise-state model), 112-194 (`#routeMessage` three-outcome route), 196-341 (`#deliverSend` + `#deliverKernelServiceMessage`), and 343-436 (`#deliverNotify` + `#deliverGCAction` + `#deliverBringOutYourDead`).
- **Thirteenth ocap-kernel ingest; fifth kernel-internals comment-fragment.** Genre: sibling-implementation / reference-not-substrate. Synthesizing concept [[ocap-kernel]]. The routing decision between the run loop (`KernelQueue.ts`) and the kernel↔vat endpoint pair (`VatHandle.ts` / `VatSupervisor.ts`).
- No comment-versus-code drift found in any of the four clusters (each section carries its own Notice / drift check). Two honest non-drift observations are recorded: the endpoint-vanished bare `catch` in `#deliverSend` carries the maintainers' own `TODO` that it should be narrowed to `VatNotFoundError` (a self-flagged latent bug, not a comment/code contradiction), and one `#deliverNotify` inline comment ("the promise being notified") is slightly loose about which promise the in-loop vs tail decrement covers (the code is correct). ocap-kernel is a read-only reference shelf, not a garden fork, so no boatman missive is available regardless.
