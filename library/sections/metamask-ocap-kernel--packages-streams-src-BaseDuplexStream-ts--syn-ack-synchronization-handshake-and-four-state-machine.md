---
title: "The SYN/ACK synchronization handshake and its four-state machine: how a duplex stream rendezvous with its remote counterpart before any value flows"
source: packages/streams/src/BaseDuplexStream.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/streams/src/BaseDuplexStream.ts
source_kind: comment-fragment
source_path: packages/streams/src/BaseDuplexStream.ts
source_line_range: "11-71, 177-278"
source_branch: main
source_commit: 8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c
source_date: 2026-01-13
comment_subject: A BaseDuplexStream synchronizes with its remote counterpart via a SYN/ACK handshake carried as sentinel values on the value channel itself; a four-state machine (Idle/Pending/Complete/Failed) tracks the rendezvous, synchronize() is idempotent, #performSynchronization runs the symmetric SYN-then-ACK protocol with a duplicate-SYN guard and an unexpected-message failure, and #completeSynchronization/#failSynchronization are idempotent terminal transitions.
source_authors: [Erik Marks, Dimitris Marlagkoutsos]
ingested: 2026-07-06
ingested_by: scholar
topics: [streams, eventual-send]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the synchronization handshake in BaseDuplexStream.ts. Fifteenth ocap-kernel ingest; first from packages/streams; the transport substrate under VatHandle.ts / VatSupervisor.ts / KernelRouter.ts. See [[ocap-kernel]].
---

## Abstract

`packages/streams/src/BaseDuplexStream.ts` is the base of `@metamask/streams`'s **duplex stream** — "essentially a `BaseReader` with a `write()` method," backed by separate reader and writer instances under the hood. Before any value may be read or written, the two ends of a duplex link must **synchronize**: each side must know the other is alive and listening. ocap-kernel does this with a **SYN/ACK handshake** modeled on TCP's, but with a twist unique to a value-carrying stream — the handshake messages are **sentinel values sent on the stream's own value channel** (`@@Syn` / `@@Ack`), not an out-of-band control channel. A four-value `SynchronizationStatus` state machine (`Idle` → `Pending` → `Complete` | `Failed`) tracks the rendezvous; `synchronize()` is idempotent and returns a promise that resolves when the link is up; `#performSynchronization` runs the symmetric protocol (send SYN, wait for a SYN or ACK, send ACK, complete) with a guard against a **duplicate SYN** and a fail-stop on any unexpected message; and `#completeSynchronization` / `#failSynchronization` are idempotent terminal transitions that resolve or reject the shared sync promise exactly once.

## Body

### The sentinel signals and the state machine

The handshake tokens are two branded objects, distinguished from ordinary stream values by a reserved sentinel key:

```ts
export const DuplexStreamSentinel = {
  Syn: '@@Syn',
  Ack: '@@Ack',
} as const;

const SynStruct = object({ [DuplexStreamSentinel.Syn]: literal(true) });
export const isSyn = (value: unknown): value is DuplexStreamSyn => is(value, SynStruct);
export const makeSyn = (): DuplexStreamSyn => ({ [DuplexStreamSentinel.Syn]: true });
// ...isAck / makeAck are symmetric over DuplexStreamSentinel.Ack...

type DuplexStreamSignal = DuplexStreamSyn | DuplexStreamAck;
export const isDuplexStreamSignal = (value: unknown): value is DuplexStreamSignal =>
  isSyn(value) || isAck(value);
```

The rendezvous state is a four-value enum, plus an `isEnded` predicate that collapses the two terminal states:

```ts
const SynchronizationStatus = { Idle: 0, Pending: 1, Complete: 2, Failed: 3 } as const;

const isEnded = (status: SynchronizationStatus): boolean =>
  status === SynchronizationStatus.Complete ||
  status === SynchronizationStatus.Failed;
```

