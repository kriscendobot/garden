The job is complete. Here is my report.

## Completion report

**Job:** `scholar-ingest-ocap-kernel-comment-fragments-4` — thirteenth ocap-kernel ingest; fifth kernel-internals comment-fragment.

**What I did:** Ingested `packages/ocap-kernel/src/KernelRouter.ts` (MetaMask/ocap-kernel, `main`, file-path sha `d979a06`, 437 lines / ~104 comment-lines) — the natural next pick per the plan, the kernel's message router that sits between the run loop (`KernelQueue.ts`) and the two ends of the kernel↔vat duplex link (`VatHandle.ts` / `VatSupervisor.ts`), all already in the library. First ingest of this path (idempotency: no prior source file), so the recorded `source_commit` is the current upstream sha.

**Sections written (4 + parent index + source index):**
- `router-and-promise-state-delivery-model` (25-110) — eventual-send, capability-security
- `route-message-splat-send-requeue` (112-194) — eventual-send, capability-security
- `deliver-send-refcount-and-endpoint-vanished-splat` (196-341) — capability-security, persistence
- `deliver-notify-promise-resolution-and-gc-actions` (343-436) — eventual-send, persistence

**Cross-linking / indexing:** `[[ocap-kernel]]` concept page (index row + 4 leaf rows + 14 new aliases); `sources/README.md` row; topic pages eventual-send (×3), capability-security (×3), persistence (×2); `keywords.md` (3 lines: routing outcomes, kernel-error codes, kref→eref translation). All landed via `land-journal-edit.sh` (producer-clone CAS) — nothing hand-`git`'d against the live worktree.

**Drift:** None in any cluster. Two honest non-drift observations recorded: (a) the endpoint-vanished bare `catch` in `#deliverSend` carries the maintainers' own `TODO` to narrow it to `VatNotFoundError` (self-flagged latent bug, not a contradiction); (b) one `#deliverNotify` comment is slightly loose about which promise the in-loop vs tail refcount-decrement covers (code is correct). Read-only reference shelf, so no boatman missive available.

**Integrity gate:** `library-link-check.sh --source-slug metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts --wikilinks` → **OK, exit 0**. Sections index and topics-count column regenerated and landed as the final step.

**Follow-ups:**
- Posted deferred plan `scholar-ingest-ocap-kernel-comment-fragments-5` naming the 3 remaining files (`KernelServiceManager.ts` — the receiving end of `KernelRouter.#invokeKernelService`; `packages/streams/src/BaseDuplexStream.ts`; `packages/kernel-utils/src/exo.ts`).
- **Noticed, not fixed (out of scope):** two pre-existing danglers in `library/sources/README.md` — `[[engine-implementation]]` (danfinlay/quickjs row, 2026-07-03) and `[[local-model-serving]]` (MylesBorins/athanor row, 2026-07-04). Both name existing *topic* pages written as concept wikilinks; grep confirmed neither is in the row I added. Flagged in the follow-on plan for a librarian/future scholar. Two standing backfill notes (KernelQueue leaf topic rows; Kernel.ts typo no-op) carried forward as well.

Result entry: `entries/2026/07/06/000444Z-result-gardener-dfe430.md`.
