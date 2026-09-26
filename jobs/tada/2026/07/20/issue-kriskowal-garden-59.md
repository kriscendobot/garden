All work is complete. Here is my report.

---

## Completion report — issue-kriskowal-garden-59

**Issue (dckc, kriskowal/garden#59):** "Does the endo pet daemon support the `@agoric/store` interfaces (MapStore, WeakMapStore, SetStore)? If so, show tests; if not, make a design and build it. Run the gauntlet."

### Finding: No — not supported today
Two parallel deep-dives into `endojs/endo-but-for-bots @ llm` established:
- The daemon persists via **formulas + SQLite + a content-addressed blob store**. Its only "store"-like abstractions are **name→formula-id maps** (`pet-store`, `directory`/NameHub, `synced-store`) and **write-once value snapshots** (`storeValue` → immutable `marshal` formula). There is no durable, incrementally-mutable `MapStore`/`SetStore`/`WeakMapStore` a guest can create and `set`/`delete` keys on across restarts.
- No `@agoric/store`/`@agoric/zone`/`vatstore`/durable-kind machinery anywhere in `packages/daemon`. `@agoric/store` sits **downstream of `@endo/patterns`**; endo ships the foundation (`M`, `Key` comparison, immutable `CopyMap`/`CopySet`) but not the mutable persistent collections. So there were no tests to show.

### What I did (this being the "make a design and build it" branch)
1. **Design doc** — wrote `packages/daemon/designs/daemon-persistent-stores.md` (grounded in actual daemon source: formula-type/record, manager-database, pet-store, store-controller). It specifies a daemon-native store mirroring the `@agoric/store` API over the daemon's own formula+SQLite substrate (new `map-store` formula type + `map_store_entry` table + `MapStore` exo + `makeMapStore(petName)`), reusing `@endo/patterns`/`@endo/exo`, no `@agoric/*` dep. Phased: Phase 1 strong `MapStore` with restart-persistence tests (closes the issue) → `SetStore` → weak variants → parity polish.
2. **Design PR** — opened draft **endojs/endo-but-for-bots#809** (branch `daemon-persistent-stores`), left open for dckc's review of direction.
3. **Builder follow-on job** — posted `build-daemon-mapstore-gh59` to implement Phase 1 against the design and **run the gauntlet** (its draft PR auto-runs clean→panel→fix-loop→un-draft). The ISSUE NOTE block is copied verbatim so it comments back on #59 when done.
4. **Issue reply** — commented the full answer, evidence, design link, and build status on #59 (comment #5026682802). Did not close the issue (submitter closes when satisfied).

### Changes
- New file on PR branch: `packages/daemon/designs/daemon-persistent-stores.md` (design PR #809).
- New job on the board: `build-daemon-mapstore-gh59`.

### Follow-ups (owned by the queued builder job, not this job)
- Implement Phase 1 `MapStore` + restart-persistence tests; land green through the gauntlet; comment the implementation PR on #59.
- Design open questions flagged in the doc: options-record shape for `makeMapStore`, marshal codec reuse vs. thin entry codec, weak-reference GC (Phase 3).
