---
title: "The delivery surface and the commit-vat-KV-only-on-success rule (why a failed delivery neither commits nor rolls back the vat's store)"
source: packages/ocap-kernel/src/vats/VatHandle.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatHandle.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatHandle.ts
source_line_range: "221-361"
source_branch: main
source_commit: d54aa5ceb3ed41a182b5044dd27a95f07bac5a07
source_date: 2026-04-21
comment_subject: The deliver* family (message, notify, dropExports, retireExports, retireImports, bringOutYourDead) are thin sendVatCommand wrappers that each return a crank result; sendVatCommand commits the vat's KV mutations into its VatStore only when the delivery had no error and no illegal syscall — and on error it deliberately neither commits nor rolls back, because an erroring vat is always terminated and its private database deleted while the kernel database is rolled back.
source_authors: [Chip Morningstar, Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-07-05
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the VatHandle delivery surface and KV-commit rule. Eleventh ocap-kernel ingest, third kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

The kernel drives a vat through six **delivery** methods — `deliverMessage`, `deliverNotify`, `deliverDropExports`, `deliverRetireExports`, `deliverRetireImports`, `deliverBringOutYourDead` — each a **thin wrapper**: send the corresponding `deliver` command into the vat, then compute a `CrankResult`. The substance lives one level down in **`sendVatCommand`**, which carries the file's load-bearing persistence rule: after an `initVat` or `deliver` command, it commits the vat's key-value mutations into `#vatStore` **only when the delivery produced no error and no illegal syscall**. On an error it does **neither commit nor roll back** — and the comment explains why that asymmetry is safe: a vat that errors is *always terminated*, its private database is *deleted*, and the kernel's own database is *rolled back* by the crank machinery. So the vat's uncommitted KV changes simply vanish with the vat; there is nothing to undo.

## Body

### The delivery family: six one-shape wrappers

Every delivery method has the same body — issue a `deliver` command with a discriminating first param, then fold the outcome into a crank result:

```ts
async deliverMessage(target: ERef, message: EndpointMessage): Promise<CrankResult> {
  await this.sendVatCommand({ method: 'deliver', params: ['message', target, message] });
  return this.#getDeliveryCrankResult();
}
async deliverNotify(resolutions: VatOneResolution[]): Promise<CrankResult> {
  await this.sendVatCommand({ method: 'deliver', params: ['notify', resolutions] });
  return this.#getDeliveryCrankResult();
}
async deliverDropExports(vrefs: ERef[]): Promise<CrankResult> { /* ['dropExports', vrefs] */ }
async deliverRetireExports(vrefs: ERef[]): Promise<CrankResult> { /* ['retireExports', vrefs] */ }
async deliverRetireImports(vrefs: ERef[]): Promise<CrankResult> { /* ['retireImports', vrefs] */ }
async deliverBringOutYourDead(): Promise<CrankResult> { /* ['bringOutYourDead'] */ }
```

The set is the vat-facing half of the kernel's delivery vocabulary: `message` and `notify` are the two message-delivery kinds; `dropExports` / `retireExports` / `retireImports` and `bringOutYourDead` are the garbage-collection deliveries (the "bring out your dead" GC sweep is the SwingSet idiom the glossary ingest documents). Each returns via `#getDeliveryCrankResult` (covered in the crank-result section).

### sendVatCommand and the commit-only-on-success rule

```ts
async sendVatCommand<Method extends VatMethod>({ method, params }): Promise<...> {
  const result = await this.#rpcClient.call(method, params);
  if (method === 'initVat' || method === 'deliver') {
    const [[sets, deletes], deliveryError] = result as VatDeliveryResult;
    this.#vatSyscall.deliveryError = deliveryError ?? undefined;
    const noErrors = !deliveryError && !this.#vatSyscall.illegalSyscall;
    // On errors, we neither update this vat's KV data nor rollback previous changes.
    // This is safe because vats are always terminated when errors occur
    // and they have their own databases, which are deleted when the vat is terminated.
    // The main kernel database will be rolled back.
    if (noErrors) {
      this.#vatStore.updateKVData(sets, deletes);
    }
  }
  return result;
}
```

The rule has two parts:

1. **Commit only on clean delivery.** A vat's delivery result carries `[sets, deletes]` (the vat's requested KV mutations) plus a `deliveryError`. The mutations are written into `#vatStore` **only** when `noErrors` holds — i.e. no `deliveryError` *and* no `illegalSyscall` recorded on the `VatSyscall` bridge. Either fault suppresses the commit.
2. **On error, do nothing — deliberately.** The comment is explicit that this is *not* an oversight: the code does not roll back the vat's prior changes either. It is safe because the erroring vat is torn down (`terminate`), its private KV database is deleted with it, and the crank machinery rolls back the shared kernel database. The vat's half-applied local changes disappear along with the vat, so an explicit undo is unnecessary. This is the vat-store side of the crank's all-or-nothing turn: the kernel DB rolls back atomically, and the vat DB is simply discarded.

Note also `this.#vatSyscall.deliveryError = deliveryError ?? undefined` — the delivery error is stashed on the syscall bridge so `#getDeliveryCrankResult` can read it when deciding whether the crank aborts and the vat terminates.

## Notice / drift check

The multi-line comment is an accurate and load-bearing description of the branch it annotates: the commit is gated on `noErrors`, and there is indeed no rollback branch — consistent with the stated invariant that erroring vats are terminated and their databases deleted. The claim "vats are always terminated when errors occur" is corroborated within the same file by `#getDeliveryCrankResult`, which sets `results.terminate` on every one of `illegalSyscall`, `deliveryError`, and `vatRequestedTermination.reject`. No comment-versus-code drift in this cluster.

## Lineage note

The "a crank either commits atomically or is discarded" discipline is the SwingSet transactional-turn model; ocap-kernel splits it across two stores (the shared kernel DB, rolled back by the crank; the per-vat DB, deleted with a dead vat) so a vat's local mutations need no separate undo path. Endo's persistence is formula-graph traversal rather than a per-vat SQLite slice, so the "delete the vat's own database" move has no direct Endo analog — a concrete divergence worth remembering when comparing failure-atomicity strategies. See [[ocap-kernel]] and [[persistence]]; the crank-abort-versus-commit-flush counterpart on the queue side is [KernelQueue.ts crank-abort-rollback section](metamask-ocap-kernel--packages-ocap-kernel-src-KernelQueue-ts--crank-abort-rollback-versus-commit-flush.md).

Source: [packages/ocap-kernel/src/vats/VatHandle.ts](https://github.com/MetaMask/ocap-kernel/blob/d54aa5ceb3ed41a182b5044dd27a95f07bac5a07/packages/ocap-kernel/src/vats/VatHandle.ts) (lines 221-361) at commit `d54aa5c`.
