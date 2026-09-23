---
title: "Kernel as orchestrator: the manager decomposition and the constructor wiring graph"
source: packages/ocap-kernel/src/Kernel.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/Kernel.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/Kernel.ts
source_line_range: "43-222"
source_branch: main
source_commit: 052f4d4865b39df29f8f67fdffa3c52ef17b4282
source_date: 2026-05-12
comment_subject: The Kernel class is a thin orchestrator that owns a graph of single-responsibility managers (vat, subcluster, remote, OCAP-URL, kernel-service, IO) plus the run queue, router, and store, and wires them together in a dependency-ordered constructor.
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security, daemon]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the class-doc + manager-field + constructor-wiring cluster in Kernel.ts. See [[ocap-kernel]].
---

## Abstract

The `Kernel` class in `packages/ocap-kernel/src/Kernel.ts` is not where the kernel's mechanism lives; it is a **thin orchestrator** that owns a graph of single-responsibility collaborators and delegates almost every public method straight through to one of them. The class field comments name nine of them: `#vatManager` (vat lifecycle), `#subclusterManager` (subcluster operations), `#remoteManager` (remote kernel connections), `#ocapURLManager` (OCAP URL issuing and redemption), `#kernelServiceManager` (kernel-service registration and invocation), `#ioManager` (IO channel lifecycle, optional, requires factory injection), plus the `#kernelQueue` (run queue), `#kernelRouter` (router), and `#kernelStore` (persistent state). The private constructor builds these in a **dependency order** that is itself the architecture: store first, then the queue (passed a terminate callback that deliberately bypasses `VatManager.terminateVat`), then the managers that each take `kernelStore` + `kernelQueue`, then the router (which takes the store, the queue, an endpoint resolver, and the service-invoker), and finally `harden(this)`. Reading the constructor top to bottom is reading the kernel's collaborator graph.

## Body

### The class comment frames the kernel as a lifecycle manager

The class-level JSDoc states the responsibility in one line:

> The main class for the ocap kernel. It is responsible for managing the lifecycle of the kernel and the vats.

Everything else in the file is the enactment of "managing the lifecycle." The public surface (launch/terminate subcluster, restart/terminate vat, queueMessage, issue/redeem OCAP URL, register kernel service, revoke, getStatus, reset, stop) is almost entirely one-line delegation to a manager. The kernel's own code is the *wiring*, not the work.

### The managers are named by single responsibility

Each private field carries a one-line comment naming exactly one responsibility:

```ts
/** Manages vat lifecycle operations */
readonly #vatManager: VatManager;

/** Manages subcluster operations */
readonly #subclusterManager: SubclusterManager;

/** Manages remote kernel connections */
readonly #remoteManager: RemoteManager;

/** Manages OCAP URL issuing and redemption */
readonly #ocapURLManager: OcapURLManager;

/** Manages kernel service registration and invocation */
readonly #kernelServiceManager: KernelServiceManager;
```

Alongside the managers sit the three substrate collaborators: `#kernelStore` ("Storage holding the kernel's own persistent state"), `#kernelQueue` ("The kernel's run queue"), and `#kernelRouter` ("The kernel's router"). The optional `#ioManager` is explicitly flagged "optional, requires factory injection" — it exists only when an `ioChannelFactory` is supplied. The `#platformServices` field carries the framing comment for the whole host-boundary idea: a "Service to do things the kernel worker can't do: network communications and spawning workers (in iframes) for vats to run in." That sentence is the kernel's host-portability contract in miniature: anything the worker sandbox cannot do is reached only through injected platform services.

### The constructor is a dependency-ordered wiring graph

The private constructor builds the collaborator graph in an order dictated by who depends on whom:

1. **Store first.** `makeKernelStore(kernelDatabase, logger)`, then a one-time `markInitialized()` if the store is fresh. An optional `resetStorage` triggers `#resetKernelState` (covered in the sibling section on incarnation identity).
2. **Queue second**, constructed with a terminate callback that deliberately calls `#vatManager.stopVat(...)` rather than `terminateVat`, with an inline comment explaining the crank-reentrancy deadlock that bypass avoids (covered in the sibling section on crank reentrancy).
3. **The store-plus-queue managers.** `VatManager`, `RemoteManager`, then `OcapURLManager` (which takes only the remote manager), then `KernelServiceManager`. Each manager is handed a `subLogger({ tags: [...] })` so its log lines are attributable.
4. **The optional IO manager**, built only `if (options.ioChannelFactory)`, wired to the service manager's register/unregister methods.
5. **The subcluster manager**, which needs the most: store, queue, vat manager, a `getKernelService` closure, a bound `queueMessage`, and the IO manager when present.
6. **The router last**, taking the store, the queue, a bound `#getEndpoint` resolver, and the service manager's bound `invokeKernelService`. The router needs the endpoint resolver, so it is built after the managers that resolve endpoints.

The constructor closes by registering the OCAP URL issuer and redemption services with the service manager, then `harden(this)`. The static `Kernel.make(...)` is the only public construction path: it news the private constructor and then awaits `#init` (covered in the sibling section on the startup sequence).

### Why this matters to the garden

The garden reads ocap-kernel as a sibling implementation. The lesson here is structural, not importable: a SwingSet-lineage kernel can be decomposed into a constellation of narrow managers behind a thin orchestrator, with the run queue and store as shared substrate threaded into each. Endo's daemon plays the analogous orchestrator role; the manager-per-responsibility split (and the discipline of giving each its own tagged sub-logger) is a pattern worth comparing against the daemon's own internal structure.

## Lineage note

The vat/subcluster/remote/store/queue/router vocabulary is recognizably Agoric SwingSet-derived. ocap-kernel's distinctive moves visible here are the explicit **manager-per-concern** decomposition and the **platform-services injection boundary** that keeps everything the worker cannot do (network, worker spawning) behind one injected interface. See [[ocap-kernel]] for the lineage flag and the package-README cluster that first observed the architectural substance lives in this file rather than the near-stub `@metamask/ocap-kernel` README.

Source: [packages/ocap-kernel/src/Kernel.ts](https://github.com/MetaMask/ocap-kernel/blob/052f4d4865b39df29f8f67fdffa3c52ef17b4282/packages/ocap-kernel/src/Kernel.ts) (lines 43-222) at commit `052f4d4`.
