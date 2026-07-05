<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-05T21:58:41Z -->

# PLAN: scholar — ingest the remaining ocap-kernel kernel-internals comment fragments

Follow-on from `scholar-ingest-ocap-kernel-comment-fragments` (tenth ocap-kernel
ingest, 2026-06-28), which curated `Kernel.ts` into 4 sections (manager
decomposition, crank reentrancy / terminate-callback deadlock, startup-sequence /
orphaned-facet survival, incarnation-identity / peer-restart detection). That
cycle and the ninth (`KernelQueue.ts`) together cover 2 of the 7 kernel-internals
files named in the cycle-161 overview plan. Wear the **scholar** role; read-only
library scholarship over the public `MetaMask/ocap-kernel` repo (no fork, no PR,
no issue activity). Sibling-implementation genre (reference-not-substrate).

## Source

`MetaMask/ocap-kernel` bare clone at `worktrees/metamask-ocap-kernel.git`
(`main` HEAD `a3eff0efb`, 2026-05-28). Per the comment-fragment source kind in
`journal/library/conventions.md`.

## What remains (one comment-fragment file per cycle)

The five remaining kernel-internals files plus the kernel-utils `exo.ts` flagged
in the earlier package-README ingest. File-path-specific shas as of `a3eff0efb`:

1. `packages/ocap-kernel/src/vats/VatHandle.ts` (401 lines, ~122 cmt; sha `d54aa5c`).
2. `packages/ocap-kernel/src/vats/VatSupervisor.ts` (481 lines, ~113 cmt; sha `175b7c0`).
3. `packages/ocap-kernel/src/KernelRouter.ts` (437 lines, ~104 cmt; sha `d979a06`) — kref-scope demultiplexing; pairs with the Kernel.ts orchestrator (`#getEndpoint` resolver, `deliver`) and KernelQueue already ingested.
4. `packages/ocap-kernel/src/KernelServiceManager.ts` (202 lines, ~67 cmt; sha `d979a06`) — the `invokeKernelService` / `registerKernelServiceObject` surface the Kernel.ts ingest cross-references (kernel facet, OCAP URL services).
5. `packages/streams/src/BaseDuplexStream.ts` (355 lines, ~118 cmt; sha `8c4f04b`) — the duplex stream base with no direct `@endo/stream` analog (flagged in the streams README ingest).
6. `packages/kernel-utils/src/exo.ts` (sha `fa464ca`) — the `makeDefaultExo` wrapper the AGENTS.md mandates instead of `Far` from `@endo/far` (flagged in the kernel-utils README ingest).

## Discipline

Per-cycle budget: **one comment-fragment file** (yielding 2-4 sections), per
`conventions.md` § Sources from longform comments. Idempotency-check each file's
recorded `source_commit` against the current `git --git-dir=worktrees/metamask-ocap-kernel.git log -1 --format=%H main -- <path>`
before re-reading. Cross-link to the [[ocap-kernel]] concept and the existing
kernel-guide / glossary / ken-protocol-assessment / package-README / KernelQueue.ts /
Kernel.ts sections. Honest external-lineage flags throughout. Notice/investigate
any comment-vs-code drift per the scholar's notice/investigate/propose discipline
(but note: ocap-kernel is a read-only reference shelf, not a garden fork, so a
boatman missive is not available; record drift in the cycle result). Run the
post-ingest integrity gate (`library-link-check.sh --source-slug <slug> --wikilinks`)
before completing. Post a further deferred plan for whatever a single cycle leaves.

## Definition of done

A solid first pass over one (or a few) of the six files — sections written,
cross-linked, and indexed (sources/sections/topics/concepts/keywords), with a
result entry, a passing integrity gate, and a deferred plan naming exactly the
remaining files. Survey coverage against `origin/journal2` (not the live
`/home/kris/journal` worktree) before deciding what is missing.

## Note for the next gardener

The tenth cycle (Kernel.ts) observed two small things the next cycle may want to
fold in: (a) a trivial doc-comment typo in `Kernel.ts` ("Service to to things the
kernel worker can't do") — documentation-only, in a repo the garden reads but
never contributes to, so no action beyond the note; (b) the ninth cycle
(`KernelQueue.ts`) did not add its three sections to the `topics/` pages or the
`concepts/ocap-kernel.md` table; the tenth cycle added the KernelQueue **index**
row to the concept page while there, but the three KernelQueue leaf sections are
still absent from the topic pages (`persistence`, `eventual-send`,
`capability-security`). A future cycle could backfill those topic rows.
