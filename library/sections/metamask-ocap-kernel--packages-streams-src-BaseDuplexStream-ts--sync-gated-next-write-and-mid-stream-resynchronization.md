---
title: "Sync-gated next()/write() and mid-stream re-synchronization: reads and writes defer to the sync promise, and a mid-stream SYN transparently re-runs the handshake"
source: packages/streams/src/BaseDuplexStream.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/streams/src/BaseDuplexStream.ts
source_kind: comment-fragment
source_path: packages/streams/src/BaseDuplexStream.ts
source_line_range: "101-175"
source_branch: main
source_commit: 8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c
source_date: 2026-01-13
comment_subject: The constructor wires next() and write() so both defer to the #syncKit promise until synchronization is Complete; a mid-stream SYN read by next() transparently re-runs the handshake (feeding the already-read SYN in as previousResult); #resetSynchronizationStatus makes a fresh promise kit; and a catch handler on the sync promise avoids unhandled-rejection errors when no read or write is yet waiting.
source_authors: [Erik Marks, Dimitris Marlagkoutsos]
ingested: 2026-07-06
ingested_by: scholar
topics: [streams, eventual-send]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the sync-gated next/write wiring in BaseDuplexStream.ts. Fifteenth ocap-kernel ingest; first from packages/streams. See [[ocap-kernel]].
---

## Abstract

The `BaseDuplexStream` constructor wires the public `next()` and `write()` methods so that **neither can move a value until synchronization completes**: each method checks the `SynchronizationStatus`, and if the stream is not yet `Complete` it chains its real work onto `this.#syncKit.promise` (resolved when the [SYN/ACK handshake](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--syn-ack-synchronization-handshake-and-four-state-machine.md) succeeds). Once `Complete`, `next()` reads directly — but it also **watches for a mid-stream SYN**: if the peer re-initializes (sends a fresh SYN after the link was up), `next()` resets the state, transparently re-runs the handshake feeding the already-read SYN in as `previousResult`, and only then resumes the read, so re-synchronization is invisible to the consumer. `#resetSynchronizationStatus` swaps in a fresh `PromiseKit` for the new round, and a `catch(() => undefined)` on the sync promise suppresses unhandled-rejection noise for the window when the promise may reject before any read or write is waiting on it.

## Body

### The constructor gates next() and write() on the sync promise

```ts
constructor(reader: ReadStream, writer: WriteStream) {
  // Set a catch handler to avoid unhandled rejection errors. The promise may
  // reject before reads or writes occur, in which case there are no handlers.
  this.#syncKit.promise.catch(() => undefined);

  // Next and write only work if synchronization completes.
  this.next = async () => {
    if (this.#synchronizationStatus !== SynchronizationStatus.Complete) {
      return this.#syncKit.promise.then(async () => reader.next());
    }

    const result = await reader.next();

    // If we receive a SYN message, we re-synchronize.
    if (isSyn(result.value)) {
      this.#resetSynchronizationStatus();
      this.#performSynchronization(result).catch((error) => {
        this.#failSynchronization(error);
      });
      return this.#syncKit.promise.then(async () => reader.next());
    }
    return result;
  };

  this.write = async (value: Write) =>
    this.#synchronizationStatus === SynchronizationStatus.Complete
      ? writer.next(value)
      : this.#syncKit.promise.then(async () => writer.next(value));

  this.#reader = reader;
  this.#writer = writer;

  harden(this);
}
```

`next` and `write` are assigned as arrow-function fields in the constructor (capturing `reader`/`writer` directly) rather than declared as prototype methods — the JSDoc'd `next` / `write` class fields above the constructor are the type declarations these assignments satisfy. Both encode the same gate: **if not `Complete`, chain onto `#syncKit.promise` first**. A `write` issued before synchronization does not fail or drop — it waits for the handshake, then performs `writer.next(value)`. A `next` issued before synchronization likewise waits, then reads. This is what lets a consumer call `write()` / iterate immediately after construction (or after calling `synchronize()`) without manually awaiting the handshake — the gating is implicit.

