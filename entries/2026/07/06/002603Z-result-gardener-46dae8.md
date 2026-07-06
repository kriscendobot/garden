---
kind: result
role: gardener
host: endolinbot
at: 2026-07-06T00:26:05Z
---
# result: scholar — ingest ocap-kernel KernelServiceManager.ts comment fragments (batch 5, fourteenth ocap-kernel ingest)

Job: `scholar-ingest-ocap-kernel-comment-fragments-5`. Wore the **scholar** role;
read-only library scholarship over the public `MetaMask/ocap-kernel` repo
(sibling-implementation genre, reference-not-substrate). One comment-fragment
file ingested this cycle.

## Source ingested

- `packages/ocap-kernel/src/KernelServiceManager.ts` — **2 sections** (202
  lines, ~67 comment-lines). Idempotency check: recorded/current file-path-
  specific sha `d979a06325666af32ca7f68b13e9c85486d89ab5` (last touched
  2026-04-07, #917) matched the plan; no prior library coverage existed, so this
  was a first ingest, not a re-ingest. **Fourteenth ocap-kernel ingest; sixth
  kernel-internals comment-fragment** (after KernelQueue.ts, Kernel.ts,
  VatHandle.ts, VatSupervisor.ts, KernelRouter.ts). It is the receiving end of
  `KernelRouter.#invokeKernelService` (the `endpointId === 'kernel'` branch),
  closing the kernel-service delivery leg the KernelRouter ingest left open.

### Sections written
- `...KernelServiceManager-ts.md` (parent `kind: index`)
- `...KernelServiceManager-ts--service-registry-registration-and-dual-index.md` — the `KernelService` record; the dual by-name/by-kref `Map` index; `registerKernelServiceObject`'s name-dedup + provision-a-kref-at-most-once-per-name (`initKernelObject('kernel')` → `setKernelServiceKref` → `pinObject`, GC-exempt, survives restart); `unregister` reversing all of it; the `getKernelService`/`getKernelServiceByKref`/`isKernelService` read surface the router consumes. Topics: `capability-security`, `persistence`.
- `...KernelServiceManager-ts--invoke-fire-and-forget-and-crank-deadlock-avoidance.md` — `invokeKernelService`: the JSDoc rationale for not awaiting the method (a service may `waitForCrank()`; awaiting inline would deadlock the crank), `kunser` of `[method, args]`, dispatch **through `E()`** (local object or remote CapTP presence), the `.then/.catch` resolving the caller's promise in a future turn as the `'kernel'` decider, `kser(resultValue)` on success, and both failure paths (async rejection + synchronous throw) normalizing to `DELIVERY_FAILED` (a no-result message just logs). Topics: `eventual-send`, `capability-security`.

## Pages touched
- **New:** `sources/metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts.md` (source index, 2-row section table).
- **Concept** `concepts/ocap-kernel.md`: added the index row + 2 section rows to the "Sections that touch this concept" table; extended `aliases` with `KernelServiceManager`, `registerKernelServiceObject`, `unregisterKernelServiceObject`, `isKernelService`, `systemOnly`, `pinObject`, `kser`, `kunser`, etc.
- **Topic pages** (via `insert-sections-table-row.sh`): `capability-security.md` (+2), `persistence.md` (+1), `eventual-send.md` (+1).
- **Indexes:** `sources/README.md` (+1 source row); `keywords.md` (+8 ocap-kernel keyword lines for the KernelServiceManager surface).
- **Regenerated (final landing step):** `sections/README.md` (`regenerate-sections-index.sh`, landed) and `topics/README.md` Index Sections-count column (`regenerate-topics-counts.sh`, landed).

## Integrity gate
`library-link-check.sh --source-slug metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts --wikilinks` → **OK** (every checked section-table target, `sections/README.md` index row, cross-section link, and `[[ocap-kernel]]` wikilink resolves to a committed file). Both projected indexes regenerated and landed after the gate.

## Drift / notices
**No comment-vs-code drift** in either cluster (each section carries its own Notice / drift check). One honest **design observation** recorded (not a contradiction): the `pinObject`/`unpinObject` pairing is the whole GC-safety story for a service kref, so an `unregisterKernelServiceObject` while a vat still holds the kref leaves that reference dangling — but the vat's later send simply splats as a no-owner target, handled gracefully by the router's `#deliverSend`. ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Follow-on posted
- `scholar-ingest-ocap-kernel-comment-fragments-6` (deferred plan) — names the **two** remaining comment-fragment files: `packages/streams/src/BaseDuplexStream.ts` (sha `8c4f04b`) and `packages/kernel-utils/src/exo.ts` (sha `fa464ca`), with idempotency shas and cross-link guidance.

## Deferred backlog (carried, unchanged this cycle)
- The three `KernelQueue.ts` leaf sections were never added as Section rows to the `persistence` / `eventual-send` / `capability-security` topic pages (the KernelQueue **index** row is on the concept page); a future cycle can backfill.
- The trivial `Kernel.ts` "Service to to things" doc-comment typo remains a documentation-only no-action item in a read-only repo.
- Pre-existing `sources/README.md` danglers `[[engine-implementation]]` and `[[local-model-serving]]` (both exist as **topic** pages, not concepts) remain open for a librarian/future scholar; out of scope here.

Self-improvement: The batch plans have carried a stable, well-tested recipe (isolated gardener clone as staging, land via `land-journal-edit.sh`, `insert-sections-table-row.sh` for topic rows, scoped `--source-slug --wikilinks` gate, then the two regenerators as the final landing step) that made this cycle friction-free; no new lesson beyond confirming the recipe holds for a `packages/ocap-kernel/src/` file with no prior coverage.
