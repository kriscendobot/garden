---
title: Crank atomicity — abort-and-rollback versus commit-and-flush
source: packages/ocap-kernel/src/KernelQueue.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelQueue.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelQueue.ts
source_line_range: "132-180"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: A crank is all-or-nothing — an aborted delivery rolls the store back to the 'start' savepoint and discards buffered effects, while a successful delivery flushes the crank buffer; vat termination and garbage collection run after either outcome.
source_authors: [Erik Marks, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-06-28
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. Comment-fragment ingest of the crank-result handler in KernelQueue.ts; the atomic-output-or-rollback discipline cross-comparable with the garden's daemon-persistence work. See [[ocap-kernel]].
---

## Abstract

`#processCrankResult(crankResult, queueItem)` is the kernel's **atomicity gate**: a crank either commits or it does not, and this method chooses. On `crankResult.abort` it rewinds the kernel store to the `'start'` savepoint (`rollbackCrank('start')`), so a failed delivery leaves no trace, and it discards the kernel subscriptions that were queued for invocation during the crank (`#resolvedWithKernelSubscription = []`). The code comments spell out the two consequences of rollback: for an active vat the message "can be retried in a future crank," and for a terminated vat "the message will just go splat." When a rollback coincides with termination of the target vat and the queue item was a `send` carrying a result, the handler rejects that result's JS subscription immediately, because "the rollback undid the delivery, and the vat won't be around to handle a retry." On the success path (no abort) it instead **flushes the crank buffer** (`#flushCrankBuffer`), releasing the vat's buffered outputs to the run queue. Either way, a `crankResult.terminate` triggers `#terminateVat`, and every crank ends with `collectGarbage()`. A standing `TODO` notes that today every error terminates the vat, and that a retry-then-terminate-after-N-failures policy is "probably where we should implement the vat restart logic."

## Body

### Abort path: rollback to the savepoint, discard buffered effects

```ts
if (crankResult?.abort) {
  // Rollback the kernel state to before the failed delivery attempt.
  // For active vats, this allows the message to be retried in a future crank.
  // For terminated vats, the message will just go splat.
  this.#kernelStore.rollbackCrank('start');
  // Discard kernel subscriptions that were queued for invocation
  this.#resolvedWithKernelSubscription = [];
  ...
}
```

The rollback target is the `'start'` savepoint that `run` took at the top of the crank (see the sibling section on the run loop). Rolling back to it reverts every store mutation the failed delivery made, which is why the comment can promise that an active vat's message is simply retriable later. The `#resolvedWithKernelSubscription` list (promises that resolved during this crank and are awaiting a kernel-side callback) is cleared, because those resolutions are part of the work being undone.

### Terminating-vat-with-result: reject the subscription immediately

```ts
// If the vat is being terminated, reject the JS subscription for this
// message's result promise immediately. The rollback undid the delivery,
// and the vat won't be around to handle a retry.
if (
  crankResult.terminate &&
  queueItem.type === 'send' &&
  queueItem.message.result
) {
  const subscription = this.subscriptions.get(queueItem.message.result);
  if (subscription) {
    this.subscriptions.delete(queueItem.message.result);
    subscription.reject(crankResult.terminate.info);
  }
}
```

When the rollback is paired with vat termination, the ordinary "retry next crank" promise no longer holds, so any kernel-held JS subscription on the message's result is rejected now with the termination info, rather than left hanging forever.

### The standing TODO: all errors terminate, restart logic not yet present

```ts
// TODO: Currently all errors terminate the vat, but instead we could
// restart it and terminate the vat only after a certain number of failed
// retries. This is probably where we should implement the vat restart logic.
```

This is a candidate comment-versus-code observation: the comment documents a deliberately conservative present behavior (any delivery error is fatal to the vat) and names the spot where a softer retry-then-terminate policy would live.

### Success path: flush the crank buffer

```ts
} else {
  // Upon on successful crank completion, enqueue buffered vat outputs for delivery.
  this.#flushCrankBuffer();
}
```

This is the commit half of the all-or-nothing pair. A vat's outputs produced during the crank are not visible on the run queue until the crank succeeds; flushing the buffer is what makes them visible. The buffering mechanism and the `immediate` flag that feeds it are covered in the sibling section on enqueue and resolution.

### After either outcome: termination and garbage collection

```ts
// Vat termination during delivery is triggered by an illegal syscall
// or by syscall.exit().
if (crankResult?.terminate) {
  const { vatId, info } = crankResult.terminate;
  await this.#terminateVat(vatId, info);
}
this.#kernelStore.collectGarbage();
```

Termination is requested by the delivery result (its triggers, per the comment, are an illegal syscall or an explicit `syscall.exit()`) and is carried out after the commit-or-rollback decision. `collectGarbage()` closes every crank regardless of outcome, pairing with the GC-action priority that opens the next crank's item selection.

## Lineage note

This abort-or-flush gate is ocap-kernel's in-code statement of the **output-valid rollback-recovery** property: a delivery's side effects are buffered and only released atomically on success, and a failure rewinds cleanly. The `metamask-ocap-kernel--overview` ingest flagged this "crank-buffering atomic-output-or-rollback discipline" as directly cross-comparable with the garden's daemon-persistence and formula-graph work, and `docs/ken-protocol-assessment.md` tabulates it against Kelly, Karp, Stiegler, Close, and Cho's HPL-2010-155. The savepoint and rollback primitives themselves live in the kernel-store package. See [[ocap-kernel]].

Source: [packages/ocap-kernel/src/KernelQueue.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelQueue.ts) (lines 132-180) at commit `d979a06`.
