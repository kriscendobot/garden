---
title: "Idempotent, endowment-teardown-first termination: the shared termination promise and why teardown failures never block stream closure"
source: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatSupervisor.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_line_range: "116-248"
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-24
comment_subject: VatSupervisor.terminate is idempotent via a shared #terminationPromise (concurrent callers await the same teardown+stream-close completion rather than an early-return guard's premature resolution), and #doTerminate runs endowment teardown FIRST (releasing pending timers and open connections) before closing the kernel stream, logging teardown failures — including each sub-error of an AggregateError — but never letting them block stream closure, so the original termination error always reaches the kernel.
source_authors: [Dimitris Marlagkoutsos, Erik Marks, grypez]
ingested: 2026-07-05
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo. Comment-fragment ingest of the terminate / #doTerminate cluster plus the #terminationPromise and #endowmentsTeardown field comments. Twelfth ocap-kernel ingest, fourth kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

`VatSupervisor`'s termination path is small but carefully commented, and the two design decisions its comments defend are worth curating. First, **termination is idempotent through a shared promise**: `terminate()` memoizes the in-flight teardown as `#terminationPromise`, and every concurrent caller returns that *same* promise, so they all await the one real teardown-plus-stream-close completion rather than a premature resolution from an early-return guard. Second, **endowment teardown runs first, and its failures never block stream closure**: `#doTerminate` releases the vat's endowment resources (pending timers, open network connections) *before* closing the kernel stream, logs any teardown failure — walking each sub-error of an `AggregateError` — but always proceeds to `#kernelStream.end(error)` so the original termination `error` reaches the kernel no matter what teardown did. This is the vat-side termination discipline that complements `VatHandle`'s kernel-side death protocol.

## Body

### The two field comments that frame the design

The class fields carry the rationale before the methods use it:

```ts
/**
 * Releases resources held by the endowment factories (e.g. pending timers,
 * open network connections). Invoked from {@link terminate} before closing
 * the kernel stream; failures are logged but do not prevent stream closure.
 */
readonly #endowmentsTeardown: () => Promise<void>;

/**
 * Promise of the in-flight termination, or `null` if not yet started.
 * Concurrent callers share this promise so they all await the same
 * teardown + stream-close completion rather than getting a premature
 * resolution from an early-return guard.
 */
#terminationPromise: Promise<void> | null = null;
```

The `#endowmentsTeardown` comment states the ordering contract (teardown before stream close) and the failure policy (logged, non-blocking). The `#terminationPromise` comment states *why* a shared promise rather than a boolean guard: a boolean early-return would let a second caller resolve *before* the first caller's teardown finished, so the promise is the memoized completion every caller must observe.

### Idempotent terminate

```ts
async terminate(error?: Error): Promise<void> {
  if (this.#terminationPromise) {
    return this.#terminationPromise;
  }
  this.#terminationPromise = this.#doTerminate(error);
  return this.#terminationPromise;
}
```

The first caller sets `#terminationPromise` to the running `#doTerminate(error)`; any later caller (a second `terminate()`, the stream-drain's `StreamReadError` self-terminate, an explicit kernel-driven teardown) sees the non-null field and returns the *same* promise. Every caller therefore resolves exactly when the real teardown-and-close finishes — the "same teardown + stream-close completion" the field comment promises.

### Teardown-first, failure-tolerant #doTerminate

```ts
async #doTerminate(error?: Error): Promise<void> {
  try {
    await this.#endowmentsTeardown();
  } catch (teardownError) {
    const message = `Endowment teardown failed during terminate of vat "${this.id}"`;
    if (teardownError instanceof AggregateError) {
      for (const subError of teardownError.errors) {
        this.#logger.error(message, subError);
      }
    } else {
      this.#logger.error(message, teardownError);
    }
  }
  await this.#kernelStream.end(error);
}
```

The ordering is deliberate and matches the `terminate` JSDoc ("Endowment teardown runs first so pending timers and other resources are released before the kernel stream closes"): the vat's endowment-held resources are released *before* the channel to the kernel is torn down, so a timer or open connection cannot outlive the stream. The `try/catch` is the "failures are logged but never block stream closure" policy in code — a teardown fault is logged (and if it is an `AggregateError`, *each* constituent sub-error is logged individually, since endowment teardown fans out over several factories that may each fail) but control always falls through to `await this.#kernelStream.end(error)`. The `error` argument — the original reason for termination, e.g. a `StreamReadError` or an illegal-syscall fault — is passed straight to `#kernelStream.end`, so the kernel always learns *why* the vat died, even if teardown itself misbehaved.

## Notice / drift check

Both field comments and the `terminate` JSDoc match the code exactly: teardown precedes `#kernelStream.end`; teardown failures are caught, logged, and non-blocking; the `AggregateError` branch logs each sub-error; and the shared-promise guard returns the memoized promise to concurrent callers rather than a boolean early-return. No comment-versus-code drift in this cluster.

## Lineage note

Ordered, idempotent, failure-tolerant teardown of an isolated worker is a general supervisor concern rather than a SwingSet-specific one; the comparative interest for Endo is the explicit "teardown before stream close, and never let teardown failure swallow the death reason" contract — a concrete pattern for the daemon's own worker-teardown paths. See [[ocap-kernel]] and the kernel-side counterpart, [VatHandle priority-ordered crank result and termination section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--priority-ordered-crank-result-and-termination.md), where `VatHandle.terminate()` rejects every promise the dying vat was the decider for — the kernel-store bookkeeping that pairs with this vat-side resource teardown.

Source: [packages/ocap-kernel/src/vats/VatSupervisor.ts](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/packages/ocap-kernel/src/vats/VatSupervisor.ts) (the `#endowmentsTeardown` / `#terminationPromise` field comments at lines 116-129 and the `terminate` / `#doTerminate` methods at lines 208-248) at commit `175b7c0`.
