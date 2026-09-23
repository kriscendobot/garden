---
title: "BaseDuplexStream.ts (MetaMask/ocap-kernel) — the SES-compatible duplex stream base with a SYN/ACK synchronization handshake, sync-gated reads/writes, and idempotent reader-with-write close"
source: packages/streams/src/BaseDuplexStream.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/streams/src/BaseDuplexStream.ts
source_kind: comment-fragment
source_path: packages/streams/src/BaseDuplexStream.ts
source_line_range: "1-355"
source_branch: main
source_commit: 8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c
source_date: 2026-01-13
comment_subject: BaseDuplexStream is @metamask/streams's duplex stream base — a BaseReader-with-write() backed by separate reader and writer instances, synchronized with its remote counterpart by a SYN/ACK handshake carried as sentinel values on the value channel; a four-state machine tracks the rendezvous, next()/write() defer to a sync promise until the handshake completes (transparently re-running it on a mid-stream SYN), and return()/throw()/end() are idempotent close paths.
source_authors: [Erik Marks, Dimitris Marlagkoutsos]
ingested: 2026-07-06
ingested_by: scholar
topics: [streams, eventual-send]
status: current
kind: index
section_count: 3
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Fifteenth ocap-kernel ingest and the FIRST from packages/streams; the transport substrate under the three already-ingested vat-endpoint / router files (VatHandle.ts / VatSupervisor.ts / KernelRouter.ts) all sit on. Flagged as the sibling-implementation divergence by the streams README ingest (no direct @endo/stream analog). See [[ocap-kernel]] concept for the lineage flag.
---

## Abstract

`packages/streams/src/BaseDuplexStream.ts` is the base class of `@metamask/streams`'s **duplex stream** — "essentially a `BaseReader` with a `write()` method," backed by separate `BaseReader` and `BaseWriter` instances under the hood. It is the **transport substrate** beneath ocap-kernel's vat↔kernel links: the stream type the [`VatHandle`](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts.md) and [`VatSupervisor`](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts.md) endpoint pair both drain, and the one [`KernelRouter`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md) delivers over. The streams README ingest flagged it as the **sibling-implementation divergence** — the one piece of `@metamask/streams` with *no direct `@endo/stream` analog*. The file's substance splits into three comment clusters the section files below curate.

First, the **SYN/ACK synchronization handshake and its four-state machine**: before any value flows, the two ends rendezvous via a handshake whose SYN (`@@Syn`) and ACK (`@@Ack`) tokens are sentinel values sent on the stream's *own value channel* (the type system is deliberately overridden with `@ts-expect-error`, and consumer validators are augmented so they do not reject signals); a four-value `SynchronizationStatus` (Idle → Pending → Complete | Failed) tracks it, `synchronize()` is idempotent, `#performSynchronization` runs the symmetric protocol with a duplicate-SYN guard and an unexpected-message fail-stop, and the terminal transitions settle the shared sync promise exactly once. Second, **sync-gated `next()`/`write()` and mid-stream re-synchronization**: the constructor wires both methods to defer to `#syncKit.promise` until Complete, and a `Complete`-state `next()` that reads a SYN transparently re-runs the handshake (feeding the already-read SYN in as `previousResult`) so re-synchronization is invisible to the consumer. Third, **the duplex stream as a `Reader` with `write()`**: the reader/writer-backed shape, `[Symbol.asyncIterator]` returning `this`, `drain`/`pipe` consumption, and the idempotent `return`/`throw`/`end` close paths that settle synchronization and close both halves before returning a done result.

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo and Agoric work, never imports its code. It is the **fifteenth** ocap-kernel ingest and the **first from `packages/streams`** — a shift off the `packages/ocap-kernel/` kernel-internals files (KernelQueue / Kernel / VatHandle / VatSupervisor / KernelRouter / KernelServiceManager) down to the transport layer they all sit on. The primary axis is [`streams`](../topics/streams.md) (the `@endo/stream` lineage), with `eventual-send` secondary (the sync-promise gate and the promise-kit machinery).

## Sections

- [The SYN/ACK synchronization handshake and its four-state machine: how a duplex stream rendezvous with its remote counterpart before any value flows](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--syn-ack-synchronization-handshake-and-four-state-machine.md)
- [Sync-gated next()/write() and mid-stream re-synchronization: reads and writes defer to the sync promise, and a mid-stream SYN transparently re-runs the handshake](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--sync-gated-next-write-and-mid-stream-resynchronization.md)
- [The duplex stream as a Reader with write(): the reader/writer-backed shape, drain/pipe, and idempotent return/throw/end close](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--reader-with-write-shape-drain-pipe-and-idempotent-close.md)

## See also

- Source index: [metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts](../sources/metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts.md)
- Synthesizing concept: [[ocap-kernel]]
- The package README that flagged this file as the sibling divergence: [metamask-ocap-kernel--packages-streams-readme--ses-compatible-streams-gtor-endo-stream-lineage](metamask-ocap-kernel--packages-streams-readme--ses-compatible-streams-gtor-endo-stream-lineage.md)
- The vat-endpoint pair that drains this stream: [VatHandle.ts](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts.md) (its [make/#init lifecycle section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--make-init-lifecycle-and-stream-drain.md) fires the stream drain) and [VatSupervisor.ts](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts.md)
- The router that delivers over this transport: [KernelRouter.ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md)
- The Endo counterpart the lineage note contrasts against: the [`streams` topic](../topics/streams.md) (`@endo/stream` `makeQueue`/`makePipe`/`pump`/`prime`)

Source: [packages/streams/src/BaseDuplexStream.ts](https://github.com/MetaMask/ocap-kernel/blob/8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c/packages/streams/src/BaseDuplexStream.ts) at commit `8c4f04b`.
