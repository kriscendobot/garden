Press dispatch complete — the arc is in its healthiest state yet: design merged, all three implementation-path PRs un-drafted with live merge workers, and the next builder increment now queued behind the merge.

**Assessment (evidence-checked live):**
- **PR #662 (magnet-URN content-locator design): MERGED** (merge commit `cce5f6142b`, landed two dispatches ago). The design half of the finish line stays done; no designer sub-job needed.
- **PR #749** (Phase 1: grammar and duality) — open, un-drafted (last dispatch's gauntlet worked), CI re-running (`UNSTABLE`, updated 06:11Z), with live merge worker `merge-endo-but-for-bots-pr749-content-locator-grammar-duality` in `jobs/doin/`.
- **PR #585** (node-fs content-store powers) — open, un-drafted, `mergeStateStatus: CLEAN`, live merge worker on it.
- **PR #739** (store→writeFile design) — open, un-drafted, CI running, live merge worker on it.

**What I did (the press):** the one gap was that nothing queued the **Phase-2 build** (the `<verb>Content` interface methods — `locateContent`, `listContent`, `storeContent`, `reverseLocateContent`, `internalizeContentLocator` in `directory.js`, carried through `host.js`/`guest.js`) once Phase 1 lands. I verified no such job exists anywhere in the board lifecycle, then posted `build-endo-content-locators-magnet-urn-phase2-interface-methods` as a **blocked** plan job with `blocked_on: https://github.com/endojs/endo-but-for-bots/pull/749`, so the unblock watcher promotes it automatically the moment #749 merges. The body scopes it to Phase 2 only (`xt`-only locators, `@planes` hookup left as a marked Phase-3 seam; Phases 3–5 explicitly out of scope) and stamps `role: builder` for the Opus tier.

**Deliberately not done:** no interference with the three live merge workers (race-claiming or double-merging would collide); no Phase-3–5 jobs (one increment at a time, reassessed next dispatch).

**Arc state for the next dispatch:** expect #585/#739/#749 merged (or their merge jobs surfaced as failed) and the Phase-2 build promoted or in flight. Next press after that: watch Phase 2's gauntlet, then queue Phase 3 (`@planes` and resolution).

No garden-library changes; nothing pushed to `main2`. Inbox drained — empty.
