Inbox empty. Work is complete.

## Completion report

Picked up the intent of a dead-lettered message for `issue-kriskowal-garden-29`: mhofman's latest comment on kriskowal/garden#29 asked two things about the ymax critical-promotion PoC (kriscendobot/agoric-sdk#9, branch `garden29-promote-ymax-critical`). Both are addressed and pushed as commit `678f417`, with a sourced reply posted to the issue thread ([#issuecomment-4929011565](https://github.com/kriskowal/garden/issues/29#issuecomment-4929011565)).

**1. "Is the options change reflected in the data exports / cosmos DB?" — Yes, verified.**
Confirmed at source that `${vatID}.options` is a **consensus** kvStore key (`getKVStoreKeyType` classes anything not `local.`/`host.` as consensus), and swing-store's `getExportData` yields every consensus key as a `kv.<key>` export-data record. Added a SwingSet unit test (`packages/SwingSet/test/upgrade-swingset.test.js`) that runs the real `applyVatOptionUpdates` and asserts the promoted value appears both in the per-commit **export feed** (`exportCallback`, what cosmic-swingset forwards to cosmos) and in a full **state-sync export** (`makeSwingStoreExporter().getExportData()`) as `kv.<vatID>.options` with `critical:true`.

**2. "Author the a3p test" (deterministic-vatID plan) — done.**
- `g:ymax1/test/ymax1.test.js`: logs + asserts the deterministic ymax1 vatID (the value to pin).
- `n:upgrade-next/package.json`: adds the proposer-supplied `upgradeInfo.vatOptionUpdates` channel (the only channel that works on the synthetic chain, since the cosmos-side structured channel is ChainID-gated to agoric-3/agoricdev-25).
- `n:upgrade-next/test/critical-vat.test.js`: resolves the live ymax1 vatID, cross-checks it against the pinned vatID (fails loudly on determinism drift, per mhofman's "note if it changes"), and asserts `options().critical === true` post-upgrade via `getVatInfoFromID().options()`.
- `n:upgrade-next/README.md`: documents the mechanism and one-line activation.

**Follow-ups / open decisions surfaced to mhofman:** `vatOptionUpdates` ships **empty (safe no-op)** because (a) the concrete synthetic-chain vatID must be observed from a first run before pinning, and (b) `g:ymax1` currently *terminates* ymax1 in its last step, which must be dropped for the promotion to have a live target. Offered to flip it on once he confirms he wants ymax1 left running through the upgrade.

Tests are authored but not run (no monorepo/xsnap toolchain in this environment — consistent with the thread's prior "written but not run" convention); they follow the idioms of `exportImport.test.js` and the existing a3p proposal tests. Syntax-validated all touched JS/JSON.
