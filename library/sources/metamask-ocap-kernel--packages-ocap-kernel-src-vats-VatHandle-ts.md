---
source: packages/ocap-kernel/src/vats/VatHandle.ts
source_kind: comment-fragment
source_repo: MetaMask/ocap-kernel
source_path: packages/ocap-kernel/src/vats/VatHandle.ts
source_line_range: "1-401"
source_branch: main
source_commit: d54aa5ceb3ed41a182b5044dd27a95f07bac5a07
comment_subject: VatHandle is the kernel-side handle for exactly one vat — an EndpointHandle wiring two RPC endpoints over the vat's duplex stream (kernel-to-vat commands out, vat-to-kernel syscalls in), constructed only through a static async make, exposing the six deliver* methods and the sendVatCommand commit rule, and carrying the vat death protocol (priority-ordered crank result plus decider-promise-rejecting terminate).
source_date: 2026-04-21
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-07-05
ingested_by: scholar
section_count: 4
status: current
notes: |
  Eleventh ocap-kernel ingest and the THIRD kernel-internals comment-fragment
  source (after KernelQueue.ts, the ninth ingest, and Kernel.ts, the tenth).
  VatHandle is the kernel's per-vat endpoint handle — the object VatManager holds
  for one running vat, implementing the shared EndpointHandle interface. 401 lines,
  comment-dense (~122 comment-lines). Its longform comments and JSDoc yield four
  coherent argument clusters: the dual RPC wiring (an RpcClient sends kernel->vat
  commands namespaced by vatId, an RpcService dispatches vat->kernel syscalls into
  a VatSyscall bridge, over one duplex stream, plus the vat's own KernelStore
  slice); the async-make lifecycle (private constructor + static async make so no
  half-built handle escapes; #init fires an unawaited stream drain whose only
  failure path is to terminate the vat with a StreamReadError, then awaits initVat;
  #handleMessage demultiplexes responses vs notifications); the delivery surface
  (six thin deliver* wrappers; sendVatCommand commits vat KV mutations only on a
  clean delivery and deliberately neither commits nor rolls back on error, safe
  because erroring vats are terminated and their private DB deleted while the
  kernel DB is rolled back); and the vat death protocol (#getDeliveryCrankResult's
  deliberate priority order illegal-syscall > delivery-error > vat-requested-exit,
  each producing abort + terminate; terminate() rejects every promise this vat was
  the decider for before deleting it). SwingSet-lineage; reference-not-substrate
  stance. Idempotency anchor is source_commit (file-path-specific sha d54aa5c).
  Remaining kernel-internals files from the cycle-161 plan (VatSupervisor.ts,
  KernelRouter.ts, KernelServiceManager.ts, BaseDuplexStream.ts, kernel-utils/
  exo.ts) stay queued under the follow-on plan job
  scholar-ingest-ocap-kernel-comment-fragments-3.
---

> Abstract: `packages/ocap-kernel/src/vats/VatHandle.ts` is the kernel's **per-vat
> endpoint handle** — the object the kernel (via its `VatManager`) holds for
> exactly one running vat, implementing the shared `EndpointHandle` interface. Its
> one-line class comment, "Handles communication with and lifecycle management of a
> vat," is the whole contract, and the file splits along that sentence into four
> comment clusters. The **dual RPC wiring**: the constructor assembles the vat's I/O
> as two RPC endpoints over one duplex stream — an `RpcClient` carrying kernel → vat
> commands (`initVat`, `deliver`, `ping`), namespaced by the vat's id, and an
> `RpcService` dispatching vat → kernel syscalls into a `VatSyscall` bridge — plus
> the vat's own persistent-state slice (`makeVatStore`). The **async-make
> lifecycle**: a private constructor with a static async `make`, an `#init` that
> fires an *unawaited* stream drain whose only failure path is to self-terminate the
> vat with a `StreamReadError`, and a `#handleMessage` demultiplexer (responses →
> client, notifications → service). The **delivery surface**: six thin `deliver*`
> wrappers and `sendVatCommand`'s rule that a vat's KV mutations commit *only* on a
> clean delivery — and on error neither commit nor roll back, because an erroring
> vat is always terminated and its private database deleted while the kernel
> database is rolled back. The **vat death protocol**: `#getDeliveryCrankResult`'s
> deliberate priority order (illegal syscall > delivery error > vat-requested exit),
> each producing an abort + terminate directive, and `terminate()`'s dismantling
> that rejects every promise this vat was the decider for before deleting it.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [endpoint-handle-and-dual-rpc-wiring](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--endpoint-handle-and-dual-rpc-wiring.md) | capability-security, eventual-send | current |
| [make-init-lifecycle-and-stream-drain](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--make-init-lifecycle-and-stream-drain.md) | daemon, eventual-send | current |
| [delivery-surface-and-kv-commit-on-success](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--delivery-surface-and-kv-commit-on-success.md) | persistence, capability-security | current |
| [priority-ordered-crank-result-and-termination](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts--priority-ordered-crank-result-and-termination.md) | persistence, capability-security | current |

Parent index section file: [metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts](../sections/metamask-ocap-kernel--packages-ocap-kernel-src-vats-VatHandle-ts.md).

## Provenance

- Fetched 2026-07-05 from the local bare clone `worktrees/metamask-ocap-kernel.git` at `main` HEAD `a3eff0efb`; the file's own path-specific commit is `d54aa5ceb3ed41a182b5044dd27a95f07bac5a07` (last touched 2026-04-21 by #941, "type vat-endowments allowlist as literal union").
- Authors over the file's history: Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks (`git log` over the path).
- 401 lines, comment-dense (~122 comment-lines); the four sections map to lines roughly 42-136 (class fields + constructor / dual-RPC wiring), 138-219 (`make` / `#init` / `#handleMessage` lifecycle + stream drain), 221-361 (the `deliver*` family + `sendVatCommand` KV-commit rule), and 308-400 (`terminate` + `#getDeliveryCrankResult` death protocol).
- **Eleventh ocap-kernel ingest; third kernel-internals comment-fragment.** Genre: sibling-implementation / reference-not-substrate. Synthesizing concept [[ocap-kernel]].
- No comment-versus-code drift found in any of the four clusters (each section carries its own Notice / drift check). ocap-kernel is a read-only reference shelf, not a garden fork, so no boatman missive is available regardless.
