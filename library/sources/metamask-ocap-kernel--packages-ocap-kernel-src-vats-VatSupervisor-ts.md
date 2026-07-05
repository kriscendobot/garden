---
source: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_kind: comment-fragment
source_repo: MetaMask/ocap-kernel
source_path: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_line_range: "1-481"
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
comment_subject: VatSupervisor is the in-vat counterpart to the kernel-side VatHandle — running inside the vat worker, owning the one duplex stream to the kernel, wiring the same two RPC endpoints pointed the opposite way (syscalls out, kernel commands in), running an optimistic-execution syscall model, terminating teardown-first via a shared idempotent promise, and loading user code through an initVat sequence that enacts the vat-endowment allowlist.
source_date: 2026-04-24
source_authors: [Dimitris Marlagkoutsos, Erik Marks, grypez]
ingested: 2026-07-05
ingested_by: scholar
section_count: 4
status: current
notes: |
  Twelfth ocap-kernel ingest and the FOURTH kernel-internals comment-fragment
  source (after KernelQueue.ts, Kernel.ts, and VatHandle.ts). VatSupervisor is
  the in-vat mirror image of the kernel-side VatHandle: it runs inside the vat
  worker, owns the vat's end of the one duplex stream to the kernel, and wires
  the SAME two RPC endpoints as VatHandle but pointed the opposite direction —
  an RpcClient that sends the vat's syscalls OUT and an RpcService that handles
  the kernel's initVat/handleDelivery commands coming IN. The two files are the
  two ends of one JSON-RPC-over-duplex-stream link, so this ingest completes the
  kernel↔vat endpoint pair. 481 lines, comment-dense (~113 comment-lines). Its
  longform comments and JSDoc yield four coherent argument clusters: the
  mirror-image dual RPC wiring (plus a construction-time endowment assembly
  guarded by two defense-in-depth asserts and a fire-and-forget drain that
  self-terminates with a StreamReadError on read error); the optimistic syscall
  execution model (fire-and-forget notify + immediate ['ok', null] to satisfy
  liveslots' synchronous interface, made safe because failures are caught
  crank-side in VatHandle which terminates the vat and rolls the crank back);
  the teardown-first idempotent termination (a shared #terminationPromise so
  concurrent callers await one completion; #doTerminate releases endowment
  resources before closing the stream, logging teardown failures — each
  AggregateError sub-error individually — but never blocking stream closure so
  the original death reason always reaches the kernel); and the initVat
  endowment-confinement sequence (once-only load; intersect a kernel-supplied
  allowedGlobalNames against the full allowlist; reject any requested global not
  on the effective allowlist; wrap a requested fetch in a per-vat host-allowlist
  caveat with NO implicit-allow-all pathway; disjoint endowment merge whose
  collisions become a specific DuplicateEndowmentError; then build liveslots and
  hand the vat its opening startVat delivery). SwingSet-lineage; reference-not-
  substrate stance. Idempotency anchor is source_commit (file-path-specific sha
  175b7c0). No comment-versus-code drift found in any of the four clusters (one
  non-drift observation recorded: the constructor's Promise.all wraps a single
  drain promise — harmless dead structure, not a comment/code contradiction).
  Remaining kernel-internals files from the cycle-161 plan (KernelRouter.ts,
  KernelServiceManager.ts, BaseDuplexStream.ts, kernel-utils/exo.ts) stay queued
  under the follow-on plan job scholar-ingest-ocap-kernel-comment-fragments-4.
---

> Abstract: `packages/ocap-kernel/src/vats/VatSupervisor.ts` is the **in-vat
> supervisor** — the object that runs *inside* the vat worker and "supervises a
> vat's execution, managing its lifecycle and communication with the kernel." It
> is the matched-pair counterpart to the kernel-side `VatHandle`: the two objects
> are the two ends of one JSON-RPC-over-duplex-stream link, and `VatSupervisor`
> wires the *same* two RPC endpoints as `VatHandle` but pointed the opposite way.
> The file splits into four comment clusters. The **mirror-image dual RPC
> wiring**: an `RpcClient` sends the vat's syscalls *out* to the kernel
> (namespaced by the vat id), an `RpcService` handles the kernel's
> `initVat`/`handleDelivery` commands coming *in*, over one `#kernelStream`, plus
> a construction-time endowment assembly guarded by two defense-in-depth asserts
> and a fire-and-forget drain that self-terminates the vat with a
> `StreamReadError` on any read error. **Optimistic syscall execution**: to
> satisfy liveslots' synchronous syscall interface the vat fires each syscall as a
> fire-and-forget notification and immediately returns `['ok', null]` without
> awaiting, made safe because failures are caught crank-side in `VatHandle` which
> terminates the vat and rolls the crank back. **Teardown-first idempotent
> termination**: `terminate()` memoizes the in-flight teardown as a shared
> `#terminationPromise`, and `#doTerminate` releases endowment resources before
> closing the kernel stream, logging teardown failures (each `AggregateError`
> sub-error individually) but never letting them block stream closure. The
> **`initVat` endowment-confinement sequence**: a once-only load that intersects a
> kernel-supplied `allowedGlobalNames` restriction against the full allowlist,
> rejects any requested global not on the effective allowlist, wraps a requested
> `fetch` in a per-vat host-allowlist caveat with no implicit-allow-all pathway,
> merges the endowment records disjointly (collisions become a specific
> `DuplicateEndowmentError`), then builds liveslots and hands the vat its opening
> `startVat` delivery.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [in-vat-endpoint-and-mirrored-dual-rpc-wiring](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--in-vat-endpoint-and-mirrored-dual-rpc-wiring.md) | capability-security, eventual-send | current |
| [optimistic-syscall-execution](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--optimistic-syscall-execution.md) | eventual-send, capability-security | current |
| [idempotent-teardown-first-termination](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--idempotent-teardown-first-termination.md) | daemon, capability-security | current |
| [initvat-endowment-filtering-and-caveated-fetch](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts--initvat-endowment-filtering-and-caveated-fetch.md) | capability-security, bundles | current |

Parent index section file: [metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatSupervisor-ts.md).

## Provenance

- Fetched 2026-07-05 from the local bare clone `worktrees/metamask-ocap-kernel.git` at `main` HEAD `a3eff0efb`; the file's own path-specific commit is `175b7c0663ce37c2626d33e08134346d4cdd17bf` (last touched 2026-04-24 by #942, "integrate Snaps network endowment factory").
- Authors over the file's history: Dimitris Marlagkoutsos, Erik Marks, grypez (`git log` over the path).
- 481 lines, comment-dense (~113 comment-lines); the four sections map to lines roughly 73-206 (class fields + constructor / mirror-image dual-RPC wiring + endowment assembly + drain), 280-300 (`executeSyscall` optimistic-execution model), 116-129 + 208-248 (the `#endowmentsTeardown` / `#terminationPromise` field comments and the `terminate` / `#doTerminate` methods), and 327-480 (the `#initVat` user-code-load + endowment-confinement sequence).
- **Twelfth ocap-kernel ingest; fourth kernel-internals comment-fragment.** Genre: sibling-implementation / reference-not-substrate. Synthesizing concept [[ocap-kernel]]. The in-vat mirror of `VatHandle.ts` (the eleventh ingest), completing the kernel↔vat endpoint pair.
- No comment-versus-code drift found in any of the four clusters (each section carries its own Notice / drift check). One non-drift observation is recorded in the dual-RPC section: the constructor's `Promise.all([...])` wraps a single `drain` promise — harmless dead structure, not a comment/code contradiction. ocap-kernel is a read-only reference shelf, not a garden fork, so no boatman missive is available regardless.
