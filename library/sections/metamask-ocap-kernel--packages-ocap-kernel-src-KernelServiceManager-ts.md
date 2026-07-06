---
title: "KernelServiceManager.ts (MetaMask/ocap-kernel) — the kernel-service registry and invocation surface: a pinned, persisted, dual-indexed service table plus the fire-and-forget invokeKernelService that dodges crank deadlock"
source: packages/ocap-kernel/src/KernelServiceManager.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelServiceManager.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelServiceManager.ts
source_line_range: "1-202"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: KernelServiceManager owns the kernel's privileged in-kernel service objects — registration (dedup by name, provision-and-pin a persisted 'kernel'-owned kref, dual index by name and by kref), unregistration (reverse all of it), a read surface (getKernelService / getKernelServiceByKref / isKernelService) the router uses to classify a kernel-bound target, and invokeKernelService, which deliberately does not await the service method (E()-dispatch + promise-chaining so a service can waitForCrank without deadlocking the crank, with all failures normalized to DELIVERY_FAILED).
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-06
ingested_by: scholar
topics: [capability-security, persistence, eventual-send]
status: current
kind: index
section_count: 2
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Sixth kernel-internals comment-fragment ingest from the cycle-161 overview plan (after KernelQueue.ts, Kernel.ts, VatHandle.ts, VatSupervisor.ts, and KernelRouter.ts); the receiving end of KernelRouter's endpointId==='kernel' branch (#invokeKernelService), closing the kernel-service delivery leg. See [[ocap-kernel]] concept for the lineage flag.
---

## Abstract

`packages/ocap-kernel/src/KernelServiceManager.ts` "manages kernel services registration and invocation" — it is the kernel's registry of **privileged in-kernel service objects** that vats reach by `E()`-sending to a **kref**, and it is the object [`KernelRouter`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md)'s `endpointId === 'kernel'` branch delivers into via `#invokeKernelService`. It is the **receiving end** of the kernel-service delivery leg the KernelRouter ingest left open. The 202-line file splits into two comment clusters the section files below curate.

First, the **service registry**: a `KernelService` record (`name`, `kref`, the JavaScript `service` object, a `systemOnly` privilege flag) held in a deliberate **dual index** — one `Map` keyed by name, one by kref — so both "does this name exist" and "is this kref a service" are O(1). `registerKernelServiceObject` **dedups by name** (a duplicate throws) and provisions a kref **at most once per name across the kernel's history**: it consults the persistent kernel store, and only on a miss does it `initKernelObject('kernel')` (mint a kernel-owned ref), `setKernelServiceKref` (persist the name→kref binding), and **`pinObject`** it (GC-exempt, so a vat may hold or store the service reference indefinitely). `unregisterKernelServiceObject` reverses every step; `getKernelService` / `getKernelServiceByKref` / `isKernelService` are the read surface the router consumes.

Second, **`invokeKernelService`**: the dispatch that deliberately **does NOT await** the service method. It unserializes `[method, args]`, calls the method **through `E()`** (so a local object and a remote CapTP presence both work), and attaches a `.then/.catch` that resolves the caller's kernel result promise **in a future turn** with the `'kernel'` decider — the design that lets a service method call `waitForCrank()` without deadlocking the very crank that invoked it. Success carries `kser(resultValue)`; an async rejection and a synchronous throw both normalize to a `DELIVERY_FAILED` kernel error (the same code the router uses for a failed vat delivery); a message with no result promise just logs.

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo and Agoric work, never imports its code. It is the **sixth** kernel-internals comment-fragment ingest (after `KernelQueue.ts`, `Kernel.ts`, `VatHandle.ts`, `VatSupervisor.ts`, and `KernelRouter.ts`); where `KernelRouter` decides a dequeued message is kernel-bound and calls `#invokeKernelService`, this file is what that call reaches.

## Sections

- [The kernel-service registry: registration with kref pinning, unregistration, and the dual by-name / by-kref index](metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts--service-registry-registration-and-dual-index.md)
- [invokeKernelService: fire-and-forget dispatch via E(), promise-chaining to avoid crank deadlock, and three-path DELIVERY_FAILED resolution](metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts--invoke-fire-and-forget-and-crank-deadlock-avoidance.md)

## See also

- Source index: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts](../sources/metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts.md)
- Synthesizing concept: [[ocap-kernel]]
- The router leg that calls into this file (`endpointId === 'kernel'` → `#invokeKernelService`): [metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md), specifically its [#deliverSend section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md)
- The decider-authority resolution rule these resolutions obey (only the owner may resolve; here the owner is `'kernel'`): [metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md)
- The `waitForCrank` deadlock hazard `invokeKernelService`'s fire-and-forget design avoids: [metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--crank-reentrancy-and-the-terminate-callback-deadlock](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--crank-reentrancy-and-the-terminate-callback-deadlock.md)
- The host-facing description of the same service surface (register by name, validated at launch, run in kernel context; syscall → router → KernelServiceManager path): [metamask-ocap-kernel--docs-kernel-guide-md--kernel-services](metamask-ocap-kernel--docs-kernel-guide-md--kernel-services.md)
- The pin/refcount substrate registration leans on: [metamask-ocap-kernel--packages-kernel-store-readme--storage-abstractions-and-implementations-package-purpose](metamask-ocap-kernel--packages-kernel-store-readme--storage-abstractions-and-implementations-package-purpose.md)

Source: [packages/ocap-kernel/src/KernelServiceManager.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelServiceManager.ts) at commit `d979a06`.
