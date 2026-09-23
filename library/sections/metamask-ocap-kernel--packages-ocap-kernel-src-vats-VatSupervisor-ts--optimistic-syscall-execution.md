---
title: "Optimistic syscall execution: the vat fires a syscall and continues without awaiting, and failure is caught crank-side in VatHandle (terminate + rollback)"
source: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatSupervisor.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_line_range: "280-300"
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-24
comment_subject: executeSyscall issues the vat's syscalls under an optimistic-execution model — to satisfy liveslots' synchronous syscall interface the vat sends the syscall as a fire-and-forget notification and immediately returns ['ok', null] without awaiting, assuming success; the kernel processes syscalls synchronously and any failure is caught crank-side in VatHandle, which terminates the vat and rolls the crank back.
source_authors: [Dimitris Marlagkoutsos, Erik Marks, grypez]
ingested: 2026-07-05
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo. Comment-fragment ingest of the executeSyscall "IMPORTANT" architecture comment; the vat-side complement of VatHandle's crank-side error handling. Twelfth ocap-kernel ingest, fourth kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

`executeSyscall` is the single method by which the supervised vat asks the kernel for effects, and its longform `IMPORTANT` comment captures the whole **optimistic-execution model** the vat/kernel boundary runs on. Liveslots demands a *synchronous* syscall interface — `dispatch` runs vat user code that calls `syscall.send(...)` and expects an immediate return — but the kernel is on the other end of an asynchronous duplex stream. ocap-kernel bridges the gap by making the vat **fire the syscall as a fire-and-forget JSON-RPC notification and immediately return `['ok', null]` without awaiting the kernel's response**, on the *assumption* that the syscall will succeed. Correctness is preserved not by checking each syscall's result inline but by a division of labor: the kernel processes syscalls synchronously on receipt, and any failure is caught **crank-side in `VatHandle`**, which terminates the offending vat and rolls the whole crank back. The optimism is therefore safe because a wrong optimistic assumption is never committed — the crank that made it is discarded wholesale.

## Body

### The method and its IMPORTANT comment

```ts
executeSyscall(vso: VatSyscallObject): VatSyscallResult {
  // IMPORTANT: Syscall architecture design explanation:
  // - Vats operate on an "optimistic execution" model - they send syscalls and continue execution
  //    without waiting for responses, assuming success.
  // - The Kernel processes syscalls synchronously on receipt and failures are caught in VatHandle.
  // - The vat is terminated and the crank is rolled back if a syscall fails.
  this.#rpcClient
    .notify('syscall', coerceVatSyscallObject(vso))
    // Just to please the linter (notifications never reject)
    .catch(() => undefined);
  return ['ok', null];
}
```

Three facts, all load-bearing:

1. **Fire-and-forget, no await.** The syscall goes out via `this.#rpcClient.notify('syscall', ...)` — a JSON-RPC *notification*, which by construction has no response to wait for. The vat does not pause; it continues its synchronous turn. The trailing `.catch(() => undefined)` is explicitly annotated "Just to please the linter (notifications never reject)": the notify promise is never expected to reject, and the catch only exists to satisfy the floating-promise lint rule.
2. **Always returns success to liveslots.** The method returns the constant `['ok', null]` — a `VatSyscallResult` claiming unconditional success — regardless of what the kernel will actually do. This is what satisfies liveslots' synchronous contract: the syscall "returns" instantly with an optimistic ok.
3. **Failure is somebody else's job.** The comment names exactly where the truth is enforced: the kernel processes the syscall synchronously, and "failures are caught in `VatHandle`." A failed syscall does not propagate back through this return value; instead `VatHandle`'s crank-result logic (illegal syscall > delivery error > vat-requested exit) turns it into an abort-and-terminate directive, and the run loop rolls the crank's store savepoint back.

### Why the optimism is safe

The pattern only works because the surrounding crank is **transactional**. A syscall's real effect is applied to the kernel store *within* the current crank, and the crank commits atomically only if it completes cleanly. If any syscall in the crank was illegal or a delivery errored, `VatHandle` folds that into the crank result, the vat is terminated, and `KernelQueue` aborts the crank — rolling the store back to the `'start'` savepoint so none of the optimistically-assumed-successful effects survive. The vat that made a bad optimistic assumption is destroyed rather than corrected, so the vat never observes a state where its optimism was wrong: it either completed the crank (optimism was correct) or it no longer exists (crank rolled back).

## Translation

| ocap-kernel term | What it denotes | Endo / reader-side analog |
|---|---|---|
| optimistic execution | vat sends syscall, assumes success, does not await | no direct Endo analog — Endo's daemon does not run liveslots vats; CapTP calls are genuinely async with real promise results |
| `['ok', null]` | a `VatSyscallResult` claiming success unconditionally | a resolved result the caller trusts until proven otherwise |
| "caught in VatHandle" | the kernel-side crank-result fault-folding + terminate | the transactional boundary that discards a bad turn wholesale |

## Notice / drift check

The `IMPORTANT` comment is accurate on every point: `notify` is a genuine fire-and-forget notification, no response is awaited, the method returns the constant `['ok', null]`, and the "caught in `VatHandle` / terminate + roll back" claim matches the kernel-side `VatHandle` crank-result-and-termination logic and the `KernelQueue` abort/rollback path already ingested. The "notifications never reject" comment matches the `.catch(() => undefined)` it annotates. No comment-versus-code drift in this cluster.

## Lineage note

Optimistic synchronous syscalls into an asynchronous kernel are a SwingSet/liveslots idiom (`@agoric/swingset-liveslots` requires the synchronous `VatSyscallResult` return that forces the optimism). Endo has no equivalent because its daemon does not host liveslots vats; a comparative reader should note this as a concrete cost/benefit datum — the synchronous liveslots interface buys ergonomic vat code at the price of "assume success, terminate-and-roll-back on failure" rather than per-syscall error handling. See [[ocap-kernel]], the kernel-side fault handler [VatHandle priority-ordered crank result section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--priority-ordered-crank-result-and-termination.md), and the crank abort/rollback machinery in [KernelQueue.ts crank-abort-versus-commit-flush section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--crank-abort-rollback-versus-commit-flush.md).

Source: [packages/ocap-kernel/src/vats/VatSupervisor.ts](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/packages/ocap-kernel/src/vats/VatSupervisor.ts) (lines 280-300) at commit `175b7c0`.
