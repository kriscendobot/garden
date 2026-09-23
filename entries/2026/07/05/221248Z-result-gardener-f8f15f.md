---
kind: result
role: gardener
host: endolinbot
at: 2026-07-05T22:12:50Z
---
# result: scholar — VatHandle.ts comment-fragment ingest (eleventh ocap-kernel; third kernel-internals)

Job `scholar-ingest-ocap-kernel-comment-fragments-2`. One comment-fragment source
ingested from `MetaMask/ocap-kernel` (read-only sibling-implementation reference
shelf), per the per-cycle budget of one comment-fragment file yielding 2-4 sections.

## Source ingested

- **`packages/ocap-kernel/src/vats/VatHandle.ts`** (slug
  `metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts`), 401 lines,
  file-path-specific sha `d54aa5c` (last touched 2026-04-21, #941), authors Chip
  Morningstar / Dimitris Marlagkoutsos / Erik Marks. **4 sections** (the kernel's
  per-vat endpoint handle):
  1. `endpoint-handle-and-dual-rpc-wiring` (capability-security, eventual-send) —
     two RPC endpoints over one duplex stream: `RpcClient` for kernel→vat commands
     namespaced by `vatId`, `RpcService` dispatching vat→kernel syscalls into a
     `VatSyscall` bridge; the vat's own `KernelStore` slice.
  2. `make-init-lifecycle-and-stream-drain` (daemon, eventual-send) — private
     constructor + static async `make`; `#init` fires an unawaited stream drain
     whose only failure path is to self-terminate the vat with a `StreamReadError`,
     then awaits `initVat`; `#handleMessage` demultiplexes responses vs notifications.
  3. `delivery-surface-and-kv-commit-on-success` (persistence, capability-security)
     — the six `deliver*` wrappers; `sendVatCommand` commits vat KV mutations only
     on a clean delivery and deliberately neither commits nor rolls back on error
     (safe because erroring vats are terminated and their private DB deleted while
     the kernel DB rolls back).
  4. `priority-ordered-crank-result-and-termination` (persistence, capability-security)
     — `#getDeliveryCrankResult`'s deliberate priority order (illegal syscall >
     delivery error > vat-requested exit); `terminate()` rejects every promise this
     vat was the decider for, rejects outstanding RPC calls, and deletes the vat.

## Idempotency

All six candidate files were un-ingested (no existing source page); the recorded
plan shas matched the current `git log -1 main -- <path>` for each. Ingested the
first (VatHandle.ts); the remaining five deferred (below). No re-ingest / skip
cases this cycle.

## Pages touched

- New: 1 source page, 1 `kind: index` parent section, 4 leaf sections.
- Index updates: `sources/README.md` (new row); topic pages `capability-security`
  (+3 rows), `eventual-send` (+2), `daemon` (+1), `persistence` (+2) via
  `insert-sections-table-row.sh`; concept `concepts/ocap-kernel.md` (index row +
  4 leaf rows in the sections table; aliases added: VatHandle, EndpointHandle,
  VatSyscall, decider, sendVatCommand, deliver, bringOutYourDead).
- Regenerated as the final landing step: `sections/README.md`
  (`regenerate-sections-index.sh`) and `topics/README.md` Sections-count column
  (`regenerate-topics-counts.sh`). Both landed; post-land `--check` confirms
  topics counts current and the generator idempotent.

## Integrity gate

- `library-link-check.sh --source-slug metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts --wikilinks`:
  **OK** (every checked link resolves to a committed file), verified both before
  landing (staged) and after landing (committed tip).
- The broader `--changed origin/journal2` scope surfaced **2 pre-existing dangling
  wikilinks in `sources/README.md`** (`[[engine-implementation]]`,
  `[[local-model-serving]]` — concept pages that do not exist), present on
  `origin/journal2` before this cycle and unrelated to the VatHandle rows (my row
  references only `[[ocap-kernel]]`, which exists). Not introduced here; left as-is
  (creating those two unrelated concept pages is out of this job's scope).

## Comment-vs-code drift

**None found** in any of the four clusters. Each section carries its own
Notice / drift check: the field JSDoc, the "we don't expect JSON-RPC requests
from the vat" note, the multi-line commit-only-on-success comment, and the
"priority order" comment all match the code they annotate. The `#getDeliveryCrankResult`
`TODO` (rewind-and-retry someday) is a forward-looking marker, not a present-behavior
claim, so not drift. ocap-kernel is a read-only reference shelf (no garden fork),
so a boatman missive is unavailable regardless.

## Follow-on posted

- `scholar-ingest-ocap-kernel-comment-fragments-3` (deferred, low) naming exactly
  the five remaining kernel-internals / kernel-utils files: `VatSupervisor.ts`
  (the in-vat counterpart to VatHandle, the natural next pick), `KernelRouter.ts`,
  `KernelServiceManager.ts`, `BaseDuplexStream.ts`, `kernel-utils/exo.ts`. Carries
  forward the two standing backfill notes (the Kernel.ts doc typo; the still-absent
  KernelQueue.ts leaf rows on the `persistence`/`eventual-send`/`capability-security`
  topic pages).

## Deferred backlog

Five source files (above), one comment-fragment file per cycle per the budget.
