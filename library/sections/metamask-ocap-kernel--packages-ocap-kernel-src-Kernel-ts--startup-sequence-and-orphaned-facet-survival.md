---
title: "The kernel startup sequence: ordering constraints and orphaned-facet survival across incarnations"
source: packages/ocap-kernel/src/Kernel.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/Kernel.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/Kernel.ts
source_line_range: "257-324"
source_branch: main
source_commit: 052f4d4865b39df29f8f67fdffa3c52ef17b4282
source_date: 2026-05-12
comment_subject: The async #init sequence is carefully ordered — always provide the kernel facet (so run-queue messages targeting a previous incarnation's facet kref do not crash the queue), restore persisted system subclusters, start all previously-running vats before the queue so queued messages have live targets, start the forever run loop non-blocking with its run-loop error swallowed, and only then launch new system subclusters.
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-28
ingested_by: scholar
topics: [daemon, persistence]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the #init startup-ordering and facet-survival comments in Kernel.ts. See [[ocap-kernel]].
---

## Abstract

`Kernel.make` constructs the kernel and then awaits the private `#init`, whose body is a **strictly ordered boot sequence** where every step's position is justified by a comment. It sets the remote message handler, then **always provides the kernel facet** even with no system subcluster configs, because the run queue may still hold messages targeting the kernel facet kref from a **previous incarnation's** system subclusters: if the facet were not registered, `invokeKernelService` would throw and **crash the kernel queue**. The comment notes the ideal (purge orphaned messages before the queue starts) and why it is not done (the run queue has no selective-removal capability). It then restores persisted system subclusters (deleting ones whose config is gone, so orphaned vats are not started), **starts all previously-running vats before starting the queue** so that any queued message has its target vat ready, starts the forever run loop **non-blocking** with a `.catch` that logs but deliberately does not re-throw (to avoid an unhandled rejection in a long-running task), and only then launches **new** system subclusters, which requires the queue to already be running. The companion `provideFacet()` is idempotent: it returns an existing `kernelFacet` service or creates, registers (`systemOnly: true`), and returns one.

## Body

### Always provide the facet — orphaned messages from a previous incarnation

The most load-bearing comment in `#init` explains why the facet is registered unconditionally:

```ts
// Always provide the kernel facet, even when there are no system subcluster
// configs. The run queue may contain messages targeting the kernel facet kref
// from a previous incarnation's system subclusters. If the facet is not
// registered, invokeKernelService throws and crashes the kernel queue.
// Ideally, orphaned messages would be purged before the queue starts, but
// the run queue has no selective removal capability.
this.provideFacet();
```

This is a persistence-driven invariant. The run queue is durable; a message enqueued by a system subcluster in one kernel incarnation can still be sitting in the queue after a restart, even if the current configuration declares no system subclusters at all. When the run loop later dequeues that message and routes it to the kernel facet kref, the service-invocation path (`invokeKernelService`) must find a registered facet or it throws — and because the throw happens inside crank processing, it crashes the queue. Registering the facet always makes the orphaned message harmless (it gets delivered to a live facet) instead of fatal. The comment is candid that the cleaner fix (purge the orphans up front) is unavailable because the run queue offers no selective removal.

### provideFacet is idempotent and systemOnly

```ts
provideFacet(): KernelFacet {
  const existing = this.#kernelServiceManager.getKernelService('kernelFacet');
  if (existing) {
    return existing.service as KernelFacet;
  }
  const kernelFacet = makeKernelFacet(this);
  this.#kernelServiceManager.registerKernelServiceObject(
    'kernelFacet',
    kernelFacet,
    { systemOnly: true },
  );
  return kernelFacet;
}
```

The facet re-exposes the kernel's own control surface to a system vat (see the [[ocap-kernel]] concept). It is registered `systemOnly: true`, so only system subclusters may reach it. The idempotent shape lets `#init` call it unconditionally without risking a double registration.

### Start vats before the queue; launch new system subclusters after

The remaining ordering carries its own justifications:

```ts
// Restore persisted system subclusters and delete ones that no
// longer have a config, to ensure that orphaned vats aren't started
this.#subclusterManager.initSystemSubclusters(configs);

// Start all vats that were previously running before starting the queue
// This ensures that any messages in the queue have their target vats ready
await this.#vatManager.initializeAllVats();

// Start the kernel queue processing (non-blocking)
// This runs for the entire lifetime of the kernel
this.#kernelQueue
  .run(this.#kernelRouter.deliver.bind(this.#kernelRouter))
  .catch((error) => {
    this.#logger.error(
      'Run loop error (kernel may be non-functional):',
      error,
    );
    // Don't re-throw to avoid unhandled rejection in this long-running task
  });

// Launch new system subclusters (requires queue to be running)
await this.#subclusterManager.launchNewSystemSubclusters(configs);
```

Three ordering constraints are stated:

1. **Restore-and-prune system subclusters first**, deleting any whose config no longer exists, so a restart does not resurrect orphaned vats.
2. **Initialize all previously-running vats before the queue starts**, so that when the run loop begins draining, every message already in the queue has a live target vat. Starting the queue first would risk delivering to a vat that is not yet up.
3. **Start the run loop non-blocking, then launch new system subclusters**, because launching a new subcluster sends a bootstrap message that the running queue must process. The `.run(...)` promise is a `Promise<never>` (it never resolves; see the sibling KernelQueue run-loop section), so it is intentionally not awaited; instead its rejection is caught, logged, and swallowed so a run-loop failure does not surface as an unhandled rejection in this long-running task.

### Why this matters to the garden

This sequence is a compact case study in restart-safety for a durable message queue: the kernel must reconcile the *persisted* queue against the *current* configuration before it begins draining. The facet-always-provide rule is the defensive counterpart to a queue that cannot selectively forget. Endo's daemon, which also persists work across restarts, faces the same class of problem (messages or tasks that outlive the configuration that created them), so the ordering discipline and the "make the orphan harmless rather than fatal" stance are worth comparing against the daemon's own restart path.

## Lineage note

Restoring persisted vats before resuming the run loop, and treating queued cross-incarnation messages as a first-class hazard, are SwingSet-lineage concerns (the kernel's durable run queue is the SwingSet inheritance). See [[ocap-kernel]] and the sibling [KernelQueue.ts run-loop section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--forever-run-loop-and-crank-lifecycle.md) for the forever loop this sequence starts, and the [incarnation-identity section](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--incarnation-identity-and-peer-restart-detection.md) for what a "previous incarnation" means at the remote-peer layer.

Source: [packages/ocap-kernel/src/Kernel.ts](https://github.com/MetaMask/ocap-kernel/blob/052f4d4865b39df29f8f67fdffa3c52ef17b4282/packages/ocap-kernel/src/Kernel.ts) (lines 257-324) at commit `052f4d4`.