`Idle` is the constructed-but-not-yet-synchronizing state; `Pending` means the handshake is in flight; `Complete` and `Failed` are terminal. The class holds the current status and a `PromiseKit<void>` (`#syncKit`) whose promise every gated read and write awaits — resolved on `Complete`, rejected on `Failed`.

### Signals ride the value channel, and the type system is deliberately overridden

The most load-bearing comment in the file is the `**ATTN:**` block on `#performSynchronization`, which explains why the handshake breaks the stream's own type contract on purpose:

```
 * **ATTN:** The synchronization protocol requires sending values that do not
 * conform to the read and write types of the stream. We do not currently have
 * the type system to express this, so we just override TypeScript and do it
 * anyway. This is far from ideal, but it works because (1) the streams always
 * allow stream signal values at runtime, and (2) the special values cannot
 * be observed by users of the stream.
```

That is why every `this.#writer.next(makeSyn())` / `makeAck()` call carries a `// @ts-expect-error See docstring.` — the writer's declared `Write` type does not include the signal objects, but at runtime the streams are built to pass them through. Two companion facts make it safe: the signals are never surfaced to the stream's consumer (the gated `next()` intercepts them — see the [sync-gated next/write section](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--sync-gated-next-write-and-mid-stream-resynchronization.md)), and any consumer-supplied input validator is **augmented** so it does not reject a signal:

```ts
export const makeDuplexStreamInputValidator = <Read>(
  validateInput?: ValidateInput<Read>,
): ((value: unknown) => value is Read) | undefined =>
  validateInput &&
  ((value: unknown): value is Read =>
    isDuplexStreamSignal(value) || validateInput(value));
```

The JSDoc states the contract directly: "Validators passed in by consumers must be augmented such that errors aren't thrown for `DuplexStreamSignal` values." Concrete duplex-stream subclasses call this helper so a strict consumer validator cannot fail the handshake.

### synchronize(): idempotent entry into the handshake

```ts
async synchronize(): Promise<void> {
  if (this.#synchronizationStatus !== SynchronizationStatus.Idle) {
    return this.#syncKit.promise;
  }
  try {
    await this.#performSynchronization();
  } catch (error) {
    this.#failSynchronization(error as Error);
  }
  return this.#syncKit.promise;
}
```

The JSDoc marks it "**Idempotent**": a second call while `Pending`, `Complete`, or `Failed` returns the existing `#syncKit.promise` without re-running the protocol. Only from `Idle` does it drive `#performSynchronization`, and it funnels any thrown error into `#failSynchronization` so the returned promise always reflects the terminal state.

### #performSynchronization: the symmetric SYN-then-ACK protocol

```ts
async #performSynchronization(previousResult?): Promise<void> {
  this.#synchronizationStatus = SynchronizationStatus.Pending;
  let receivedSyn = false;
  let sentAck = false;

  const sendAck = async (): Promise<void> => {
    sentAck = true;
    await this.#writer.next(makeAck());          // @ts-expect-error See docstring.
  };

  await this.#writer.next(makeSyn());            // @ts-expect-error See docstring.

  let result = previousResult ?? (await this.#reader.next());
  while (this.#synchronizationStatus === SynchronizationStatus.Pending) {
    if (isAck(result.value)) {
      if (!sentAck) {
        await sendAck();
      }
      this.#completeSynchronization();
    } else if (isSyn(result.value)) {
      if (receivedSyn) {
        this.#failSynchronization(
          new Error('Received duplicate SYN message during synchronization'),
        );
      } else {
        receivedSyn = true;
        await sendAck();
        result = await this.#reader.next();
      }
    } else {
      this.#failSynchronization(
        new Error(`Received unexpected message during synchronization: ${stringify(result)}`),
      );
    }
  }
}
```

The protocol is symmetric so that either side may initiate and the two can even start simultaneously. Each side always **sends a SYN first**, then loops on what it reads:

