The completion signal (`<<<GARDEN-JOB-COMPLETE>>>`) is the deterministic doin→tada trigger — I won't run `complete-job.sh` manually and risk a double-complete. Everything is landed and verified. Here is my report.

---

## Completion report — `scholar-ingest-ocap-kernel-comment-fragments-2`

**What I did.** Wore the scholar role and ingested one comment-fragment source from the read-only `MetaMask/ocap-kernel` reference shelf, per the one-file-per-cycle budget. Confirmed all six candidate files were un-ingested and their plan shas matched the current `git log -1 main -- <path>` before reading.

**Source ingested — `packages/ocap-kernel/src/vats/VatHandle.ts`** (401 lines, sha `d54aa5c`; eleventh ocap-kernel ingest, third kernel-internals comment-fragment after KernelQueue.ts and Kernel.ts). The kernel's per-vat endpoint handle, curated into **4 sections**:
1. **dual RPC wiring** (capability-security, eventual-send) — two RPC endpoints over one duplex stream: `RpcClient` for kernel→vat commands, `RpcService` dispatching vat→kernel syscalls into a `VatSyscall` bridge.
2. **make/#init lifecycle + stream drain** (daemon, eventual-send) — private constructor + static async `make`; an unawaited drain whose only failure path self-terminates the vat with a `StreamReadError`.
3. **delivery surface + KV-commit-on-success** (persistence, capability-security) — six `deliver*` wrappers; `sendVatCommand` commits vat KV only on a clean delivery and deliberately neither commits nor rolls back on error.
4. **priority-ordered crank result + vat death protocol** (persistence, capability-security) — illegal-syscall > delivery-error > vat-requested-exit; `terminate()` rejects every promise this vat was the decider for before deleting it.

**What changed (landed on journal2).** 1 source page + 1 `kind:index` parent + 4 leaf sections (new); `sources/README.md` row; topic rows on `capability-security` (+3), `eventual-send` (+2), `daemon` (+1), `persistence` (+2); `concepts/ocap-kernel.md` (index + 4 leaf rows, 7 new aliases). Regenerated and landed `sections/README.md` and the `topics/README.md` Sections-count column.

**Integrity gate.** `library-link-check.sh --source-slug … --wikilinks` = **OK** both pre-land (staged) and post-land (committed tip); topics-counts `--check` = current/idempotent. The broader `--changed` scope surfaced 2 **pre-existing** dangling wikilinks in `sources/README.md` (`[[engine-implementation]]`, `[[local-model-serving]]`) present on origin/journal2 before this cycle and unrelated to my rows — left as-is (out of scope).

**Drift.** No comment-vs-code drift in any of the four clusters (each section carries its own Notice/drift check). ocap-kernel is a read-only shelf, so no boatman missive is available regardless.

**Follow-ups.** Posted deferred/low plan `scholar-ingest-ocap-kernel-comment-fragments-3` naming exactly the five remaining files (VatSupervisor.ts — the natural next pick as VatHandle's in-vat counterpart, KernelRouter.ts, KernelServiceManager.ts, BaseDuplexStream.ts, kernel-utils/exo.ts), carrying forward the two standing backfill notes (the Kernel.ts doc typo; the still-absent KernelQueue.ts leaf rows on three topic pages). Result entry posted (`221248Z-result-gardener-f8f15f.md`). Inbox was empty at the checkpoint.

Self-improvement: the `--changed` gate scope reports pre-existing dangling wikilinks in any large shared index you touch (here `sources/README.md`), which is noise for a scoped ingest — the `--source-slug` scope is the authoritative producer-side check for a single cluster, and I verified my danglers were pre-existing by diffing against `origin/journal2` rather than assuming. Worth internalizing so future cycles don't chase index-wide advisory noise or, worse, "fix" it by inventing unrelated concept pages.
