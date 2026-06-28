---
source: packages/ocap-kernel/src/KernelQueue.ts
source_kind: comment-fragment
source_repo: MetaMask/ocap-kernel
source_path: packages/ocap-kernel/src/KernelQueue.ts
source_line_range: "1-376"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
comment_subject: The kernel's run queue and forever run loop — crank atomicity against a store savepoint, buffered vat effects, reference-counting, and decider-authorized promise resolution.
source_date: 2026-04-07
source_authors: [Erik Marks, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-06-28
ingested_by: scholar
section_count: 3
status: current
notes: |
  Ninth ocap-kernel ingest and the FIRST kernel-internals comment-fragment
  source (the per-package-README cluster, the eighth ingest, ended with the
  observation that the architectural substance lives in Kernel.ts / KernelQueue.ts
  / VatHandle.ts, queued as comment-fragment follow-ons). 376-line TypeScript
  module; the kernel's run queue and run loop. Three coherent argument clusters:
  the forever run loop + crank lifecycle (savepoint, GC/reap priority, sleep/wake);
  crank atomicity (abort/rollback versus commit/flush); and the enqueue/resolution
  machinery (immediate-versus-buffered effects, reference-counting, decider-
  authorized resolution). SwingSet-lineage; reference-not-substrate stance.
  Idempotency anchor is source_commit (file-path-specific sha `d979a06`). Remaining
  kernel-internals files from the cycle-161 plan (Kernel.ts, VatHandle.ts,
  VatSupervisor.ts, KernelRouter.ts, KernelServiceManager.ts, BaseDuplexStream.ts,
  kernel-utils/exo.ts) stay queued under the parked plan job
  `scholar-ingest-ocap-kernel-comment-fragments`.
---

> Abstract: `packages/ocap-kernel/src/KernelQueue.ts` is the **run queue and run
> loop** at the center of MetaMask/ocap-kernel's SwingSet-lineage kernel. The
> `KernelQueue` class owns the queue of items to process, the kernel's own promise
> subscriptions, and the loop that drains the queue one **crank** at a time. Its
> `run(deliver)` method is a forever loop (`Promise<never>`) that brackets each
> crank between `startCrank`/`endCrank`, opens it with a `'start'` store savepoint,
> prioritizes garbage-collection and reap actions over ordinary message delivery,
> and sleeps on an empty queue behind a single-use wake thunk. `#processCrankResult`
> makes each crank atomic: an aborted delivery rolls the store back to the savepoint
> and discards buffered effects (an active vat's message is retriable; a terminated
> vat's "will just go splat"), while a successful delivery flushes the crank buffer.
> The enqueue and resolution methods buffer vat-side effects until commit (the
> `immediate` flag), reference-count every enqueued reference with a tagged reason,
> and enforce that only a promise's recorded `decider` may resolve it, and only once.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [forever-run-loop-and-crank-lifecycle](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md) | persistence, capability-security | current |
| [crank-abort-rollback-versus-commit-flush](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--crank-abort-rollback-versus-commit-flush.md) | persistence, capability-security | current |
| [immediate-versus-buffered-enqueue-and-decider-authorized-resolution](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md) | eventual-send, capability-security | current |

Parent index section file: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts.md).

## Provenance

- Fetched 2026-06-28 from the local bare clone `worktrees/metamask-ocap-kernel.git` at `main` HEAD `a3eff0efb`; the file's own path-specific commit is `d979a06325666af32ca7f68b13e9c85486d89ab5` (last touched 2026-04-07).
- Authors over the file's history: Erik Marks, Dimitris Marlagkoutsos, Chip Morningstar (`git log` over the path).
- 376 lines, comment-dense; the three sections map to lines roughly 65-130 (run loop + item selection), 132-180 (crank-result handler), and 182-376 (enqueue / flush / resolvePromises).
- **Ninth ocap-kernel ingest; first kernel-internals comment-fragment.** Genre: sibling-implementation / reference-not-substrate. Synthesizing concept [[ocap-kernel]].
