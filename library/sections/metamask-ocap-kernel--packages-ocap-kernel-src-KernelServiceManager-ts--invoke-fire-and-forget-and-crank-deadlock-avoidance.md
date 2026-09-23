---
title: "invokeKernelService: fire-and-forget dispatch via E(), promise-chaining to avoid crank deadlock, and three-path DELIVERY_FAILED resolution"
source: packages/ocap-kernel/src/KernelServiceManager.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelServiceManager.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelServiceManager.ts
source_line_range: "136-201"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: "invokeKernelService deliberately does NOT await the service method: it unserializes [method, args] from the message's methargs, calls the method through E() (so local objects and remote CapTP presences both work), and attaches a then/catch to the returned promise that resolves the kernel result promise (as the 'kernel' decider) in a future turn — the design that lets a service method call waitForCrank() without deadlocking the very crank that invoked it. A synchronous throw before a promise is returned is caught separately, and all three failure paths reject the result with a DELIVERY_FAILED kernel error (or just log if the message had no result promise)."
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-06
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of KernelServiceManager's invokeKernelService. Fourteenth ocap-kernel ingest, sixth kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

`invokeKernelService(target, message)` is the receiving end of [`KernelRouter.#invokeKernelService`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md) — where the router's `endpointId === 'kernel'` branch lands. Its density is one deliberate design decision stated in a long JSDoc: **it does NOT await the service method's result.** It looks up the `KernelService` by `target` kref (throwing if none), unserializes `[method, args]` from the message's marshalled `methargs` with `kunser` (asserting the method is a string and args is an array), then calls the method **through `E()`** and attaches a `.then/.catch` that resolves the kernel result promise **in a future turn of the event loop**. The reason the JSDoc gives: a service method may itself call `waitForCrank()`; if `invokeKernelService` awaited the method inline, the crank could never complete, so `waitForCrank` would never resolve — a **deadlock**. By dispatching fire-and-forget and letting the crank finish immediately, the resolution is decoupled from the crank that triggered it. `E()` (not a direct method call) is used so the same code path works for a **local object** and for a **remote CapTP presence** whose methods are not enumerable. All three failure modes — an async rejection, a synchronous throw before a promise is returned, and (implicitly) a success — resolve the kernel promise with the `'kernel'` decider: success carries `kser(resultValue)`; either failure carries `makeKernelError('DELIVERY_FAILED', detail)`; a message with **no** `result` promise just logs the error instead.

## Body

### The JSDoc: why the method is not awaited

```ts
/**
 * Invoke a kernel service.
 *
 * This method does NOT await the service method result. Instead, it uses
 * promise chaining to resolve the kernel promise when the method eventually
 * completes. This allows service methods to use `waitForCrank()` without
 * causing deadlock - the crank can complete, and the resolution happens
 * in a future turn of the event loop.
 *
 * @param target - The target kref of the service.
 * @param message - The message to invoke the service with.
 */
invokeKernelService(target: KRef, message: KernelMessage): void {
```

This is the load-bearing comment. `waitForCrank()` is the ocap-kernel primitive a kernel-service (or a kernel facet) uses to suspend until the *current* crank commits — the same primitive the [`Kernel.ts`](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--crank-reentrancy-and-the-terminate-callback-deadlock.md) crank-reentrancy section flags as a deadlock hazard when a callback awaits from *inside* the loop. If `invokeKernelService` awaited the service method, and the method awaited `waitForCrank`, the crank that is blocked on the method could never reach its commit, and `waitForCrank` would hang forever. The fix is to make invocation **synchronous-to-the-crank but asynchronous-to-the-result**: return `void` immediately (the crank completes), and resolve the caller's result promise later via a promise chain. The method's signature returns `void`, not a promise, which is the type-level statement of "do not await me."

### Unserialize, then dispatch through E()

```ts
const kernelService = this.#kernelServicesByObject.get(target);
if (!kernelService) {
  throw Error(`No registered service for ${target}`);
}
const { methargs, result } = message;
const [method, args] = kunser(methargs) as [string, unknown[]];
assert.typeof(method, 'string');
assert(Array.isArray(args));

// Use E() so this works for both local objects and remote presences
// (CapTP proxies whose methods aren't enumerable).
// Call the method without awaiting. This allows the crank to complete
// even if the method internally waits for the crank to end.
try {
  const service = kernelService.service as Record<
    string,
    (...methodArgs: unknown[]) => unknown
  >;
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  const resultPromise = E(service)[method]!(...args);
```

