---
title: "VatHandle as the vat's endpoint handle: the dual RPC wiring (client sends commands in, service dispatches syscalls out)"
source: packages/ocap-kernel/src/vats/VatHandle.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatHandle.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatHandle.ts
source_line_range: "42-136"
source_branch: main
source_commit: d54aa5ceb3ed41a182b5044dd27a95f07bac5a07
source_date: 2026-04-21
comment_subject: VatHandle is the kernel-side handle for one vat — an EndpointHandle that owns the vat's duplex stream, its per-vat KernelStore slice, and a VatSyscall bridge, and wires two RPC endpoints in opposite directions — an RpcClient that sends kernel-to-vat commands (initVat, deliver, ping) over the stream and an RpcService that dispatches the syscalls the vat sends back.
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-07-05
ingested_by: scholar
topics: [capability-security, eventual-send]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the VatHandle constructor / class-field wiring. Eleventh ocap-kernel ingest, third kernel-internals comment-fragment (after KernelQueue.ts and Kernel.ts). See [[ocap-kernel]].
---

## Abstract

`VatHandle` is the kernel's per-vat **endpoint handle** — the object the kernel holds for exactly one running vat, implementing the `EndpointHandle` interface it shares with the remote-comms endpoints. Its constructor is where the vat's whole I/O surface is assembled, and the sharpest structural fact is that it wires **two RPC endpoints pointed in opposite directions**: an `RpcClient` that carries **kernel → vat** commands (`initVat`, `deliver`, `ping`) written onto the vat's duplex stream, and an `RpcService` that dispatches the **vat → kernel** traffic (the vat's syscalls) into a `VatSyscall` bridge. The handle also owns the vat's slice of persistent state (`kernelStore.makeVatStore(vatId)`) and namespaces every outbound request id with the vat's own id (`` `${vatId}:` ``) so responses route back unambiguously. The class is a private-constructor / static-async-`make` pair (see the sibling lifecycle section); this section covers the field decomposition the constructor lays down.

## Body

### The class and its fields

```ts
/**
 * Handles communication with and lifecycle management of a vat.
 */
export class VatHandle implements EndpointHandle {
  readonly vatId: VatId;              // the vat this handle is for
  readonly #vatStream: VatStream;     // duplex channel to/from the vat worker
  readonly config: VatConfig;
  readonly #logger: Logger | undefined;
  readonly #allowedGlobalNames: AllowedGlobalName[] | undefined;
  readonly #kernelStore: KernelStore; // kernel-wide persistent state
  readonly #vatStore: VatStore;       // THIS vat's persistent state slice
  readonly #vatSyscall: VatSyscall;   // bridges vat syscalls into the kernel
  readonly #kernelQueue: KernelQueue;
  readonly #rpcClient: RpcClient<typeof vatMethodSpecs>;
  readonly #rpcService: RpcService<typeof vatSyscallHandlers>;
}
```

The one-line class comment — "Handles communication with and lifecycle management of a vat" — is the whole contract: this object *is* the vat, as far as the rest of the kernel is concerned. Everything else in the file is the two halves of that sentence: communication (the two RPC endpoints over the stream) and lifecycle (`make` / `#init` / `terminate`).

### The vat's own persistent-state slice

The constructor derives the vat's durable store from the kernel-wide store:

```ts
this.#kernelStore = kernelStore;
this.#vatStore = kernelStore.makeVatStore(vatId);
```

`#kernelStore` is the shared, kernel-global state; `#vatStore` is *this* vat's private key-value slice, carved from it by id. The delivery path commits into `#vatStore` (see the delivery-surface section); the decider-promise and vat-deletion bookkeeping on termination goes through `#kernelStore`. The split is the persistence-boundary counterpart of the ocap boundary: a vat can only touch its own KV data, never a sibling's.

### Two RPC endpoints, opposite directions

The two remaining fields are the communication surface, and their asymmetry is the section's centerpiece:

```ts
// kernel -> vat: send commands, namespaced by this vat's id
this.#rpcClient = new RpcClient(
  vatMethodSpecs,
  async (request) => {
    await this.#vatStream.write(request);
  },
  `${this.vatId}:`,
);

// vat -> kernel: dispatch the syscalls the vat emits
this.#rpcService = new RpcService(vatSyscallHandlers, {
  handleSyscall: (params) => {
    this.#vatSyscall.handleSyscall(params as VatSyscallObject);
  },
});
```

- The **`RpcClient`** is the *outbound* half. It is constructed against `vatMethodSpecs` (the methods the kernel may call on a vat — `initVat`, `deliver`, `ping`), and its transport is a closure that `write`s the request onto `#vatStream`. Its third argument, `` `${this.vatId}:` ``, prefixes each request id so a response arriving on the shared stream can be attributed to the right vat.
- The **`RpcService`** is the *inbound* half. It is constructed against `vatSyscallHandlers` (the syscalls a vat may invoke on the kernel), and every dispatched call is funneled into `this.#vatSyscall.handleSyscall(...)`. `VatSyscall` (constructed just above, endowed with the `kernelQueue`, `kernelStore`, and a `syscall`-tagged sub-logger) is the actual bridge from the vat's syscall vocabulary into kernel effects.

The two objects share one physical channel (`#vatStream`) but split its traffic by JSON-RPC message kind — a design the `#handleMessage` demultiplexer (covered in the lifecycle section) enforces: responses go to the client, notifications to the service.

## Notice / drift check

The comments in this cluster are accurate JSDoc: the field comments ("Communications channel to and from the vat itself", "Storage holding this vat's persistent state", "The vat's syscall") each match the field they annotate, and the two RPC directions are exactly as the constructor bodies wire them. No comment-versus-code drift in this cluster.

## Lineage note

The vat as an isolated compute unit reached only through a handle, and the syscall vocabulary a vat uses to ask the kernel for effects, are SwingSet-derived (`@agoric/swingset-liveslots` supplies the `VatSyscallObject` / `VatOneResolution` types imported at the top of the file). The garden's interest is comparative: Endo's daemon reaches a worker over a `@endo/stream` duplex and a CapTP session rather than a JSON-RPC client/service pair, so the two-endpoints-over-one-stream shape here is a concrete alternative wiring for the same "kernel drives an isolated worker" problem. See [[ocap-kernel]] and the run-loop that ultimately calls this handle's `deliver*` methods, [KernelQueue.ts forever-run-loop section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md).

Source: [packages/ocap-kernel/src/vats/VatHandle.ts](https://github.com/MetaMask/ocap-kernel/blob/d54aa5ceb3ed41a182b5044dd27a95f07bac5a07/packages/ocap-kernel/src/vats/VatHandle.ts) (lines 42-136) at commit `d54aa5c`.
