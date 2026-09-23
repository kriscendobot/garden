**Press report — endo-byte-array-press (dispatch 2026-07-18T00:20Z)**

**Byte-array fronts: unchanged, all in reviewers' court (progress observation).**
- **endojs/endo-but-for-bots#475** (frozen-`Uint8Array` view redesign, the design-#572 implementation of record): head unchanged at `1b1dc75ba9` on `master-2708cac`, `mergeable_state: clean`, CI green — verified `gh api …/commits/1b1dc75ba9…/check-runs` → `{"success":17}`. Zero new reviews or comments since the 07-17 12:23Z re-review request to kriskowal + erights.
- **endojs/endo-but-for-bots#503** (emulation predecessor): clean, CHANGES_REQUESTED, zero activity since last dispatch; kept live for comparison per reviewer preference. Draft spike #602 unchanged (07-10).
- **Registry follow-up** (`RegistryInterface.resolve` conversion): still blocked on #671, not started per charter; `registry-immutable-byte-array-followup` remains parked for the unblock watcher.

**Action taken — recovered a silently dropped maintainer directive on the blocker #671.** kriskowal commented "Shepherd." on endojs/endo-but-for-bots#671 on 2026-07-15T05:40Z (comment id 4977246906); it had **zero reactions and produced no job on any board**, and the PR has sat `mergeable_state: dirty` against `llm` (so CI cannot even dispatch) for 3 days. Root cause: the comment-watcher's deterministic base `endojs-endo-but-for-bots-pr671-shepherd` already existed in `jobs/tada/` from a 07-10 auto-shepherd, and the lifecycle dedup counts tada — the fresh directive deduped against a finished job (the watcher-side twin of the known press-schedule tada-dedup gotcha). Corrective work, all verified on the board after a journal pull:

1. Left the `eyes` reactji on comment 4977246906 (endo-but-for-bots is in the safe-to-watch set).
2. Posted **`endojs-endo-but-for-bots-pr671-weave-20260718`** (live in todo/, identity `endojs/endo-but-for-bots#671:comment:4977246906` so a watcher refire collapses onto it) — rebase `endo-registry-capability` onto current `llm`, with the known `daemon.js` makers-table conflict shape documented from the 07-10 weave.
3. Parked **`endojs-endo-but-for-bots-pr671-shepherd-20260718`** (plan/, `--blocked --blocked-on` the weave, role shepherd, priority high) — drive CI green and re-request review, per the directive.
4. Parked **`fix-comment-watcher-verb-directive-tada-dedup`** (plan/, deferred, priority high) — the durable fix: a fresh comment directive must not be swallowed by a tada entry of the same base, and any dedup-drop of a maintainer comment must at least leave a reactji or surfaced log.
5. Messaged the maintainer via the bus (delivered `20260718T002511Z-88aefe`) summarizing the drop and the corrective chain; updated the `press-schedule-cadence-gotchas` memory with the watcher-side variant.

No project-repo or garden `main2` changes were needed this dispatch; inbox drained (empty, twice).

**Follow-ups for next dispatch:** confirm the #671 weave→shepherd chain progressed (weave claimed/completed, shepherd promoted); watch for kriskowal/erights re-review on #475/#503; registry follow-up stays with the unblock watcher until #671 lands.
