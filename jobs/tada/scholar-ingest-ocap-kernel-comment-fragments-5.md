# Job report: scholar-ingest-ocap-kernel-comment-fragments-5

Ingested `packages/ocap-kernel/src/KernelServiceManager.ts` (sha `d979a06`) into
the library as 2 sections + parent index + source index (fourteenth ocap-kernel
ingest, sixth kernel-internals comment-fragment): the kernel-service registry
(dual by-name/by-kref index, dedup + provision-and-pin-a-persisted-kref) and
`invokeKernelService` (fire-and-forget `E()` dispatch, promise-chained resolution
as the `'kernel'` decider to dodge crank deadlock, all failures → DELIVERY_FAILED).
Cross-linked to `[[ocap-kernel]]`, KernelRouter, KernelQueue, Kernel.ts, and the
kernel-guide kernel-services section; indexed under capability-security /
persistence / eventual-send; keywords + concept aliases updated. No comment-vs-code
drift (one design note: pin/unpin is the sole GC-safety story for service krefs).

Integrity gate (`library-link-check --source-slug … --wikilinks`): OK. Both
projected indexes (`sections/README.md`, `topics/README.md` counts) regenerated
and landed. Follow-on deferred plan `scholar-ingest-ocap-kernel-comment-fragments-6`
posted naming the two remaining files (BaseDuplexStream.ts, kernel-utils/exo.ts).
Result entry: entries/2026/07/06/002603Z-result-gardener-46dae8.md.
