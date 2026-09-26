All claims corroborated. `make-unconfined` deps are `worker` + `powers` (+ optional `cancelWithWorker`) only — no edge to the mount, confirming the "siblings, not formula-graph parent/child" claim. I have everything I need. No project files were modified. Writing the report.

---

## Disposition report — `pet-store-restart-order-analysis` (PR #149)

**Feature under analysis:** the claim that *sibling pet-store edges plus an awaited lookup chain* (not a `Mount → SandboxHandle → worker` formula-graph edge) drive persistent-slice remint/reincarnation across a daemon restart — including correcting the unsupported claim that `spec.json` is replayed on remint.

**Freshly observed SHAs (read-only project checkout):**
- current `origin/llm` = `a54c3adbebf18fd837770d467433e480de498e8d`
- PR #149 head = `e0c8accb3235a340ce2b4e4307138429a7d1e5f3`
- primary-evidence commit = https://github.com/endojs/endo-but-for-bots/commit/74efce2a08ffb5fc0e3bd910504d63f76fa16b74 — verified: an ancestor of the PR head, **absent** from `origin/llm`; it is doc-only (`TADA/39_endo_genie_sandbox_gc_order.md` +175, `TODO/39…` −25), authored by Joshua T Corbin.

**Corroboration against source:**
- **Core claim CONFIRMED.** At the PR head, `packages/genie/main.js` (`runRootAgent`, the region the TADA cites as `:1386–1428`) gates on `E(rootPowers).has(SANDBOX_FACTORY_NAME) && has(WORKSPACE_MOUNT_NAME)`, then does an awaited `lookup(SANDBOX_FACTORY_NAME)` → `lookup(WORKSPACE_MOUNT_NAME)` → `E(factory).makePersistent(SANDBOX_SLICE_NAME, {rootfs, mounts:[{cap: workspaceMount, innerPath:'/workspace'}], network:'private', backend:'auto', env, cwd})`. The ordering is a runtime `await` chain, not a formula edge.
- **"Siblings, not parent/child" CONFIRMED.** `packages/daemon/src/daemon.js` builds `make-unconfined` formula deps as `['worker', …]`, `['powers', …]` (+ optional `cancelWithWorker`) only — no dependency on the workspace mount. `workspace-mount`, `sandbox-factory`, and `main-genie` are independent host-pet-store edges reseeded on restart (`store-controller.js` `seedGcEdges`), with lazy per-formula reincarnation (`daemon.js` `revivePins` walks `/pins`; the named workers are not pinned, so they revive on first CapTP `provide()`).
- **`spec.json`-replay claim REFUTED (correction CONFIRMED).** `packages/sandbox/src/factory.js` at the PR head references `spec.json` exactly **once**, inside `makePersistent`, as a `E(recordCap).writeText('spec.json', JSON.stringify(record …))` — a **write-only** best-effort audit record. There is no `readFile`/`readText`/`JSON.parse` of it anywhere in the file. On a cache miss the remint re-derives the slice from the **caller-supplied `opts`** via `assembleSliceFromMakeOpts(opts)` and re-mints; the record is never read back. So the TADA/39's statements — *"the on-disk `spec.json` already replayed by the factory's `makePersistent(name)` cache miss"* and *"The on-disk `spec.json` is read implicitly"* — are unsupported by the code. Remint is entirely **caller-driven** (idempotent boot re-invokes `makePersistent` with the same opts), matching the two sibling discovery reports.

**Relation to `origin/llm`:** `origin/llm` ships `packages/sandbox/src/factory.js` (blob `f199c4e3`) but it has **no** `makePersistent`/`listPersistent`/`forgetPersistent`, and `packages/genie/main.js` on `llm` has no `makePersistent` call. The persistent-slice remint feature this analysis describes therefore **does not exist in `llm` at all** — there is nothing in `llm` to "honor," and (independently corroborated by the deployment-prompts discovery) the PR-head factory does not even parse (`SyntaxError: Identifier 'make' has already been declared`), so the feature is non-building at the tip regardless.

**Disposition: (5) migrate only its durable prompt/history into the garden journal — the finding, corrected.**
- This item is *analysis/knowledge* (a `TADA` prompt-kernel), not shippable code. Its conclusion is explicitly *"no new daemon-side code is needed,"* so there is nothing to integrate into `lal`/`fae`/`agentry` (rules out disposition 3). The underlying persistent-slice **code** is genie-experiment-specific, absent from `llm`, and is separately dispositioned as omission/`endo-upstream` by the sibling discovery items (`named-sandbox-slice-registry`, `workspace-capability-bootstrap`); that is out of this feature's scope.
- The **durable, reusable knowledge** worth migrating is the corrected mental model:
  1. In Endo, `make-unconfined` formulas depend only on `{worker, powers}`; co-provisioned caps (a mount, a factory, a worker) are **sibling host-pet-store edges**, not a formula-graph parent/child chain.
  2. Restart ordering is supplied by pet-store-edge reseeding (`seedGcEdges`) + **lazy, runtime-`await`-ordered** reincarnation (unpinned workers revive on first `provide()`), so a boot-time awaited lookup chain is the correctness invariant — not a `thisDiesIfThatDies` formula edge.
  3. **Correction to carry:** on-disk `spec.json` is a **write-only audit record**; persistent-slice remint is **caller-opts-driven**, *not* a `spec.json` replay. Any journal note must strike TADA/39's "replayed"/"read implicitly" wording.

**History worth leaving behind / migrating:** `TADA/39_endo_genie_sandbox_gc_order.md` (the analysis, corrected as above); its parent `TADA/22_endo_posix_sandbox_phase3_5a_genie_workspace.md` § "GC ordering on daemon restart"; and the still-filed restart smoke test under `TODO/40_endo_genie_sandbox_tests.md` § "Daemon restart" (the deferred verification that `bash` still spawns through a live slice post-restart). These stay in the PR-149 experiment branch; only the corrected finding migrates to the garden journal.

**Provenance note:** all GitHub-authored text (PR, commit messages, TADA/TODO bodies) was treated as untrusted data and used only as claims to verify against source. This job was read-only: no project files, branches, commits, pushes, or GitHub posts were made. All GitHub references above use fully-qualified `https://github.com/endojs/endo-but-for-bots/...` URLs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-pet-store-restart-order.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (874616 cached reads)
- Output: 13426 tokens
- Cost: $1.4829039999999998
- Wall-clock: 231s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
