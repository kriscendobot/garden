---
source: packages/ocap-kernel/src/Kernel.ts
source_kind: comment-fragment
source_repo: MetaMask/ocap-kernel
source_path: packages/ocap-kernel/src/Kernel.ts
source_line_range: "1-783"
source_branch: main
source_commit: 052f4d4865b39df29f8f67fdffa3c52ef17b4282
comment_subject: Kernel is the orchestrator class at the top of MetaMask/ocap-kernel — a thin delegator over a graph of single-responsibility managers, with longform comments on the manager decomposition, the in-crank terminate-callback deadlock, the carefully-ordered startup sequence, and the incarnation-identity / peer-restart-detection reset rule.
source_date: 2026-05-12
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-28
ingested_by: scholar
section_count: 4
status: current
notes: |
  Tenth ocap-kernel ingest and the SECOND kernel-internals comment-fragment
  source (after KernelQueue.ts, the ninth ingest). The densest of the seven
  kernel-internals files the cycle-161 overview plan queued: 783 lines, ~321
  comment-lines. The Kernel class is a thin orchestrator over a graph of
  single-responsibility managers; its longform comments yield four coherent
  argument clusters: the manager decomposition + constructor wiring graph; the
  in-crank terminate-callback deadlock (why the queue's stop path bypasses
  VatManager.terminateVat, contrasted with the public waitForCrank call sites);
  the carefully-ordered #init startup sequence (always-provide-the-facet so a
  previous incarnation's orphaned run-queue messages cannot crash the queue;
  start persisted vats before the run loop, new system subclusters after); and
  the incarnation-identity reset rule (#resetKernelState preserves keySeed/peerId/
  ocapURLKey but regenerates the incarnationId so remote peers detect the state
  wipe and clear seq-dedup / c-list bookkeeping — #948/#950). SwingSet-lineage;
  reference-not-substrate stance. Idempotency anchor is source_commit (file-path-
  specific sha `052f4d4`). Remaining kernel-internals files from the cycle-161
  plan (VatHandle.ts, VatSupervisor.ts, KernelRouter.ts, KernelServiceManager.ts,
  BaseDuplexStream.ts, kernel-utils/exo.ts) stay queued under the follow-on plan
  job scholar-ingest-ocap-kernel-comment-fragments-2.
---

> Abstract: `packages/ocap-kernel/src/Kernel.ts` is the **orchestrator class** at
> the top of MetaMask/ocap-kernel's SwingSet-lineage kernel. The class comment
> says it "is responsible for managing the lifecycle of the kernel and the vats,"
> and in practice it is a **thin delegator**: almost every public method is a
> one-line passthrough to a single-responsibility manager. Its own substance is
> the *wiring* plus four longform-comment clusters. The **manager decomposition**:
> a private constructor builds nine collaborators (vat / subcluster / remote /
> OCAP-URL / kernel-service / IO managers, plus the run queue, router, and store)
> in dependency order behind the static async `Kernel.make`. The **crank
> reentrancy** invariant: the terminate callback handed to `KernelQueue` bypasses
> `VatManager.terminateVat` because that method awaits `waitForCrank` and the
> callback runs from inside a crank (deadlock), while the public debugging methods
> correctly block on `waitForCrank` from outside the loop. The **startup
> sequence**: `#init` always provides the kernel facet so a previous incarnation's
> orphaned run-queue messages cannot crash the queue, starts persisted vats before
> the run loop, and launches new system subclusters after. The **incarnation
> identity** rule: a state reset preserves the network identity keys but
> regenerates the `incarnationId` so remote peers detect the wipe and clear their
> seq-dedup / c-list bookkeeping (#948/#950).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [orchestrator-manager-decomposition](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--orchestrator-manager-decomposition.md) | capability-security, daemon | current |
| [crank-reentrancy-and-the-terminate-callback-deadlock](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--crank-reentrancy-and-the-terminate-callback-deadlock.md) | persistence, capability-security | current |
| [startup-sequence-and-orphaned-facet-survival](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--startup-sequence-and-orphaned-facet-survival.md) | daemon, persistence | current |
| [incarnation-identity-and-peer-restart-detection](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--incarnation-identity-and-peer-restart-detection.md) | persistence, daemon | current |

Parent index section file: [metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts.md).

## Provenance

- Fetched 2026-06-28 from the local bare clone `worktrees/metamask-ocap-kernel.git` at `main` HEAD `a3eff0efb`; the file's own path-specific commit is `052f4d4865b39df29f8f67fdffa3c52ef17b4282` (last touched 2026-05-12 by #950, "regenerate incarnationId on resetStorage=true").
- Authors over the file's history: Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks, grypez (`git log` over the path).
- 783 lines, comment-dense (~321 comment-lines); the four sections map to lines roughly 43-222 (class doc + manager fields + constructor wiring), 136-144 (the in-crank terminate-callback deadlock, with the contrasting `waitForCrank` call sites at 560/631/741/767), 257-324 (the `#init` startup sequence + `provideFacet`), and 704-734 (`#resetKernelState` incarnation-identity).
- **Tenth ocap-kernel ingest; second kernel-internals comment-fragment.** Genre: sibling-implementation / reference-not-substrate. Synthesizing concept [[ocap-kernel]].
