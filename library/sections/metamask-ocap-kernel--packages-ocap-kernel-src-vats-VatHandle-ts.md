---
title: "VatHandle.ts (MetaMask/ocap-kernel) — the kernel's per-vat endpoint handle: dual RPC wiring, async-make lifecycle, the delivery surface, and the vat death protocol"
source: packages/ocap-kernel/src/vats/VatHandle.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatHandle.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatHandle.ts
source_line_range: "1-401"
source_branch: main
source_commit: d54aa5ceb3ed41a182b5044dd27a95f07bac5a07
source_date: 2026-04-21
comment_subject: VatHandle is the kernel-side handle for exactly one vat — an EndpointHandle wiring two RPC endpoints over the vat's duplex stream (kernel-to-vat commands out, vat-to-kernel syscalls in), constructed only through a static async make, exposing the six deliver* methods and the sendVatCommand commit rule, and carrying the vat death protocol (priority-ordered crank result plus decider-promise-rejecting terminate).
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-07-05
ingested_by: scholar
topics: [capability-security, eventual-send, daemon, persistence]
status: current
kind: index
section_count: 4
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Third kernel-internals comment-fragment ingest from the cycle-161 overview plan (after KernelQueue.ts and Kernel.ts); the vat-facing endpoint the Kernel orchestrator's VatManager holds. See [[ocap-kernel]] concept for the lineage flag.
---

## Abstract

`packages/ocap-kernel/src/vats/VatHandle.ts` is the kernel's **per-vat endpoint handle** — the object the kernel (via its `VatManager`) holds for exactly one running vat, implementing the shared `EndpointHandle` interface. Its one-line class comment, "Handles communication with and lifecycle management of a vat," is the whole contract, and the file's substance splits along that sentence into four coherent comment clusters the section files below curate.

First, the **dual RPC wiring**: the constructor assembles the vat's I/O surface as two RPC endpoints pointed in opposite directions over one duplex stream — an `RpcClient` carrying kernel → vat commands (`initVat`, `deliver`, `ping`), namespaced by the vat's own id, and an `RpcService` dispatching vat → kernel syscalls into a `VatSyscall` bridge — plus the vat's own persistent-state slice (`kernelStore.makeVatStore(vatId)`). Second, the **async-make lifecycle**: a private constructor with a static async `make` (so no half-initialized handle escapes), an `#init` that fires an *unawaited* stream drain whose only failure path is to self-terminate the vat with a `StreamReadError`, and a `#handleMessage` demultiplexer that routes responses to the client and notifications to the service. Third, the **delivery surface**: the six thin `deliver*` wrappers and `sendVatCommand`'s load-bearing rule that a vat's KV mutations commit into its store *only* on a clean delivery — and on error neither commit nor roll back, because an erroring vat is always terminated and its private database deleted while the kernel database is rolled back. Fourth, the **vat death protocol**: `#getDeliveryCrankResult`'s deliberate priority order (illegal syscall over delivery error over vat-requested exit), each producing an abort plus terminate directive, and `terminate()`'s clean dismantling that rejects every promise this vat was the decider for before deleting it.

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo and Agoric work, never imports its code. It is the **third** kernel-internals comment-fragment ingest (after `KernelQueue.ts` and `Kernel.ts`) and the vat-facing endpoint the [Kernel.ts orchestrator](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts.md)'s manager graph drives; it confirms that the `@metamask/ocap-kernel` package's architectural substance lives in these source files rather than in the near-stub package README.

## Sections

- [VatHandle as the vat's endpoint handle: the dual RPC wiring (client sends commands in, service dispatches syscalls out)](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--endpoint-handle-and-dual-rpc-wiring.md)
- [The make / #init lifecycle: a fire-and-forget stream drain that self-terminates the vat on a read error](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--make-init-lifecycle-and-stream-drain.md)
- [The delivery surface and the commit-vat-KV-only-on-success rule (why a failed delivery neither commits nor rolls back the vat's store)](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--delivery-surface-and-kv-commit-on-success.md)
- [Priority-ordered crank result and vat termination (illegal syscall over delivery error over vat-requested exit)](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--priority-ordered-crank-result-and-termination.md)

## See also

- Source index: [metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts](../sources/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts.md)
- Synthesizing concept: [[ocap-kernel]]
- The orchestrator whose `VatManager` holds these handles: [metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts.md), whose [crank-reentrancy section](metamask-ocap-kernel--packages-ocap-kernel-src-Kernel-ts--crank-reentrancy-and-the-terminate-callback-deadlock.md) reaches vat teardown from inside a crank
- The run loop that drives the `deliver*` methods: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts.md), and its [crank-abort-versus-commit-flush section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--crank-abort-rollback-versus-commit-flush.md) — the queue-side counterpart of the KV-commit-on-success rule
- The host-developer vocabulary these deliveries enact: [metamask-ocap-kernel--docs-kernel-guide-md--core-concepts](metamask-ocap-kernel--docs-kernel-guide-md--core-concepts.md); the "bring out your dead" GC idiom is documented in the [glossary ingest](../sources/metamask-ocap-kernel--docs-glossary-md.md)

Source: [packages/ocap-kernel/src/vats/VatHandle.ts](https://github.com/MetaMask/ocap-kernel/blob/d54aa5ceb3ed41a182b5044dd27a95f07bac5a07/packages/ocap-kernel/src/vats/VatHandle.ts) at commit `d54aa5c`.
