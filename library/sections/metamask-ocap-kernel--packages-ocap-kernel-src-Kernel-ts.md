---
title: "Kernel.ts (MetaMask/ocap-kernel) — the orchestrator class: manager decomposition, crank reentrancy, startup ordering, and incarnation identity"
source: packages/ocap-kernel/src/Kernel.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/Kernel.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/Kernel.ts
source_line_range: "1-783"
source_branch: main
source_commit: 052f4d4865b39df29f8f67fdffa3c52ef17b4282
source_date: 2026-05-12
comment_subject: Kernel is the orchestrator class at the top of MetaMask/ocap-kernel — a thin delegator over a graph of single-responsibility managers, with longform comments on the manager decomposition, the in-crank terminate-callback deadlock, the carefully-ordered startup sequence, and the incarnation-identity / peer-restart-detection reset rule.
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security, daemon, persistence]
status: current
kind: index
section_count: 4
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Second kernel-internals comment-fragment ingest from the cycle-161 overview plan (the densest of the seven; follow-on to KernelQueue.ts). See [[ocap-kernel]] concept for the lineage flag.
---

## Abstract

`packages/ocap-kernel/src/Kernel.ts` is the **orchestrator class** at the top of MetaMask/ocap-kernel's SwingSet-lineage kernel. The class comment frames it plainly: it "is responsible for managing the lifecycle of the kernel and the vats." In practice it is a **thin delegator** — almost every public method is one-line passthrough to a single-responsibility manager — and its own substance is the *wiring* plus four longform-comment clusters that the section files below curate. First, the **manager decomposition**: nine collaborators (vat / subcluster / remote / OCAP-URL / kernel-service / IO managers, plus the run queue, router, and store) built in dependency order by the private constructor, behind the static async `Kernel.make`. Second, the **crank reentrancy** invariant: the terminate callback handed to `KernelQueue` must bypass `VatManager.terminateVat` because that method awaits `waitForCrank`, and the callback runs from inside a crank, so it would deadlock — while the public debugging methods correctly *do* block on `waitForCrank` from outside the loop. Third, the **startup sequence**: `#init`'s carefully ordered boot, including the rule to always provide the kernel facet so orphaned run-queue messages from a previous incarnation cannot crash the queue, and the discipline of starting persisted vats before the run loop and new system subclusters after. Fourth, the **incarnation identity** rule: a state reset preserves the network identity keys but deliberately regenerates the `incarnationId`, which signals to remote peers that local state was wiped so they clear their seq-dedup and c-list bookkeeping (peer-restart detection, #948/#950).

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo and Agoric work, never imports its code. It is the **second** kernel-internals comment-fragment ingest (after `KernelQueue.ts`) and the **densest** of the seven files the cycle-161 overview plan queued; it confirms that the `@metamask/ocap-kernel` package's architectural substance lives in this source rather than in the near-stub package README.

## Sections

- [Kernel as orchestrator: the manager decomposition and the constructor wiring graph](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--orchestrator-manager-decomposition.md)
- [Crank reentrancy and the terminate-callback deadlock (why the queue's stop path bypasses VatManager.terminateVat)](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--crank-reentrancy-and-the-terminate-callback-deadlock.md)
- [The kernel startup sequence: ordering constraints and orphaned-facet survival across incarnations](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--startup-sequence-and-orphaned-facet-survival.md)
- [Incarnation identity and peer-restart detection (why a state reset preserves network identity but regenerates the incarnationId)](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--incarnation-identity-and-peer-restart-detection.md)

## See also

- Source index: [metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts](../sources/metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts.md)
- Synthesizing concept: [[ocap-kernel]]
- The sibling kernel-internals comment-fragment: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts.md) (the run queue and run loop this orchestrator drives)
- The host-developer vocabulary the orchestrator enacts: [metamask-ocap-kernel--docs-kernel-guide-md--core-concepts](metamask-ocap-kernel--docs-kernel-guide-md--core-concepts.md), and the kernel API surface [metamask-ocap-kernel--docs-kernel-guide-md--kernel-api](metamask-ocap-kernel--docs-kernel-guide-md--kernel-api.md)
- The incarnation-identity reset's persistence cousins: [[eventual-send]], and the identity-as-derivation-chain pattern in the `docs/identity-backup-recovery.md` ingest

Source: [packages/ocap-kernel/src/Kernel.ts](https://github.com/MetaMask/ocap-kernel/blob/052f4d4865b39df29f8f67fdffa3c52ef17b4282/packages/ocap-kernel/src/Kernel.ts) at commit `052f4d4`.