- **Receives ACK** — the peer has acknowledged this side's SYN. If this side has not yet sent its own ACK it does so, then **completes**. (A side that sent SYN and immediately got an ACK back needs no further round trip.)
- **Receives SYN** (the peer's opening move, arriving concurrently) — reply with an ACK and read again, expecting the peer's ACK next. The `receivedSyn` flag makes a **second** SYN an error: `'Received duplicate SYN message during synchronization'` is a protocol violation (a well-behaved peer sends exactly one SYN).
- **Receives anything else** — fail-stop with `'Received unexpected message during synchronization: …'`. A data value arriving mid-handshake means the peers have desynchronized, and the stream refuses to guess.

The optional `previousResult` parameter is how a **mid-stream re-synchronization** feeds the already-read SYN back into the protocol without dropping it (the gated `next()` passes the SYN it just saw; see the sync-gated section).

### The idempotent terminal transitions

```ts
#completeSynchronization(): void {
  if (isEnded(this.#synchronizationStatus)) return;
  this.#synchronizationStatus = SynchronizationStatus.Complete;
  this.#syncKit.resolve();
}

#failSynchronization(error: Error): void {
  if (isEnded(this.#synchronizationStatus)) return;
  this.#synchronizationStatus = SynchronizationStatus.Failed;
  this.#syncKit.reject(error);
}
```

Both are marked "Idempotent" and both guard on `isEnded`: once the stream has reached `Complete` or `Failed`, neither transition fires again, so the `#syncKit` promise settles exactly once. This is what lets the close paths (`return()` calls `#completeSynchronization`, `throw()` calls `#failSynchronization` — see the [close section](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--reader-with-write-shape-drain-pipe-and-idempotent-close.md)) run unconditionally without risk of a double-settle.

## Notice / drift check

The comments match the code. The `**ATTN:**` docstring's two safety claims are both honored: the `@ts-expect-error`-marked writes send signal objects the `Write` type does not admit, and `makeDuplexStreamInputValidator` is the augmentation that keeps a consumer validator from rejecting them; the gated `next()` (other section) is what keeps the signals unobservable to the consumer. The "Idempotent" annotations on `synchronize`, `#completeSynchronization`, and `#failSynchronization` are each backed by an explicit guard (the status check / `isEnded`). No comment-versus-code drift in this cluster. One honest design observation for the sibling-reader: the duplicate-SYN guard and the unexpected-message fail-stop make `#performSynchronization` strict — a re-synchronization triggered by a peer that itself re-initializes (sends a fresh SYN mid-stream) is handled by the `previousResult` feed, but a peer that sends *two* SYNs or interleaves a data value is treated as a hard error rather than being recovered; this is a deliberate fail-stop choice, not a contradiction. ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

The SYN/ACK-over-the-value-channel handshake has **no direct `@endo/stream` analog** — Endo's `@endo/stream` is a bare async-iterator abstraction (`makeQueue` / `makePipe` / `pump` / `prime`) with no built-in rendezvous protocol; connection establishment in Endo is the netlayer's or CapTP's concern, layered above the stream, not baked into the stream base. ocap-kernel folds a lightweight liveness handshake into the duplex base itself because its vat↔kernel links (the [`VatHandle`](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--endpoint-handle-and-dual-rpc-wiring.md) / [`VatSupervisor`](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--in-vat-endpoint-and-mirrored-dual-rpc-wiring.md) pair) must confirm the worker is live before the kernel begins delivering. Borrowing TCP's SYN/ACK vocabulary but smuggling the tokens through the data channel (rather than a separate control channel) is the distinctive move. See the streams README's [gtor + @endo/stream lineage note](metamask-ocap-kernel--packages-streams-readme--ses-compatible-streams-gtor-endo-stream-lineage.md) — which flagged `BaseDuplexStream.ts` as the sibling-implementation divergence — and [[ocap-kernel]].

Source: [packages/streams/src/BaseDuplexStream.ts](https://github.com/MetaMask/ocap-kernel/blob/8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c/packages/streams/src/BaseDuplexStream.ts) (lines 11-71, 177-278) at commit `8c4f04b`.
