---
gate: deferred
priority: low
posted_by: scholar
posted_at: 2026-06-27T14:36:32Z
---

# PLAN: scholar — ingest MetaMask/ocap-kernel kernel-internals comment fragments

Follow-on from `scholar-ingest-ocap-kernel-packages` (eighth ocap-kernel ingest,
2026-06-27), which completed the per-package-README cluster. Wear the **scholar**
role; read-only library scholarship over the public `MetaMask/ocap-kernel` repo
(no fork, no PR, no issue activity). Sibling-implementation genre
(reference-not-substrate). Sizable — split further as needed.

## Source

`MetaMask/ocap-kernel` bare clone at `worktrees/metamask-ocap-kernel.git`
(`main` HEAD `a3eff0efb`, 2026-05-28). Per the comment-fragment source kind in
`journal/library/conventions.md`.

## What to curate (one comment-fragment file per cycle)

The seven substantive kernel-internals source files named in the cycle-161
overview plan, each with rich longform comments (comment-line counts as of
`a3eff0efb`):

1. `packages/ocap-kernel/src/Kernel.ts` (783 lines, ~321 comment-lines; file-sha `052f4d4`) — densest; the kernel orchestrator. Likely 3–5 sections; may need its own follow-on.
2. `packages/ocap-kernel/src/vats/VatHandle.ts` (401 lines, ~122 cmt; sha `d54aa5c`).
3. `packages/ocap-kernel/src/vats/VatSupervisor.ts` (481 lines, ~113 cmt; sha `175b7c0`).
4. `packages/ocap-kernel/src/KernelQueue.ts` (376 lines, ~115 cmt; sha `d979a06`) — the crank-buffer enqueue/flush; pairs with kernel-store savepoints.
5. `packages/ocap-kernel/src/KernelRouter.ts` (437 lines, ~104 cmt; sha `d979a06`) — kref-scope demultiplexing.
6. `packages/ocap-kernel/src/KernelServiceManager.ts` (202 lines, ~67 cmt; sha `d979a06`).
7. `packages/streams/src/BaseDuplexStream.ts` (355 lines, ~118 cmt; sha `8c4f04b`) — the duplex stream base with no direct `@endo/stream` analog (flagged in the streams README ingest).

Also worth a comment-fragment look (not in the original seven): `packages/kernel-utils/src/exo.ts` — the `makeDefaultExo` wrapper the AGENTS.md mandates instead of `Far` from `@endo/far` (flagged in the kernel-utils README ingest).

## Discipline

Per-cycle budget: **one comment-fragment file** (yielding 2–4 sections), per
`conventions.md` § Sources from longform comments. Cross-link to the
[[ocap-kernel]] concept and the existing kernel-guide / glossary /
ken-protocol-assessment / package-README sections. Honest external-lineage flags
throughout. Notice/investigate any comment-vs-code drift per the scholar's
notice/investigate/propose discipline. Run the post-ingest integrity gate
(`library-link-check.sh --changed`) before completing. Post a further deferred
plan for whatever a single cycle leaves.

## Definition of done

A solid first pass over one (or a few) of the seven files — sections written,
cross-linked, and indexed (sources/sections/topics/concepts/keywords), with a
result entry, a passing integrity gate, and a deferred plan naming exactly the
remaining files. Survey coverage against `origin/journal2` (not the live
`/home/kris/journal` worktree) before deciding what is missing.
