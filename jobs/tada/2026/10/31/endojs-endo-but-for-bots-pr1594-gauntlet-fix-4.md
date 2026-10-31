# Fix round 4 for endojs/endo-but-for-bots PR #1594: done, CI green

I applied every must-fix item from panel-4's review (5724776124) and pushed them to `daemon-rename-to-manager`. The head moved from `50b82489fd` to `10a1297e11`, and CI is green on all 36 checks.

## What changed

**Commit `0b28819ae7` — fix(daemon): restore the `WorkerFacetForManagerInterface` re-export** (archivist #1, curator #1, surfacer #1)
- The changeset says `./src/interfaces.js` exports this name, but the previous round had removed it. I put the re-export back under the new name, as base already did under the old name. It has no `@deprecated` tag, which was panel-3's complaint.
- The comment in `worker-facet-interface.js` now matches.
- I restored the test that checks both import paths give the same guard object (coverage-auditor #2).
- `xs-worker-facet.test.js` passes locally (13 tests), eslint reports no errors, and prettier is clean.

**Commit `10a1297e11` — docs(daemon): finish the manager rename in the changeset and docs**
- **Changeset** (surfacer #2, curator should-fix):
  - It now names both CapTP interface tags that change: `EndoDaemonFacetForWorker`→`EndoManagerFacetForWorker` and `EndoWorkerFacetForDaemon`→`EndoWorkerFacetForManager`.
  - It lists the renamed types: `ManagerDatabase`, `ManagerPersistencePowers`, `ManagerControlPowers`, `ManagerWorkerFacet`, `WorkerManagerFacet`, `ManagerCoreExternal`, and the `workerManagerFacet` field. I checked each one exists in `src/types.d.ts`.
  - It notes that `bundle-bus-daemon-rust-xs.mjs` keeps its name.
- **`docs/error-tracing-design.md`** (archivist #2): renamed the leftover old identifiers to `managerCore`, `makeManagerFacetForWorker`, `ManagerFacetForWorkerInterface` and `EndoManagerFacetForWorker`.
- **`packages/daemon/AGENTS.md`** (should-fix): removed the wrong `manager.js` line number for the gateway guard.

**PR body** (coverage-auditor #1, the XS code path)
- I built `endor` in release mode and ran `test/endo.test.js` with the Rust supervisor and the XS manager, at head `10a1297e11` and again at base `9a14ddf660` (bundle and `endor` rebuilt for each).
- The results are identical: 66 tests pass, the same 31 fail, and ava times out.
- So the rename changes nothing on the XS path. `test:rust` is already red on base, which is the concrete reason it isn't added to CI in this PR. The body now says this instead of only calling it a follow-up.

## CI
- The first run's `test (24.x, macos-15)` leg failed in `http-content-plane.test.js` with an unhandled `ClientDestroyedError` rejection. That is a known macOS flake in a file this PR doesn't touch.
- I reran the failed job; it passed and `ci-wait-merge` returned rc 0.

## Not done
- I left the stale `daemon-node.js` comment in `.github/workflows/ci.yml` unchanged. It was a should-fix, and an earlier commit (`c13ac3d27a`) deliberately left it for the Rust-side follow-up.

## Follow-ups
- On base, 31 tests in `test/endo.test.js` fail under `test:rust` (Rust supervisor plus XS manager), mainly session owners, native sessions, stored blobs and garbage collection. Under `ENDO_BIN` without `ENDO_NODE_WORKER_BIN`, the file also crashes on load (`testNeedsNodeWorker.serial is not a function`). Both need fixing before `test:rust` can run in CI.
- The `http-content-plane` `ClientDestroyedError` flake on macOS is still there.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (4239957 cached reads)
- Output: 18370 tokens
- Cost: $1.9291274000000003
- Wall-clock: 6160s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
