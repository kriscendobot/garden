---
title: "Crank reentrancy and the terminate-callback deadlock (why the queue's stop path bypasses VatManager.terminateVat)"
source: packages/ocap-kernel/src/Kernel.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/Kernel.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/Kernel.ts
source_line_range: "136-144"
source_branch: main
source_commit: 052f4d4865b39df29f8f67fdffa3c52ef17b4282
source_date: 2026-05-12
comment_subject: The terminate callback the kernel hands KernelQueue calls VatManager.stopVat directly rather than terminateVat, because terminateVat awaits waitForCrank and the callback itself runs from inside a crank, which would deadlock; the public debugging methods that may safely block on a crank boundary do call waitForCrank.
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-28
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the crank-reentrancy deadlock comment in Kernel.ts. See [[ocap-kernel]].
---

## Abstract

The kernel constructs its `KernelQueue` with a vat-terminate callback, and that callback carries one of the file's sharpest invariants: it must **not** route through `VatManager.terminateVat()`, because `terminateVat` awaits `waitForCrank()` and the callback is itself invoked from inside a crank, so awaiting the crank to finish from within the crank would **deadlock**. The callback therefore calls the lower-level `#vatManager.stopVat(vatId, true, reason)` directly and then `markVatAsTerminated(vatId)`. The same `waitForCrank()` primitive appears in the public, externally-driven methods (`clearStorage`, `getStatus`, `reset`, `stop`) where blocking until the current crank settles is exactly the right thing: those callers are *outside* the run loop. The contrast between the two call sites is a worked example of a reentrancy hazard in a single-threaded crank machine: a primitive that means "wait for the in-flight turn to complete" is safe from outside the turn and a deadlock from inside it.

## Body

### The bypass and its comment

In the constructor, the run queue is given a terminate callback:

```ts
// Bypass VatManager.terminateVat() here because it calls waitForCrank(),
// which would deadlock — this callback is invoked from within a crank.
this.#kernelQueue = new KernelQueue(
  this.#kernelStore,
  async (vatId, reason) => {
    await this.#vatManager.stopVat(vatId, true, reason);
    this.#kernelStore.markVatAsTerminated(vatId);
  },
);
```

The queue fires this callback when a crank's processing decides a vat must be torn down (the KernelQueue side of vat termination during delivery). Because the callback runs *during* a crank, it cannot use the high-level `terminateVat`, whose contract includes a `waitForCrank()` barrier. It drops to `stopVat(vatId, true, reason)` (the `true` forcing the stop) and records the termination directly in the store.

### waitForCrank is safe — and required — from the outside

The public methods that an external driver calls *between* cranks use `waitForCrank()` deliberately, to fence their work behind a settled crank boundary:

```ts
async clearStorage(): Promise<void> {
  await this.#kernelQueue.waitForCrank();
  this.#kernelStore.clear();
}

async getStatus(): Promise<KernelStatus> {
  await this.#kernelQueue.waitForCrank();
  // ... read vats, subclusters, remote-comms state ...
}

async reset(): Promise<void> {
  await this.#kernelQueue.waitForCrank();
  // ... destroy IO channels, terminate all vats, reset state ...
}

async stop(): Promise<void> {
  await this.#kernelQueue.waitForCrank();
  this.#kernelStore.recordLastActiveTime();
  // ... stop remote comms, cleanup, terminate all, close db ...
}
```

For these callers the barrier is correct: they are not inside a crank, so they may block until the current crank settles and then mutate kernel state without racing an in-flight delivery. `clearStorage`, `reset`, and `stop` mutate or tear down state and must not interleave with a crank; `getStatus` reads a consistent snapshot at a crank boundary.

### The general invariant

The two call sites together teach the rule: in a single-threaded crank machine, `waitForCrank()` means "park until the in-flight turn finishes." Called from **outside** the run loop it is a clean synchronization fence. Called from **inside** a crank (as the queue's terminate callback is) it waits for the very turn that is calling it, which can never complete, so it deadlocks. The fix is not to remove the barrier from `terminateVat` but to give in-crank teardown a barrier-free path (`stopVat` + `markVatAsTerminated`) — exactly what the callback does.

## Notice / drift check

The comment matches the code precisely: the callback calls `stopVat`, not `terminateVat`; `terminateVat` (line 552) delegates to `this.#vatManager.terminateVat`, and the four public methods above each open with `await this.#kernelQueue.waitForCrank()`. No comment-versus-code drift in this cluster. (A trivial unrelated typo lives at the `#platformServices` field comment — "Service to to things the kernel worker can't do" — noted only for completeness; it is documentation-only and in a repository the garden reads but never contributes to.)

## Lineage note

The crank as the kernel's atomic turn is SwingSet-derived; the reentrancy hazard described here is general to any single-threaded run-loop kernel that exposes a "wait for the current turn" primitive. The garden's interest is comparative: the same hazard shape (a barrier that is safe outside the loop and a deadlock inside it) recurs in any turn-based persistence machine, including Endo's daemon. See [[ocap-kernel]] and the sibling [KernelQueue.ts run-loop section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md) for the crank lifecycle this callback fires inside of.

Source: [packages/ocap-kernel/src/Kernel.ts](https://github.com/MetaMask/ocap-kernel/blob/052f4d4865b39df29f8f67fdffa3c52ef17b4282/packages/ocap-kernel/src/Kernel.ts) (lines 136-144, with the contrasting `waitForCrank` call sites at 560, 631, 741, 767) at commit `052f4d4`.
