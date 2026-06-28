project: ocap-kernel

Tenth ocap-kernel ingest; second kernel-internals comment-fragment source. Curated
`packages/ocap-kernel/src/Kernel.ts` (783 lines, ~321 comment-lines, file-path sha
`052f4d4`, last touched 2026-05-12 by #950), the densest of the seven kernel-internals
files the cycle-161 overview plan queued. Genre: sibling-implementation /
reference-not-substrate (MetaMask/ocap-kernel, SwingSet-lineage, distinct codebase
from @endo — read, never imported).

## Ingested (4 sections + parent index + source page)

Source slug `metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts`:

- `--orchestrator-manager-decomposition` (topics: capability-security, daemon) — the
  Kernel as a thin orchestrator over nine single-responsibility collaborators built in
  a dependency-ordered constructor behind the static async `Kernel.make`; `platformServices`
  as the one injected host boundary.
- `--crank-reentrancy-and-the-terminate-callback-deadlock` (persistence, capability-security)
  — the in-crank terminate callback bypasses `VatManager.terminateVat` (which awaits
  `waitForCrank`) to avoid a self-wait deadlock, contrasted with the four public debugging
  methods that correctly fence on `waitForCrank` from outside the run loop.
- `--startup-sequence-and-orphaned-facet-survival` (daemon, persistence) — `#init`'s ordered
  boot: always-provide-the-facet so a previous incarnation's orphaned run-queue messages
  cannot crash the queue (the run queue has no selective-removal capability); start persisted
  vats before the run loop; launch new system subclusters after; run loop started non-blocking
  with its rejection logged-and-swallowed.
- `--incarnation-identity-and-peer-restart-detection` (persistence, daemon) — `#resetKernelState`
  preserves keySeed/peerId/ocapURLKey (durable network identity) but regenerates the
  `incarnationId` so remote peers detect the state wipe and clear seq-dedup / c-list
  bookkeeping (#948/#950); the mnemonic-recovery path clears identity too.

Plus the `kind: index` parent section file and the `sources/` index page (section_count: 4).

## Indexes updated

- `sources/README.md` — new source row (tenth ingest).
- `sections/README.md` — new source block with the 4 child rows, placed before the KernelQueue block.
- `topics/capability-security.md` (2 rows), `topics/daemon.md` (3 rows), `topics/persistence.md` (3 rows).
- `concepts/ocap-kernel.md` — added the 4 Kernel.ts section rows + the Kernel.ts and (backfilled) KernelQueue.ts index rows; widened `aliases` with incarnationId, waitForCrank, crank reentrancy, Kernel.make, platformServices, provideFacet, peer-restart detection.
- `keywords.md` — 10 new keyword lines resolving to the `ocap-kernel` concept.

## Idempotency

`Kernel.ts` had no prior section files; recorded `source_commit` `052f4d4` matches the
current `git --git-dir=worktrees/metamask-ocap-kernel.git log -1 --format=%H main -- packages/ocap-kernel/src/Kernel.ts`.
`KernelQueue.ts` (the ninth ingest) is already current at `d979a06`; not re-touched.

## Notice / drift

Comments in `Kernel.ts` match the code (the deadlock-bypass callback, the facet-always-provide
rule, the incarnationId reset rule all verified against the source). One trivial doc-comment
typo noted ("Service to to things the kernel worker can't do"); documentation-only and in a
read-only reference repo the garden never contributes to, so no missive (ocap-kernel is not a
garden fork). Recorded in the follow-on plan for the record.

## Integrity gate

`library-link-check.sh --source-slug metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts --wikilinks` → OK (every checked link resolves to a committed file). A second `--files` run over the touched topic/concept/sources index pages → OK.

## Follow-on

Posted deferred low-priority plan `scholar-ingest-ocap-kernel-comment-fragments-2` naming the
six remaining files (VatHandle.ts, VatSupervisor.ts, KernelRouter.ts, KernelServiceManager.ts,
BaseDuplexStream.ts, kernel-utils/exo.ts), with idempotency shas and a next-gardener note about
backfilling the absent KernelQueue.ts topic-page rows.

Self-improvement: nothing this time.
