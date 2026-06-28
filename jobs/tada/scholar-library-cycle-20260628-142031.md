Cycle complete. Report:

## Scholar library cycle — completion report

**Job:** `scholar-library-cycle-20260628-142031` (hourly scholar cadence) — completed (`doin → tada`, doin cleared).

**Inbox/topic:** Empty inbox. Drained the `role/scholar` topic and `broadcast`: procedural updates only (the new step-8 integrity gate, `fetch-source.sh`/`land-journal-edit.sh`, the erights mirror directive, the deliberate-deploy/per-subagent-worktree rule). No `ingest-source` or writeback-review asks.

**Erights-mirror directive — already satisfied, no work:** All `erights--*` sources already carry `source_fetched_via: mirror` (re-ingested 2026-06-27). The `combex--*` sources are on combex.com (not mirrored) and correctly wayback-fetched.

**Ingested (1 source, 3 sections + 1 parent index):** `MetaMask/ocap-kernel packages/ocap-kernel/src/KernelQueue.ts` at commit `d979a06` — the first kernel-internals comment-fragment, the highest-value pending scholar work (the per-package-README cluster ended by flagging that ocap-kernel's substance lives in the source, not the stub READMEs). Three cohesive sections:
- `forever-run-loop-and-crank-lifecycle` — the `Promise<never>` run loop, `startCrank`/`endCrank` bracket, `'start'` savepoint, GC/reap priority, sleep/wake thunk.
- `crank-abort-rollback-versus-commit-flush` — crank atomicity (rollback+discard vs flush), active-vat retry vs terminated-vat "just go splat", the all-errors-terminate TODO.
- `immediate-versus-buffered-enqueue-and-decider-authorized-resolution` — the buffer-until-commit flag, tagged reference-counting, decider-authorized one-shot resolution.

**Indexes:** `library/sources/README.md` (source row) and `library/sections/README.md` (block + count bumped to 5840/507/5333) updated. All content landed via `land-journal-edit.sh`.

**Integrity gate (step 8):** `library-link-check.sh --source-slug …` → **PASS** (exit 0) after one fix: the parent index's See-also linked `metamask-ocap-kernel--overview.md` as a sibling section, but overview is a source with a long-slug parent index, so the bare link dangled. Corrected to `../sources/…` and re-landed; gate clean.

**Deferred:** Remaining kernel-internals files (`Kernel.ts`, `VatHandle.ts`, `VatSupervisor.ts`, `KernelRouter.ts`, `KernelServiceManager.ts`, `BaseDuplexStream.ts`, `kernel-utils/exo.ts`) stay queued under the existing parked plan `scholar-ingest-ocap-kernel-comment-fragments`; no new follow-on needed. The source's `source_commit` anchor prevents re-ingest.

**Result entry:** `entries/2026/06/28/143320Z-result-scholar-8eb993.md`. Scratch worktree and files torn down.

**Self-improvement:** Nothing structural. Craft note (self-only): in a parent index "See also", link the *source* page unless a bare `sections/<source-slug>.md` parent actually exists — the step-8 gate caught the dangling sibling-section link pre-completion exactly as designed.
