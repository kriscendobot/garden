---
title: "The make / #init lifecycle: a fire-and-forget stream drain that self-terminates the vat on a read error"
source: packages/ocap-kernel/src/vats/VatHandle.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatHandle.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatHandle.ts
source_line_range: "138-219"
source_branch: main
source_commit: d54aa5ceb3ed41a182b5044dd27a95f07bac5a07
source_date: 2026-04-21
comment_subject: VatHandle uses a private-constructor / static-async make pair so the vat is only ever handed out fully initialized; #init starts an unawaited background drain of the vat's stream (whose only failure path is to terminate the vat with a StreamReadError) and then awaits the initVat delivery, and #handleMessage demultiplexes stream traffic into responses (to the RpcClient) versus notifications (to the RpcService).
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-07-05
ingested_by: scholar
topics: [daemon, eventual-send]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the VatHandle make/#init lifecycle and stream-drain. Eleventh ocap-kernel ingest, third kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

`VatHandle` is never `new`-ed by callers: its constructor is `private` and the only way in is the static async **`make`**, which constructs the instance, runs **`#init`**, and throws if the first delivery failed — so a `VatHandle` that escapes `make` is always fully initialized and its vat has answered `initVat`. `#init` itself does two things: it kicks off an **unawaited, fire-and-forget drain** of the vat's stream whose *sole* failure handler is to terminate the vat with a `StreamReadError`, and then it **awaits** the `initVat` command that boots the vat with its persisted KV state. The background drain routes each inbound message through `#handleMessage`, which **demultiplexes** the single stream: JSON-RPC *responses* go to the outbound `RpcClient`, JSON-RPC *notifications* (the vat's syscalls) go to the inbound `RpcService`, and anything else throws. This is the async-construction pattern: the visible handle is synchronous to hold but its liveness is carried by a detached read loop.

## Body

### Private constructor, static make

```ts
static async make(params: VatConstructorProps): Promise<VatHandle> {
  const vat = new VatHandle(params);
  const [, deliveryError] = await vat.#init();
  if (deliveryError) {
    throw new Error(`Failed to initialize vat ${vat.vatId}: ${deliveryError}`);
  }
  return vat;
}
```

The `private constructor` (annotated `// eslint-disable-next-line no-restricted-syntax`) makes `make` the sole entry point. The contract is: no half-built vat handles exist. If `initVat` returns a delivery error, `make` throws rather than returning a handle to a vat that never booted.

### The fire-and-forget drain and its only failure path

```ts
async #init(): Promise<VatDeliveryResult> {
  Promise.all([this.#vatStream.drain(this.#handleMessage.bind(this))]).catch(
    async (error) => {
      this.#logger?.error(`Unexpected read error`, error);
      await this.terminate(
        true,
        new StreamReadError({ vatId: this.vatId }, error),
      );
    },
  );

  return await this.sendVatCommand({
    method: 'initVat',
    params: {
      vatConfig: this.config,
      state: this.#vatStore.getKVData(),
      ...(this.#allowedGlobalNames
        ? { allowedGlobalNames: this.#allowedGlobalNames }
        : {}),
    },
  });
}
```

The first statement is **deliberately not awaited**. `#vatStream.drain(...)` runs forever, pumping each inbound message into `#handleMessage`; `#init` fires it and moves on. The `.catch(...)` is the entire error policy for the vat's read side: any drain failure logs an "Unexpected read error" and **terminates the vat** (with `terminating = true`) carrying a `StreamReadError` tagged with the `vatId`. So the read loop's only exit is vat death — a broken channel to the worker is unrecoverable, and the handle tears the vat down rather than limping. The `Promise.all([...])` wrapper around the single drain promise is incidental (a one-element all); the load-bearing part is the detached `.catch`.

The second statement is **awaited**: `initVat` hands the vat its config, its persisted KV state (`#vatStore.getKVData()` — resuscitation from the durable slice), and, when configured, the endowment allowlist. Its `VatDeliveryResult` is what `make` inspects.

### #handleMessage: demultiplexing one stream by message kind

```ts
async #handleMessage(message: JsonRpcMessage): Promise<void> {
  if (isJsonRpcResponse(message)) {
    this.#rpcClient.handleResponse(message.id as string, message);
  } else if (isJsonRpcNotification(message)) {
    this.#rpcService.assertHasMethod(message.method);
    await this.#rpcService.execute(message.method, message.params);
  } else {
    // We don't expect any JSON-RPC requests from the vat, but the stream may permit them
    throw new Error(`Received unexpected message: ${message}`);
  }
}
```

This is where the two RPC endpoints of the wiring section actually split the shared channel. A **response** is the vat answering a kernel command — routed to `#rpcClient.handleResponse`. A **notification** is the vat *initiating* a syscall — validated against the known method set (`assertHasMethod`) and executed by `#rpcService`. A full JSON-RPC *request* from the vat is unexpected (the vat is not supposed to call the kernel request/response-style) and throws; the comment flags that the stream type permits it even though the protocol does not.

## Notice / drift check

The comments are accurate. The inline note "We don't expect any JSON-RPC requests from the vat, but the stream may permit them" correctly describes the `else` branch: `isJsonRpcResponse` and `isJsonRpcNotification` are the two handled kinds, and a request falls through to the throw. The `make`/`#init` JSDoc matches the two-step (drain then initVat) body. No comment-versus-code drift in this cluster.

## Lineage note

Async construction behind a static `make`, and a detached read loop whose failure collapses the endpoint, are general patterns for driving an isolated worker over a stream; the SwingSet lineage supplies the `initVat` / delivery vocabulary. Endo's daemon likewise boots a worker and pumps a duplex, but reaches it through CapTP rather than a JSON-RPC client/service split, and its supervision of a dead read side is structured differently. The comparative point: here a read error is *always* fatal to the vat, encoded in a single `.catch` on an unawaited drain. See [[ocap-kernel]], the sibling [dual-RPC-wiring section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--endpoint-handle-and-dual-rpc-wiring.md) for the two endpoints this demultiplexer feeds, and the [KernelQueue.ts run-loop section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md) for the crank loop that drives the awaited `deliver*` side.

Source: [packages/ocap-kernel/src/vats/VatHandle.ts](https://github.com/MetaMask/ocap-kernel/blob/d54aa5ceb3ed41a182b5044dd27a95f07bac5a07/packages/ocap-kernel/src/vats/VatHandle.ts) (lines 138-219) at commit `d54aa5c`.
