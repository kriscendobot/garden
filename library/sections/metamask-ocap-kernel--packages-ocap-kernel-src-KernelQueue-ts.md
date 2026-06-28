---
title: "KernelQueue.ts (MetaMask/ocap-kernel) — the kernel run loop, crank atomicity, and message/resolution machinery"
source: packages/ocap-kernel/src/KernelQueue.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelQueue.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelQueue.ts
source_line_range: "1-376"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: KernelQueue is the kernel's run queue and run loop — a forever loop of cranks, each atomic against a store savepoint, with buffered vat effects and decider-authorized promise resolution.
source_authors: [Erik Marks, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-06-28
ingested_by: scholar
topics: [persistence, capability-security, eventual-send]
status: current
kind: index
section_count: 3
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). First kernel-internals comment-fragment ingest from the cycle-161 overview plan (follow-on to the per-package-README cluster). See [[ocap-kernel]] concept for the lineage flag.
---

## Abstract

`packages/ocap-kernel/src/KernelQueue.ts` is the **run queue and run loop** at the center of MetaMask/ocap-kernel's SwingSet-lineage kernel. The `KernelQueue` class owns the queue of items to process, the kernel's own promise subscriptions, and the loop that drains the queue one **crank** at a time. Three disciplines run through its longform comments. First, `run(deliver)` is a **forever loop** (`Promise<never>`, "loops forever: the returned promise never resolves") that brackets each crank between `startCrank`/`endCrank`, opens it with a `'start'` store savepoint, prioritizes garbage-collection and reap actions over ordinary message delivery, and sleeps on an empty queue behind a single-use wake thunk. Second, `#processCrankResult` makes each crank **atomic**: an aborted delivery rolls the store back to the savepoint and discards buffered effects (an active vat's message is retriable, a terminated vat's "will just go splat"), while a successful delivery flushes the crank buffer. Third, the enqueue and resolution methods buffer vat-side effects until commit (the `immediate` flag), reference-count every enqueued reference, and enforce that **only a promise's recorded decider may resolve it**.

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo and Agoric work, never imports its code. It is the first of the kernel-internals comment-fragment ingests the cycle-161 overview plan queued after the per-package-README cluster, and it grounds the `metamask-ocap-kernel--overview` ingest's flag that the package's architectural substance lives in `Kernel.ts`, `KernelQueue.ts`, and their siblings rather than in the near-boilerplate package READMEs.

## Sections

- [The forever run-loop and the crank lifecycle (startCrank, savepoint, GC/reap priority, sleep-and-wake)](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md)
- [Crank atomicity — abort-and-rollback versus commit-and-flush](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--crank-abort-rollback-versus-commit-flush.md)
- [Immediate-versus-buffered enqueue, reference-counting, and decider-authorized resolution](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md)

## See also

- Source index: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts](../sources/metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts.md)
- Synthesizing concept: [[ocap-kernel]]
- The crank-buffering atomic-output-or-rollback discipline: [metamask-ocap-kernel--overview](../sources/metamask-ocap-kernel--overview.md), and the persistence substrate package [metamask-ocap-kernel--packages-kernel-store-readme](../sources/metamask-ocap-kernel--packages-kernel-store-readme.md)
- Shared substrate for the promise model: [[eventual-send]], [[promise-pipelining]]

Source: [packages/ocap-kernel/src/KernelQueue.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelQueue.ts) at commit `d979a06`.
