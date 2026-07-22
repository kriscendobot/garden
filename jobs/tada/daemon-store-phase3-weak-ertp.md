All verification complete and artifacts cleaned up. Writing the completion report.

---

## Completion report — `daemon-store-phase3-weak-ertp` (build Phase 3)

**Job state on claim:** This build job had been reaped twice. A prior run had already completed the implementation: commit `74931b920` was pushed to `origin/daemon-store-phase3-weak-ertp`, and draft **PR #823** ("feat(daemon): durable weak collection stores (Phase 3)") was open, correctly stacked on `daemon-store-phase2-setstore`. My work was to verify that build against the design and re-run the local gates.

**Verified the implementation matches the design (`daemon-persistent-stores.md` § Phase 3):**
- `kind: 'weak-map'` / `'weak-set'` added; `makeWeakMapStore` / `makeWeakSetStore` on host + guest; interfaces registered.
- `WeakMapStore` = has/get/init/set/delete; `WeakSetStore` = has/add/delete — both non-enumerable, no `getSize`/snapshot (matches design § interface).
- Reverse weak-key index: new `collection_store_weak_key` table + lookup index (schema bumped v2→v3); a weak entry creates **no retention edge to its key** (`collectionRetentionSlots` skips key slots for weak kinds); values remain strongly retained while the entry lives.
- Formula collection of a key atomically deletes its indexed rows in one SQLite transaction (`deleteWeakCollectionEntriesForKey`) and releases the weak-map's retained value via the graph callback in `manager.js`.
- Restart reconstructs the weak index before serving (`rebuildWeakKeyIndex` in the reformulation path).

**Local verification (executed, evidence below):** the repo's very long worktree path overran the 108-char unix-domain-socket limit and broke daemon boot, so I hardlink-copied the fully-built worktree to a short path to run:
- Phase 3 weak + ERTP tests: **4/4 passed** — weak-surface, restart-preserves-live-key, collect-key-removes-entry-and-releases-value, and *minimal ERTP issuer kit conserves Amount across restart on WeakMapStore* (asserts total Amount = 10n after a create→mint→transfer→restart→balances-intact sequence and ledger-entry drop when a payment is collected).
- Full store-family subset: **41/41 passed** (MapStore/SetStore/collection/restart).
- `eslint .`: **0 errors** (warnings only); `tsc`: **0 errors**.

**PR #823 CI:** draft, base `daemon-store-phase2-setstore`, `MERGEABLE`/`CLEAN`, and **every check SUCCESS** — the full matrix (`test 22.x/24.x` on ubuntu+macos, `test-xs`, `cover`, `test262`, `lint`, `sandbox-drivers`, …). CI running the complete suite green independently confirms no regressions.

**Gauntlet / un-draft / issue-comment — deliberately deferred, not skipped:** The issue #59 outcome comment is gated on the PR being *green **and** un-drafted*. PR #823 is correctly still a draft: phases 1 (#819) and 2 (#822) are likewise still draft with no panel reviews — the expected state for a stacked build mid-orchestration, since phase 3 cannot un-draft/merge ahead of its predecessors. The panel → un-draft → issue-#59 comment belong to the later orchestrated merge sequence (phase 1→2→3), matching phases 1 and 2.

**Changed:** nothing new — the prior run's Phase 3 commit was complete and correct; I made no code changes. Cleaned up a stale project-worktree registration and my scratch verification artifacts, and tore down the worktrees I created.

**Follow-ups:** the stacked merge sequence proceeds under the issue-#59 orchestration; the issue outcome comment fires when phase 3 reaches green-and-un-drafted after phases 1–2 merge to `llm`.
