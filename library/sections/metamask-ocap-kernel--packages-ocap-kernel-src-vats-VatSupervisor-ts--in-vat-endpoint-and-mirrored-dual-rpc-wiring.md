---
title: "VatSupervisor as the in-vat endpoint: the mirror-image dual RPC wiring (client sends syscalls out, service handles kernel commands in) and the defense-in-depth endowment assembly"
source: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatSupervisor.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_line_range: "73-206"
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-24
comment_subject: VatSupervisor is the in-vat counterpart to the kernel-side VatHandle — it runs inside the vat worker, owns the one duplex stream to the kernel, and wires the same two RPC endpoints as VatHandle but pointed the opposite way (an RpcClient that sends the vat's syscalls OUT to the kernel, an RpcService that handles the kernel's initVat/handleDelivery commands coming IN), plus a construction-time endowment assembly guarded by two defense-in-depth asserts.
source_authors: [Dimitris Marlagkoutsos, Erik Marks, grypez]
ingested: 2026-07-05
ingested_by: scholar
topics: [capability-security, eventual-send]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the VatSupervisor class-field + constructor wiring; the in-vat mirror image of the kernel-side VatHandle dual-RPC section. Twelfth ocap-kernel ingest, fourth kernel-internals comment-fragment (after KernelQueue.ts, Kernel.ts, VatHandle.ts). See [[ocap-kernel]].
---

## Abstract

`VatSupervisor` is the **in-vat counterpart** to the kernel-side `VatHandle`: it runs *inside* the vat worker and is the object that supervises "a vat's execution, managing its lifecycle and communication with the kernel." Where `VatHandle` sits on the kernel side of one duplex stream, `VatSupervisor` sits on the vat side of the *same* stream — and the sharpest structural fact is that it wires **the same two RPC endpoints as `VatHandle`, pointed the opposite way**. Its `RpcClient` carries **vat → kernel** traffic (the syscalls the vat emits), and its `RpcService` handles **kernel → vat** commands (`initVat`, `handleDelivery`). This is the exact mirror of `VatHandle`, whose client sends kernel→vat commands and whose service dispatches vat→kernel syscalls — the two objects are the two ends of one JSON-RPC-over-duplex-stream link. The constructor also assembles the vat's endowments once, up front, guarded by **two defense-in-depth asserts** (a superstruct shape check and an explicit `harden`), and fires a fire-and-forget stream drain whose only failure path is to self-terminate the vat with a `StreamReadError` — the vat-side twin of `VatHandle`'s `#init` drain.

## Body

### The class and its fields

```ts
/**
 * Supervises a vat's execution, managing its lifecycle and communication with the kernel.
 */
export class VatSupervisor {
  /** The id of the vat being supervised */
  readonly id: VatId;

  /** Communications channel between this vat and the kernel */
  readonly #kernelStream: DuplexStream<JsonRpcMessage, JsonRpcMessage>;

  /** The logger for this vat */
  readonly #logger: Logger;

  /** RPC client for sending syscall requests to the kernel */
  readonly #rpcClient: SupervisorRpcClient;

  /** RPC service for handling requests from the kernel */
  readonly #rpcServer: RpcService<typeof vatHandlers>;

  /** Flag that the user code has been loaded */
  #loaded: boolean = false;

  /** Function to dispatch deliveries into liveslots */
  #dispatch: DispatchFn | null;

  /** In-memory KVStore cache for this vat. */
  #vatKVStore: VatKVStore | undefined;
  // ... endowment fields (see the initVat section)
}
```

The one-line class comment — "Supervises a vat's execution, managing its lifecycle and communication with the kernel" — is the mirror of `VatHandle`'s "Handles communication with and lifecycle management of a vat." The field comments name each half: `#kernelStream` is the one channel; `#rpcClient` sends syscalls out; `#rpcServer` handles the kernel's requests in; `#dispatch` and `#vatKVStore` are the liveslots wiring that only exists after `initVat` (covered in the initVat section).

### Two RPC endpoints, opposite directions from VatHandle

The constructor wires the vat's I/O as two endpoints over the single `#kernelStream`:

```ts
this.#rpcClient = new RpcClient(
  vatSyscallMethodSpecs,
  async (request) => {
    await this.#kernelStream.write(request);
  },
  `${this.id}:`,
  this.#logger.subLogger({ tags: ['rpc-client'] }),
);

this.#rpcServer = new RpcService(vatHandlers, {
  initVat: this.#initVat.bind(this),
  handleDelivery: this.#deliver.bind(this),
});
```

- The **`RpcClient`** is the *outbound* half, built against `vatSyscallMethodSpecs` — the syscall vocabulary the vat may invoke on the kernel. Its transport closure `write`s onto `#kernelStream`, and (exactly as on the `VatHandle` side) it prefixes each request id with `` `${this.id}:` `` so responses on the shared stream route back to the right vat. This is the direction-flip: on the *kernel* side `VatHandle`'s `RpcClient` sends **kernel → vat** commands; here on the *vat* side the `RpcClient` sends **vat → kernel** syscalls.
- The **`RpcService`** is the *inbound* half, built against `vatHandlers` and dispatching the two commands the kernel issues to a vat — `initVat` (load user code, covered in the initVat section) and `handleDelivery` (deliver a message into liveslots). Again the mirror of `VatHandle`, whose `RpcService` dispatches the vat's *syscalls*; here the service dispatches the kernel's *commands*.

