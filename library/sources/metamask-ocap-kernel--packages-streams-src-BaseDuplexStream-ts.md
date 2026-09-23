---
source: packages/streams/src/BaseDuplexStream.ts
source_kind: comment-fragment
source_repo: MetaMask/ocap-kernel
source_path: packages/streams/src/BaseDuplexStream.ts
source_line_range: "1-355"
source_branch: main
source_commit: 8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c
comment_subject: BaseDuplexStream is @metamask/streams's SES-compatible duplex stream base — a BaseReader-with-write() backed by separate reader and writer instances, synchronized with its remote counterpart by a SYN/ACK handshake carried as sentinel values on the value channel, with a four-state machine, sync-gated reads/writes that transparently re-run the handshake on a mid-stream SYN, and idempotent return/throw/end close paths.
source_date: 2026-01-13
source_authors: [Erik Marks, Dimitris Marlagkoutsos]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
notes: |
  Fifteenth ocap-kernel ingest and the FIRST from packages/streams (the prior
  fourteen were the monorepo survey, six per-package READMEs, four docs pages,
  and six packages/ocap-kernel kernel-internals comment-fragment files —
  KernelQueue.ts, Kernel.ts, VatHandle.ts, VatSupervisor.ts, KernelRouter.ts,
  KernelServiceManager.ts). BaseDuplexStream.ts is the transport substrate under
  the three vat-endpoint / router files already ingested: the stream type
  VatHandle.ts and VatSupervisor.ts both drain, and the one KernelRouter delivers
  over. Flagged as the sibling-implementation divergence by the streams README
  ingest — the one piece of @metamask/streams with NO direct @endo/stream analog.
  355 lines, JSDoc-dense (~118 comment-lines). Three coherent argument clusters:
  the SYN/ACK synchronization handshake and its four-state machine (SYN/ACK
  sentinel values sent on the value channel with a deliberate @ts-expect-error
  type override + a consumer-validator augmentation; Idle/Pending/Complete/Failed;
  idempotent synchronize(); the symmetric #performSynchronization protocol with a
  duplicate-SYN guard and an unexpected-message fail-stop; idempotent terminal
  transitions); sync-gated next()/write() and mid-stream re-synchronization (both
  methods defer to #syncKit.promise until Complete; a Complete-state next() that
  reads a SYN transparently re-runs the handshake via previousResult; a fresh
  promise kit per round + an unhandled-rejection catch guard); and the duplex
  stream as a Reader with write() (reader/writer-backed shape; self-returning
  async iterator; drain/pipe; idempotent return/throw/end closing both halves
  after settling synchronization; the DuplexStream public-surface Pick type).
  SwingSet-lineage streams package; reference-not-substrate stance. Idempotency
  anchor is source_commit (file-path-specific sha 8c4f04b). No comment-versus-code
  drift found in any of the three clusters; two honest non-drift observations
  recorded (the strict duplicate-SYN/unexpected-message fail-stop in
  #performSynchronization, and the fire-and-forget unawaited re-sync whose success
  flows through the promise kit rather than the returned promise). Remaining
  kernel-internals comment-fragment file from the cycle-161 plan
  (kernel-utils/exo.ts) is ingested in the same cycle; with both done, the
  kernel-internals + streams comment-fragment backlog is drained.
---

> Abstract: `packages/streams/src/BaseDuplexStream.ts` is the base class of
> `@metamask/streams`'s **duplex stream** — "essentially a `BaseReader` with a
> `write()` method," backed by separate `BaseReader` and `BaseWriter` instances
> under the hood. It is the **transport substrate** beneath ocap-kernel's
> vat↔kernel links: the stream type `VatHandle.ts` and `VatSupervisor.ts` both
> drain, and the one `KernelRouter` delivers over — and the streams README ingest
> flagged it as the sibling-implementation divergence with *no direct
> `@endo/stream` analog*. The file splits into three comment clusters. The
> **SYN/ACK synchronization handshake and its four-state machine**: before any
> value flows, the two ends rendezvous via a handshake whose `@@Syn`/`@@Ack`
> tokens are sentinel values sent on the stream's *own value channel* (the type
> system deliberately overridden with `@ts-expect-error`; consumer validators
> augmented so they do not reject signals); an Idle→Pending→Complete|Failed state
> machine tracks it, `synchronize()` is idempotent, `#performSynchronization` runs
> the symmetric protocol with a duplicate-SYN guard and an unexpected-message
> fail-stop, and the terminal transitions settle the shared sync promise exactly
> once. **Sync-gated `next()`/`write()` and mid-stream re-synchronization**: the
> constructor wires both methods to defer to `#syncKit.promise` until Complete,
> and a `Complete`-state `next()` that reads a SYN transparently re-runs the
> handshake (feeding the already-read SYN in as `previousResult`) so
> re-synchronization is invisible to the consumer. **The duplex stream as a
> `Reader` with `write()`**: the reader/writer-backed shape, `[Symbol.asyncIterator]`
> returning `this`, `drain`/`pipe` consumption, and the idempotent
> `return`/`throw`/`end` close paths that settle synchronization and close both
> halves before returning a done result.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [syn-ack-synchronization-handshake-and-four-state-machine](../sections/metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--syn-ack-synchronization-handshake-and-four-state-machine.md) | streams, eventual-send | current |
| [sync-gated-next-write-and-mid-stream-resynchronization](../sections/metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--sync-gated-next-write-and-mid-stream-resynchronization.md) | streams, eventual-send | current |
| [reader-with-write-shape-drain-pipe-and-idempotent-close](../sections/metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--reader-with-write-shape-drain-pipe-and-idempotent-close.md) | streams | current |

Parent index section file: [metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts](../sections/metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts.md).

## Provenance

- Fetched 2026-07-06 from the local bare clone `worktrees/metamask-ocap-kernel.git` at `main` HEAD `a3eff0efb`; the file's own path-specific commit is `8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c` (last touched 2026-01-13 by Erik Marks / Dimitris Marlagkoutsos).
- Authors over the file's history: Erik Marks, Dimitris Marlagkoutsos (`git log` over the path).
- 355 lines, JSDoc-dense (~118 comment-lines); the three sections map to lines 11-71 + 177-278 (the sentinels, state machine, `synchronize`, `#performSynchronization`, terminal transitions), 101-175 (the constructor's sync-gated `next`/`write` + re-sync + `#resetSynchronizationStatus`), and 80-166 + 280-355 (the class shape, `drain`/`pipe`, `return`/`throw`/`end`, and the `DuplexStream` type).
- **Fifteenth ocap-kernel ingest; first from `packages/streams`.** Genre: sibling-implementation / reference-not-substrate. Synthesizing concept [[ocap-kernel]]. The transport substrate under the three vat-endpoint / router files already ingested.
- License: dual Apache-2.0 + MIT.
- No comment-versus-code drift found in any of the three clusters (each section carries its own Notice / drift check). Two honest non-drift observations recorded: `#performSynchronization`'s duplicate-SYN guard and unexpected-message case are a deliberate strict fail-stop (not a contradiction), and the `Complete`-state `next()` invokes `#performSynchronization` fire-and-forget so its success flows through the sync promise kit rather than the returned promise (correct, if indirect). ocap-kernel is a read-only reference shelf, not a garden fork, so no boatman missive is available regardless.