The target must be a **currently-registered** service (the by-kref lookup from the [registry section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts--service-registry-registration-and-dual-index.md)); an unknown kref throws synchronously (this is the "no owner"-adjacent error, distinct from the router's own splat handling). The message's `methargs` is the marshalled `[method, args]` tuple; `kunser` unserializes it and the two `assert`s enforce the wire shape defensively. The comment justifies **`E()`**: a kernel service can be a **remote CapTP presence** (a proxy whose methods are not own-enumerable properties), so a direct `service[method](...)` would fail on it — `E(service)[method](...)` goes through the eventual-send machinery that works uniformly for a local object and a remote presence. This is the same `@endo/eventual-send` `E` the whole [[ocap-kernel]] uses for inter-vat messaging, applied here to reach a possibly-remote service implementation.

### The three resolution paths, all as the 'kernel' decider

```ts
  Promise.resolve(resultPromise)
    .then((resultValue) => {
      if (result) {
        this.#kernelQueue.resolvePromises('kernel', [
          [result, false, kser(resultValue)],
        ]);
      }
      return undefined;
    })
    .catch((problem: unknown) => {
      if (result) {
        const detail =
          problem instanceof Error ? problem.message : String(problem);
        this.#kernelQueue.resolvePromises('kernel', [
          [result, true, makeKernelError('DELIVERY_FAILED', detail)],
        ]);
      } else {
        this.#logger?.error('Error in kernel service method:', problem);
      }
    });
} catch (syncError) {
  // Handle synchronous errors thrown before returning a Promise
  if (result) {
    const detail =
      syncError instanceof Error ? syncError.message : String(syncError);
    this.#kernelQueue.resolvePromises('kernel', [
      [result, true, makeKernelError('DELIVERY_FAILED', detail)],
    ]);
  } else {
    this.#logger?.error('Error in kernel service method:', syncError);
  }
}
```

Three outcomes, resolved into the kernel run queue with **`'kernel'` as the decider** (the same decider-authority mechanism [`KernelQueue`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md) enforces — only the entity that owns a promise's resolution right may resolve it, and for a kernel-service result that entity is the kernel itself):

- **Fulfilled** → `resolvePromises('kernel', [[result, false, kser(resultValue)]])` — the `false` is "not rejected," and `kser` re-serializes the return value into a marshalled resolution for the waiting caller.
- **Rejected (async)** → the `.catch` rejects with `[result, true, makeKernelError('DELIVERY_FAILED', detail)]` — the `true` is "rejected," and the error is normalized to a `DELIVERY_FAILED` kernel error carrying the original message string. This is the **same error code** the router's [`#deliverSend`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md) uses for a failed vat delivery, so a caller sees one uniform "your message did not complete" failure regardless of whether the target was a vat or a kernel service.
- **Threw synchronously** (before a promise was even returned — e.g. `E(service)[method]` blew up while marshalling arguments) → the outer `try/catch` catches it and rejects with the same `DELIVERY_FAILED` shape.

In all three, a message with **no `result` promise** (a send-only, no reply expected) takes the `else` branch: there is nobody to resolve, so a failure is merely logged. `Promise.resolve(resultPromise)` wraps the method's return in case it returned a non-thenable, guaranteeing the chain runs.

## Notice / drift check

Each comment matches its code. The class-level JSDoc's central claim ("does NOT await ... uses promise chaining ... allows service methods to use `waitForCrank()` without causing deadlock ... resolution happens in a future turn") is exactly what the `Promise.resolve(...).then/.catch` with a `void` return implements. The inline `E()` comment ("works for both local objects and remote presences (CapTP proxies whose methods aren't enumerable)") correctly explains why `E()` is used instead of a direct call. The "Call the method without awaiting" and "Handle synchronous errors thrown before returning a Promise" comments each sit on the code they describe. No comment-versus-code contradiction in this cluster. ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

The "resolve the caller's promise in a later turn rather than awaiting inline" shape is the SwingSet **device/kernel-service** discipline: kernel-side code must not block the crank on work whose completion depends on the crank finishing. Endo's counterpart is structural rather than conventional — `HandledPromise` and the eventual-send queue already decouple a send from its settlement, so an Endo host object never faces the "await the reply inside the turn that produced it" deadlock in the first place; ocap-kernel reconstructs that decoupling explicitly because its crank is a synchronous transaction boundary. The `DELIVERY_FAILED` normalization mirrors the router's, giving the kernel one failure vocabulary across vat and kernel-service targets. See [[ocap-kernel]], the decider-authority resolution rule ([KernelQueue.ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--immediate-versus-buffered-enqueue-and-decider-authorized-resolution.md)), the crank-reentrancy `waitForCrank` deadlock this design avoids ([Kernel.ts](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--crank-reentrancy-and-the-terminate-callback-deadlock.md)), and the router leg that calls this ([KernelRouter.ts #deliverSend](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md)).

Source: [packages/ocap-kernel/src/KernelServiceManager.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelServiceManager.ts) (lines 136-201) at commit `d979a06`.
