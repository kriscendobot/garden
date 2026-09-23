Job complete and verified. Final state is clean: the job is in `tada/`, the follow-on plan is parked, and nothing lingers in `doin/`.

## Completion report

**Ingested** `packages/ocap-kernel/src/KernelServiceManager.ts` (MetaMask/ocap-kernel, sha `d979a06`, 202 lines) — the fourteenth ocap-kernel ingest and sixth kernel-internals comment-fragment. Idempotency-checked: no prior coverage existed, so a first ingest. It is the receiving end of `KernelRouter.#invokeKernelService` (the `endpointId === 'kernel'` branch), closing the kernel-service delivery leg the KernelRouter cycle left open.

**Sections written (2 leaf + parent index + source index):**
- *service-registry-registration-and-dual-index* — the `KernelService` record, the dual by-name/by-kref `Map` index, `registerKernelServiceObject`'s dedup-by-name + provision-a-kref-at-most-once (`initKernelObject('kernel')` → persist name→kref → `pinObject`, GC-exempt, survives restart), unregister, and the router-facing read surface. Topics: capability-security, persistence.
- *invoke-fire-and-forget-and-crank-deadlock-avoidance* — `invokeKernelService`: why it does NOT await the method (a service may `waitForCrank()`; awaiting would deadlock the crank), `E()`-dispatch for local-or-remote-CapTP-presence, promise-chained resolution in a future turn as the `'kernel'` decider, `kser` on success, and both failure paths normalizing to `DELIVERY_FAILED`. Topics: eventual-send, capability-security.

**Indexed:** new source-index; concept `ocap-kernel.md` (index + 2 section rows, aliases extended); topic pages capability-security (+2), persistence (+1), eventual-send (+1); `sources/README.md` (+1 row); `keywords.md` (+8 lines). Both projected indexes (`sections/README.md`, `topics/README.md` counts) regenerated and landed as the final step.

**Drift:** none found in either cluster. One honest design note recorded (not a contradiction): pin/unpin is the whole GC-safety story for a service kref, so unregistering while a vat still holds it dangles that reference — handled gracefully as a router splat.

**Integrity gate:** `library-link-check --source-slug … --wikilinks` → OK.

**Follow-on:** deferred plan `scholar-ingest-ocap-kernel-comment-fragments-6` posted, naming exactly the two remaining files (`packages/streams/src/BaseDuplexStream.ts` sha `8c4f04b`, `packages/kernel-utils/src/exo.ts` sha `fa464ca`), plus the carried backfill notes (KernelQueue topic-row backfill; the pre-existing `sources/README.md` `[[engine-implementation]]`/`[[local-model-serving]]` danglers).

Result entry: `entries/2026/07/06/002603Z-result-gardener-46dae8.md`.
