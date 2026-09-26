Press dispatch complete — the arc advanced past both design milestones this cycle, and this dispatch unstuck the two stalled pieces and queued the next increment.

**Assessment (evidence-checked live):**
- **PR #662 (magnet-URN content-locator design): MERGED** — the design half of the finish line stays done; no designer sub-job needed.
- **PR #749 (Phase 1, grammar + duality): MERGED** at 10:25Z today.
- **PR #739 (store→writeFile design): MERGED.**
- **PR #783 (Phase 2, the five `<verb>Content` interface methods)** — the blocked Phase-2 build job queued last dispatch was promoted, ran, and completed (tada report confirms directory.js/manager.js/host.js/guest.js wiring plus 9 passing integration tests; all 21 CI checks green). But the PR was **still draft with zero review comments and no gauntlet job anywhere on the board** — the auto-gauntlet stalled, same failure shape the 00:05 dispatch found on PR #749.
- **PR #585 (node-fs content-store powers)** — un-drafted, panel passed, `CLEAN`, CI re-running 13 pass / 11 pending / 0 failing, but its conductor merge job was **reaper-poisoned** at 07:03Z (deadline-overrun ×1, likely a stall waiting on a slow CI cycle) and parked in `plan/` with `gate: go-ahead`.

**What I did (the press):**
1. Posted `gauntlet-endo-but-for-bots-pr783-content-locator-interface-methods` (clean → panel → fix-loop → un-draft; merge explicitly deferred to a conductor step, matching the #585/#749 precedent).
2. Parked `build-endo-content-locators-magnet-urn-phase3-planes-resolution` as a **blocked** plan job with `blocked_on:` PR #783, `role: builder` — scoped to the `@planes` special name, `getAllContentSources`, and the `ContentDataPlane` registry, wiring the marked Phase-3 seam in `storeContent`; Phases 4–5 explicitly out of scope. The unblock watcher promotes it the moment #783 merges.
3. Messaged the maintainer/liaison (delivered `20260717T122427Z-fa1cac`) requesting go-ahead promotion of the poisoned #585 merge job, with the evidence that the overrun is transient, not deterministic — a `go-ahead` gate is liaison-promoted only, so I did not promote it myself.

**Deliberately not done:** no self-promotion of the poisoned go-ahead job; no Phase-4/5 jobs (one increment at a time); no interference with live peers (none are on this arc's PRs).

**Arc state for the next dispatch:** expect #783 panel-reviewed and un-drafted (then post its conductor merge), #585 merged if the liaison promoted, and Phase 3 promoted or in flight once #783 merges. Verified on the refreshed journal: the gauntlet job is on the board, the Phase-3 job is parked in `plan/`, inbox drained — empty. No garden-library changes; nothing pushed to `main2`.
