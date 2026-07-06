scholar cycle complete — thirteenth ocap-kernel ingest; fifth kernel-internals comment-fragment.

Ingested `packages/ocap-kernel/src/KernelRouter.ts` (MetaMask/ocap-kernel, sha `d979a06`, 437 lines) into 4 sections: the router + promise-state delivery model, the three-outcome `#routeMessage` (splat/send/requeue by kref scope), the refcount-bookkeeping `#deliverSend` (endpoint-vanished-splat, kref→eref translation, kernel-service branch), and the c-list-gated `#deliverNotify` + GC deliveries. Plus the `kind: index` parent + source-index files.

Cross-linked to [[ocap-kernel]] and the KernelQueue / Kernel / VatHandle / VatSupervisor sections; indexed across sources/README, concept page (index + 4 leaf rows + aliases), topics (eventual-send ×3, capability-security ×3, persistence ×2), and keywords (3 lines).

No comment-vs-code drift; two honest non-drift notes recorded (the maintainers' own TODO to narrow the endpoint-vanished `catch`; a slightly-loose `#deliverNotify` comment). Integrity gate `--source-slug … --wikilinks` → OK/exit 0. Sections index + topics counts regenerated and landed. Also noticed (and flagged in the follow-on) 2 pre-existing `sources/README.md` danglers unrelated to this cycle (`[[engine-implementation]]`, `[[local-model-serving]]`).

Follow-on plan `scholar-ingest-ocap-kernel-comment-fragments-5` parked naming the 3 remaining files (KernelServiceManager.ts, BaseDuplexStream.ts, kernel-utils/exo.ts).

Result entry: entries/2026/07/06/000444Z-result-gardener-dfe430.md.

Self-improvement: The post-ingest integrity gate has two scopes with different meanings — `--source-slug <my-slug>` is the *gating* check (my cluster, which passed clean), while a whole-file `--files sources/README.md` surfaces every dangler in a shared index, including pre-existing ones from other ingests. Reading the danglers and confirming (via grep) they are not in my added row kept me from either falsely failing my own cycle or silently "fixing" another scholar's rows out of scope — I flagged them for a librarian instead. Worth remembering: on a shared-index whole-file check, always attribute each dangler to a row before deciding it is mine.
