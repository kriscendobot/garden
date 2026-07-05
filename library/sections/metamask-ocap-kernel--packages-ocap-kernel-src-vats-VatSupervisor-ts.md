---
title: "VatSupervisor.ts (MetaMask/ocap-kernel) — the in-vat supervisor: mirror-image dual RPC wiring, optimistic syscall execution, teardown-first termination, and the initVat endowment-confinement sequence"
source: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatSupervisor.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_line_range: "1-481"
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-24
comment_subject: VatSupervisor is the in-vat counterpart to the kernel-side VatHandle — running inside the vat worker, owning the one duplex stream to the kernel, wiring the same two RPC endpoints pointed the opposite way (syscalls out, kernel commands in), running an optimistic-execution syscall model, terminating teardown-first via a shared idempotent promise, and loading user code through an initVat sequence that enacts the vat-endowment allowlist (kernel-restricted filtering, no-implicit-allow-all caveated fetch, disjoint endowment merge).
source_authors: [Dimitris Marlagkoutsos, Erik Marks, grypez]
ingested: 2026-07-05
ingested_by: scholar
topics: [capability-security, eventual-send, daemon, bundles]
status: current
kind: index
section_count: 4
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Fourth kernel-internals comment-fragment ingest from the cycle-161 overview plan (after KernelQueue.ts, Kernel.ts, and VatHandle.ts); the in-vat mirror image of the kernel-side VatHandle, so the two form a matched pair. See [[ocap-kernel]] concept for the lineage flag.
---

## Abstract

`packages/ocap-kernel/src/vats/VatSupervisor.ts` is the **in-vat supervisor** — the object that runs *inside* the vat worker and "supervises a vat's execution, managing its lifecycle and communication with the kernel." It is the matched-pair counterpart to the kernel-side [`VatHandle`](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts.md): the two objects are the two ends of one JSON-RPC-over-duplex-stream link, and `VatSupervisor` wires the *same* two RPC endpoints as `VatHandle` but pointed the opposite direction. The file's substance splits into four comment clusters the section files below curate.

First, the **mirror-image dual RPC wiring**: an `RpcClient` that sends the vat's syscalls *out* to the kernel (namespaced by the vat id) and an `RpcService` that handles the kernel's `initVat` / `handleDelivery` commands coming *in*, over one `#kernelStream`, plus a construction-time endowment assembly guarded by two defense-in-depth asserts (a superstruct shape check and an explicit `harden`) and a fire-and-forget drain that self-terminates the vat with a `StreamReadError` on any read error. Second, **optimistic syscall execution**: to satisfy liveslots' *synchronous* syscall interface the vat fires each syscall as a fire-and-forget notification and immediately returns `['ok', null]` without awaiting, on the assumption of success — an assumption made safe because failures are caught crank-side in `VatHandle`, which terminates the vat and rolls the crank back. Third, **teardown-first idempotent termination**: `terminate()` memoizes the in-flight teardown as a shared `#terminationPromise` (so concurrent callers await one real completion), and `#doTerminate` releases endowment resources *before* closing the kernel stream, logging teardown failures — each sub-error of an `AggregateError` individually — but never letting them block stream closure, so the original death reason always reaches the kernel. Fourth, the **`initVat` endowment-confinement sequence**: a once-only user-code load that intersects a kernel-supplied `allowedGlobalNames` restriction against the full allowlist, rejects any requested global not on the effective allowlist, wraps a requested `fetch` in a per-vat host-allowlist caveat with **no implicit-allow-all pathway**, merges the endowment records disjointly (collisions become a specific `DuplicateEndowmentError`), then builds liveslots and hands the vat its opening `startVat` delivery.

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo and Agoric work, never imports its code. It is the **fourth** kernel-internals comment-fragment ingest (after `KernelQueue.ts`, `Kernel.ts`, and `VatHandle.ts`), and — being the in-vat mirror of `VatHandle` — it completes the kernel↔vat endpoint pair: the two files describe the same duplex link from its two ends.

## Sections

- [VatSupervisor as the in-vat endpoint: the mirror-image dual RPC wiring (client sends syscalls out, service handles kernel commands in) and the defense-in-depth endowment assembly](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--in-vat-endpoint-and-mirrored-dual-rpc-wiring.md)
- [Optimistic syscall execution: the vat fires a syscall and continues without awaiting, and failure is caught crank-side in VatHandle (terminate + rollback)](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--optimistic-syscall-execution.md)
- [Idempotent, endowment-teardown-first termination: the shared termination promise and why teardown failures never block stream closure](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--idempotent-teardown-first-termination.md)
- [The initVat sequence: once-only load, kernel-restricted endowment filtering, the no-implicit-allow-all caveated fetch, and the liveslots build](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--initvat-endowment-filtering-and-caveated-fetch.md)

## See also

- Source index: [metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts](../sources/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts.md)
- Synthesizing concept: [[ocap-kernel]]
- The kernel-side mirror image (the other end of the same duplex link): [metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts.md), whose [dual RPC wiring section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--endpoint-handle-and-dual-rpc-wiring.md) is the kernel-side twin of this file's wiring and whose [priority-ordered crank result section](metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--priority-ordered-crank-result-and-termination.md) is where the optimistic syscalls' failures are caught
- The run loop that drives the deliveries this supervisor receives: [metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts.md), and its [crank-abort-versus-commit-flush section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--crank-abort-rollback-versus-commit-flush.md) — the rollback that makes optimistic execution safe
- The host-facing description of the endowment allowlist this file enacts: [metamask-ocap-kernel--docs-kernel-guide-md--vat-endowments](metamask-ocap-kernel--docs-kernel-guide-md--vat-endowments.md)

Source: [packages/ocap-kernel/src/vats/VatSupervisor.ts](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/packages/ocap-kernel/src/vats/VatSupervisor.ts) at commit `175b7c0`.
