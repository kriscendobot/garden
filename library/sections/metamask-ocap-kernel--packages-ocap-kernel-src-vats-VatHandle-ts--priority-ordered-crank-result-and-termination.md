---
title: "Priority-ordered crank result and vat termination (illegal syscall over delivery error over vat-requested exit)"
source: packages/ocap-kernel/src/vats/VatHandle.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatHandle.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatHandle.ts
source_line_range: "308-400"
source_branch: main
source_commit: d54aa5ceb3ed41a182b5044dd27a95f07bac5a07
source_date: 2026-04-21
comment_subject: #getDeliveryCrankResult folds three fault conditions into a hardened CrankResult in a deliberate priority order — an illegal syscall outranks a delivery error, which outranks a vat-requested termination — each producing an abort plus a terminate directive; and terminate() itself, when killing a vat permanently, rejects every promise this vat was the decider for, rejects all outstanding RPC calls, and deletes the vat from the store.
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-07-05
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the VatHandle crank-result priority order and terminate() teardown. Eleventh ocap-kernel ingest, third kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

After a delivery, `#getDeliveryCrankResult` folds up to three fault conditions into a single **hardened** `CrankResult`, and the file explicitly documents that the `if / else if` chain is a **priority order, not an accident of layout**: an **illegal syscall** outranks a **delivery error**, which outranks a **vat-requested termination**. The first matching condition wins, sets `abort = true` (rewind the crank), and fills in a `terminate` directive naming the vat. The paired `terminate()` method is the actual teardown: when killing a vat permanently (`terminating = true`), it ends the stream, then — because this vat may be the **decider** for promises other vats are awaiting — rejects every such promise with a `VAT_TERMINATED` kernel error, rejects all still-outstanding RPC calls to the vat, and deletes the vat from the kernel store. The two together are the vat's death protocol: decide *whether and why* to die (the crank result), then *dismantle cleanly* (terminate).

## Body

### The priority-ordered crank result

```ts
async #getDeliveryCrankResult(): Promise<CrankResult> {
  const results: CrankResult = { didDelivery: this.vatId };

  // These conditionals express a priority order: the consequences of an
  // illegal syscall take precedence over a vat requesting termination, etc.
  if (this.#vatSyscall.illegalSyscall) {
    results.abort = true;
    const { info } = this.#vatSyscall.illegalSyscall;
    // TODO: For now, vat errors both rewind changes and terminate the vat.
    // Some day, they might rewind changes and retry the syscall.
    // We should terminate the vat only after a certain # of failed retries.
    results.terminate = { vatId: this.vatId, reject: true, info };
  } else if (this.#vatSyscall.deliveryError) {
    results.abort = true;
    const info = makeFatalKernelError('INTERNAL_ERROR', this.#vatSyscall.deliveryError);
    results.terminate = { vatId: this.vatId, reject: true, info };
  } else if (this.#vatSyscall.vatRequestedTermination) {
    if (this.#vatSyscall.vatRequestedTermination.reject) {
      results.abort = true; // vatPowers.exitWithFailure wants rewind
    }
    results.terminate = { vatId: this.vatId, ...this.#vatSyscall.vatRequestedTermination };
  }

  return harden(results);
}
```

The three tiers, highest first:

