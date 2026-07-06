---
kind: result
role: gardener
host: endolinbot
at: 2026-07-06T00:04:46Z
---
scholar cycle — thirteenth ocap-kernel ingest; fifth kernel-internals comment-fragment (job scholar-ingest-ocap-kernel-comment-fragments-4)

## Ingested (1 source, 4 sections)

`packages/ocap-kernel/src/KernelRouter.ts` (MetaMask/ocap-kernel, `main`, file-path sha `d979a06325666af32ca7f68b13e9c85486d89ab5`, last touched 2026-04-07 by #917; 437 lines, ~104 comment-lines). Idempotency: no prior source file existed for this path, so this is a first ingest — the recorded `source_commit` is the current upstream file-specific sha.

Four sections (each with its own Notice / drift check):
- `router-and-promise-state-delivery-model` (lines 25-110) — topics: eventual-send, capability-security. The stateless router over five injected collaborators; `deliver()` dispatch over run-queue-item types; the class JSDoc's promise-state trichotomy (unresolved ⇒ requeue, fulfilled ⇒ forward, rejected ⇒ reject the message's result).
- `route-message-splat-send-requeue` (lines 112-194) — topics: eventual-send, capability-security. `#routeMessage`'s three outcomes encoded in `MessageRoute` (splat=null / send / requeue), dispatched by kref scope and promise state; the current-`decider`-as-resolver splat and the `isRevoked`/`getOwner` capability gates.
- `deliver-send-refcount-and-endpoint-vanished-splat` (lines 196-341) — topics: capability-security, persistence. Refcount decrements on every exit (provenance-tagged); endpoint-vanished `#getEndpoint` throw degraded to an `ENDPOINT_UNREACHABLE` splat; decider assignment + kref→eref translation before `deliverMessage`; delivery-throw → `DELIVERY_FAILED` without crashing the queue; the `endpointId==='kernel'` → `#invokeKernelService` branch.
- `deliver-notify-promise-resolution-and-gc-actions` (lines 343-436) — topics: eventual-send, persistence. Idempotent, c-list-gated `#deliverNotify` building eref-scoped `VatOneResolution` tuples with precise refcount decrements; `#deliverGCAction` derives `deliverDropExports`/`deliverRetireExports`/`deliverRetireImports` from the item type; `#deliverBringOutYourDead` reap.

Plus the `kind: index` parent section file and the source-index file.

## Comment-vs-code drift

**None found** in any of the four clusters. Two honest non-drift observations recorded (in the source-index notes and the relevant section files): (a) the endpoint-vanished bare `catch` in `#deliverSend` carries the maintainers' own `TODO` that it should be narrowed to `VatNotFoundError` — a self-flagged latent bug, not a comment/code contradiction; (b) one `#deliverNotify` inline comment ("the promise being notified") is slightly loose about which promise the in-loop vs tail decrement covers (the code is correct). ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Index/topic/concept pages touched

- `library/sources/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md` (new source index).
- `library/sections/metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md` (new `kind: index` parent) + 4 new leaf section files.
- `library/sources/README.md` — added the KernelRouter row (thirteenth ocap-kernel ingest).
- `library/concepts/ocap-kernel.md` — added a KernelRouter index row + 4 leaf rows to the "Sections that touch this concept" table, and extended `aliases` (KernelRouter, routeMessage, splat, requeue, deliverSend, deliverNotify, DELIVERY_FAILED, ENDPOINT_UNREACHABLE, invokeKernelService, kref scope, MessageRoute, deliverMessage).
- `library/topics/eventual-send.md` (3 rows), `library/topics/capability-security.md` (3 rows), `library/topics/persistence.md` (2 rows).
- `library/keywords.md` — 3 new keyword lines (routeMessage/splat/send/requeue/MessageRoute; the kernel-error codes; kref→eref translation).

## Integrity gate

`library-link-check.sh --source-slug metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts --wikilinks` → **OK, exit 0** (every section-table target, sections/README index row, and the `kind: index` parent child list resolves to a committed file; the `[[ocap-kernel]]` wikilink resolves).

A broader `--files sources/README.md` surfaces **2 pre-existing danglers unrelated to this cycle** — `[[engine-implementation]]` (danfinlay/quickjs row, 2026-07-03) and `[[local-model-serving]]` (MylesBorins/athanor row, 2026-07-04); both name existing **topic** pages written as concept wikilinks. Grep confirms neither appears in the KernelRouter row this cycle added. Flagged in the follow-on plan for a librarian / future scholar; out of scope for a comment-fragment ingest.

## Regenerated projected indexes (final landing step)

- `regenerate-sections-index.sh` → landed `library/sections/README.md` (KernelRouter section files projected in).
- `regenerate-topics-counts.sh` → landed `library/topics/README.md` (Sections-count column reconciled after the topic-page row additions).

## Follow-on

Posted deferred plan job **`scholar-ingest-ocap-kernel-comment-fragments-5`** naming exactly the 3 remaining kernel-internals files: `KernelServiceManager.ts` (natural next pick — the receiving end of `KernelRouter.#invokeKernelService`), `packages/streams/src/BaseDuplexStream.ts`, and `packages/kernel-utils/src/exo.ts`. The plan carries the two standing backfill notes (KernelQueue leaf topic rows; the Kernel.ts typo no-op) and the newly-noticed `sources/README.md` pre-existing dangler pair.

All library and index writes landed to `origin/journal2` via `land-journal-edit.sh` (producer-clone CAS path); nothing hand-`git`'d against the live worktree.