The two objects share one physical channel and split traffic by JSON-RPC message kind, enforced by the `#handleMessage` demultiplexer:

```ts
async #handleMessage(message: JsonRpcMessage): Promise<void> {
  if (isJsonRpcResponse(message)) {
    this.#rpcClient.handleResponse(message.id as string, message);
  } else if (isJsonRpcRequest(message)) {
    // ... execute on #rpcServer, write back result or serialized error
  }
}
```

Responses (to the vat's own outbound syscalls) go to the client; requests (the kernel's commands) go to the service, whose result — or a `serializeError`-wrapped fault — is written straight back onto the stream. This is the vat-side twin of `VatHandle`'s `#handleMessage` (responses → client, notifications → service).

### The endowment assembly, guarded twice

Before wiring the RPC endpoints, the constructor produces the vat's endowments once and guards them with two explicit defense-in-depth checks:

```ts
const endowments = makeAllowedGlobals({
  logger: this.#logger.subLogger({ tags: ['endowments'] }),
});
// Defense in depth: custom `MakeAllowedGlobals` factories may return the
// wrong shape (e.g., no `teardown` callable) — assert before use so the
// failure surfaces at construction rather than during termination.
assert(
  endowments,
  VatEndowmentsStruct,
  `makeAllowedGlobals returned an invalid VatEndowments value for vat "${id}"`,
);
// Defense in depth: custom `MakeAllowedGlobals` factories may skip hardening.
this.#allowedGlobals = harden(endowments.globals);
this.#endowmentsTeardown = endowments.teardown;
```

The `makeAllowedGlobals` factory is a *constructor parameter* (defaulting to `createDefaultEndowments`), so a caller can supply a custom endowment set — and the two comments say plainly that the asserts exist because that caller cannot be trusted to return a well-shaped, hardened value. The superstruct `assert` forces a malformed factory (e.g. one missing the `teardown` callable) to fail *at construction* rather than silently during termination; the explicit `harden` re-hardens the globals in case a custom factory skipped it. The `teardown` half is stashed as `#endowmentsTeardown` for the termination path (see the termination section).

### The fire-and-forget drain that self-terminates

The constructor's last act starts reading the kernel stream and arms self-termination on any read failure:

```ts
Promise.all([
  this.#kernelStream.drain(this.#handleMessage.bind(this)),
]).catch(async (error) => {
  this.#logger.error(
    `Unexpected read error from VatSupervisor "${this.id}"`,
    error,
  );
  await this.terminate(new StreamReadError({ vatId: this.id }, error));
});
```

The `drain` is *not* awaited by the constructor — it is a background loop over the whole vat lifetime — and its only failure path is to log and call `terminate(new StreamReadError(...))`. This is the vat-side twin of `VatHandle`'s `#init` drain (same `StreamReadError`, same self-terminate-on-read-error discipline). The `Promise.all([...])` wraps a single-element array; it reads as a vestige of a former multi-stream drain and is functionally just the one `drain` promise (see the Notice check).

## Notice / drift check

The field comments each match their field ("RPC client for sending syscall requests to the kernel" over the `#rpcClient` that `notify`s `'syscall'`; "RPC service for handling requests from the kernel" over the `#rpcServer` bound to `initVat`/`handleDelivery`), and both defense-in-depth comments describe exactly what the two `assert`/`harden` lines do. No comment-versus-code drift in this cluster.

One **non-drift observation** worth recording for the sibling-reader: the `Promise.all([this.#kernelStream.drain(...)])` wraps a *single* promise in an array, so the `Promise.all` is a no-op wrapper around one `drain`. It is harmless (the `.catch` still fires on the one drain's rejection) but it is dead structure — likely a leftover from a design that drained more than one stream. Not a comment/code contradiction, so it is a stylistic note, not a drift finding; and since ocap-kernel is a read-only reference shelf (not a garden fork) no boatman missive is available regardless.

## Lineage note

The two-RPC-endpoints-over-one-duplex-stream shape, the syscall vocabulary, and the `makeLiveSlots` dispatch are SwingSet-derived (`@agoric/swingset-liveslots` supplies `VatDeliveryObject` / `VatSyscallObject` / `VatSyscallResult`, imported at the top of the file). The garden's interest is comparative: Endo's daemon reaches a worker over a `@endo/stream` duplex and a CapTP session rather than a JSON-RPC client/service pair, so `VatSupervisor` + `VatHandle` together are a concrete alternative wiring for "an isolated worker and its supervisor talk over one stream." See [[ocap-kernel]], the kernel-side mirror [VatHandle dual-RPC section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--endpoint-handle-and-dual-rpc-wiring.md), and the run loop that ultimately drives these deliveries, [KernelQueue.ts forever-run-loop section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md).

Source: [packages/ocap-kernel/src/vats/VatSupervisor.ts](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/packages/ocap-kernel/src/vats/VatSupervisor.ts) (lines 73-206) at commit `175b7c0`.
