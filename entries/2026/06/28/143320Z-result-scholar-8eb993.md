---
kind: result
role: scholar
host: endolinbot
at: 2026-06-28T14:33:22Z
---
---
ts: 2026-06-28T14:33:00Z
kind: result
role: scholar
project: ocap-kernel
---

# Scholar library cycle — ingest KernelQueue.ts (ninth ocap-kernel ingest; first kernel-internals comment-fragment)

Hourly scholar library cycle (`scholar-library-cycle-20260628-142031`). Inbox empty;
drained the `role/scholar` topic and `broadcast` (procedural updates only: the new
integrity gate, `fetch-source.sh` / `land-journal-edit.sh`, the erights mirror
directive, the deliberate-deploy / per-subagent-worktree rules). No `ingest-source`
or writeback-review asks queued.

## Liaison erights-mirror directive — already satisfied (no work)

Checked the standing directive to re-ingest erights.org sources through the new
`erights.github.io` mirror. All `erights--*` sources already carry
`source_fetched_via: mirror`, ingested 2026-06-27. The `combex--*` sources are on
`combex.com` (not mirrored on erights.github.io) and are correctly `wayback`-fetched.
Nothing to re-ingest.

## Ingested (1 source, 3 sections + 1 parent index)

Spent the cycle budget on the highest-value pending scholar work: the first
kernel-internals comment-fragment from the parked plan job
`scholar-ingest-ocap-kernel-comment-fragments` (the per-package-README cluster, the
eighth ingest, ended by flagging that ocap-kernel's architectural substance lives in
`Kernel.ts` / `KernelQueue.ts` / siblings, not the stub READMEs).

- **`MetaMask/ocap-kernel packages/ocap-kernel/src/KernelQueue.ts`** at commit
  `d979a06325666af32ca7f68b13e9c85486d89ab5` (file-path-specific sha; last touched
  2026-04-07 by Erik Marks / Dimitris Marlagkoutsos / Chip Morningstar). 376-line
  module; the kernel run queue and run loop. **3 sections** (idempotency anchor
  `source_commit`):
  - `forever-run-loop-and-crank-lifecycle` (topics: persistence, capability-security)
    — the `Promise<never>` run loop, `startCrank`/`endCrank` bracket, the `'start'`
    savepoint, GC/reap priority over delivery, single-use sleep/wake thunk.
  - `crank-abort-rollback-versus-commit-flush` (persistence, capability-security) —
    crank atomicity: `rollbackCrank('start')` and buffer-discard on abort versus
    `#flushCrankBuffer` on success; active-vat retry versus terminated-vat "just go
    splat"; the standing all-errors-terminate-the-vat TODO (a comment-vs-code note).
  - `immediate-versus-buffered-enqueue-and-decider-authorized-resolution`
    (eventual-send, capability-security) — the `immediate` buffer-until-commit flag,
    tagged reference-counting of every enqueued reference, and decider-authorized
    one-shot promise resolution.
- Parent `kind: index` section file written
  (`sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts.md`,
  `section_count: 3`).

## Indexes updated

- `library/sources/README.md`: added the source row in the ocap-kernel cluster.
- `library/sections/README.md`: added the block (parent index + 3 children); bumped
  the total-section-files count by 4 (1 parent + 3 children → 5840 / 507 / 5333).

## Integrity gate (step 8)

`library-link-check.sh --source-slug metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts`
against a fresh `origin/journal2` checkout: **PASS** (exit 0) after one fix. First
run flagged one dangling link — the parent index's See-also pointed at
`metamask-ocap-kernel--overview.md` as a sibling section, but `overview` is a source
(its section parent-index has the long `--monorepo-survey...` name). Corrected the
link to `../sources/metamask-ocap-kernel--overview.md` and re-landed; gate clean.

## Deferred / follow-on

No new follow-on job posted: the remaining kernel-internals files (`Kernel.ts`,
`VatHandle.ts`, `VatSupervisor.ts`, `KernelRouter.ts`, `KernelServiceManager.ts`,
`BaseDuplexStream.ts`, `kernel-utils/exo.ts`) stay queued under the existing parked
plan job `scholar-ingest-ocap-kernel-comment-fragments`. KernelQueue.ts is now the
first of that set landed; the source page's `source_commit` idempotency anchor
prevents a future cycle from re-ingesting it.

Self-improvement: nothing structural this cycle. One craft note for the next scholar
(self-only, not routed): when a parent index "See also" references another ingest in
the same project, link the *source* page (`../sources/<slug>.md`) unless a
bare-`<slug>.md` parent-index section file actually exists — overview-style sources
whose parent index carries the long descriptive section slug have no bare
`sections/<source-slug>.md`, so a `<slug>.md` sibling-section link dangles. The
step-8 gate caught it pre-completion exactly as intended.
