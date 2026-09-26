CI is **GREEN** (rc 0). The fix stage is complete. Let me record a brief memory note on the outcome, then report.

The work is done. Here is my completion report:

---

## FIX round 1 — kriscendobot/minion.town PR #93

Applied the panel round-1 must-fix items to the clip content-store GC PR, pushed as follow-up commits, and drove CI to green.

**Must-fix items applied (all 6):**

1. **`--drop-unresolved` fail-open closed** (`content-gc.ts`). Excision now refuses outright when liveness cannot be verified (no powers plane / `GATEWAY_ENDO_SOCK` unset) and treats a *failed* liveness check as "keep", never "excise" — only a check that completes and resolves to nothing live is confirmed-dead.
2. **`unpublish` takedown ordering** (`publish.ts`). Unregister the serving pin *first*, then drop the guest pet name best-effort (caught) — a transient `removeDirectory` glitch can no longer gate the takedown. Added a `removeDirectory`-rejection test.
3. **`internBlob` TOCTOU** (`content-store.ts`). Touch the file directly (dropped the separate `fs.access` check) and, on ENOENT from a concurrent GC unlink, fall through to re-write the identical content-addressed blob instead of failing the publish.
4. **Strict mark-phase ENOENT** (`content-gc.ts`). `readVhostRecordStrict` now distinguishes a vanished record (ENOENT → excluded from the live set) from a torn/corrupt read (still fails closed after a retry).
5. **Unbounded audit `readFile`** (`content-gc.ts`). The audit only inspects blobs small enough to plausibly be a manifest (`MANIFEST_INSPECTION_MAX_BYTES = 8 MiB`), bounding peak per-blob memory under the unit's `MemoryMax=256M`.
6. **Property coverage** (`content-gc.test.ts`). Added `fast-check` (new devDependency) property tests for `computeLiveSet` (exact union) and `computeOrphans` (liveness/grace partition + orphaned-bytes invariant).

**Also addressed:** should-fix #7 (added `endo-gateway-gc` to the `workflow_dispatch` deploy-target choice list) and #10 (corrected stale docstrings in `content-gc.ts`, `content-store.ts`, and the CLI USAGE).

**Verification:** `tsc --noEmit` clean; full `test/gateway/` suite 142/142 green locally (incl. updated/added GC + publish tests). Pushed `63b5de9..655e584` (5 focused commits) to `feat/clip-content-store-gc`. CI terminal: **GREEN** (rollup total=1 failed=0).

**Not applied (deferred to a later round, out of this stage's must-fix scope):** should-fix #8 (shared vhost-record predicate), #9 (discriminated-union `BlobInventoryEntry`), #11 (createDirectory/removeDirectory duality), and the coverage-auditor's c8 report request.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-content-store-gc-build-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (4782035 cached reads)
- Output: 40707 tokens
- Cost: $4.484763500000001
- Wall-clock: 615s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