1. **Illegal syscall.** The vat did something forbidden. Abort the crank and terminate with `reject: true`. The `info` comes from the recorded illegal-syscall detail.
2. **Delivery error.** The delivery itself failed internally. Abort and terminate, wrapping the error as a **fatal** `INTERNAL_ERROR` kernel error.
3. **Vat-requested termination.** The vat asked to exit (via `vatPowers.exitWith...`). This is the *cooperative* case — a clean `exitWithSuccess` does **not** abort (no rewind: the vat's final state is kept), while `exitWithFailure` sets `reject: true` and *does* abort, as the inline note "`vatPowers.exitWithFailure wants rewind`" records. The terminate directive spreads the vat's own requested fields.

The centerpiece comment names the design intent: the ordering is deliberate, so that (for example) a vat which both requested a clean exit *and* committed an illegal syscall in the same crank is treated as the illegal case, not the graceful one. The `TODO` is an honest future-work marker: today an illegal syscall both rewinds and kills; a future version might rewind-and-retry a bounded number of times before killing. The whole result is `harden`ed before return — the crank result is a hardened, tamper-proof record.

### terminate(): the clean dismantling

```ts
async terminate(terminating: boolean, error?: Error): Promise<void> {
  await this.#vatStream.end(error);
  const terminationError = error ?? new VatDeletedError(this.vatId);
  if (terminating) {
    // Reject promises exported to other vats for which this vat is the decider
    const failure = makeKernelError('VAT_TERMINATED', terminationError.message);
    for (const kpid of this.#kernelStore.getPromisesByDecider(this.vatId)) {
      this.#kernelQueue.resolvePromises(this.vatId, [[kpid, true, failure]]);
    }
    this.#rpcClient.rejectAll(terminationError);
    this.#kernelStore.deleteVat(this.vatId);
  }
}
```

`terminate` always ends the stream. The `terminating` flag distinguishes a *permanent kill* from a mere channel close: only when `terminating` is set does the handle do the full ocap-hygiene teardown. The load-bearing move is the **decider-promise rejection**: a dying vat may be the *decider* (the party authorized to resolve) for promises other vats are blocked on, and if it just vanished those promises would dangle forever. So it enumerates `getPromisesByDecider(vatId)` and rejects each through `kernelQueue.resolvePromises` with a `VAT_TERMINATED` failure. It then `rejectAll`s the outstanding in-flight RPC calls to the vat (so their awaiters see the termination error rather than hanging), and finally `deleteVat` removes the vat's record — the deletion that, per the delivery-surface section, makes the "don't roll back the vat's KV" rule safe.

## Translation

| VatHandle term | What it denotes |
|---|---|
| decider | the vat authorized to resolve/reject a given kernel promise (`getPromisesByDecider`); a SwingSet term the ocap-kernel glossary ingest documents. |
| crank result `abort` | rewind this crank's kernel-DB changes (the transactional-turn rollback). |
| crank result `terminate` | a directive to the run loop to tear this vat down after the crank. |
| `reject: true` | when terminating, reject (rather than silently drop) the vat's decided promises / this delivery's effects. |

## Notice / drift check

The comments match the code precisely: the "priority order" comment annotates a real `if / else if / else if` cascade whose branches are ordered exactly as described; the `exitWithFailure wants rewind` note matches the guarded `results.abort = true`; and `terminate`'s "Reject promises ... for which this vat is the decider" comment matches the `getPromisesByDecider` loop. The `TODO` is a forward-looking marker, not a claim about present behavior, so it is not drift. No comment-versus-code drift in this cluster.

## Lineage note

The decider concept, the crank-as-transactional-turn (abort = rewind), and the "bring out your dead" GC vocabulary are all SwingSet-derived. The specific discipline here — that terminating a vat must proactively reject the promises it was the decider for, rather than leaking them — is a general liveness obligation for any capability system where one party is authorized to resolve another's promises; the Endo/HandledPromise world faces the same "who resolves this if the resolver dies" question. See [[ocap-kernel]], the [delivery-surface / KV-commit section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--delivery-surface-and-kv-commit-on-success.md) whose "erroring vats are always terminated" invariant this method enacts, and the [Kernel.ts crank-reentrancy section](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--crank-reentrancy-and-the-terminate-callback-deadlock.md) for how the orchestrator's in-crank terminate callback reaches vat teardown without deadlocking.

Source: [packages/ocap-kernel/src/vats/VatHandle.ts](https://github.com/MetaMask/ocap-kernel/blob/d54aa5ceb3ed41a182b5044dd27a95f07bac5a07/packages/ocap-kernel/src/vats/VatHandle.ts) (lines 308-330 for `terminate`, 363-400 for `#getDeliveryCrankResult`) at commit `d54aa5c`.