### Mid-stream re-synchronization is transparent to the consumer

The interesting half is the `Complete`-state `next()`. After a normal read it inspects the value: an ordinary value is returned as-is, but a **SYN** means the peer has re-initialized the link (for example, the other end restarted and is re-establishing the connection). Rather than surface the SYN sentinel to the consumer (who must never see a signal — the handshake invariant from the [synchronization section](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--syn-ack-synchronization-handshake-and-four-state-machine.md)), `next()`:

1. Calls `#resetSynchronizationStatus()` to drop back to `Idle` with a fresh promise kit.
2. Kicks off `#performSynchronization(result)` — passing the **already-read SYN** as `previousResult` so the handshake loop consumes it instead of reading a fresh message and losing it (this is the exact reason `#performSynchronization` takes an optional `previousResult`). The re-sync runs unawaited, with its own `.catch` routing failures into `#failSynchronization`.
3. Returns `this.#syncKit.promise.then(async () => reader.next())` — i.e. waits for the *new* handshake to complete, then does the read the consumer originally asked for.

From the consumer's vantage the `next()` call simply takes a little longer and then yields the next real value; the re-handshake is entirely absorbed. Note that `#performSynchronization` is *not* awaited here (unlike in `synchronize()`) — the method returns the sync promise's continuation instead, and the fire-and-forget `.catch` ensures a re-sync failure still rejects the sync kit.

### #resetSynchronizationStatus: a fresh promise kit per round

```ts
#resetSynchronizationStatus(): void {
  this.#synchronizationStatus = SynchronizationStatus.Idle;
  this.#syncKit = makePromiseKit<void>();
  this.#syncKit.promise.catch(() => undefined);
}
```

Because the prior round's `#syncKit` promise is already settled (a completed link resolved it), re-synchronization needs a **new** promise for gated reads/writes to await. `#resetSynchronizationStatus` returns to `Idle` and installs a fresh `PromiseKit`, immediately attaching the same `catch(() => undefined)` unhandled-rejection guard the constructor uses. The guard matters here for the same reason: the new sync promise may reject (a failed re-handshake) before any consumer read is chained onto it.

## Notice / drift check

The two inline comments — "Next and write only work if synchronization completes" and "If we receive a SYN message, we re-synchronize" — accurately describe the gating and the re-sync branch. The constructor comment "The promise may reject before reads or writes occur, in which case there are no handlers" correctly justifies the `catch(() => undefined)` guard (repeated in `#resetSynchronizationStatus`). No comment-versus-code drift in this cluster. One honest observation for the sibling-reader: in the `Complete`-state `next()`, `#performSynchronization(result)` is invoked without `await` and its result discarded (only its rejection is caught) — the method's completion is instead observed through `#syncKit.promise`; this is correct because `#completeSynchronization` resolves that shared promise, but it means the re-sync's success path flows through the promise kit rather than the returned promise, a slightly indirect control flow that the code handles correctly. ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

The "await a readiness promise before every operation" gate is a lightweight cousin of the pattern Endo's `@endo/eventual-send` embodies at a different layer — `E()` and `HandledPromise` let a caller message a target that may not be settled yet, buffering until it is. Here the buffering is coarser (one link-wide sync promise, not per-message), and the re-synchronization-on-mid-stream-SYN behavior is peculiar to a long-lived duplex link that must survive a peer restart without tearing down the stream — a concern the kernel's [incarnation-identity / peer-restart-detection](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--incarnation-identity-and-peer-restart-detection.md) logic addresses one layer up. See [[ocap-kernel]] and the [synchronization-handshake section](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--syn-ack-synchronization-handshake-and-four-state-machine.md) this gating sits on.

Source: [packages/streams/src/BaseDuplexStream.ts](https://github.com/MetaMask/ocap-kernel/blob/8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c/packages/streams/src/BaseDuplexStream.ts) (lines 101-175) at commit `8c4f04b`.
