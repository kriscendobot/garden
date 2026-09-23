---
title: The forever run-loop and the crank lifecycle (startCrank, savepoint, GC/reap priority, sleep-and-wake)
source: packages/ocap-kernel/src/KernelQueue.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelQueue.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelQueue.ts
source_line_range: "65-130"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: The kernel's run loop drives one crank per iteration, brackets each crank with a store savepoint, prioritizes garbage-collection and reap actions over ordinary message delivery, and sleeps on an empty queue behind a single-use wake thunk.
source_authors: [Erik Marks, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-06-28
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo. Comment-fragment ingest of the run-loop cluster in KernelQueue.ts. See [[ocap-kernel]].
---

## Abstract

`KernelQueue.run(deliver)` is the kernel's **forever run loop**: its return type is `Promise<never>` and the class comment states plainly that it "loops forever: the returned promise never resolves." Each iteration is one **crank**. The loop brackets every crank between `kernelStore.startCrank()` and `kernelStore.endCrank()` (in a `finally`, so the bracket closes even on a thrown delivery), and immediately after `startCrank` it takes a savepoint named `'start'` (`createCrankSavepoint('start')`) that becomes the rollback anchor the crank-result handler uses if delivery aborts. Item selection is **priority-ordered** in `#getNextRunQueueItem`: a pending garbage-collection action (`processGCActionSet`) preempts everything, then a reap action (`nextReapAction`), and only then an ordinary run-queue item (`dequeueRun`). When the queue is empty the loop **sleeps**: it installs a single resolve thunk in `#wakeUpTheRunQueue` and awaits its promise inside the `finally` after `endCrank`, so a producer that enqueues onto an empty queue can wake it. A guard (`Fail` with "run queue already waiting to be woken; cannot sleep again before the previous wake handler is consumed") enforces that only one sleep is outstanding at a time.

## Body

### The run loop is a forever loop of cranks

The class-level comment describes the run queue as "a queue of items that need to be processed," and `run`'s own comment states the contract:

> The kernel's run loop: take an item off the run queue, deliver it, repeat. Note that this loops forever: the returned promise never resolves.

The signature encodes that contract as the return type `Promise<never>`. The body is an unbounded `for (;;)` loop; each pass is a crank.

### Each crank is bracketed by startCrank / endCrank and opens with a 'start' savepoint

```ts
this.#kernelStore.startCrank();
try {
  this.#kernelStore.createCrankSavepoint('start');
  const queueItem = this.#getNextRunQueueItem();
  if (queueItem) {
    this.#kernelStore.nextTerminatedVatCleanup();
    const crankResult = await deliver(queueItem);
    await this.#processCrankResult(crankResult, queueItem);
  } else {
    // ... install the wake thunk (see below)
  }
} finally {
  this.#kernelStore.endCrank();
  if (wakeUpPromise) {
    await wakeUpPromise;
  }
}
```

The `'start'` savepoint taken right after `startCrank` is the anchor the crank-result handler rewinds to on an aborted delivery (covered in the sibling section on abort/rollback versus commit/flush). Bracketing the work in a `try`/`finally` guarantees `endCrank` runs even if `deliver` throws.

### Item selection prioritizes GC and reap actions over ordinary delivery

`#getNextRunQueueItem` is where the kernel's scheduling priority lives. Its comment carries an explicit mutation warning:

> Get the next item from the kernel run queue. **ATTN:** Mutates the kernel store if the queue is not empty.

The order is fixed:

```ts
const gcAction = processGCActionSet(this.#kernelStore);
if (gcAction) {
  return gcAction;
}
const reapAction = this.#kernelStore.nextReapAction();
if (reapAction) {
  return reapAction;
}
if (this.#kernelStore.runQueueLength() > 0) {
  const item = this.#kernelStore.dequeueRun();
  if (item) {
    return item;
  }
}
return undefined;
```

Garbage-collection actions run first, then reap actions, then ordinary run-queue messages. The kernel keeps reference-counting and reaping ahead of message delivery so memory pressure is relieved before new work proceeds.

### Sleeping on an empty queue behind a single-use wake thunk

When `#getNextRunQueueItem` returns `undefined`, the loop sleeps. It cannot sleep twice concurrently:

```ts
if (this.#wakeUpTheRunQueue !== null) {
  Fail`run queue already waiting to be woken; cannot sleep again before the previous wake handler is consumed`;
}
const { promise, resolve } = makePromiseKit<void>();
this.#wakeUpTheRunQueue = resolve;
wakeUpPromise = promise;
```

The thunk's field comment names it "Thunk to signal run queue transition from empty to non-empty." The `finally` awaits `wakeUpPromise` after closing the crank, so the loop parks until a producer fires the thunk. The producer side (`#enqueueRun` firing the thunk when the queue goes from empty to length one) is covered in the sibling section on enqueue and resolution.

## Lineage note

The crank-and-savepoint loop is recognizably SwingSet-derived: the per-crank store savepoint and the "take one item, deliver, repeat" run loop mirror Agoric SwingSet's kernel run loop. The garden's interest is comparative: ocap-kernel makes the crank's atomicity boundary explicit in code (savepoint at crank start, rollback or flush at crank end), which is the same "output-valid rollback-recovery" discipline the `docs/ken-protocol-assessment.md` ingest tabulated against the HPL-2010-155 paper. See [[ocap-kernel]] for the lineage flag and the sibling kernel-store package that holds the savepoint machinery.

Source: [packages/ocap-kernel/src/KernelQueue.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelQueue.ts) (lines 65-130) at commit `d979a06`.
