---
source: packages/ocap-kernel/src/KernelServiceManager.ts
source_kind: comment-fragment
source_repo: MetaMask/ocap-kernel
source_path: packages/ocap-kernel/src/KernelServiceManager.ts
source_line_range: "1-202"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
comment_subject: KernelServiceManager owns the kernel's privileged in-kernel service objects — a dual-indexed (by name, by kref), pinned, persisted registry plus the fire-and-forget invokeKernelService that dispatches through E() and resolves the caller's promise in a later turn so a service can waitForCrank() without deadlocking the crank, normalizing every failure to DELIVERY_FAILED.
source_date: 2026-04-07
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
notes: |
  Fourteenth ocap-kernel ingest and the SIXTH kernel-internals comment-fragment
  source (after KernelQueue.ts, Kernel.ts, VatHandle.ts, VatSupervisor.ts, and
  KernelRouter.ts). KernelServiceManager is the receiving end of
  KernelRouter's endpointId==='kernel' branch (#invokeKernelService), closing
  the kernel-service delivery leg the KernelRouter ingest left open. 202 lines,
  JSDoc-dense (~67 comment-lines). Its longform comments yield two coherent
  argument clusters: the service registry (a KernelService record — name, kref,
  service object, systemOnly flag — held in a deliberate dual index by name and
  by kref; registerKernelServiceObject dedups by name and provisions a kref at
  most once per name across kernel history, minting a 'kernel'-owned object,
  persisting the name→kref binding, and pinning it so a held/stored service
  reference is GC-exempt and survives restart; unregister reverses all of it;
  three thin readers the router consumes); and invokeKernelService (the dispatch
  that deliberately does NOT await the service method — it unserializes
  [method,args], calls through E() so a local object or a remote CapTP presence
  both work, and promise-chains the resolution into a future turn as the
  'kernel' decider, the design that lets a service method waitForCrank() without
  deadlocking the crank that invoked it; success carries kser(resultValue); an
  async rejection and a synchronous throw both normalize to a DELIVERY_FAILED
  kernel error — the same code the router uses for a failed vat delivery; a
  message with no result promise just logs). SwingSet-lineage; reference-not-
  substrate stance. Idempotency anchor is source_commit (file-path-specific sha
  d979a06). No comment-versus-code drift found in either cluster; one design
  observation recorded (the pin/unpin pairing is the whole GC-safety story for
  service krefs, so an unregister while a vat still holds the kref dangles that
  reference — handled gracefully as a splat by the router, not a contradiction).
  Remaining files from the cycle-161 plan (streams/BaseDuplexStream.ts,
  kernel-utils/exo.ts) stay queued under the follow-on plan job
  scholar-ingest-ocap-kernel-comment-fragments-6.
---

> Abstract: `packages/ocap-kernel/src/KernelServiceManager.ts` is the kernel's
> registry of **privileged in-kernel service objects** that vats reach by
> `E()`-sending to a **kref**, and it is the object [`KernelRouter`](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md)'s
> `endpointId === 'kernel'` branch delivers into via `#invokeKernelService` — the
> **receiving end** of the kernel-service delivery leg the KernelRouter ingest
> left open. The file splits into two comment clusters. The **service registry**:
> a `KernelService` record (`name`, `kref`, the JavaScript `service` object, a
> `systemOnly` privilege flag) held in a deliberate **dual index** (one `Map` by
> name, one by kref) so both "does this name exist" and "is this kref a service"
> are O(1); `registerKernelServiceObject` dedups by name and provisions a kref at
> most once per name across the kernel's history — minting a `'kernel'`-owned
> object, persisting the name→kref binding, and **`pinObject`**-ing it so a
> held-or-stored service reference is GC-exempt and survives restart — while
> `unregisterKernelServiceObject` reverses every step and three thin readers
> (`getKernelService` / `getKernelServiceByKref` / `isKernelService`) are the
> surface the router consumes. And **`invokeKernelService`**: the dispatch that
> deliberately **does NOT await** the service method — it unserializes
> `[method, args]`, calls the method **through `E()`** (so a local object and a
> remote CapTP presence both work), and promise-chains the resolution into a
> future turn as the `'kernel'` decider, the design that lets a service method
> call `waitForCrank()` without deadlocking the crank that invoked it; success
> carries `kser(resultValue)`, while an async rejection and a synchronous throw
> both normalize to a `DELIVERY_FAILED` kernel error (the same code the router
> uses for a failed vat delivery).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [service-registry-registration-and-dual-index](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts--service-registry-registration-and-dual-index.md) | capability-security, persistence | current |
| [invoke-fire-and-forget-and-crank-deadlock-avoidance](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts--invoke-fire-and-forget-and-crank-deadlock-avoidance.md) | eventual-send, capability-security | current |

Parent index section file: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts.md).

## Provenance

- Fetched 2026-07-06 from the local bare clone `worktrees/metamask-ocap-kernel.git` at `main` HEAD `a3eff0efb`; the file's own path-specific commit is `d979a06325666af32ca7f68b13e9c85486d89ab5` (last touched 2026-04-07 by #917, "branded kernel identifiers with runtime validation").
- Authors over the file's history: Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar (`git log` over the path).
- 202 lines, JSDoc-dense (~67 comment-lines); the two sections map to lines 10-134 (the `KernelService` type, the dual index, register/unregister/lookup) and 136-201 (`invokeKernelService`).
- **Fourteenth ocap-kernel ingest; sixth kernel-internals comment-fragment.** Genre: sibling-implementation / reference-not-substrate. Synthesizing concept [[ocap-kernel]]. The receiving end of `KernelRouter.#invokeKernelService`.
- No comment-versus-code drift found in either cluster (each section carries its own Notice / drift check). One design observation is recorded: the pin/unpin pairing is the whole GC-safety story for service krefs, so an `unregister` while a vat still holds the kref dangles that reference (the vat's later send splats as a no-owner target, handled gracefully by the router's `#deliverSend`) — a sharp edge, not a comment/code contradiction. ocap-kernel is a read-only reference shelf, not a garden fork, so no boatman missive is available regardless.
